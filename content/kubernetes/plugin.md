---
title: "[k8s] Kubernetes Plugin"
date: 2020-09-04T15:32:40+08:00
tags: ["kubernetes"]
---

How to install kubectl plugin?

<!--more-->

# Kubernetes plugin install

不小心被自己雷到所以記錄一下

document 中寫:

> Any files that are executable, and begin with `kubectl-` will show up in the order in which they are present in your PATH in this command's output.

**所以如果**

* filename `kubectl-abc123` , 要使用就輸入 `kubectl abc123`

* filename `kubectl-abc456` , 要使用就輸入 `kubectl abc456`

plugin 是跟著檔名的

下次文件還是看清楚點

## Source 

https://kubernetes.io/docs/tasks/extend-kubectl/kubectl-plugins/
