#!/usr/bin/env bash
# evolve/runner.sh —— 每周离线进化 runner（M2 记忆整理 + M3 镜头复盘 → 一份周报）
# 由 launchd 调用（scripts/init 安装，默认每周一 09:17）。手动: ME_HOME=~/.me bash skills/me/evolve/runner.sh
# 关闭: touch $ME_HOME/evolution/.disabled
set -uo pipefail

SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"   # = skills/me（框架仓，本脚本绝不改它）
ME_HOME="${ME_HOME:-$HOME/.me}"
EVO="$ME_HOME/evolution"; RUNS="$EVO/runs"
TODAY=$(date +%Y-%m-%d)
# 本周窗口起始 = 7 天前（BSD 优先，回落 GNU；可用 EVOLVE_SINCE 覆盖补跑）
SINCE="${EVOLVE_SINCE:-$(date -v-7d +%Y-%m-%d 2>/dev/null || date -d '7 days ago' +%Y-%m-%d 2>/dev/null)}"
LOCK="$EVO/.lock"; LOG="$RUNS/$TODAY.log"; REPORT="$RUNS/$TODAY.md"

mkdir -p "$RUNS" "$ME_HOME/archive"

notify() {  # $1=消息
  if [ -x "$EVO/notify.sh" ]; then "$EVO/notify.sh" "$1" "$REPORT" >>"$LOG" 2>&1 || true
  else /usr/bin/osascript -e "display notification \"$1\" with title \"/me evolve\"" 2>/dev/null || true; fi
}

# 开关
[ -f "$EVO/.disabled" ] && { echo "evolve disabled, skip"; exit 0; }

# 单实例锁（同时只跑一个）
if [ -e "$LOCK" ] && kill -0 "$(cat "$LOCK" 2>/dev/null)" 2>/dev/null; then
  echo "another evolve running, skip"; exit 0
fi
echo $$ > "$LOCK"; trap 'rm -f "$LOCK"' EXIT

if ! command -v claude >/dev/null 2>&1; then
  echo "claude CLI not found in PATH" >>"$LOG"; notify "🔴 /me 进化失败：找不到 claude CLI（看 $LOG）"; exit 1
fi

# 框架仓基线（跑完要确认它没被动过）
fw_state() { echo "$(git -C "$SKILL_DIR" rev-parse HEAD 2>/dev/null)|$(git -C "$SKILL_DIR" status --porcelain 2>/dev/null)"; }
FW_BEFORE="$(fw_state)"

# 把 orchestrator + M2 + M3 细则拼成一个 prompt（不让 agent 去 Read 框架仓）
PROMPT="$(cat "$SKILL_DIR/evolve/orchestrator.md")

========== 附录【M2 记忆整理细则】 ==========
$(cat "$SKILL_DIR/evolve/memory/consolidate.md")

========== 附录【M3 镜头复盘细则】 ==========
$(cat "$SKILL_DIR/evolve/lens-evolve/review.md")

==========（以下为本次运行的真实值，直接使用）==========
【运行日期】$TODAY
【窗口起始】$SINCE
【数据根 ME_HOME】$ME_HOME
【框架根 SKILL_DIR】$SKILL_DIR
请严格按 orchestrator 的 Step 0-4 执行；最终周报写到 $REPORT。"

echo "[$(date '+%H:%M:%S')] evolve start (window $SINCE ~ $TODAY)" >>"$LOG"
# cwd 锁定到 ~/.me（默认编辑落在数据仓）；bypassPermissions 让无 TTY 下 git 等 Bash 不被挂起
( cd "$ME_HOME" && echo "$PROMPT" | claude -p --permission-mode bypassPermissions --output-format json ) >>"$LOG" 2>&1
RC=$?
echo "[$(date '+%H:%M:%S')] claude exit=$RC" >>"$LOG"

# 机械红线①：框架仓必须零改动（不靠 prompt 自律）
if [ "$(fw_state)" != "$FW_BEFORE" ]; then
  echo "⚠️ 框架仓 $SKILL_DIR 被改动！evolve 不应碰框架。" >>"$LOG"
  notify "🔴 /me 进化异常：框架仓被改动，请检查 $SKILL_DIR（看 $LOG）"; exit 1
fi

# 机械红线②：成功 = 退出码0 且 周报真生成（claude -p 可能 RC=0 但内部出错）
if [ "$RC" -ne 0 ] || [ ! -f "$REPORT" ]; then
  notify "🔴 /me 进化异常（exit=$RC，周报未生成），看 $LOG"; exit 1
fi

notify "🧬 /me 周进化完成 $TODAY；报告：$REPORT"
exit 0
