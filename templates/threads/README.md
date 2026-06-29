# threads 模板说明

> 用途说明：本目录提供 5 类"议题线（thread）"的空骨架模板，每个模板对应一种心理学 / 管理学方法论。复制到 $ME_HOME 后填写。（本文件为结构模板说明）

---

## 什么是 thread

一条 thread 是一个长期议题——一段关系、一组信念、一次转型——它会跨越多次对话不断更新。模板提供结构骨架，你只需把占位符 `<...>` / `{{...}}` 换成自己的内容。

数据根统一为 `$ME_HOME/...`（默认 `~/.me`）。框架文件（experts / frameworks / toolkit / SKILL.md）与本仓同级。

---

## 模板与方法论对照

| 模板文件 | 方法论 | 适用场景 |
|----------|--------|----------|
| `relationship-dynamics.template.md` | 系统式家庭治疗 | 看清三代关系结构、不成文规则、反复上演的剧本与代际传递 |
| `cognitive-beliefs.template.md` | CBT（认知行为疗法） | 梳理核心信念、识别思维陷阱、用思维日记与证据松动旧信念 |
| `narrative.template.md` | 叙事疗法 | 把问题与人分开、外化问题、发现例外、重写自我叙事 |
| `single-relationship.template.md` | 单一关系议题追踪 | 聚焦某一段具体关系的长期脉络、滤镜偏差与互动策略 |
| `career-transition.template.md` | 管理转型教练 | 统筹一次职业转型 / 项目落地，自检转型陷阱、沉淀方法 |

---

## 填写指引

1. **先复制再填**：把模板复制到 `$ME_HOME` 下对应位置，不要直接改模板本身。
2. **通用文件头**：每个文件顶部都包含
   - `# <thread标题>`
   - `> 一句话隐喻`
   - `> 关联：[[<related_thread>]]、$ME_HOME/relations/<role>/<placeholder>`
   - `> 最后更新 <YYYY-MM-DD>`
   填写时同步更新隐喻、关联与日期。
3. **占位符规范**：统一用尖括号 `<...>` 或 `{{...}}`，如 `<姓名>`、`<YYYY-MM-DD>`、`{{user_name}}`。
4. **关联用 relations 档案**：涉及具体的人时，链接到 `$ME_HOME/relations/<role>/<placeholder>`，避免在 thread 里重复堆人物信息。
5. **持续更新**：thread 是活的，每次有新进展就追加一行 / 更新一格，并刷新"最后更新"日期。
6. **隐私**：本目录为公开开源模板，任何复制后填写的真实内容都只存在于本地 `$ME_HOME`，不要回流到开源仓。
7. **危机情形**：涉及自伤 / 危机时，参考 `config/crisis-hotlines.{{locale}}.md`。
