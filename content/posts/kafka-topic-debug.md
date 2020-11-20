---
title: "Kafka_topics_debug"
date: 2020-09-30T12:18:38+08:00
tags: ["kafka", "helm"]
---

Error: Exception thrown by the agent : java.rmi.server.ExportException: Port already in use: 5555; nested exception is: 

<!--more-->

使用: https://github.com/bitnami/charts/tree/master/bitnami/kafka

在 kafka pod 內想要執行 `kafka-topics.sh` 報錯

```bash
Error: Exception thrown by the agent : java.rmi.server.ExportException: Port already in use: 5555; nested exception is: 
```

查詢一下是 `JMX_PORT` 被佔走了

把指令換成下面就可以了

```bash
unset JMX_PORT; kafka-topics.sh ...
```

Source:

* https://stackoverflow.com/questions/44016688/unable-to-list-kafka-topics-in-openwhisk-setup
