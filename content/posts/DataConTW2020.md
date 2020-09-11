---
title: "DataConTW2020"
date: 2020-09-10T10:01:45+08:00
tags: ["Conference"]
---

Summarized DataConTW2020

<!--more-->

一些重點整理


## Schedule

### K1 - A Production Quality Sketching Library for the Analysis of Big Data

* 主要在講 Apache DataSketch
    * https://incubator.apache.org/clutch/datasketches.html


### K2 - COMMON CAVEATS OF MACHINE LEARNING

* 恩, 有點像大學教授上課
* POI 是外購的

### K3 - 資料「中」極戰！布局中台發展　實現業務創新

* EAI 業務整合

* Enterprise Integration Patterns

* 分享比較多 DevOps 部分, Data 部分比較少
    * 但架構設計, 想法其實還不錯, 有點好奇金融業推行過程中遇到的阻力有多大XDD

### C1 - 正確打開電商 Hashtag 的姿勢

* 看待 hashtag 的方式

* hashtag generator 

    * TFIDF 無法使用

        * 商品數量太多會影響

    * NER

        * 常用於辨識新聞文本

### C2 - Keep Learning Keep Journey – 誰要去他鄉？出國預測實作

* 如何抓取出國的人

* 如何良好跟業務溝通
    * 這邊雖然沒什麼技術層面, 但對於工程師來說應該都滿重要的

### PySpark 實務經驗分享 – 使用 PySpark 探索客戶位置大數據

* Know your customer

#### Location Resource

* 外購 POI

* 特約商店 POS 機

* Google Map API

#### Problem

* 信用卡店家名稱不易辨識

* 鄰近商家演算法

### 建立 Data Pipeline 的 基本原則與痛點

* LineTW

* Busuness Understanding:
    * Whay 想要得到什麼東西
    * Why 為什麼需要這份資料
    * Where 資料從哪裡來, 要往哪裡去？
    * When 什麼時候要拿到？ 多久拿一次? 忍受多久的修復時間
    * Who 使用者是誰? 誰要負責處理? 有沒有其他人有可能用到?
    * How 打算用什麼方式處理?
    * How much 多少預算?
    * Effect 這份資料有什麼影響力

* Data understanding
    * Volume
    * Velocity
    * Variety

* Pipeline 幂等性

    * 確保 job 重複執行不會影響資料

### 當客服比你更懂你 – Python 營運化的資料科學

    * 雖然沒有講太細節, 但 spark struct streaming 跟 batch job 的混合還滿有趣的, 感覺有很多坑要克服, 很可惜沒有講太細節

---

## Summarized

整體來說因為是線上會議, 連線品質滿不穩定的, 對參加者來說這是滿大的缺點, 希望明年可以改善
