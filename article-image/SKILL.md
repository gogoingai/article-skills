---
name: article-image
description: 为文章生成 AI 配图（架构图、流程图、技术示意图等），涵盖从"画图提示"写作规范到调用 gpt-image-2 实际生成、质检、上传、写入文章的完整流程。适用于任何需要配图的写作场景，不限于技术文章。触发关键词：画个架构图、画流程图、生成配图、生成图片、把图画出来、渲染一下、帮我生图。也可被其他写作类技能通过 Skill 工具在"配图阶段"调用。
---

# 文章配图 Skill

## 与调用方的接口约定

其他写作技能（如 article-write）在正文里为图片预留位置时，用两种标记之一：

| 标记 | 含义 | 谁来写 |
| --- | --- | --- |
| `> 🖼️ 待配图：[一句话描述这张图要表达的核心内容]` | 占位标记，只知道这里需要一张图，还没想好具体画法 | 调用方（写作阶段） |
| \`\`\`（代码块）第一行 `# 画图提示：[描述]` | 完整画图提示，规范已写全，可以直接生成 | 本技能，或调用方已自行写好 |

本技能被调用时，**先把占位标记转换成完整画图提示，再进入生成流程**——两步不能合并，写法未确认前不要直接生成。

> **工具等价说明**：文中"`Skill` 工具"是 Claude Code 的跨技能调用机制名。其他 agent 没有对应机制时，调用方应直接 Read 本技能的 `SKILL.md` 和 `references/` 文件内联执行。

---

## 触发识别

| 场景 | 入口 |
|------|------|
| 用户直接说"画个XX图"、"生成配图"，给出内容描述 | 直接进入「写画图提示」 |
| 文章里已有 `> 🖼️ 待配图` 占位标记 | 先转换成完整画图提示，见 `references/gen-workflow.md` 第二步 |
| 用户说"生成图片"、"渲染一下"、"把图画出来" | → 查 `references/gen-workflow.md`，完整生成流程 |
| 用户提到"手绘风格""Excalidraw""马克笔风格""水彩涂鸦""奶油描边""思维导图风""彩色铅笔""排线阴影""技术PPT风格"等风格关键词 | → 直接跳对应的 `references/styles/*.md`（见下方风格库表） |

---

## 写画图提示

核心原则（4 条，展开说明见 `references/core-principles.md`）：
1. 描述视觉物体，不指定显示文字——prompt 触发元素，不指定渲染细节
2. 不写 px/尺寸/颜色值/字号——生图模型自行决定渲染细节
3. 图类型、节点标签、箭头语义、关键数据、视觉层次是该写的内容
4. 禁止任何画图 DSL（Mermaid、draw.io、Graphviz、PlantUML）——只输出 `# 画图提示` 代码块

先判断该画哪类图 → `references/diagram-type-selector.md`（图类型快速选表 + 该画哪类架构图），再去对应的图型模板文件取 prompt 骨架：

| 图型模板文件 | 覆盖的图类型 |
| --- | --- |
| `references/templates/architecture.md` | 横向多层架构图、树形层次检索路径图 |
| `references/templates/flow.md` | 竖向三阶段流程、竖向分支流程、横向阶段列流程、两层流程（主流程+展开细节） |
| `references/templates/comparison.md` | 并排方案对比、并行双路流程、左右结果对比 |
| `references/templates/data-viz.md` | 横向条形图、公式+分级卡片、时间演化折线图、金字塔分层图 |

风格库（手绘插画 / Excalidraw / 单色马克笔 / 技术PPT 四选一，不混用）：

| 风格 | 文档 | 参考图目录 |
| --- | --- | --- |
| 手绘插画 | `references/styles/handdrawn.md` | `assets/styles/handdrawn/` |
| Excalidraw（白板斜线填充） | `references/styles/excalidraw.md` | `assets/styles/excalidraw/` |
| 单色马克笔（波浪线注释） | `references/styles/mono-marker.md` | `assets/styles/mono-marker/` |
| 水彩涂鸦（星星火花装饰） | `references/styles/doodle-watercolor.md` | `assets/styles/doodle-watercolor/` |
| 奶油描边（黑色粗描边思维导图） | `references/styles/cream-outline.md` | `assets/styles/cream-outline/` |
| 彩色铅笔质感（编号徽章+排线阴影） | `references/styles/pencil-sketch.md` | `assets/styles/pencil-sketch/` |
| 技术PPT（机器人吉祥物） | `references/styles/techppt.md` | `assets/styles/techppt/` |
| （无风格关键词/默认） | 极简专业 PPT 风格，直接在图型模板结尾加「风格：白色背景，高级技术 PPT 配图，极简专业，文字标注全部用中文。」 | — |

其他参考文档：

| 文档 | 内容 |
| --- | --- |
| `references/pitfalls.md` | 常见踩坑教训（跨风格通用） |
| `references/design-principles.md` | 设计四大原则与配色审美 |
| `references/diagram-examples.md` | 完整示例 |

---

## 生成图片

→ 查 `references/gen-workflow.md`（环境检测 → 列出画图点并补全占位标记 → 逐张生成/质检/确认 → 写入文章 → 联动提醒）

逐张生成、逐张确认，不批量、不跳过用户；`gen.sh` 必须串行执行。

---

## 依赖

- **codex CLI**（唯一的外部工具依赖，需要 ChatGPT Plus/Pro 订阅并 `codex login`）：驱动 GPT Image 2 实际生图
- 生图脚本：`scripts/gpt-image-2-gen.sh` + `scripts/extract_image.py`——已随本技能一起分发（vendored，MIT，见 `scripts/THIRD_PARTY_NOTICES.md`），**不需要单独安装 gpt-image-2 skill**
- 图床：`picgo`（需已配置 uploader）
- 风格参考图库：`assets/styles/`（`handdrawn/` 手绘插画、`excalidraw/` 白板斜线填充、`mono-marker/` 单色马克笔、`doodle-watercolor/` 水彩涂鸦、`cream-outline/` 奶油描边思维导图、`pencil-sketch/` 彩色铅笔质感、`techppt/` 技术PPT风格，配合 `--ref` 使用，对应文档见 `references/styles/`）

---

## 技能自我进化

遇到新的画图踩坑（生成结果反复出现的结构/文字/配色问题），在解决后更新对应文档，不要只在当次会话里口头记住：

- 跨风格通用踩坑（任意风格都会遇到，如断线、乱连线、留白失衡）→ `references/pitfalls.md`
- 某个风格特有的踩坑 → 该风格自己的 `references/styles/*.md` 文件
- 某个图型模板特有的踩坑 → 该模板所在的 `references/templates/*.md` 文件
