# 平铺 Skill Library 与工作流 README 方案

Status: ready to execute
Date: 2026-11-07
Supersedes: ./2026-11-07-agent-workspace-and-skill-tiers.md

## 1. 已定决策

1. 保留 23 个 skill，删除其余 17 个。
2. 所有 skill 平铺在 `skills/<name>/`，不再有 bucket 目录。
3. `setup-matt-pocock-skills` 改名为 `setup-workflow`。
4. 这轮不考虑 `antfu/skills`，也不做 global / optional 分层。
5. 删除 `software-factory`。
6. 保留 `triage` 和 `retro`。
7. README 增加技能目录和工作流视角的使用说明。
8. `.agents/worktree`、`.agents/notes` 与 `implement-spec` 的改造放到下一轮，本轮只做仓库结构与文档。

## 2. 最终技能集

### 2.1 清单

| 阶段 | Skill | 做什么 | 被谁引用 | 整目录一起带上的文件 |
|---|---|---|---|---|
| 初始化 | `setup-workflow` | 每个 repo 跑一次，写 issue tracker、triage labels、domain docs 配置 | `to-spec`, `to-tickets`, `wayfinder`, `implement-spec`, `code-review`, `triage` | `SKILL.md`, `issue-tracker-*.md`, `domain.md`, `triage-labels.md`, `agents/` |
| 想清楚 | `grill-with-docs` | 访谈式澄清，边问边写 GLOSSARY 和 ADR | 你直接调用 | `SKILL.md`, `agents/` |
| 想清楚 | `grilling` | 访谈原语，一轮轮追问直到问题收敛 | `grill-with-docs`, `wayfinder`, `triage`, `improve-codebase-architecture` | `SKILL.md`, `agents/` |
| 想清楚 | `domain-modeling` | 维护领域词汇与 ADR | `grill-with-docs`, `wayfinder`, `triage`, `improve-codebase-architecture` | `SKILL.md`, `GLOSSARY-FORMAT.md`, `ADR-FORMAT.md`, `agents/` |
| 想清楚 | `wayfinder` | 大范围探索，建 decision ticket map | 你直接调用 | `SKILL.md`, `agents/` |
| 想清楚 | `research` | 针对一个问题查一手资料，写成带引用的笔记 | `wayfinder` | `SKILL.md`, `agents/` |
| 想清楚 | `prototype` | 一次性代码验证状态模型或 UI | 你直接调用，`wayfinder` 的 prototype ticket | `SKILL.md`, `LOGIC.md`, `UI.md`, `agents/` |
| 想清楚 | `handoff` | 把当前会话压成交接文档，换 session 继续 | 你直接调用 | `SKILL.md`, `agents/` |
| 计划 | `to-spec` | 把已有讨论收敛成 spec | 你直接调用 | `SKILL.md`, `agents/` |
| 计划 | `to-tickets` | 把 spec 拆成带阻塞边的 tracer-bullet tickets | 你直接调用 | `SKILL.md`, `agents/` |
| 实现 | `implement-spec` | 按 ticket graph 并行实现整个 spec | 你直接调用 | `SKILL.md`, `agents/` |
| 实现 | `implement` | 实现单个 ticket 或小改动 | 你直接调用 | `SKILL.md`, `agents/` |
| 实现 | `tdd` | 红绿重构循环 | `implement`, `implement-spec` | `SKILL.md`, `tests.md`, `mocking.md`, `agents/` |
| 实现 | `codebase-design` | 模块、接口、深度、seam 的共享词汇 | `tdd`, `improve-codebase-architecture` | `SKILL.md`, `DEEPENING.md`, `DESIGN-IT-TWICE.md`, `agents/` |
| 审查 | `code-review` | 从 Standards 和 Spec 两个轴 review diff | `implement`, `implement-spec` | `SKILL.md`, `agents/` |
| 审查 | `pr` | 写有证据和影响面的 PR body | 无显式调用，`implement-spec` 开 PR 时用 | `SKILL.md`, `CREDITS.md`, `agents/` |
| 记录 | `write-notes-like-deepseek` | 把非平凡改动的 why、备选、代价写进 `.agents/notes` | 你直接调用 | `SKILL.md`, `references/`, `scripts/`, `templates/`, `assets/` |
| 改进 | `retro` | 复盘一次会话，改进 agent 环境 | 你直接调用 | `SKILL.md`, `agents/` |
| 改进 | `writing-for-agents` | 写 skill、AGENTS.md 这类 agent 文档的规范 | `retro` | `SKILL.md`, `SKILL-MECHANICS.md`, `agents/` |
| 旁路 | `diagnosing-bugs` | 硬 bug 的定位纪律，先建反馈环 | 你直接调用 | `SKILL.md`, `scripts/`, `agents/` |
| 旁路 | `improve-codebase-architecture` | 扫架构深化机会，产 HTML 报告 | 你直接调用 | `SKILL.md`, `HTML-REPORT.md`, `agents/` |
| 旁路 | `triage` | 外部 issue 和 PR 的分诊状态机，产 agent brief | 你直接调用 | `SKILL.md`, `AGENT-BRIEF.md`, `OUT-OF-SCOPE.md`, `agents/` |
| 旁路 | `teach` | 多 session 教学，维护 mission、lessons、learning records | 你直接调用 | `SKILL.md`, `MISSION-FORMAT.md`, `RESOURCES-FORMAT.md`, `LEARNING-RECORD-FORMAT.md`, `GLOSSARY-FORMAT.md`, `agents/` |

