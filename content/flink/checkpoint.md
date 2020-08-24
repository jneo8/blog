---
title: "Checkpoints"
date: 2020-08-23T20:55:16+08:00
---

![flink-logo](/img/flink/flink-header-logo.svg)

Introduce Flink Checkpoints.

<!--more-->

---

# Clickpoint

Flink的容錯機制

Clickpoint 可以讓state && corresponding stream position 被恢復

## Enable Checkpoints

* https://ci.apache.org/projects/flink/flink-docs-release-1.11/dev/stream/state/checkpointing.html


## Retained Checkpoints

* 透過 **ExternalizedCheckpointCleanup** 參數

* ExternalizedCheckpointCleanup.RETAIN_ON_CANCELLATION
    * job 被取消時, 保留 Checkpoints
    * 需要手動刪除 Checkpoints

* ExternalizedCheckpointCleanup.DELETE_ON_CANCELLATION
    * job 被取消時, Checkpoints 會被delete
    * job fail -> Checkpoints 被保留

## Directory Structute

* Checkpoint 是透過 file 管理的, 其目錄結構可以參照 [FLINK-8531](https://issues.apache.org/jira/browse/FLINK-8531)

```bash
/user-defined-checkpoint-dir
    /{job-id}
        |
        + --shared/
        + --taskowned/
        + --chk-1/
        + --chk-2/
        + --chk-3/
        ...
```

* The SHARED directory is for state that is possibly part of multiple checkpoints

* TASKOWNED is for state that must never be dropped by the JobManager

* EXCLUSIVE is for state that belongs to one checkpoint only.

## Difference to Savepoints

* Use a state backend specific(low-level) data format, may be incremental

* Do not support Flink specific features like rescaling



## Resource

https://ci.apache.org/projects/flink/flink-docs-stable/ops/state/checkpoints.html
