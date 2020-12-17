---
title: "[Flink] Async I/O"
date: 2020-11-21T14:13:41+08:00
tags: ["flink"]
---

Flink Asynchronuos I/O

<!--more-->

## Why we need Asynchronous I/O ?

當你需要在 streaming function 中 access 外部 resource(Database, API) 時
使用一般的 function 可能會導致 過長的等待時間
這時你就會需要 AsyncI/O

![](https://ci.apache.org/projects/flink/flink-docs-release-1.11/fig/async_io.svg#center)

## Enricher pattern

什麼是 Enricher pattern?
簡單來說就是賦予基本的 element, 更多的 information

![](https://social.technet.microsoft.com/wiki/resized-image.ashx/__size/550x0/__key/communityserver-wikis-components-files/00-00-00-00-05/3771.DataEnricher.gif#center)

推薦觀看 [AWS 在 Flink Forward Global Virtual Conference 2020 上給的 talk](https://www.youtube.com/watch?v=UParyxe-2Wc&list=PLDX4T_cnKjD054YExbUOkr_xdYknVPQUm&index=13&ab_channel=FlinkForward)

內容包含 Async I/O 實做架構 && 一些注意的點, 像是

* `Capacity`: 控制 input size
* `Timeout`: Complete Timeout
* `Open/Close Functions`: 開啟關閉外部連線
    * Open / Close Function 實做時需要使用 [RichAsyncFunction](https://ci.apache.org/projects/flink/flink-docs-master/api/java/org/apache/flink/streaming/api/functions/async/RichAsyncFunction.html) 才有 open/close methods 可以用
* `Open Parallelism`: 注意併發數量
* `Checkpoint interval`: 適當的 checkpoint interval 大小, 太小效能會太差, 太大會讓 checkpoint 太大

## [ResultFuture](https://ci.apache.org/projects/flink/flink-docs-master/api/java/org/apache/flink/streaming/api/functions/async/ResultFuture.html)

* 負責回傳資料 or Error
* 需要注意的是 method `ResultFuture.complete` 只能 call 一次 
    * __Note that it should be called for exactly one time in the user code. Calling this function for multiple times will cause data lose.__
* 可以透過回傳空集合達到類似 Filter 的功能, 外部白名單過濾
