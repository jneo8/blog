+++ 
date = 2021-01-14T18:14:52+08:00
title = "Intro kafkacat"
description = "Generic command line non-JVM Apache Kafka producer and consumer"
slug = ""
authors = []
tags = ["kafka"]
categories = ["kafka"]
externalLink = ""
series = []
+++

最近在試 kafka 的效能, 找到了一個好用的 tool

[kafkacat github](https://github.com/edenhill/kafkacat)

可以當 Producer & Consumer, 支援的用法也很多

介紹就不寫了, 看 Document 比較快


## [Configurations](https://github.com/edenhill/kafkacat#configuration)

Config 可以跟 `librdkafka` 互通, 可以參考 [Introduction to librdkafka](https://docs.confluent.io/2.0.0/clients/librdkafka/INTRODUCTION_8md.html)

效能調校的話有幾個重要的設定, (document 可以用的設定真的多, 看有夠久):

* `batch.num.messages`: 發送前 local queue 內的最小 message number. 可以理解為最小 batch size. 越大 round trip time(rtt) 越小, 可以加大 throughput.:

* `queue.buffering.max.ms`: 最長等待時間, 理解上是到了就發送. 如果需要 low latency 可以設定越小越好.

* `compression.codec`: 啟用 batch 壓縮, batch size 越大壓縮率越好的可能性越大
