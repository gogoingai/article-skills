# Changelog

本文件记录仓库里所有技能的重大变更，按发布时间倒序排列。

## 2.2.0 — 安装方式改用 npx skills，移除 setup.sh

改用通用技能安装器 [`npx skills`](https://github.com/vercel-labs/skills)（`npx skills add justis-xu/skills --all -g`）作为唯一安装方式，移除仓库自带的 `setup.sh`。

- 好处：一条命令装到 72+ 种 agent（不限 Claude Code），有官方的 `update`/`remove`/`list` 生命周期管理
- 代价：`npx skills add` 把技能内容拉取为独立快照放在 `~/.agents/skills/<name>`，**不再是** symlink 回本仓库——本仓库文件改动后必须 `git push` + `npx skills update` 才会生效，不再是"改完立即生效"
- README 已更新为新的安装说明和开发时的 push+update 提醒

## 2.1.0 — article-write 规划流程对齐 gstack spec 的三个纪律

参考 gstack `spec` 技能的五阶段设计（理解动机→划定边界→技术追问→草稿评审→质量门禁），给 `article-write` 的规划阶段（Step 1~3.5）补齐三处此前缺失的纪律：

- **证据前置**：生成系统专属问卷、问技术类问题之前，必须先用 Grep/Read 扫描定位到具体 `path:line`，禁止凭项目名/README 一句话描述就出题；找不到证据要如实说明，不能假装扫过。
- **范围锁定（新增 Step 1.5 / 问卷 D0）**：骨架前必须问清楚"这次明确不覆盖什么"和"篇幅砍半时保留什么"，写入 `context.md` 的 `## 范围锁定` 字段，防止骨架阶段贪多、写到一半才发现摊子太大。
- **骨架质量自检（新增 Step 3.4）**：骨架经用户确认后、进入任务列表前，自查三要素完整性、关键机制是否有源码依据、是否超出范围锁定、篇幅预算是否合理；发现问题先给用户看，最多来回调整 2 轮，不无限打磨。

## 2.0.0 — 拆分为三个技能

将原本单一的 `zh-tech-intro` 技能（已改名 `article-write`）按"用户会不会脱离主流程单独触发"这个标准拆分为三个协作技能，避免单个技能文件无限膨胀：

- **新增 `article-image`**：迁出全部画图相关内容（画图提示写作规范、gpt-image-2 生成/质检/上传流程、`gen-image.sh` 环境检测脚本、画图完整示例、手绘/技术PPT风格参考库）。可被直接触发（"画个架构图"），也可被其他写作技能通过 `Skill` 工具在配图阶段调用。
- **新增 `article-review`**：迁出全部审查相关内容（R0 真实性核查、R1 英文术语、R2 翻译腔、R3 AI 写作痕迹、R4 结构自检、R5 连贯性，含术语表和 AI 写作模式库）。支持两种使用方式：独立触发时走 `Skill` 工具完整调用；被 `article-write` 写作/修改过程中高频复用时，直接 Read 规则文件内联执行，不发起额外的技能调用。
- **`zh-tech-intro` 改名 `article-write` 并重构为写作主协调技能**：只负责规划（问卷+骨架）和逐节写作，写作阶段配图只插入占位标记 `> 🖼️ 待配图：[描述]`，全文定稿后统一调用 `article-image`；审查逻辑改为调用/内联 `article-review`。命名与 `article-image`/`article-review` 统一为 `article-*` 前缀。个人数据目录 `~/.gogoingai/zh-tech-intro/` 同步改名为 `~/.gogoingai/article-write/`。
- **新增仓库级 `setup.sh`**：为仓库里每个含 `SKILL.md` 的顶层目录创建 `~/.agents/skills/<name>` 和 `~/.claude/skills/<name>` 的 symlink，幂等，支持单独指定技能名。
- **新增仓库级 `VERSION` / `CHANGELOG.md`**：本仓库现在是一个多技能集合，版本号覆盖全部技能整体，不是单个技能各自记版本。

## 1.x — 单技能时代（历史，未逐版本记录）

`zh-tech-intro` 作为唯一技能，内置全部规划、写作、画图、审查逻辑，靠内部的 `references/` 分层做按需加载。详见 2.0.0 之前的 git 历史。
