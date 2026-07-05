---
name: article-review
description: 审查中文技术文章质量：真实性核查（对照源码）、连贯性、英文术语规范、翻译腔、AI 写作痕迹、结构自检。适用于任何中文技术文章，不限定必须是 article-write 写出来的。触发关键词：审查、检查一下、看看有没有问题、review、整体看看。也可被其他写作类技能通过 Skill 工具调用，或直接被内联引用（见下方"两种被使用的方式"）。
---

# 文章审查 Skill

## 两种被使用的方式

审查在一篇文章的生命周期里会被高频小跑（每改一节可能就要过一遍语言审查），也会被单独整体触发，两种场景对"要不要走完整一轮 Skill 调用"的要求不一样：

| 场景 | 方式 |
| --- | --- |
| 用户直接说"审查这篇文章"、"看看有没有问题" | 独立触发，走完整流程（见下方「审查流程」） |
| 其他写作技能（如 article-write）在写作/修改过程中反复用到 R1~R4 | **不要每次都用 `Skill` 工具发起一轮新调用**——直接用 Read 工具读取本技能 `references/` 下对应的规则文件（如 `r1-english.md`），内联执行检查，把结果并入调用方自己的流程里 |

> **工具等价说明**："`Skill` 工具"是 Claude Code 的跨技能调用机制名。其他 agent 没有对应机制时，按上表第二种方式处理——直接 Read 本技能文件内联执行。

---

## 审查流程

→ 查 `references/index.md`（核心规则、执行顺序、报告格式）

| 步骤 | 文件 | 内容 |
|------|------|------|
| R0 | `references/r0-factcheck.md` | 真实性核查（对照源码，揪编造/写错的内容） |
| R5 | `references/r5-coherence.md` | 连贯性 + 清晰度 |
| R1 | `references/r1-english.md` | 英文术语检查（依赖 `references/language/glossary.md`） |
| R2 | `references/r2-translation.md` | 翻译腔审查 |
| R3 | `references/r3-ai-patterns.md` | AI 写作痕迹（依赖 `references/language/humanizer-zh.md`） |
| R4 | `references/r4-structure.md` | 结构自检（默认跳过，用户要求"完整审查"时才跑） |

默认自动模式：触发时 R0→R5→R1→R2→R3 一次性跑完，发现问题直接修，全部完成后一次性汇报。用户说"手动审查"时才切换为每步等确认。

---

## 依赖

- `references/language/glossary.md`、`references/language/humanizer-zh.md`：本技能自带的术语表和 AI 写作模式库，独立可用
- 若同时安装了 article-write：R2/R4 会交叉参考它的翻译工作流和写作禁止事项清单，增强判断依据，但不是硬依赖——没装也能正常审查

---

## 技能自我进化

遇到新的审查踩坑（反复出现但清单里没覆盖的问题类型），更新对应 `references/rN-*.md`，不要只在当次会话里口头记住。
