---
title: "[k8s] ZookeeperInstall"
date: 2020-09-09T14:37:16+08:00
tags: ["k8s"]
---

_Install ZooKeeper on k8s cluster_

<!--more-->

實做 https://kubernetes.io/docs/tutorials/stateful-application/zookeeper/ 全紀錄


### 名詞解析

> _比較基礎的跳過 ( pods, Cluster DNS ... )_

* [PodDisruptionBudgets](https://kubernetes.io/docs/concepts/workloads/pods/disruptions/#pod-disruption-budgets)

* [PodAntiAffinity](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#affinity-and-anti-affinity)


### Prerequire

* K8s cluster (at least 4 nodes * 2 CPU * 4 Gib Memory)
    * **A Dedicated cluster**

* Dynamically provision PersistentVolumes


### Objectives

> 因為很重要我還是寫下來

* How to deploy a ZooKeeper ensemable using StatefulSet

* How to consistently configure the ensemble using ConfigMaps

* How to spread the deployment of ZooKeeper servers in the ensemble.

* How to use PodDisruptionBudgets to ensure service availability during planned maintenance.

---

開始實做吧


### Creating a ZooKeeper Ensemble 

```bash
wget https://k8s.io/examples/application/zookeeper/zookeeper.yaml

kubectl apply -f ./zookeeper.yaml
```

這邊會看到

```bash
service/zk-hs created
service/zk-cs created
poddisruptionbudget.policy/zk-pdb created
statefulset.apps/zk created
```

表示成功

然後下

```bash
kubectl get pods -w -l app=zk
```

會看到 pod 被成功創建

#### 觀察 domain name && dns 如何被設定

* StatefulSet controller 會給每個 pod 一個 unique hostname

```bash
for i in 0 1 2; do kubectl exec zk-$i -- hostname; done

# zk-0
# zk-1
# zk-2
```

* Unique identifier file `myid` store in zk server's data directory

	* 在 zk 內, 每台 server 都會有 unique identifier

```bash
for i in 0 1 2; do echo "myid zk-$i";kubectl exec zk-$i -- cat /var/lib/zookeeper/data/myid; done

# myid zk-0
# 1
# myid zk-1
# 2
# myid zk-2
# 3
```

* FQDN for each pod

```bash
for i in 0 1 2; do kubectl exec zk-$i -- hostname -f; done

# zk-0.zk-hs.default.svc.cluster.local
# zk-1.zk-hs.default.svc.cluster.local
# zk-2.zk-hs.default.svc.cluster.local
```


* zoo.cfg 

	> 這邊可以看見前面的 FQDN 被寫在設定檔中

```bash
kubectl exec zk-0 -- cat /opt/zookeeper/conf/zoo.cfg

# clientPort=2181
# dataDir=/var/lib/zookeeper/data
# dataLogDir=/var/lib/zookeeper/data/log
# tickTime=2000
# initLimit=10
# syncLimit=5
# maxClientCnxns=60
# minSessionTimeout=4000
# maxSessionTimeout=40000
# autopurge.snapRetainCount=3
# autopurge.purgeInteval=12
# server.1=zk-0.zk-hs.default.svc.cluster.local:2888:3888
# server.2=zk-1.zk-hs.default.svc.cluster.local:2888:3888
# server.3=zk-2.zk-hs.default.svc.cluster.local:2888:3888
```

上面幾個步驟可以一起講

* Pod Ready -> 產生 A record
* FQDNs 解析 A record 導向 zk server
* 這台 zk server 上會有 `myid` 表示 identity configured
* 這樣可以確保 `zoo.cfg` 上的 `servers` 設定導向正確

#### Sanity Testing the Ensemble

```bash
kubectl exec zk-0 zkCli.sh create /hello world
kubectl exec zk-1 zkCli.sh get /hello
```

---

### Providing Durable Storage 

```bash
kubectl delete statefulset zk

# 等全部刪除後再往下

kubectl apply -f https://k8s.io/examples/application/zookeeper/zookeeper.yaml

kubectl exec zk-2 zkCli.sh get /hello
```

這邊會發現就算刪除又重新創建, 資料仍然存在

是因為在 `volumeClaimTemplates` 中有做設定

`StatefulSet` controller 會產生 `PersistentVolumeClaim` 給 `StatefulSet` 中的所有 Pod

```bash
kubectl get pvc -l app=zk

# NAME           STATUS    VOLUME                                     CAPACITY   ACCESSMODES   AGE
# datadir-zk-0   Bound     pvc-bed742cd-bcb1-11e6-994f-42010a800002   20Gi       RWO           1h
# datadir-zk-1   Bound     pvc-bedd27d2-bcb1-11e6-994f-42010a800002   20Gi       RWO           1h
# datadir-zk-2   Bound     pvc-bee0817e-bcb1-11e6-994f-42010a800002   20Gi       RWO           1h
```

透過 `volumeMounts` 把 pvc mount 到 ZooKeeper 的資料存放資料夾內

---

### Ensuring Consistent Configuration 

為了讓 ZooKeeper 正確被設定, 設定被直接寫在啟動的 command 中

```yaml
command:
      - sh
      - -c
      - "start-zookeeper \
        --servers=3 \
        --data_dir=/var/lib/zookeeper/data \
        --data_log_dir=/var/lib/zookeeper/data/log \
        --conf_dir=/opt/zookeeper/conf \
        --client_port=2181 \
        --election_port=3888 \
        --server_port=2888 \
        --tick_time=2000 \
        --init_limit=10 \
        --sync_limit=5 \
        --heap=512M \
        --max_client_cnxns=60 \
        --snap_retain_count=3 \
        --purge_interval=12 \
        --max_session_timeout=40000 \
        --min_session_timeout=4000 \
        --log_level=INFO"
```

---

### Configuring Logging

ZooKeeper use Log4j, 把 log 寫到 standard out 中
透過 `kubectl logs` 便可以看到

```bash
kubectl exec zk-0 cat /usr/etc/zookeeper/log4j.properties

kubectl logs zk-0 --tail 20
```

---

### Managing the ZooKeeper Process 

使用 K8s 管理 ZooKeeper Process

用 `patch` 更新 `cpus`

```bash
kubectl patch sts zk --type='json' -p='[{"op": "replace", "path": "/spec/template/spec/containers/0/resources/requests/cpu", "value":"0.3"}]'
```

觀察 RollingUpdate 狀態

```bash
kubectl rollout status sts/zk

kubectl rollout history sts/zk
```

Roll back 

```bash
kubectl rollout undo sts/zk
```

---

### Handing Process Failure

Restart Policies 控制 Pod entry point failures.

但在 `StatefulSet` 中唯一的 policy 是 `Always` ( 也是 default )

透過 kill 掉 entry point 觀察 Pod restart 狀況

```bash
kubectl exec zk-0 -- ps -ef

kubectl get pod -w -l app=zk

kubectl exec zk-0 -- pkill java
```

---

### Tolerating Node Failure 

```bash
for i in 0 1 2; do kubectl get pod zk-$i --template {{.spec.nodeName}}; echo ""; done
```

透過設定 `podAntiAffinity` 讓 ZooKeeper 跑在不同台 server 上

`requiredDuringSchedulingIgnoredDuringExecution` 告訴 k8s 永遠不將 `label/app:zk` 放在 相同的 `topologyKey` 上

```yaml
      affinity:
        podAntiAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            - labelSelector:
                matchExpressions:
                  - key: "app"
                    operator: In
                    values:
                    - zk
              topologyKey: "kubernetes.io/hostname"
```

### Surviving Maintenance 

這部份實做滿有趣的

有興趣可以參考 https://kubernetes.io/docs/tutorials/stateful-application/zookeeper/#surviving-maintenance


---


### Summary

這一篇其實並沒有講到太多 ZooKeeper 的部份, 有可能是因為本身對 ZooKeeper 有一定熟悉度

通篇比較多是在說 k8s 的機制去把網路跟設定接起來
然後有比較多 failure 的控制
如果對 k8s 機制或者功能不熟的話應該會有滿多收獲

