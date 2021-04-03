+++ 
draft = true
date = 2021-01-25T10:13:40+08:00
title = "Introduction to sbt"
description = "Introduction to sbt and how it work."
slug = ""
authors = []
tags = ["sbt", "scala"]
categories = []
externalLink = ""
series = []
+++

# sbt

## 什麼是 sbt ?

sbt 是 Scala, Java 語言的 build tool.

尤其是 Scala. 起手式就是 sbt.

有一大部份開發者會綁定 IDE. `intellij` + `sbt` 一起使用. 但只用 sbt 是沒有關係的.

## Intro

關於學習 sbt 架構跟概念, 推薦官網上的[影片](https://youtu.be/-shamsTC7rQ), 看過一遍可以多了解 sbt 的設計概念

## Quick start

```bash
mkdir ${project-folder}
cd ${project-folder}
sbt new scala/scala-seed.g8

# enter project name hello

```

```bash
tree

.
├── hello
│   ├── build.sbt
│   ├── project
│   │   ├── build.properties
│   │   └── Dependencies.scala
│   └── src
│       ├── main
│       │   └── scala
│       │       └── example
│       │           └── Hello.scala
│       └── test
│           └── scala
│               └── example
│                   └── HelloSpec.scala
├── project
│   └── target
└── target
    ├── global-logging
        └── task-temp-directory
```

`scala/scala-seed.g8` 是 sbt 在 init 時的 [template](https://www.scala-sbt.org/1.x/docs/sbt-new-and-Templates.html#sbt+new+and+Templates), github 有很多 template 可以選用, 選擇一個適合自己的


## Source

https://www.scala-sbt.org/learn.html
