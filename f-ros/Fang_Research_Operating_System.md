# Fang Research Operating System (F-ROS)

**博士級 × 期刊級 × OpenClaw 可執行 × SCI Agent 自動化**

**版本**：1.0.0  
**創建時間**：2026-02-15  
**作者**：方思惟博士研究系統

---

## 📋 目錄

1. [系統概述](#系統概述)
2. [PhD Deep Mode（博士研究專用）](#phd-deep-mode博士研究專用)
3. [Reviewer Killer Mode（投稿專用）](#reviewer-killer-mode投稿專用)
4. [OpenClaw Research Engine YAML](#openclaw-research-engine-yaml)
5. [SCI Agent Ultimate Prompt](#sci-agent-ultimate-prompt)
6. [快速開始指南](#快速開始指南)
7. [應用場景矩陣](#應用場景矩陣)

---

## 🎯 系統概述

### F-ROS 核心理念

| 維度 | 說明 |
|------|------|
| **博士級** | 符合博論嚴謹標準 |
| **期刊級** | 達 SCI 發表水準 |
| **OpenClaw 可執行** | 整合現有子代理系統 |
| **SCI Agent 自動化** | 自動化研究流程 |

### 系統架構

```
┌─────────────────────────────────────────────────────────┐
│              Fang Research Operating System              │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  ┌───────────────┐  ┌───────────────┐  ┌─────────────┐│
│  │  PhD Deep     │  │  Reviewer     │  │  SCI Agent  ││
│  │  Mode         │  │  Killer Mode │  │  Ultimate   ││
│  └───────────────┘  └───────────────┘  └─────────────┘│
│          │                │                  │         │
│          └────────────────┴──────────────────┘         │
│                           │                            │
│              ┌────────────┴────────────┐              │
│              │  OpenClaw Research      │              │
│              │  Engine (YAML)          │              │
│              └─────────────────────────┘              │
│                           │                            │
│         ┌─────────────────┼─────────────────┐         │
│         ▼                 ▼                 ▼         │
│  ┌──────────┐      ┌──────────┐      ┌──────────┐  │
│  │Sub-agents│      │ Skills   │      │Memory    │  │
│  └──────────┘      └──────────┘      └──────────┘  │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

### 與現有系統整合

| 系統 | 整合點 |
|------|--------|
| **Zettelkasten** | 原子筆記連結 |
| **MemOS** | 情境召回 |
| **OpenCode** | 代碼生成 |
| **子代理** | 任務執行 |

---

## 🧠 PhD Deep Mode

### 博士研究專用提示框架

**用途**：
- 博論章節重寫
- 文獻回顧升級
- Discussion 深化
- 研究缺口挖掘

---

### Fang PhD Core Prompt

```markdown
你是博士論文研究助理。

## 角色設定
- 語氣：學術嚴謹、批判性分析、避免空泛結論
- 假設讀者具備[領域]進階知識
- 任務：分析所有提供材料，產出博士論文級別分析

## 強制執行步驟

### STEP 1：生成5個核心問題
這5個問題若被回答，即可涵蓋研究核心意義。

### STEP 2：文獻主題歸納（5–10個）
每個主題需包含：
- 定義（用自己語言）
- 支持證據（引用）
- 學術立場（假設/實證/爭議）

### STEP 3：矛盾分析
- 指出衝突主張
- 說明可能原因（方法、樣本、背景）
- 哪種證據可解決

### STEP 4：研究缺口（Gap）
- 哪些問題未被解決
- 哪些方法不足
- 哪些假設未驗證

### STEP 5：章節建議
- 可新增小節
- 應加入圖表
- 應補強數據

## 規範
- 所有主張必須附證據
- 分離事實與推論
- 承認資料不足處

## 適用目標期刊
- Energies
- Advances in Applied Energy
- 博論第二章與第五章
```

---

### 使用範例

```markdown
## 任務：分析 [論文標題]

[插入論文內容/摘要]

---

### 輸出格式

## I. 5個核心問題

Q1: [問題1]
Q2: [問題2]
Q3: [問題3]
Q4: [問題4]
Q5: [問題5]

## II. 文獻主題歸納

| 主題 | 定義 | 證據 | 立場 |
|------|------|------|------|
| 主題1 | | | |
| 主題2 | | | |

## III. 矛盾分析

| 矛盾點 | 甲方主張 | 乙方主張 | 原因 | 解決方案 |
|--------|----------|----------|------|----------|
| 矛盾1 | | | | |

## IV. 研究缺口

| 缺口類型 | 描述 | 證據 |
|----------|------|------|
| 未解決問題 | | |
| 方法不足 | | |
| 未驗證假設 | | |

## V. 章節建議

### 可新增小節
- [建議1]
- [建議2]

### 應加入圖表
- [圖表1]
- [圖表2]

### 應補強數據
- [數據1]
- [數據2]
```

---

## ⚡ Reviewer Killer Mode

### Energies 投稿專用模式

**用途**：先於 Reviewer 找出弱點，提前修正，提升接受率

---

### Energies Advanced Analysis Prompt

```markdown
你是期刊審稿前內部評估專家。

## 角色設定
- 目標：強化方法學與數據可信度
- 優先關注：
  - 樣本數
  - 實驗設計
  - 統計顯著性
  - 控制變數
  - 再現性
  - 外部有效性

## 輸出格式

【主要發現】

【方法優勢】

【方法缺陷】

【統計完整性檢查】

【潛在審稿質疑點】

【如何預先防禦】

## 額外要求
- 找出可能被批評之處
- 指出過度推論
- 建議具體補強方案

## 適用目標
- Energies
- 類似 SCI 期刊
```

---

### 使用範例

```markdown
## 任務：預審 [論文標題]

[插入論文內容]

---

### 輸出格式

## I. 主要發現

## II. 方法優勢

## III. 方法缺陷

## IV. 統計完整性檢查

| 項目 | 狀態 | 建議 |
|------|------|------|
| 樣本數 | | |
| 顯著性 | | |
| 效度 | | |

## V. 潛在審稿質疑點

| 質疑點 | 可能性 | 嚴重程度 |
|--------|--------|----------|
| 質疑1 | 高/中/低 | 高/中/低 |

## VI. 預先防禦方案

### 質疑回應
- [回應1]

### 補強方案
- [方案1]
```

---

## 🔧 OpenClaw Research Engine YAML

### 系統層級整合配置

```yaml
# Fang Research Operating System - OpenClaw Engine
# 版本: 1.0.0
# 日期: 2026-02-15

research_engine:
  name: "Fang Research Operating System"
  version: "1.0.0"
  
  modes:
    phd_deep_analysis:
      name: "PhD Deep Mode"
      focus:
        - core_questions
        - thematic_synthesis
        - contradiction_detection
        - gap_analysis
      output:
        type: "structured_academic"
        format: "markdown"
        sections:
          - core_questions
          - themes
          - contradictions
          - gaps
          - recommendations
      
    journal_defense:
      name: "Reviewer Killer Mode"
      focus:
        - methodology_strength
        - statistical_validity
        - reviewer_attack_points
      output:
        type: "defensive_brief"
        format: "markdown"
        sections:
          - findings
          - strengths
          - weaknesses
          - threats
          - countermeasures
    
    decision_memo:
      name: "Decision Memo Mode"
      focus:
        - actionable_insights
        - constraints
        - blindspots
      output:
        type: "executive_summary"
        format: "markdown"
    
    synthesis_mode:
      name: "Concept Synthesis Mode"
      focus:
        - abstract_connections
        - cross_domain_links
        - novel_combinations
      output:
        type: "conceptual_framework"
        format: "markdown"
    
    evidence_policy:
      require_citation: true
      highlight_conflicts: true
      admit_gaps: true
      citation_style: "apa"

# 子代理整合
agents:
  literature_review:
    agent: "literature-review-agent"
    enabled: true
    modes:
      - phd_deep_analysis
      - synthesis_mode
  
  research_writing:
    agent: "research-writing-agent"
    enabled: true
    modes:
      - journal_defense
      - decision_memo
  
  phd_methodology:
    agent: "phd-research-methodology"
    enabled: true
    modes:
      - phd_deep_analysis
      - synthesis_mode

# 記憶整合
memory:
  type: "sqlite_fts5"
  tables:
    - "daily_notes"
    - "long_term_memory"
    - "research_memories"
  
  policies:
    - "atomic_notes"
    - "zettelkasten_links"
    - "evidence_citations"

# 技能整合
skills:
  research:
    - "literature-review-agent"
    - "research-writing-agent"
    - "phd-research-methodology"
  
  ai:
    - "openai-whisper"
    - "nano-banana-pro"
  
  knowledge:
    - "obsidian"
    - "zettelkasten"
    - "notion"

# 執行配置
execution:
  mode: "automated"
  confirmation: true
  output_dir: "/Users/pc/.openclaw/workspace/博士研究"
  
  phd_deep_analysis:
    auto_cite: true
    max_themes: 10
    min_confidence: 0.7
  
  journal_defense:
    auto_find_weaknesses: true
    auto_suggest_countermeasures: true
    reviewer_persona: "strict"

# 工作流程
workflows:
  paper_review:
    steps:
      - mode: "phd_deep_analysis"
      - mode: "journal_defense"
      - mode: "decision_memo"
    output: "paper_review_report"
  
  literature_synthesis:
    steps:
      - mode: "phd_deep_analysis"
      - mode: "synthesis_mode"
    output: "literature_synthesis"
  
  gap_analysis:
    steps:
      - mode: "phd_deep_analysis"
        focus: "gaps"
      - mode: "synthesis_mode"
    output: "gap_analysis_report"
```

---

## 🧠 SCI Agent Ultimate Prompt

### 終極整合版提示詞

```markdown
你是資深跨領域科學研究顧問。

## 角色設定
- 專長：跨領域研究分析
- 語氣：學術嚴謹、批判性思考
- 假設：讀者具備研究領域進階知識

## 任務
對[主題]進行高階研究分析。

## 執行流程

### STEP 1：生成5個核心研究問題
這5個問題涵蓋研究核心意義。

### STEP 2：識別主流理論與實證立場
- 主要理論流派
- 實證支持程度
- 學界共識度

### STEP 3：找出關鍵矛盾與衝突證據
- 理論矛盾
- 方法爭議
- 結果不一致

### STEP 4：識別未解決研究缺口
- 未被解決的問題
- 方法論局限
- 數據缺口

### STEP 5：評估方法學嚴謹度
- 樣本代表性
- 實驗設計
- 統計方法

### STEP 6：提出可發表等級研究改進建議
- 具體可行的研究方向
- 方法學改進
- 數據補強方案

## 輸出結構

### I. 概覽
- 研究意義與背景
- 核心貢獻

### II. 證據支持之主張
- 主要發現
- 支持證據
- 信心水平

### III. 方法學批判
- 優勢
- 局限
- 改進建議

### IV. 矛盾與限制
- 內部矛盾
- 外部限制
- 未解決爭議

### V. 可發展新研究方向
- 短期可行方向
- 長期研究方向
- 跨領域機會

### VI. 信心水平評估
| 維度 | 信心水平 | 說明 |
|------|----------|------|
| 主要發現 | 高/中/低 | |
| 方法學 | 高/中/低 | |
| 結論 | 高/中/低 | |

## 規範
- 僅基於提供資料
- 強制引用
- 承認資料不足
- 避免過度推論

## 適用場景
- 博士論文
- 期刊投稿
- 計畫申請
- 學術辯論
```

---

## 🚀 快速開始指南

### 步驟 1：選擇模式

| 研究需求 | 推薦模式 |
|----------|----------|
| 文獻回顧 | PhD Deep Mode |
| 期刊投稿 | Reviewer Killer Mode |
| 決策分析 | Decision Memo Mode |
| 概念創新 | Synthesis Mode |
| 全面分析 | SCI Agent Ultimate |

### 步驟 2：準備材料

```markdown
## 必要輸入
- 研究主題/論文標題
- 全文內容或摘要
- 相關文獻

## 選用輸入
- 研究問題
- 方法論描述
- 數據資料
```

### 步驟 3：執行分析

```bash
# PhD Deep Mode
python3 skills/research-evolution/main.py phd_deep --topic "[主題]"

# Reviewer Killer Mode
python3 skills/research-evolution/main.py journal_defense --paper "[論文]"

# SCI Agent Ultimate
python3 skills/research-evolution/main.py sci_agent --topic "[主題]"
```

### 步驟 4：整合輸出

```markdown
## 輸出整合
1. 儲存到 博士研究/輸出/
2. 連結到 Zettelkatsen
3. 更新 MEMORY.md
```

---

## 📊 應用場景矩陣

### 博士研究階段 × 模式

| 階段 | 任務 | 推薦模式 |
|------|------|----------|
| **第一章 緒論** | 研究缺口識別 | SCI Agent Ultimate |
| **第二章 文獻回顧** | 主題歸納 | PhD Deep Mode |
| **第三章 研究方法** | 方法論評估 | Reviewer Killer Mode |
| **第四章 結果** | 數據分析 | SCI Agent Ultimate |
| **第五章 討論** | 矛盾分析 | PhD Deep Mode |
| **第六章 結論** | 研究貢獻 | SCI Agent Ultimate |

### 期刊投稿 × 模式

| 階段 | 任務 | 推薦模式 |
|------|------|----------|
| 投稿前 | 自我審查 | Reviewer Killer Mode |
| Response Letter | 審稿回應 | SCI Agent Ultimate |
| Revision | 修改補強 | PhD Deep Mode |

### 計畫申請 × 模式

| 階段 | 任務 | 推薦模式 |
|------|------|----------|
|構想階段| 研究缺口 | PhD Deep Mode |
| 寫作階段 | 論證強化 | SCI Agent Ultimate |
| 審查準備 | 預備質詢 | Reviewer Killer Mode |

---

## 📁 相關文件

| 文件 | 路徑 |
|------|------|
| F-ROS 完整文檔 | `博士研究/03_科研代碼/Fang_Research_Operating_System.md` |
| NotebookLM 工具庫 | `博士研究/03_科研代碼/NotebookLM爆火提示詞工具庫.md` |
| Zettelkasten 指南 | `博士研究/03_科研代碼/Zettelkasten_知識管理系統.md` |
| 手寫筆記策略 | `博士研究/03_科研代碼/手寫筆記策略.md` |

---

## 🎯 核心價值

| 維度 | 價值 |
|------|------|
| **博士級** | 符合博論嚴謹標準 |
| **期刊級** | SCI 發表水準 |
| **OpenClaw 可執行** | 整合現有系統 |
| **SCI Agent 自動化** | 自動化研究流程 |

---

## 💡 使用心法

> F-ROS = 博士級思維框架 × 期刊級審稿標準 × OpenClaw 自動化執行

### 三大原則

1. **深度優先**：不求快，要求深
2. **證據說話**：所有主張需有據
3. **承認不足**：勇敢面對研究缺口

### 最佳實踐

1. 先用 PhD Deep Mode 建立理解
2. 用 Reviewer Killer Mode 找出弱點
3. 用 SCI Agent Ultimate 全面升級

---

## 📈 版本歷史

| 版本 | 日期 | 更新內容 |
|------|------|----------|
| 1.0.0 | 2026-02-15 | 初始版本 |

---

## ✅ 待辦清單

- [ ] 測試 PhD Deep Mode
- [ ] 測試 Reviewer Killer Mode
- [ ] 整合到 OpenClaw
- [ ] 建立自動化腳本
- [ ] 收集回饋並優化

---

*創建時間：2026-02-15*
*博士班倒數：6 個月 🔥*
