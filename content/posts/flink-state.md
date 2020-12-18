---
title: "[flink] State"
date: 2020-08-26T17:18:31+08:00
tags: ["flink"]
series: ["flink"]
draft: true
---

![flink-logo](/img/flink/flink-header-logo.svg)

Introduce Flink State.

<!--more-->

---

# State

## Stateful 有狀態

* 大多數人提到streaming, 會認為說event是逐筆進來的, 處理完就結束了, 但如果 Operation 操作需要記住多筆的時候, 比如說 `window`, 那這些Operator就是 __stateful__

* Flink 需要 State 來執行 checkpoint && savepoint, 讓flink實現容錯機制

* Flink 也需redistributing state 來 Rescaling flink application

* **Queryable state** allow user access state during runtime

* 了解 [state backend](https://ci.apache.org/projects/flink/flink-docs-release-1.11/zh/ops/state/state_backends.html)


## State type

### Keyed State

![flink-logo](/img/flink/state_partitioning.svg#center)

* Only on Keyed streams

* Partitioned and Distributed stricyly together with the stream that are read by stateful operators

* All state updates are local operations, guaranteeing consistency without transaction overhead

* Keyed State is further organized into so-called Key Groups.
    * Key Groups are the atomic unit by which Flink can redistribute Keyed State; there are exactly as many Key Groups as the defined maximum parallelism. During execution each parallel instance of a keyed operator works with the keys for one or more Key Groups.

### Operator State

### Broadcase State

---

## State Persistence

### stream replay and checkpointing

- Checkpointing 會紀錄 stream 中各個 Operator

> **Note**
> * By default, Checkpointing disabled.
> * For this mechanism to realize its full guarantees, the data stream source needs to be able to rewind the stream to a defined recent point.
> * 為了實現Checkpoint, data stream source 需要能夠讓資料回朔到最靠近checkpoint的點
> > * Kafka 有這項功能, Flink Kafka connector 有使用
> > * 由於Flink checkpoints 是透過 distributed snanpshot 實現的, flink 中會混合使用這兩個詞

### Snapshotting Operator State

## Resource

- https://ci.apache.org/projects/flink/flink-docs-stable/dev/stream/state/state.html
- https://ci.apache.org/projects/flink/flink-docs-release-1.11/concepts/stateful-stream-processing.html
