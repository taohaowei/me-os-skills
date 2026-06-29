# 5 分钟上手

> 本文档带你从零跑通：把本框架装成 Claude Code 技能 → 用 `scripts/init` 生成私有数据仓 `$ME_HOME` → 填配置 → 完成第一次 `/me` 对话。海外用户见第 5 步切换危机热线。
> 内容为纯框架说明，不含任何真实数据。

开始前先记住核心模型：**框架（本仓）是公开的镜头与方法论；你的真实档案在 `$ME_HOME`（默认本地私有目录）这个本地私有仓里，两者永不混在一起。**

---

## 步骤 1 · 安装为 Claude Code 技能

把本仓放到 Claude Code 的技能目录下，使它能被识别为一个技能：

```bash
# 克隆到你的技能目录（路径以本机 Claude Code 配置为准）
git clone <本仓地址> ~/.claude/skills/me
```

验证：本仓根目录存在 `SKILL.md`，且 `experts/`、`docs/`、`scripts/` 与它同级。Claude Code 读到 `SKILL.md` 即可通过 `/me` 唤起。

---

## 步骤 2 · 跑 init 脚手架，生成 `$ME_HOME`

`scripts/init` 会从框架模板生成你的私有数据仓。它**可重复运行，已存在的文件不会被覆盖**。

```bash
bash ~/.claude/skills/me/scripts/init
```

它会做这几件事：

- 在 `$ME_HOME` 下建好目录：`core/`、`relations/`（家人 / 团队 / 干系人分类）、`threads/`、`sessions/`、`decisions/`、`projects/`、`health/`、`config/` 等。
- 从模板拷出初始档案：`core/PROFILE.md`、`core/STATE.md`、`core/SAFETY.md`、健康子系统文件等（均为带占位符的结构模板，待你填写）。
- 拷出 `config/user.config`（见下一步）。
- 对 `$ME_HOME` 执行 `git init`，建成一个**本地私有仓，且不设任何 remote**。

> 想把数据放到别处？运行前设环境变量即可：`ME_HOME=<你的路径> bash ~/.claude/skills/me/scripts/init`。
>
> 永远不要给 `$ME_HOME` 设置 git remote、也不要推送到任何公开位置——里面是你的真实数据。

---

## 步骤 3 · 填写 `config/user.config`

编辑刚生成的 `$ME_HOME/config/user.config`，至少填两项（用占位符示意，按需替换）：

```yaml
# 助手怎么称呼你（框架里的 {{user_name}} 会在运行时替换成它）
name: <你的称呼>

# 区域：决定危机热线读取哪一份 config/crisis-hotlines.{{locale}}.md
locale: {{locale}}
```

其余字段（数据根路径、启用哪些镜头）可选，留默认即可。这个文件属于个人数据，**只存在 `$ME_HOME`，永不进开源仓**。

---

## 步骤 4 · 第一次 `/me` 对话

在 Claude Code 里直接说：

```
/me
```

第一次对话会发生：

1. **安全协议前置**：助手启动即先读 `$ME_HOME/core/SAFETY.md`。这是每次必查的步骤——若对话中出现风险信号，会触发危机流程并给出本地化热线（见步骤 5）。
2. **镜头路由**：助手是一个统一人格，会按你聊的话题动态加载对应镜头（见 `lens-routing.md`），**不切换人格**。
3. **渐进式建档**：助手不会一上来就盘问。它按 L1-L5 渐进，每次只深化 0.5-1 级，并对每条信息标注 `[事实]` / `[判断]` / `[假设]` 与 `[来源]`（见 `methodology.md`）。你只管自然地聊，档案会逐步在 `$ME_HOME` 里长出来。

随便从一个真实困扰开始即可。第一次对话档案为空属正常，助手会从表层事实（L1）起步。

---

## 步骤 5 · 海外用户：切换危机热线 locale

危机热线**绝不硬编码号码**，而是按 locale 读取对应文件：`config/crisis-hotlines.{{locale}}.md`。

海外用户两种做法：

1. **切到已有 locale**：在 `$ME_HOME/config/user.config` 把 `locale` 改成你所在地区。
2. **本地化你所在地区的热线**：复制一份地区中立兜底版本，填入当地求助资源，再把 `locale` 指过去。

> 这份内容关系到危机时刻能否拿到正确的求助方式，请务必在正式使用前确认它指向你当地有效的资源。框架本身只引用 `config/crisis-hotlines.{{locale}}.md`，从不内联任何号码。

---

## 重要提醒：数据仓勿设 remote

- `$ME_HOME` 是你的私有数据仓，**绝不要 `git remote add` 推到任何远端**。
- 公开的是框架（技能目录），私有的是数据（`$ME_HOME`），两者物理分离。
- 任何沉淀、通知、后台任务都在本地完成，属于本地私有范畴，不进入公开仓。

---

## 下一步

- 想理解助手如何工作 → 读 `docs/methodology.md`。
- 想了解镜头路由与如何新增视角 → 读 `docs/lens-routing.md`。