### 2.2 删除清单

engineering：

- `ask-matt`
- `wizard`

productivity：

- `grill-me`
- `to-questionnaire`
- `wait-what`

misc：

- `git-guardrails-claude-code`
- `migrate-to-shoehorn`
- `scaffold-exercises`
- `setup-pre-commit`

in-progress：

- `chief-of-staff`
- `claude-handoff`
- `loop-me`
- `setup-ts-deep-modules`
- `software-factory`
- `writing-beats`
- `writing-fragments`
- `writing-shape`

deprecated：

- 整个目录，当前只有 README

删除后 bucket README 全部消失，只保留顶层 `README.md`。

## 3. 目标目录

```
skills/
  code-review/
  codebase-design/
  diagnosing-bugs/
  domain-modeling/
  grill-with-docs/
  grilling/
  handoff/
  implement/
  implement-spec/
  improve-codebase-architecture/
  pr/
  prototype/
  research/
  retro/
  setup-workflow/
  tdd/
  teach/
  to-spec/
  to-tickets/
  triage/
  wayfinder/
  write-notes-like-deepseek/
  writing-for-agents/
```

每个目录保持原样，包含 `SKILL.md`、`agents/` 和其他附属文件。

## 4. README 设计

README 分成五块，顺序如下。

### 4.1 开头

```markdown
# Skills

本地维护的 agent skill library。skills 平铺在 `skills/` 下，通过
`scripts/link-skills.sh` 软链到 `~/.agents/skills`。
```

加一行安装说明：

```sh
./scripts/link-skills.sh
```

### 4.2 工作流

先用一张流程图给出默认路线。

```
idea
  -> grill-with-docs / wayfinder
  -> prototype (optional)
  -> to-spec
  -> to-tickets
  -> implement-spec / implement
  -> code-review
  -> pr
  -> write-notes-like-deepseek
  -> retro
```

然后按阶段解释，每个阶段一段，点出用哪个 skill、产出什么、下一步去哪。

#### 0. 初始化

每个 repo 第一次使用前跑 `setup-workflow`。它写 `docs/agents/` 下的配置，后面的 skill 都读这些文件。

#### 1. 把问题想清楚

小范围用 `grill-with-docs`，它会调 `grilling` 和 `domain-modeling`，一边问一边把结论写进 `GLOSSARY.md` 和 `docs/adr/`。

大范围用 `wayfinder`。它把未知拆成 decision tickets，research 类型的 ticket 调 `research`，prototype 类型的调 `prototype`，需要讨论时调 `grilling` 和 `domain-modeling`。

需要看运行结果而不是只讨论时，用 `prototype`。要换 session 继续时，用 `handoff`。

#### 2. 变成可执行的计划

`to-spec` 把已有讨论收敛成 spec，`to-tickets` 把 spec 拆成 tracer-bullet tickets，并标出阻塞边。

#### 3. 实现

整个 spec 用 `implement-spec`。它把 tickets 当任务图，按 frontier 并行派 implementer。

单个 ticket 或小改动用 `implement`。两者内部都用 `tdd`，需要讨论模块形状时用 `codebase-design`。

#### 4. 审查与提交

`code-review` 从 Standards 和 Spec 两个轴 review diff。`pr` 负责写有证据和影响面的 PR body。

#### 5. 记录决策

`write-notes-like-deepseek` 判断这次改动是否非平凡。非平凡就写进 `.agents/notes/`，记录问题、决定、放弃的备选、代价和验证方式。

#### 6. 改进工作流

`retro` 复盘一次会话，找 agent 环境的问题：导航、自动检查、编码规范、AGENTS.md 大小、工具经济性、无效指令、信息获取。采纳的结论用 `writing-for-agents` 写回 AGENTS.md 或 skill。

#### 旁路

