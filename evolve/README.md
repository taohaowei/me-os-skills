# evolve —— 自动进化（M2 记忆整理 + M3 镜头复盘）

**每周一**离线跑一次：先看这周有没有新对话，有则把 `~/.me` 的记忆整理干净（**M2**）、复盘本周对话产出框架改进建议（**M3**），合成**一份周报**写到 `$ME_HOME/evolution/runs/YYYY-MM-DD.md`。

> 这是把原 `sleep/` 的"单 agent 沉淀"升级成"M2 + M3 双流水线"。能力（prompts/编排）在框架仓；调度、投递与全部数据在本地 `~/.me`。
> **`scripts/init` 安装 evolve 时会自动退役旧 `sleep/`（卸载其 launchd + 归档目录），二者不并存。**

## 三个文件

- **`orchestrator.md`** —— 总编排：跑 M2、跑 M3、**对抗核验（回查磁盘实况）**、本地提交、写当日唯一日报。
- **`memory/consolidate.md`（M2）** —— 冷热分层 / 去冗余 / 保专业 / 跨文件一致性 / SAFETY 复评。改 `~/.me`，**只归档不删除**，本地 `commit`、**不 push**。
- **`lens-evolve/review.md`（M3）** —— 复盘对话→意图/升级是否得当/质量→**只产通用框架改进建议**，写进日报等人工 review。**不自动改框架、不做个人调参。**

## 数据都在 ~/.me（私有）

- `~/.me/evolution/runs/YYYY-MM-DD.md` —— 每次运行**唯一**的进化过程 + 报告（M3 建议写在里面，不另开文件）。
- `~/.me/archive/` —— M2 归档的冷记忆（**不被 /me 启动加载**，需要时可回捞）。

## 开 / 关（默认开）

随 `scripts/init` 自动启用（macOS launchd，**每周一 09:17**）。

```bash
# 关闭
touch "$ME_HOME/evolution/.disabled"        # 或 launchctl unload ~/Library/LaunchAgents/<label>.plist
# 手动跑一次
ME_HOME=~/.me bash evolve/runner.sh
# 补跑某天
EVOLVE_DATE=2026-06-28 ME_HOME=~/.me bash evolve/runner.sh
```

## 通知

默认 macOS 通知。要换成自己的（如 IM 推送）：放一个可执行的 `$ME_HOME/evolution/notify.sh "<消息>" "<报告路径>"`（本地、私有，不进框架仓）。

## 边界（硬规则）

- 只动数据仓 `~/.me`；**绝不自动改框架仓 `skills/me`**（M3 建议靠人工 review → 改 → 过红线 gate → push）。
- 只归档不删除；**SAFETY 不自动降级**；昨日无对话且无更新则跳过。
