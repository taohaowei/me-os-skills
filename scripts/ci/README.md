# CI（红线 gate 工作流）

`redact-gate.yml` 是一个 GitHub Actions 工作流，在 push / PR 时运行 `scripts/redact-check.sh` 的**通用结构检测**（内网 IP / 私钥 / 密钥串等），作为发布红线 gate。

## 为什么放在这里、默认未启用

首次开源时本地 `gh` token 缺少 `workflow` scope，无法经 OAuth 直接推送 `.github/workflows/` 下的文件，因此先把它放在 `scripts/ci/`。启用方式二选一：

1. **命令行**：
   ```bash
   gh auth refresh -s workflow -h github.com
   mkdir -p .github/workflows && cp scripts/ci/redact-gate.yml .github/workflows/
   git add .github/workflows/redact-gate.yml && git commit -m "ci: 启用红线 gate" && git push
   ```
2. **网页版**：在 GitHub 仓库里新建 `.github/workflows/redact-gate.yml`，粘贴本目录 `redact-gate.yml` 的内容。

## 注意

CI 环境里**没有** `$ME_HOME/.redact-blocklist`（真名清单是私有的，永不入仓），所以 CI 只能跑通用结构检测；**真名类检查必须靠本地 push 前运行** `ME_HOME=~/.me bash scripts/redact-check.sh`。