- `diagnosing-bugs`：硬 bug，先建反馈环再猜原因。
- `improve-codebase-architecture`：扫架构深化机会，产 HTML 报告。
- `triage`：外部 issue 和 PR 的分诊状态机，产 agent brief。只用于别人提的 issue，不用于 `to-tickets` 自己产出的 ticket。
- `teach`：多 session 教学，维护 mission、lessons、learning records。

### 4.3 技能目录

一张表，列 23 个 skill。建议列：

| 阶段 | Skill | 做什么 | 什么时候用 |
|---|---|---|---|

表格内容可以直接取 2.1 节的前四列，把“被谁引用”换成“什么时候用”。

### 4.4 目录结构

```markdown
## 目录结构

skills/<name>/SKILL.md
skills/<name>/agents/openai.yaml
```

说明所有 skill 平铺，没有分类目录，名字全局唯一。附属文件放在各自目录里。

### 4.5 维护

- 添加 skill：新建 `skills/<name>/SKILL.md`，更新 README 的技能目录，跑 `scripts/link-skills.sh`。
- 删除 skill：`git rm -r skills/<name>`，更新 README，跑脚本。
- 改名：`git mv`，更新所有引用和 README，跑脚本。
- 不加上游 remote，不加 plugin manifest。

### 4.6 写作要求

- README 不写 em-dash。
- 每个 skill 的描述从 `SKILL.md` 的 frontmatter 取，不自己发明。
- 表格里的链接指向 `skills/<name>/SKILL.md`。
- 工作流章节按“现在怎么用”写，不写尚未实现的 `.agents/worktree`。

## 5. 迁移步骤

### Step 1：创建分支

```sh
git checkout -b codex/flat-skill-library
```

### Step 2：平铺保留的 skill

```sh
for s in grill-with-docs wayfinder prototype to-spec to-tickets implement-spec \
  write-notes-like-deepseek grilling domain-modeling research \
  setup-matt-pocock-skills tdd codebase-design code-review pr implement handoff \
  writing-for-agents diagnosing-bugs improve-codebase-architecture teach retro triage; do
  src=$(find skills -mindepth 2 -maxdepth 2 -type d -name "$s")
  git mv "$src" "skills/$s"
done
```

### Step 3：删除不保留的 skill

```sh
git rm -r skills/engineering/ask-matt skills/engineering/wizard \
  skills/productivity/grill-me skills/productivity/to-questionnaire skills/productivity/wait-what \
  skills/misc/git-guardrails-claude-code skills/misc/migrate-to-shoehorn \
  skills/misc/scaffold-exercises skills/misc/setup-pre-commit \
  skills/in-progress/chief-of-staff skills/in-progress/claude-handoff \
  skills/in-progress/loop-me skills/in-progress/setup-ts-deep-modules \
  skills/in-progress/software-factory skills/in-progress/writing-beats \
  skills/in-progress/writing-fragments skills/in-progress/writing-shape
```

删除 bucket README：

```sh
git rm skills/engineering/README.md skills/productivity/README.md \
  skills/misc/README.md skills/in-progress/README.md skills/deprecated/README.md
```

### Step 4：改名

```sh
git mv skills/setup-matt-pocock-skills skills/setup-workflow
```

修改 `skills/setup-workflow/SKILL.md`：

- frontmatter `name` 改成 `setup-workflow`。
- H1 改成 `# Setup Workflow`。
- description 改成“Configure this repo for the agent workflow: issue tracker, triage labels, and domain docs.”

### Step 5：更新引用

```sh
rg -l "setup-matt-pocock-skills" skills README.md
```

逐个替换成 `setup-workflow`。涉及：

- `skills/code-review/SKILL.md`
- `skills/wayfinder/SKILL.md`
- `skills/triage/SKILL.md`
- `skills/to-tickets/SKILL.md`
- `skills/to-spec/SKILL.md`
- `skills/implement-spec/SKILL.md`
- `skills/setup-workflow/SKILL.md`

### Step 6：重写 `scripts/link-skills.sh`

```bash
#!/usr/bin/env bash
set -euo pipefail

REPO="$(cd "$(dirname "$0")/.." && pwd)"
DEST="${1:-$HOME/.agents/skills}"

mkdir -p "$DEST"

for link in "$DEST"/*; do
  [ -L "$link" ] || continue
  target="$(readlink "$link")"
  case "$target" in
    "$REPO"/*)
      [ -e "$link" ] || rm "$link"
      ;;
  esac
done

while IFS= read -r -d '' skill_md; do
  src="$(dirname "$skill_md")"
  name="$(basename "$src")"
  target="$DEST/$name"

  if [ -e "$target" ] && [ ! -L "$target" ]; then
    rm -rf "$target"
  fi

  ln -sfn "$src" "$target"
  echo "linked $name -> $src"
done < <(find "$REPO/skills" -mindepth 2 -maxdepth 2 -name SKILL.md -print0)
```

