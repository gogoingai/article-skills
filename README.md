# skills

一套写作辅助技能集合，供 Claude Code 使用。

| 技能 | 作用 |
| --- | --- |
| [`article-write`](article-write/) | 中文技术文章写作主流程：规划（问卷+骨架）、逐节写作，调用下面两个技能完成配图和审查 |
| [`article-image`](article-image/) | 为文章生成 AI 配图：画图提示写作规范 + gpt-image-2 生成/质检/上传流程 |
| [`article-review`](article-review/) | 审查中文技术文章：真实性核查、连贯性、英文术语、翻译腔、AI 写作痕迹、结构自检 |

## 安装

用 [`npx skills`](https://github.com/vercel-labs/skills)（通用技能安装器，不限 Claude Code）一条命令装完：

```bash
npx skills add justis-xu/skills --all -g
```

- `--all` = `--skill '*' --agent '*' -y`（装全部技能、装到检测到的所有 agent、跳过确认）
- `-g` = 装到用户全局目录（`~/.agents/skills/` + 各 agent 的技能目录），不加则装到当前项目

**开发这几个技能时的注意事项**：`npx skills add` 会把技能内容拉取一份独立快照放到 `~/.agents/skills/<name>`，**不是** symlink 回这个 git 仓库。所以改完 `article-write` / `article-image` / `article-review` 里的任何文件后，要：

```bash
git push                      # 先推到 GitHub
npx skills update             # 再拉取最新版本同步到本地技能目录
```

只改本仓库文件、不 push、不 update，改动不会在 Claude Code 里生效。

版本记录见 [CHANGELOG.md](CHANGELOG.md)。
