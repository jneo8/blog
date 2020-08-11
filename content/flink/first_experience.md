---
title: "Flink 學習初心者心得"
date: 2020-08-11T22:11:12+08:00
---

講講最近flink學習的心得好了

## Cons:

嗯，以台灣來說真的很冷門

至少個人接觸到的很少人有寫過

## Pros：

跟k8s整合性還不錯, 整體來說適性滿好的, 這也是當初想接觸的動機之一

operator 現在是用Google Cloud Platform 的 [flink-on-k8s-operator](https://github.com/GoogleCloudPlatform/flink-on-k8s-operator)

operator的code是golang, 剛好最近也在看CDK相關的東西, 也許之後會有機會貢獻

__對我是跑在k8s上喔__

Dataset 跟 Data streaming, flink用一個通用的方式去同時處理Unbounded streams & bounded streams
實際使用過然後掃過源碼之後只能說優雅

_為什麼要掃源碼, 只能說scala的example少的可憐, 相比java來說_



之後等理解更多之後應該會寫一些分享文出來
