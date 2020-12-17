+++ 
date = 2020-12-17T11:17:20+08:00
title = "Clickhouse Index"
description = "How Clickhouse index work"
slug = ""
authors = []
tags = ["clickhouse"]
categories = []
externalLink = ""
series = ["clickhouse"]
+++

How Clickhouse index work?

<!--more-->

See the [document](https://clickhouse.tech/docs/en/engines/table-engines/mergetree-family/mergetree/#mergetree-data-storage) first: 

> A table consists of data parts sorted by primary key.
> 
> When data is inserted in a table, separate data parts are created and each of them is lexicographically sorted by primary key. For example, if the primary key is (CounterID, Date), the data in the part is sorted by CounterID, and within each CounterID, it is ordered by Date.
