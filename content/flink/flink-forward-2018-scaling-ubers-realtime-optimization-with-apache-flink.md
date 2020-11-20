---
title: "[Flink Forward 2018] Scaling Uber's Real-time Optimization with Flink"
date: 2020-08-22T15:21:20+08:00
tags: ["flink"]
---

Flink Forward 2018 / Scaling Uber's Real-time Optimization with Flink 心得

<!--more-->


---

# Scaling Uber's Real-time Optimization with Flink

Youtube: [![Youtube link](https://img.youtube.com/vi/YOUTUBE_VIDEO_ID_HERE/0.jpg)](https://www.youtube.com/watch?v=ydFXKrad6lo)


## `Marketplace Events` -> `Marketplace Dynamics` -> `Marketplace Decision Engines`

![uber-marketplace](/img/flink/uber-marketplace.jpg)

整場演講的主軸

如何從 Macketplace Event 取得 Dynamics 然後作出 Decision

### 解釋Uber Marketplace && challenges

* real time && real world

####  Real-time challenges

* Event time ordering

* Time sensitive

#### Aggregate in real-time

* aggregation in windows bucket
* result over event time
* As soon as poosible
* As accurate as possible

#### Real-world challenges

* Problems
    * Event spatial mapoing
    * Locality sensitive

* Aggregation in real-world

    * Influences its current and neighbours
    * Apply geo func on related events


--- 

## `Events` -> `Dynamics`


###  OLAP solution (Online analytical processing)

    * uber solution before

    * 這邊在講之前的作法以及問題

![uber-OLAP-soultion](/img/flink/uber-OLAP-soultion.jpg)

#### Problems:

* Periodical crontab

    * To Monitor Marketplace -> need to have a scheduler to call OLAP to get a snapshot(maybe once/min) -> bringing a external dependency into system

    * Difficult to write a very stable distributing schedulers in the productions

    * Any fillers that means the entire city are losing an update that's uber trying to avoid

    * Can't get data as soon as possible -> have to wait for the scheduler trigger

* Batch snapshot

    * Bottleneck in data pipeline

* 大概就是講說 因為要做snapshot, 所以導致需要有scheduler -> 產生external dependency.
    * 錯誤容易掉資料
    * 即時性差, 需要等scheduler trigger
    * 上圖的step2會變成整個 pipeline 的 buttonneck

### Event driven solution

![uber-OLAP-soultion](/img/flink/uber-event-based-soultion.jpg)
![uber-OLAP-soultion](/img/flink/uber-event-based-soultion-reduce.jpg)

* Mapreduce style

* 第一張圖在講說用flatmap把event散出給多個geo_id
    * duplicate yourself at differnet locations
    * 這邊我理解的意思是舊的方法內, 同一個人同一個snapshot只會出現在一個地方, 換成Event based 之後只要有新的event出現在新的location, event就會流向新的location

* 第二張圖是說讓Agg 基於第一張圖的結果再去計算, 讓agg最後再做, 相較於第一張圖, agg的時間被往後延了, 這讓系統更加有彈性跟stable

* Event driven design concern?
    * 這邊講一些event base system 的concern以及利用flink的特性所進行的設計

---

## `Dynamics` -> `Decision`

* ML 一般是Capture historical patterns

* 這邊主要是說如何在offline/online modelling 中作選擇

![uber-online-offline-hybird-soultion](/img/flink/uber-online-offline-hybird-solution.jpg)

* Uber 最後的solution. ofline modelling + stateful online update

---

## Recap 

![uber-marketplace](/img/flink/uber-marketplace.jpg)

* Single flink app for each part(one for `Event to Dynamics`, another for `Dynamics to Decision`)
    * 主要是想要保持架構分隔跟乾淨

## Lesson learned

* Strong infra level support
* Real-time ML is hard due to data pre-processing
* Bootstrap the model through offline jobs
* Reduce the parameter dimension
