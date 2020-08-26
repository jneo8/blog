---
title: "State"
date: 2020-08-26T17:18:31+08:00
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

* Keyed State

* Operator State

* Broadcase State
