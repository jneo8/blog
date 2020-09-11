---
title: "[Flink] Bounded And UnBounded"
date: 2020-08-18T16:25:45+08:00
tags: ["flink"]
---

flink Unbounded and Bounded 

<!--more-->

# Unbounded and Bounded 

- 相較於平時聽到的 _Batch vs Streaming_, flink 提出了不同的解釋 -- _Unbounded vs Bounded_

- #### Unbounded:

    - 定義開始, 沒有定義結束

    - 流式處理, event 必需在進入系統後立即處理

    - 因為數據是無界的, 所以不會有數據結束的時候 -> 無法確認數據是否全部抵達

    - 需要定義事件的時間順序來處理 -> _Time Attributes_

- #### Bounded:

    - 定義開始與結束

    - 可以知道數據的終點

    - 因為可以排序，有序的讀取數據並不是必需

    - Equal to batch processing

- #### Flink 用了一套相同的Engine ( _flink runtime_ ) 去處理unbounded && bounded數據

![flink-runtime](/img/flink/flink-runtime.png#center)

_runtime_ 是flink的核心運算架構, 之後會提到
