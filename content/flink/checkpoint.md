---
title: "[Flink] Checkpoints"
date: 2020-08-23T20:55:16+08:00
markup: mmark
---

_Introduce Flink Checkpoints_ .

<!--more-->

---

## Checkpointing

* Flink 的容錯機制核心, 是透過繪制一致的Checkpoint和分佈式的數據流來達成

* Clickpoint 可以讓 state && corresponding stream position 被恢復

* 故障發生後, Flink 會倒退回這些 checkpoint 

    * Flink 繪制 Data flow 的機制: [Lightweight Asynchronous Snapshots for Distributed Dataflows](https://arxiv.org/abs/1506.08603)

        * 這項技術從 [Candy-Lamport algorithm](https://www.microsoft.com/en-us/research/publication/distributed-snapshots-determining-global-states-distributed-system/?from=http%3A%2F%2Fresearch.microsoft.com%2Fen-us%2Fum%2Fpeople%2Flamport%2Fpubs%2Fchandy.pdf) 得到啟發並針對 Flink 模式進行改善

    * Checkpoint 的操作是 asynchronously

    * 從 1.11版本開始, checkpoint 可以是非對齊的

### Barries

* Distrubuted Snapshotting 的最小單位是 _stream barriers_

* _stream barries_ 是 data stream 中的一部份, 被注入進 data flow

* barries 並不會超越 records, 他們是嚴格依序排列的

* barrier 會把 records 分割成兩個snapshot(就像圖那樣)

* Barries 不會中斷 data flow, 非常輕量

* 不同 snapshot 的 多個 barriers 可以同時出現在 data flow 中 -> 多個快照可以同時發生

![flink-stream_barriers](/img/flink/stream_barriers.svg#center)

* Stream barriers are injected into parallel data flow at the stream source. The point where the barriers for snapshot n barrier are injected is called $$S^{n}$$

    * $$S^{n}$$ :

        * $$S^{n}$$ is the position in the source stream up to which the snapshot covers the data.

        * In Kafka, this position would be the last record's offset in the partition

        * Position $$S^{n}$$ will be report to checkpoint coordinator(Flink's JobManager)

* 當 Operator 接收到 snapshot N 的 barrier, operator 會把 barrier 送出給所有output stream

* 一旦 Sink operator (the end of streaming DAG) 收到 barrier N 後, 會把 snapshot N 送給 checkpoint coordinator

* 當所有 Sink operator 都確認過 snaphost N 後, snapshot 會被認定為完成

* 一旦 snapshot 完成, job 就不會再向 data sourece 要 $$S^{n}$$ 之前的數據

<br>

![stream_aligning](/img/flink/stream_aligning.svg)

    * 這張圖展示對齊式 checkpoint 的運作方式

* 第一張圖, 收到 barrier N

    * Operator 無法繼續處理 1, 2, 3 . 否則會混合 n && n + 1 的資料

* 第二張圖, 最後一個 flow 收到 barrier N

    * Operator 發出所有 pending records

    * Input buffer 內有 e, f

*  第三張圖

    * Operator 自己發出 barrier N

    * Operator snapshot the state

    * 處理 buffer 內的 records (e, f)

    * 恢復處理 flow records

    * write the state asynchronously to the state backend

> **Note that the alignment is needed for all operators with multiple inputs and for operators after a shuffle when they consume output streams of multiple upstream subtasks.**


### Snapshotting Operator State

_When operators contain any form of state, this state must be part of the snapshots as well_

* Operators snapshot their state at the point in time when they have received all snapshot barriers form their input streams, and before emitting the barries to their output streams.

* Default 會存在 JobManager memory 中
    * Production 應該要使用 distributed reliable storage (such as HDFS)

![flink-stream_barriers](/img/flink/checkpointing.svg#center)

### Recovery

* 失敗時會選擇最新完成的 checkpoint `k`, 然後會重新 deploy 整個 distrubuted dataflow.

* 給每個 operator checkpoint `k` 的 state


<br>
<br>
<br>

---

<br>
<br>
<br>

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




---

## Resource

* https://ci.apache.org/projects/flink/flink-docs-stable/ops/state/checkpoints.html
* https://ci.apache.org/projects/flink/flink-docs-stable/dev/stream/state/state.html
* https://ci.apache.org/projects/flink/flink-docs-release-1.11/concepts/stateful-stream-processing.html

