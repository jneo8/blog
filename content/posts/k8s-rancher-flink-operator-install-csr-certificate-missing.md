+++ 
date = 2020-12-23T16:50:26+08:00
title = "[k8s]K8S Rancher Install Flink Operator CSR Certificate Missing"
description = ""
slug = ""
authors = []
tags = ["rancher"]
categories = []
externalLink = ""
series = []
+++

# K8S Rancher Install Flink Operator CSR Certificate Missing

今天在 Rancher2 install [Flink-On-k8s-Operator](https://github.com/GoogleCloudPlatform/flink-on-k8s-operator) 出現錯誤. 紀錄一下


Error Message 看是沒有 certificate,

```
+ echo 'ERROR: After approving csr flink-operator-webhook-service.flink-operator-system, the signed certificate did not appear on the resource. Giving up after 10 attempts.'         
+ ERROR: After approving csr flink-operator-webhook-service.flink-operator-system, the signed certificate did not appear on the resource. Giving up after 10 attempts.                  
```

查看 CSR status

```bash
kubectl get csr flink-operator-webhook-service.flink-operator-system -o 'jsonpath={.status}'
```

```
"status": {
    "conditions": [
        {
            "lastUpdateTime": "...",
            "message": "This CSR was approved by kubectl certificate approve.",
            "reason": "KubectlApprove",
            "type": "Approved"
        }                                                    
    ]
}
```

分析一下問題:

* 有CSR
* 已經 Approved
* 但沒有 certificate

查找一下文件發現 k8s 在使用 CSR 時有兩階段, `Request signing process` & `Signers`. 應該是 Signers 那邊出現問題

[後來查找一下 Kubernetes controller manager 有提供 signer, 但 default 沒有啟動](https://kubernetes.io/docs/tasks/tls/managing-tls-in-a-cluster/#a-note-to-cluster-administrators)

在 Rancher 內則是要設定 `cluster-signing-cert-file` & `cluster-signing-key-file`

改完 Rancher cluster YAML 重新部署就好了

## Source

https://kubernetes.io/docs/reference/access-authn-authz/certificate-signing-requests/
https://github.com/cockroachdb/cockroach/issues/28075#issuecomment-420497277
