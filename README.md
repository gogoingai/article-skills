# skills

一套写作辅助技能集合，主要面向 Claude Code，也可通过 `npx skills` 装到其他 agent。

| 技能 | 作用 |
| --- | --- |
| [`article-write`](article-write/) | 中文技术文章写作主流程：规划（问卷+骨架）、逐节写作，调用下面两个技能完成配图和审查 |
| [`article-image`](article-image/) | 为文章生成 AI 配图：画图提示写作规范 + gpt-image-2 生成/质检/上传流程 |
| [`article-review`](article-review/) | 审查中文技术文章：真实性核查、连贯性、英文术语、翻译腔、AI 写作痕迹、结构自检 |

## 安装

用 [`npx skills`](https://github.com/vercel-labs/skills)（通用技能安装器，不限 Claude Code）一条命令装完：

```bash
npx skills add gogoingai/article-skills --all -g
```

- `--all` = `--skill '*' --agent '*' -y`（装全部技能、装到检测到的所有 agent、跳过确认）
- `-g` = 装到用户全局目录（`~/.agents/skills/` + 各 agent 的技能目录），不加则装到当前项目

**`article-image` 额外依赖 `gpt-image-2`（必装，不会自动带上）**：`npx skills` 不支持"技能依赖技能"，装 article-skills 不会连带装 gpt-image-2。不装的话 article-image 能正常写画图提示，但真正调用生成图片这一步会失败（有兜底：打印安装指引、不报错崩溃、文章不受影响）。想用生成功能就提前装：

```bash
npx skills add agentspace-so/agent-skills --skill gpt-image-2 -g
```

**开发这几个技能时的注意事项**：`npx skills add` 会把技能内容拉取一份独立快照放到 `~/.agents/skills/<name>`，**不是** symlink 回这个 git 仓库。所以改完 `article-write` / `article-image` / `article-review` 里的任何文件后，要：

```bash
git push                      # 先推到 GitHub
npx skills update             # 再拉取最新版本同步到本地技能目录
```

只改本仓库文件、不 push、不 update，改动不会在 Claude Code 里生效。

## 开发约定

**跨技能引用一律用 `~/.agents/skills/<name>/...`，禁止写 `~/.claude/skills/<name>/...`。** `~/.agents/skills/` 是 `npx skills` 每次安装都会建的 canonical 位置；`~/.claude/skills/` 只是装了 Claude Code 时才会有的派生 symlink，其他 agent 上不存在。写 `.claude` 路径会导致装到非 Claude agent 时找不到文件。

技能内容里出现的 `AskUserQuestion`、`TaskCreate`、`Skill` 工具是 Claude Code 专属工具名，其他 agent 没有时按各 SKILL.md 顶部的"工具等价说明"退化执行，不强行假设所有 agent 都有这些工具。

版本记录见 [CHANGELOG.md](CHANGELOG.md)。