行为变化：

- 只扫描 `skills/*/SKILL.md`。
- 删除指向本仓库但目标已不存在的软链。
- 保留 `ego-browser` 等外部软链。

### Step 7：重写 `AGENTS.md`

删除或替换这些内容：

- Skills live at `skills/<bucket>/<skill-name>/SKILL.md`。
- Buckets 是 `engineering`、`productivity`、`misc`、`in-progress`、`deprecated`。
- 更新 bucket README。
- 更新 `skills/engineering/ask-matt/SKILL.md`。

新增内容：

- Skills live at `skills/<skill-name>/SKILL.md`。
- Skill names are globally unique.
- 添加、删除、改名后更新顶层 README 的技能目录。
- 添加、删除、改名后运行 `scripts/link-skills.sh`。

保留内容：

- 不加上游 remote。
- 不加 plugin manifest、marketplace metadata、release tooling。
- 保留每个 skill 的 `agents/openai.yaml`。
- 不写代码注释。
- 散文不用 em-dash。
- `docs/agents/` 保留。

### Step 8：重写 `README.md`

按第 4 节的结构写。工作流章节用现在时，只描述当前已经能用的流程，不写尚未实现的 `.agents/worktree`。

### Step 9：标记旧提案

`docs/proposals/2026-11-07-agent-workspace-and-skill-tiers.md` 已经标成 superseded，并在头部指向本文件。

### Step 10：重新链接并验证

```sh
./scripts/link-skills.sh
```

## 6. 引用更新清单

| 文件 | 改动 |
|---|---|
| `skills/setup-workflow/SKILL.md` | name、H1、description |
| `skills/code-review/SKILL.md` | `/setup-matt-pocock-skills` 改为 `/setup-workflow` |
| `skills/wayfinder/SKILL.md` | 同上 |
| `skills/triage/SKILL.md` | 同上 |
| `skills/to-tickets/SKILL.md` | 同上，出现两次 |
| `skills/to-spec/SKILL.md` | 同上 |
| `skills/implement-spec/SKILL.md` | 同上 |
| `README.md` | 完全重写 |
| `AGENTS.md` | 布局与维护规则重写 |
| `scripts/link-skills.sh` | 平铺扫描与悬空软链清理 |

## 7. 验证

```sh
find skills -mindepth 2 -maxdepth 2 -name SKILL.md | wc -l
find skills -mindepth 3 -name SKILL.md | wc -l
find skills -mindepth 1 -maxdepth 1 -type d | wc -l
rg -n "setup-matt-pocock-skills" skills README.md AGENTS.md docs/adr || true
rg -n "skills/(engineering|productivity|misc|in-progress|deprecated)/" skills README.md AGENTS.md docs/adr || true
find "$HOME/.agents/skills" -maxdepth 1 -type l ! -exec test -e {} \; -print
ls "$HOME/.agents/skills" | wc -l
```

预期：

- 第一行 23。
- 第二行 0。
- 第三行 23。
- 两个 `rg` 都没有输出。
- 断链检查没有输出。
- `~/.agents/skills` 有 24 个条目，23 个仓库软链加 `ego-browser`。

README 额外检查：

- 每个技能目录表里的链接都能打开。
- 每个 skill 的 description 与 `SKILL.md` frontmatter 一致。
- 工作流章节提到的 skill 都在 23 个之内。

## 8. 本轮不做

这些已经讨论过，但不在本轮范围。

1. `.agents/worktree` 契约与 `implement-spec` 的 worktree 改造。
2. `.agents/notes` 在 `implement-spec` 收尾时的自动写入。
3. `docs/agents/worktree.md` 与 worktree 脚本。
4. global / optional 分层。
5. `antfu/skills` 的 vendor 或外部 clone。
6. `retro` 与 `write-notes-like-deepseek` 的边界写入各自 skill。

## 9. 风险

1. 目录移动会让 `~/.agents/skills` 的旧软链短暂失效。Step 6 的脚本会清理悬空链接，Step 10 会重建。
2. `triage` 保留后，`setup-workflow` 的 Section B 仍然有效，`triage-labels.md` 不用合并进 `issue-tracker.md`。
3. `retro` 保留后，`writing-for-agents` 有了仓内消费者，不能删。
4. 删除的 skill 仍能从 git 历史恢复，不需要额外归档目录。
5. README 的技能目录容易和实际目录漂移。维护规则里要写明改 skill 集必须更新 README。
6. 平铺后名字冲突只能在添加时靠人工检查。建议在 `link-skills.sh` 里检测重复目录名，发现就报错。
