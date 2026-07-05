# skills

一套写作辅助技能集合，供 Claude Code 使用。

| 技能 | 作用 |
| --- | --- |
| [`article-write`](article-write/) | 中文技术文章写作主流程：规划（问卷+骨架）、逐节写作，调用下面两个技能完成配图和审查 |
| [`article-image`](article-image/) | 为文章生成 AI 配图：画图提示写作规范 + gpt-image-2 生成/质检/上传流程 |
| [`article-review`](article-review/) | 审查中文技术文章：真实性核查、连贯性、英文术语、翻译腔、AI 写作痕迹、结构自检 |

## 安装

```bash
./setup.sh          # 注册仓库里所有技能
./setup.sh <name>   # 只注册某一个
```

会在 `~/.agents/skills/` 和 `~/.claude/skills/` 下建 symlink，幂等，不会覆盖已有的非本仓库文件。

版本记录见 [CHANGELOG.md](CHANGELOG.md)。
