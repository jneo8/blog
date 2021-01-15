+++ 
date = 2021-01-15T10:23:13+08:00
title = "Flink java.io.InvalidClassException: org.apache.flink.api.scala.typeutils.CaseClassTypeInfo"
description = ""
slug = ""
authors = []
tags = ["flink", "debug"]
categories = ["flink"]
externalLink = ""
series = ["flink"]
+++

# Flink  java.io.InvalidClassException: org.apache.flink.api.scala.typeutils.CaseClassTypeInfo

最近在一個小問題卡了一會, 紀錄一下

Flink run 出現, 就算跑 example word-count 也會

```
java.io.InvalidClassException: org.apache.flink.api.scala.typeutils.CaseClassTypeInfo
```

## 環境配置

[Flink k8s Operator](https://github.com/GoogleCloudPlatform/flink-on-k8s-operator) + scala sbt + [local flink 官網載來的](https://flink.apache.org/downloads.html)

有找到一篇 http://apache-flink-user-mailing-list-archive.2336050.n4.nabble.com/Error-quot-Could-not-load-deserializer-from-the-configuration-quot-td377.html 說應該是 flink version conflict

檢查了一會 sbt & flink cluster version 是對的起來的

但是官網載來的 flink 是有 flink & scala 版本差別的, 只是載來解壓縮之後沒注意到

## Summary

`version conflict`: 確保 `local flink` & `cluster flink` & `sbt` 三者的 flink & scala 的版本都要正確
