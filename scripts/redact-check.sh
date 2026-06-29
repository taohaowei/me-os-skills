#!/usr/bin/env bash
# redact-check.sh —— 发布前红线扫描（防止个人/第三方/公司敏感信息泄进公开仓）
#
# 两层检测：
#   1) 内置「通用结构」模式——不暴露作者身份，CI 也能跑（内网 IP / 私钥 / 密钥串 / 会话 cookie）
#   2) 私有黑名单——真实人名/公司/项目代号等，存在 $ME_HOME/.redact-blocklist（绝不入仓）
#      本地 push 前跑会自动加载它；CI 上没有这个文件，只跑通用检测。
#
# 用法：  bash scripts/redact-check.sh          # 扫整个仓库工作树（排除 .git）
#         命中任意模式 → 退出码 1（阻断发布）
set -uo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ME_HOME="${ME_HOME:-$HOME/.me}"
BLOCKLIST="$ME_HOME/.redact-blocklist"

# ---- 1) 通用结构模式（公开安全，不含任何具体身份）----
GENERIC_PATTERNS=(
  '\b10\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\b'          # 内网 IP 10.x
  '\b192\.168\.[0-9]{1,3}\.[0-9]{1,3}\b'                # 内网 IP 192.168.x
  '\b172\.(1[6-9]|2[0-9]|3[01])\.[0-9]{1,3}\.[0-9]{1,3}\b' # 内网 IP 172.16-31.x
  '-----BEGIN [A-Z ]*PRIVATE KEY-----'                  # 私钥
  'AKIA[0-9A-Z]{16}'                                    # AWS Access Key
  '(secret|token|password|passwd|api[_-]?key)[[:space:]]*[:=][[:space:]]*['"'"'"][^'"'"'"]{12,}' # 硬编码密钥
  '_session=[0-9a-fA-F]{8}-[0-9a-fA-F]{4}'              # 会话 cookie(UUID 形态)
  '@[a-z0-9.-]*corp\.[a-z.]+'                           # 企业内网邮箱域名
)

EXCLUDES=(":!.git/*" ":!*.redact-blocklist")
hits=0

scan() {
  local label="$1"; shift
  local pat="$1"
  # 用 git grep（只扫已跟踪+工作树），命中则打印
  if out=$(cd "$REPO_ROOT" && grep -rnaE "$pat" . --exclude-dir=.git 2>/dev/null); then
    if [ -n "$out" ]; then
      echo "❌ [$label] 命中模式: $pat"
      echo "$out" | sed 's/^/    /'
      hits=$((hits+1))
    fi
  fi
}

echo "==> 通用结构红线扫描 (REPO=$REPO_ROOT)"
for p in "${GENERIC_PATTERNS[@]}"; do scan "generic" "$p"; done

# ---- 2) 私有黑名单（真名/公司/项目）----
if [ -f "$BLOCKLIST" ]; then
  echo "==> 加载私有黑名单 $BLOCKLIST"
  while IFS= read -r line; do
    line="${line%%#*}"; line="$(echo "$line" | xargs)"   # 去注释与空白
    [ -z "$line" ] && continue
    scan "private" "$line"
  done < "$BLOCKLIST"
else
  echo "⚠️  未找到私有黑名单 $BLOCKLIST —— 只跑了通用检测。"
  echo "    本地 push 前请确保该文件存在（含真名/公司/项目代号），否则真名类泄露无法被拦截。"
fi

echo "----------------------------------------"
if [ "$hits" -gt 0 ]; then
  echo "🔴 红线扫描发现 $hits 类命中 —— 禁止发布，请先清理。"
  exit 1
fi
echo "✅ 红线扫描通过（无命中）。"
