# article-write 内容索引

## 核心文件

| 文件 | 内容 |
|------|------|
| `SKILL.md` | 三条主流程（从0到1 / 修改 / 审查）+ 核心原则 |
| `references/INDEX.md` | 本文件，全局内容导航 |

> **配图**已拆分为独立技能 **article-image**（写画图提示、调用 gpt-image-2 生成、质检、上传、写入文章）。本技能的写作阶段只插入占位标记 `> 🖼️ 待配图：[描述]`，全文定稿后用 `Skill` 工具调用 article-image 统一处理，见 `SKILL.md` Step 5。
>
> **审查**（R0~R5）已拆分为独立技能 **article-review**。用户独立触发"审查"时用 `Skill` 工具调用它；写作/修改过程中反复用到的 R0~R4，直接 Read 它的 `references/` 文件内联执行，不发起 `Skill` 调用，见 `SKILL.md`「审查」一节。
>
> **翻译**（英文素材转中文）已拆分为独立技能 **article-translate**。Step 2 素材是英文时用 `Skill` 工具调用它，它会自己当场触发 article-review 的 R2 审查，本技能不用重复触发。

---

## references/planning/ — 规划阶段

| 文件 | 内容 |
|------|------|
| `questionnaire.md` | 项目问卷生成指南：证据前置扫描 + 六维问题（含范围锁定）+ context.md 写入格式 + 后续会话加载 + 补充提问规则 |
| `modes.md` | A/B/C 三种文章模式骨架模板（快速入门 / 架构深挖 / 方案对比） |
| `skeleton.md` | 骨架写作指南：颗粒度要求、示例格式、大改时的变更写法 |

---

## references/writing/ — 写作规范

| 文件 | 内容 |
|------|------|
| `style-guide.md` | 完整写作风格规范（行文、结构、语言，含 Hard Gates） |
| `anti-patterns.md` | 禁止事项清单（35 条），含定稿自检清单 |

---

## references/examples/ — 示例

| 文件 | 内容 |
|------|------|
| `memoryos-sample.md` | 架构深挖型文章节选（Mode B 参考） |
| `powermem-sample.md` | 含折线图、公式卡片的画图提示示例 |
| `mem0-sample.md` | 版本对比型文章节选（Mode C 参考） |
| `claude-memory-sample.md` | 完整文章样例（Mode B · R2），12 处画图提示全覆盖 |
