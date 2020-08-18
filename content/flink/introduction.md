---
title: "Introduction"
date: 2020-08-18T16:25:45+08:00
---

# What is Apache Flink?


## 名詞解釋

### Unbounded and Bounded Data

- 相較於平時聽到的 **Batch vs Streaming**, flink 提出了不同的解釋, **Unbounded vs Bounded**

- #### Unbounded:

    - 定義開始, 沒有定義結束

    - 流式處理, event 必需在進入系統後立即處理

    - 因為數據是無界的, 所以不會有數據結束的時候 -> 無法確認數據是否全部抵達

    - 需要定義事件的時間順序來處理 -> **Time Attributes**

- #### Bounded:

    - 定義開始與結束

    - 可以知道數據的終點

    - 因為可以排序，有序的讀取數據並不是必需

    - Equal to batch processing

- #### Flink 用了一套相同的Engine ( **flink runtime** ) 去處理unbounded && bounded數據

![flink-runtime](/img/flink-runtime.png#center)

![flink-runtime](/img/flink-runtime.png#floatleft)

![flink-runtime](/img/flink-runtime.png#floatright)
