---
title: "[Flink] Architecture"
date: 2020-08-19T14:40:00+08:00
tags: ["flink"]
---

Flink Architecture basic introduce

<!--more-->

# Architecture

![flink-runtime](/img/flink/flink-runtime.png#center)

這張圖有幾個訊息

## Flink 可以有多種佈署方式

    * Local
    * Cluster
        * 這張圖有缺漏, 現在還有k8s
    * Cloud

### Cluster 模式又有分

* Session mode

    * 使用既有cluster resource, 透過summit去執行application
    * 所有job使用相同資源, 不需要去調配
    * 如果Task Manager 被操作不當關掉了, 所有job都會被影響, 會需要大規模recover
    * job manager 會比較忙因為需要紀錄所有job

* Per-Job mode

    * 透過YARN, k8s之類的resource控制去控制資源
    * cluster運行時被啟動, 結束後被關閉 -> 良好的資源控制
    * Production 建議使用

* Application mode
    * 簡單來說把jar檔的生成交給了Flink Master, 這可以省下jar檔傳輸的網路消耗
    * 詳細可看 [FLIP-85](https://cwiki.apache.org/confluence/display/FLINK/FLIP-85+Flink+Application+Mode)

--- 

## Flink Component stack

    * 這張圖解釋了Flink 的架構系統架構

![flink-component-stack](/img/flink/processes.svg)

* 當Flink 被啟動時會運行兩個主要的component

    * TaskManager
    * JobManager

### JobManager

下面主要分三塊

* ResourceManager

    * 負責資源控制
* Dispatcher

    * Provide REST interface for flink summit, open a new jobMaster for each summited job.
* JobMaster

    * 管理單一JobGraph, Flink 可以同時運行多個job, 每個都有自己的job master

---

## Flink API

![flink-](/img/flink/levels_of_abstraction.svg)

這張圖則是解釋 flink 各階層的 API 所支援的概念

像最高階層如果想要寫類似 SQL 的語法去產生 flink job 就是 Flink SQL
想要自己控制 state, eventTime 就可能要用 Low-level builging block
實務上應該是需要瞭解最下層

