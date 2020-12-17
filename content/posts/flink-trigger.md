---
title: "[Flink] Trigger"
date: 2020-11-20T16:18:10+08:00
tags: ["flink"]
series: ["flink"]
---

Flink Trigger

<!--more-->

## What is Flink Trigger?

Flink Trigger 是決定 Stream Window 何時會觸發計算的 Function

透過 Flink Trigger 可以做到類似的行為

* 每 10 筆 觸發一次, 計算完丟棄 window 內資料
* 每 10 秒 processing time 觸發一次, 計算完不丟棄 window 內資料
* Window 結束時觸發

類似的情境可以透過[既有的 function](https://ci.apache.org/projects/flink/flink-docs-master/api/java/org/apache/flink/streaming/api/windowing/triggers/Trigger.html)解決, 但如果需要複合式的條件就需要自己客制, 例如 __每十筆觸發一次計算, window 結束時再觸發一次__

就要透過實做 [Trigger](https://ci.apache.org/projects/flink/flink-docs-master/api/java/org/apache/flink/streaming/api/windowing/triggers/Trigger.html)來達成自己的邏輯

## 如何觸發計算 ?

要讓資料順利流進 Window 然後觸發計算, 有些地方需要一步步注意

### [Watermark](https://ci.apache.org/projects/flink/flink-docs-stable/dev/event_timestamps_watermarks.html#introduction-to-watermark-strategies)

* 需要注意是 Processing time 還是 Event Time

### [Window LifeCycle](https://ci.apache.org/projects/flink/flink-docs-stable/dev/stream/operators/windows.html#window-lifecycle)

* Window 會在第一筆 element 到達時被創造, 在 watermark 越過 __window 結束時間 + allowed lateness__ 被移除

* 舉例來說

    ```scala
    val exampleStream: DataStrema[T] = stream
      .keyBy(<key selector>)
      .window(TumblingEventTimeWindows.of(Time.minutes(5))
      .trigger(new CountTrigger(10))
      .allowedLateness(Time.minutes(1))
    ```
* 這段程式碼表示
    * 12:01 分的資料會進入 12:00 ~12:05 這個 window
    * window 每收到 十筆資料 觸發一次計算
        * 這邊要注意 CountTrigger 觸發完不丟棄資料, 資料會被重復計算, 需要丟棄的話要搭配 [PurginTrigger](https://ci.apache.org/projects/flink/flink-docs-master/api/java/org/apache/flink/streaming/api/windowing/triggers/PurgingTrigger.html)
    * 12:00-12:05 的 window 會持續接收資料到 12:06, 然後關閉
    * 如果 12:07 接收到一筆 12:05 分的資料, 該筆資料不會進入 window
    * 如果 12:06 時 window 內還剩下 8 筆資料, 這些資料不會被計算

* __資料進入 window 的邏輯 跟 觸發計算的邏輯是分開的__

### [TriggerResult](https://ci.apache.org/projects/flink/flink-docs-master/api/java/org/apache/flink/streaming/api/windowing/triggers/TriggerResult.html)

TriggerResult 有四種控制邏輯

* FIRE: 觸發計算
* PURGE: 丟棄資料
* FIRE_AND_PURGE: 觸發且丟棄
* CONTINUE: 沒有動作

使用內建的 Trigger 需要注意觸發的邏輯, 大部份都只有 FIRE 而已

## Summary

其實大概談了一些基本概念而已, 想要實做or了解其規則, 個人最推薦的方式還是直接閱讀 sourecode 比較快
Flink Github 上面有多種 Trigger 實做, 推薦有需要的稍為讀過再下手
* https://github.com/apache/flink/tree/master/flink-streaming-java/src/main/java/org/apache/flink/streaming/api/windowing/triggers
