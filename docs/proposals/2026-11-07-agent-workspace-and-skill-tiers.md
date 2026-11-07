# Agent Workspace 与 Skill 分层提案

Status: superseded
Superseded by: ./2026-11-07-flat-skill-library-plan.md
Date: 2026-11-07
Audience: 参与设计评审的另一个 agent

## 0. 一句话

把 `.agents/` 变成所有长任务的共享工作区：用 `.agents/worktree/` 隔离 integration 与 ticket 分支，用 `.agents/notes/` 留决策，用 `.agents/run/` 放临时产物，用 `.agents/skills/` 做项目级 optional 能力；同时把仓库里的 skills 分成 global 与 optional 两级。

## 1. 背景

### 1.1 仓库现状

- 这是一个本地 skill library，fork 自 `mattpocock/skills`，不是发布的 plugin。
- `scripts/link-skills.sh` 把 `skills/<bucket>/<skill>` 软链到 `~/.agents/skills`。
- 当前 bucket 是 `engineering`、`productivity`、`misc`、`in-progress`、`deprecated`。
- 已完成的 handoff 把 36 个 skill 软链到全局目录，`misc/` 下 4 个 skill 有意不链，`ego-browser` 是插件管理的软链，不能被脚本删除。
- 仓库约束：不加上游 remote，不做上游同步，不加 plugin manifest，改 skill 集后要更新 bucket README、顶层 README、`skills/engineering/ask-matt/SKILL.md`，并运行 `scripts/link-skills.sh`。

### 1.2 用户当前工作流

```
grill-with-docs / wayfinder
  -> prototype
  -> to-spec
  -> to-tickets
  -> implement-spec
```

实现结束后，用户希望把这次工作的决策与经验沉淀到 `.agents/notes/`，参考 deepseek-harness 的 `.agents/notes` 实践和本地 `write-notes-like-deepseek` skill。

### 1.3 不适感的具体来源

1. **integration branch 落在主工作区**
   `implement-spec` 只说“创建 integration branch”，没有说在哪个 worktree 创建。agent 默认在当前工作目录执行，于是主工作区被切到 integration branch，用户原来的分支和上下文被打断。

2. **worktree 路径没有契约**
   `implement-spec` 说每个 ticket 用独立 worktree，但没有规定 worktree 放在哪里、如何命名、如何清理。不同 agent 会各自发明路径。

3. **研究笔记被要求放到 repo 外**
   `implement-spec` 建议 exploration subagent 把笔记保存到 repo 外的目录。这和用户希望 `.agents/` 成为工作重心的方向相反，也不利于后续 subagent 用稳定路径引用。

4. **实现结束后没有决策沉淀**
   现在 `implement-spec` 在第 8 步就结束。非平凡改动为什么这样做、放弃了什么，没有进入 `.agents/notes/`，下一个改这段代码的 agent 看不到。

5. **所有 skill 都是全局的**
   用户想同步 `antfu/skills` 这类第三方偏好，但不想让 Vue、Vitest、pnpm 的描述污染所有项目的 skill catalog。

## 2. 设计原则

1. **一份契约，多个 skill 共享**
   路径、分支、worktree 生命周期只定义一次，不让五个 skill 各自复制一段规则。

2. **主工作区在 run 期间保持不动**
   用户当前的分支、未提交改动、编辑器状态都不应该被 integration branch 打断。

3. **临时记忆与长期记忆分开**
   `.agents/run/` 是本次 effort 的工作记忆，可以丢。`.agents/notes/` 是长期决策记录，要提交、要验证、要能被检索。

4. **optional 能力按项目启用**
   Vue、Vitest、pnpm 的偏好只在相关项目里加载，不进入全局 skill catalog。

5. **第三方 skill 用 vendor，不用 submodule 或 remote**
   仓库不能被上游 remote 绑住，也不能让同步依赖网络运行时。

6. **notes 记录决策，不记录日记**
   “为什么选 A 不选 B、放弃了什么、怎么证明”进 notes。“下次 agent 该怎么协作”进 `AGENTS.md` 或 skill，走 `retro`。

## 3. `.agents/` 布局

### 3.1 目录树

```
<repo>/
  .agents/
    .gitignore
    notes/
      proposed/
      implemented/
      rejected/
      archived/
    run/
      <effort>/
        state.md
        research/
        prototype/
        handoff/
        note-candidates/
    worktree/
      <effort>/
        integration/
        <ticket-id>/
    skills/
```

### 3.2 每个目录的职责

| 路径 | 是否提交 | 生命周期 | 写入者 | 内容 |
|---|---|---|---|---|
| `.agents/notes/` | 是 | 长期 | historian、implement、人工 | 决策记录，遵循 `write-notes-like-deepseek` |
| `.agents/run/<effort>/` | 否 | 单次 effort | orchestrator、subagents | research、prototype、handoff、候选笔记、运行清单 |
| `.agents/worktree/<effort>/` | 否 | 单次 effort | `agent-workspace` 脚本 | integration 与 ticket 的 git worktree |
| `.agents/skills/` | 否，默认 | 项目 | `enable-optional.sh` | 项目级 optional skill 软链 |

### 3.3 `.agents/.gitignore`

```gitignore
run/
worktree/
skills/
```

`notes/` 不忽略，保持可提交。若宿主项目在根 `.gitignore` 里整体忽略 `.agents/`，`agent-workspace` 要在 preflight 阶段检测并警告，因为那样 notes 不会进入 PR。

### 3.4 路径解析规则

- `.agents/run/<effort>/` 使用**主工作区的绝对路径**，由 orchestrator 在 `state.md` 里记录。
- 所有 subagent 通过绝对路径读写这个共享目录，不依赖自己的当前工作目录。
- `.agents/worktree/<effort>/` 也由主工作区解析，路径同样写进 `state.md`。
- 这样即使 subagent 在 ticket worktree 里工作，也不会把候选笔记写到错误的分支里。

### 3.5 `state.md` 运行清单

`agent-workspace init` 生成，orchestrator 持续更新：

```markdown
# Effort: <slug>

Spec: <link>
Base: <sha>
Integration branch: agent/<effort>
Integration worktree: <absolute path>
Run directory: <absolute path>

## Tickets

| Ticket | Worktree | Branch | Status |
|---|---|---|---|
| T01 | <absolute path> | agent/<effort>/t01 | pending |
```

这张表解决三个问题：断点恢复、subagent 路径传递、清理时知道哪些 worktree 还活着。

## 4. Effort 命名与分支

### 4.1 Effort slug

- 优先使用 spec 的稳定标识。GitHub tracker 用 `spec-<issue-number>`，本地 tracker 用 `<feature-slug>`。
- 只保留小写字母、数字、连字符。
- 同一个 effort 的所有路径和分支都基于这个 slug。

### 4.2 分支与 worktree

```
integration branch: agent/<effort>
ticket branch:      agent/<effort>/<ticket-id>

integration worktree: .agents/worktree/<effort>/integration
ticket worktree:      .agents/worktree/<effort>/<ticket-id>
```

默认 `agent/` 前缀，避免把 feature 与 bug fix 的语义硬编码进分支名。PR 标题负责表达类型。

### 4.3 base ref

- 默认使用主工作区当前 `HEAD` 的 commit SHA。
- 允许 `--base main` 或 `--base origin/main` 覆盖。
- 主工作区 dirty 时停止，提示用户提交或 stash。提供 `--allow-dirty` 作为显式逃生口。
- 如果当前分支已经是 `agent/<effort>`，拒绝继续，避免在 integration worktree 之外操作同一分支。

## 5. 新 skill：`agent-workspace`

### 5.1 为什么单列一个 skill

如果只改 `implement-spec`，`wayfinder`、`prototype`、`implement` 仍然会各自发明临时目录。路径规则复制到五个 skill，下次改路径要改五处。`agent-workspace` 作为唯一契约，负责：

- `.agents/` 布局与 `.gitignore`
- worktree 创建、列出、删除、清理
- `state.md` 运行清单
- preflight 与路径解析
- 失败时的诊断信息

它属于 `skills/global/engineering/agent-workspace/`，由其他 skill 通过 Skill 工具引用，也可以被用户直接调用。

### 5.2 脚本接口

```sh
agent-workspace/scripts/worktree.sh init <effort> [--base <ref>] [--allow-dirty]
agent-workspace/scripts/worktree.sh ticket <effort> <ticket-id>
agent-workspace/scripts/worktree.sh list <effort>
agent-workspace/scripts/worktree.sh remove <path>
agent-workspace/scripts/worktree.sh cleanup <effort> [--branches] [--run]
```

### 5.3 行为细节

- `init`
  - 校验 repo root 与主工作区状态
  - 创建 `.agents/run/<effort>/`、`.agents/worktree/<effort>/`
  - 创建或补全 `.agents/.gitignore`
  - 检查 `.agents/notes` 是否被忽略
  - 记录 base SHA
  - 从 base 创建 integration worktree 与 `agent/<effort>` 分支
  - 写 `state.md`
  - 输出 integration worktree 绝对路径
- `ticket`
  - 确认 integration worktree 存在
  - 从 integration 分支当前 tip 创建 ticket 分支与 worktree
  - 更新 `state.md`
  - 输出 ticket worktree 绝对路径
- `list`
  - 列出该 effort 下所有 worktree、分支、HEAD、dirty 状态
- `remove`
  - 只删除指定 worktree，先检查是否还有未提交改动
- `cleanup`
  - 删除该 effort 的 ticket worktrees
  - 默认保留 integration worktree，直到 PR 合并
  - `--branches` 同时删除已合并的 ticket 分支
  - `--run` 同时删除 `.agents/run/<effort>/`

### 5.4 并发规则

- worktree 创建可以并行，但 merge 必须串行。
- 所有 merge 在 integration worktree 内执行，避免主工作区与 integration 分支同时被 checkout。
- merger subagent 一次只跑一个，避免 git index lock。

## 6. `implement-spec` 改造

### 6.1 新步骤

```
0. Preflight
1. 读 spec 与 tickets，建立任务图
2. 可选 exploration，产物写入 .agents/run/<effort>/research/
3. 创建 integration worktree 与分支
4. 为每个 frontier ticket 创建 worktree 与 implementer subagent
5. 串行 merge 到 integration worktree
6. 新的 frontier 出现后继续派 implementer
7. 在 integration worktree 上跑 code-review，fixed point 用 base SHA
8. review 修复完成后，historian subagent 汇总 notes
9. 标记 PR ready 或按 tracker 规则关闭 tickets
10. 清理 ticket worktrees，保留 integration 直到合并
```

### 6.2 Implementer 契约

每个 implementer subagent 的提示必须包含：

- 绝对 worktree 路径
- 分支名
- integration 分支名
- ticket 的 tracker 链接或文件路径
- spec 链接
- 共享 run 目录绝对路径
- 报告格式

行为要求：

- 进入 worktree 后先确认当前分支和 base。不是 integration tip 就 reset 到 integration tip。
- 按 `tdd` 构建 ticket。
- 完成前把 integration 分支 tip merge 进自己的分支，解决冲突。
- 跑该 ticket 相关的检查。
- 在 `run/<effort>/note-candidates/<ticket-id>.md` 写候选笔记。
- 报告：完成了什么、验证命令、遗留风险、候选笔记路径。

### 6.3 候选笔记格式

```markdown
# Note candidate: <ticket-id>

## Behavior or contract changed

## Decision

## Rejected alternatives

## Evidence

## Note-worthy

yes/no + one-line reason
```

候选笔记只写要点，不要求符合最终 note 格式。historian 负责分类、去重、补全。

### 6.4 Merger 契约

- 在 integration worktree 内执行。
- 一次只处理一个 ticket 分支。
- merge 前确认 integration worktree clean。
- merge 后跑集成检查。
- 冲突无法安全解决时停止，报告冲突文件与原因，不猜。

### 6.5 Code review

- 在 integration worktree 内运行。
- fixed point 是 `state.md` 记录的 base SHA。
- 修复由一个 fresh implementer 在 integration worktree 内完成。
- review 修复完成后才写 notes，保证 notes 描述的是最终代码。

### 6.6 Historian 契约

Historian 是 fresh context 的 subagent，输入：

- spec
- ticket 列表与 ticket 评论
- 所有候选笔记
- `git diff <base>...HEAD`
- base SHA
- integration worktree 绝对路径

行为：

1. 按 `write-notes-like-deepseek` 的红线判断是否需要 note。
2. 一个真实决策写一篇 note，不按 ticket 一篇，也不写会话日记。
3. 更新已有 note 时优先原地修正事实。决策或理由翻转时新开一篇并互链。
4. 写入 `.agents/notes/implemented/<class>/yyyy-mm-dd-topic.md`。
5. 从 integration worktree 根目录运行 verify 脚本。
6. 在 integration 分支上提交 notes。
7. 如果没有任何 note 值得写，在 `state.md` 记一行原因，不制造空 note。

### 6.7 Notes 与 retro 的分界

- `.agents/notes/` 记录代码与架构决策。
- `AGENTS.md`、`docs/agents/`、skill 文件记录 agent 协作方式。
- 如果这次 run 暴露的是“流程该怎么改”，走 `retro`，不要塞进 notes。

## 7. 其他 skill 的改动

### 7.1 `implement`

在 code review 之后增加 note gate。单 ticket 流程也要判断是否非平凡，非平凡就调用 `write-notes-like-deepseek`。

### 7.2 `wayfinder`

- research ticket 的产物写入 `.agents/run/<map>/research/<ticket>.md`。
- 不再创建 `research/<name>` 分支，不再 push 一个永不合并的分支。
- 如果 map 是团队共享的，允许配置把 research 目录提交到 repo 或附件存储，默认本地。

### 7.3 `prototype`

- 在 repo 内工作时，默认产物目录是 `.agents/run/<effort>/prototype/`。
- 仍然保持 throwaway 语义，不默认持久化状态。

### 7.4 `to-spec`

- 写 spec 前检索 `.agents/notes/`，把相关历史决策纳入 Implementation Decisions。
- 在 spec 或 tracker 中记录 effort slug，供 `implement-spec` 使用。

### 7.5 `code-review`

不增加第三个轴。notes 是独立步骤，不塞进 Standards 或 Spec。code review 只需要知道 fixed point 是 base SHA。

### 7.6 `ask-matt`

- 主流程加入 `agent-workspace` 契约。
- 说明 `implement-spec` 使用 `.agents/worktree`，主工作区不动。
- 说明 notes 在 review 后由 historian 汇总。
- 增加 optional skill 的启用方式。

## 8. 仓库分层：global 与 optional

### 8.1 目标布局

```
skills/
  global/
    engineering/
    productivity/
  optional/
    antfu/
      antfu/
      vue/
      vitest/
      pnpm/
      vite/
      pinia/
      nuxt/
      nitro/
      unocss/
      vitepress/
      antfu-create-pr/
      antfu-issue-triage/
      antfu-query/
      antfu-simplify/
    misc/
  in-progress/
  deprecated/
```

两个安装层加两个生命周期区：

| 区域 | 默认全局链接 | 用途 |
|---|---|---|
| `global/` | 是 | 每天都会用到的 skill |
| `optional/` | 否 | 按项目启用的第三方或低频 skill |
| `in-progress/` | 暂定是 | 正在开发、可能变化的 skill |
| `deprecated/` | 否 | 已退役，不再加载 |

### 8.2 `link-skills.sh` 改造

- 只扫描 `skills/global/**/SKILL.md`。
- 不扫描 `optional/`、`in-progress/`、`deprecated/`。
- 默认清理 `DEST` 下指向本仓库但目标已不存在的软链。
- 只清理 target 以本仓库路径开头的软链，保留 `ego-browser` 等外部软链。
- 增加 `--dry-run` 和 `--dest`。
- 运行后打印链接数量与失效链接数量。

### 8.3 `enable-optional.sh`

```sh
enable-optional.sh <skill> [<skill>...] [--project <path>] [--remove] [--auto] [--list]
```

- 在 `skills/optional/**/<skill>/SKILL.md` 中解析 skill。
- 默认项目是当前目录。
- 创建 `<project>/.agents/skills/`。
- 用软链把 skill 指过去。
- `--remove` 删除软链。
- `--list` 列出当前项目已启用的 optional skill。
- `--auto` 读取 `package.json`、lockfile、`pnpm-workspace.yaml`，推断候选 skill，但只打印建议，不自动写入。用户确认后再执行。

### 8.4 跨工具发现

官方文档确认的事实：

- Codex 扫描从当前目录到 repo root 的每一级 `.agents/skills`，并明确支持软链目录，会跟随软链目标。
- Claude Code 扫描 `.claude/skills`，同样支持软链。
- 两者都没有把 `.agents/skills` 当作共享标准。

因此 `enable-optional.sh` 默认写 `<project>/.agents/skills`，并提供 `--target claude` 写 `<project>/.claude/skills`，或用 `--target both` 在 `.claude/skills` 下创建指向 `.agents/skills` 的软链。`.claude/` 已在本仓库 `.gitignore` 中，不需要额外处理。

如果用户同时使用两种工具，推荐 `--target both`，让同一份软链只维护一次。

### 8.5 自动推断表

| 信号 | 建议 skill |
|---|---|
| `vue` 在 dependencies 或 devDependencies | `vue`、`pinia`、`vite` |
| `nuxt` 在 dependencies | `nuxt`、`nitro` |
| `vitest` 在 dependencies | `vitest` |
| `unocss` 在 dependencies | `unocss` |
| `vitepress` 在 dependencies | `vitepress` |
| `pnpm-lock.yaml` 或 `packageManager: pnpm` | `pnpm` |
| 任意 TypeScript 项目 | `antfu` 作为可选项，不默认 |

### 8.6 antfu vendor

事实：

- 仓库：`https://github.com/antfu/skills`
- 13 个 skill，压缩包约 308K
- MIT License，Copyright Anthony Fu
- 每个 skill 的 frontmatter 带 `metadata.author`、`version`、`source`

方案：

- 全量 vendor `skills/*` 到 `optional/antfu/`。
- 保留上游目录名与 frontmatter，不改写。
- 加 `optional/antfu/LICENSE.md`。
- 加 `optional/antfu/UPSTREAM.md`，记录 repo、ref、commit SHA、同步日期、同步人。
- 加 `scripts/sync-optional.sh antfu`，从 pin 的 commit 下载 tarball，校验 LICENSE，rsync 到目标目录，打印 diff 摘要。
- 不在仓库里加 submodule，不加上游 remote。
- vendored 文件不手工编辑。需要本地偏差时，另建 skill 或在 `optional/` 下做 overlay。

### 8.7 文档更新

- `AGENTS.md`：bucket 描述改成 global/optional 两级加两个生命周期区。
- 顶层 `README.md`：Layout、Global、Optional、In Progress、Deprecated。
- `skills/global/engineering/README.md`、`skills/global/productivity/README.md`。
- `skills/optional/README.md`、`skills/optional/antfu/README.md`。
- `skills/in-progress/README.md`、`skills/deprecated/README.md`。
- `skills/global/engineering/ask-matt/SKILL.md`。

## 9. 迁移计划

### Phase A：工作区契约

1. 新建 `agent-workspace` skill 与 `worktree.sh`。
2. 改 `implement-spec`。
3. 在临时 git 仓库验证：
   - 主工作区分支不变
   - integration worktree 路径正确
   - 两个 ticket worktree 可并行
   - merge 串行
   - cleanup 只删该删的

### Phase B：其他 skill 对齐

1. 改 `implement`、`wayfinder`、`prototype`、`to-spec`。
2. 改 `ask-matt`。
3. 用一个真实小任务走一遍，观察 subagent 是否按绝对路径写候选笔记。

### Phase C：仓库分层

1. `git mv` 目录。
2. 改 `link-skills.sh`。
3. 新增 `enable-optional.sh`。
4. 更新 README、AGENTS、ask-matt。
5. 重新链接，检查 0 个 broken link，确认 `ego-browser` 保留。

### Phase D：antfu vendor

1. vendor 13 个 skill。
2. 加 LICENSE、UPSTREAM、sync 脚本。
3. 在一个 Vue 测试项目里启用 `vue`、`vitest`、`pnpm`，确认项目级发现生效，全局 catalog 不增加。

### Phase E：Dogfood

用新流程给这个 skills 仓库做一个小改动，验证：

- integration 在主工作区之外
- notes 能通过 verify
- PR 里有 notes
- cleanup 后主工作区仍然干净

## 10. Alternatives considered

1. **只改 `implement-spec`，不抽 `agent-workspace`**
   简单，但 `wayfinder`、`prototype`、`implement` 会继续各自发明路径，下次改规则要改五处。拒绝。

2. **integration branch 继续留在主工作区**
   用户明确说这是痛点。主工作区 dirty 时无法安全切分支，用户也会丢失当前上下文。拒绝。

3. **worktree 放在 `../repo-worktrees`**
   常见做法，但用户明确要求 `.agents/worktree`。放在 repo 内更可发现，也方便 subagent 用相对路径理解。拒绝。

4. **worktree 放在 `/tmp`**
   重启就丢，路径不稳定，跨 subagent 引用容易失效。拒绝。

5. **用一个新的 `ship` skill 包住 to-spec、to-tickets、implement-spec**
   会隐藏现有 skill 的边界，用户想单独调用某一步时反而更麻烦。当前不需要。拒绝。

6. **optional 用全局开关**
   需要频繁切换，而且会让所有项目都加载 Vue、Vitest、pnpm 的描述。拒绝。

7. **antfu 用 git submodule**
   需要 remote，离线不可用，和仓库“不加上游 remote”的约束冲突。拒绝。

8. **antfu 只复制 SKILL.md，不带 references**
   会破坏 skill 的渐进披露结构，引用文件缺失。拒绝。

9. **research 笔记放进 `.agents/notes/`**
   会让 notes 变成资料堆，破坏决策记录的红线。research 留在 `.agents/run/`，需要长期保留的结论再提炼成 note 或 ADR。拒绝。

10. **每个 ticket 一篇 note**
    会产生大量重复、碎片化的记录。按真实决策写，不按 ticket 写。拒绝。

11. **notes 在 PR 创建后补**
    无法保证 notes 与代码在同一个 PR 里，review 也看不到。notes 在 review 修复后、PR ready 前写。拒绝。

12. **把本地 issue tracker 从 `.scratch` 移到 `.agents/`**
    会同时改 `to-tickets`、`triage`、`wayfinder`、`setup-matt-pocock-skills`，和当前的 worktree 痛点无关。本轮不做，留给后续。

## 11. Open questions

1. `.agents/run` 这个名字是否合适？
   ➡️ 推荐 `run`。它表达“本次 effort 的运行现场”，和长期 `notes` 区分清楚。备选 `work`、`scratch`。

2. `in-progress/` 是否继续默认全局链接？
   ➡️ 推荐暂时保留链接，避免打断正在使用的 skill。分层稳定后再决定是否改成按项目启用。

3. optional 的启用粒度是项目还是机器 profile？
   ➡️ 推荐项目。Codex 支持 `$REPO_ROOT/.agents/skills` 发现，项目级最符合“Vue 项目才加载 Vue 偏好”的直觉。

4. integration 的 base 默认当前 HEAD 还是 `main`？
   ➡️ 推荐当前 HEAD，允许 `--base main`。用户通常从当前上下文开始，强行从 main 可能丢掉已提交的前置工作。

5. notes 是否要成为 code review 的硬门禁？
   ➡️ 推荐不做第三个轴。notes 是独立步骤，code review 只审代码与 spec。否则 code review 的职责会膨胀。

6. 团队共享的 wayfinder map，research 是否要提交？
   ➡️ 默认不提交，本地 `.agents/run`。如果 map 是团队共享的，再加一个配置项把 research 目录提交到 repo 或附件存储。

7. `.agents/skills/` 是否要提交？
   ➡️ 软链默认忽略。团队要共享某个项目级 skill 时，把真实文件放进 `.agents/skills/` 并提交，或强制添加。

8. 分支前缀用 `agent/` 还是 `feat/`？
   ➡️ 推荐 `agent/`，避免把 feature、fix、chore 的语义硬编码进分支名。

9. cleanup 是否自动删 integration worktree？
   ➡️ 推荐显式 cleanup，PR 合并后再删。保留 integration worktree 方便 review 和本地验证。

10. 脚本只支持 bash 吗？
    ➡️ 第一版 bash，目标环境是 macOS 和常见 Linux。Windows 原生环境不在本轮范围。

## 12. Risks

1. `git clean -xdf` 会删除 `.agents/worktree` 下的活跃 worktree。需要在 skill 和 README 里明确警告。

2. 每个 worktree 都要独立安装依赖。Node 项目会重复 `node_modules`，pnpm 共享 store 能缓解，但 native module 仍可能冲突。

3. IDE 可能索引 `.agents/worktree`，造成卡顿。需要在项目级忽略或编辑器排除。

4. `.agents/skills` 用软链时不可跨机器移植。团队成员需要各自运行 `enable-optional.sh`。

5. 多个 effort 并行时，分支名和 worktree 路径可能冲突。slug 必须稳定且唯一。

6. notes verify 依赖 `npx tsx`。宿主项目没有 Node 工具链时，historian 会卡住。需要在 skill 里提供明确的降级与报错路径。

7. vendored antfu skills 会随时间漂移。固定的 commit 与 `UPSTREAM.md` 能让同步可重现，但不会自动更新。

8. 目录移动后，旧软链会短暂失效。`link-skills.sh` 必须先清理指向旧路径的链接，再创建新链接。

9. 如果宿主项目整体忽略 `.agents/`，notes 不会进 PR。preflight 必须检测。

10. Subagent 可能忽略绝对路径，把候选笔记写进自己的 worktree。implementer 提示与 `state.md` 要双重强调共享目录。

11. integration worktree 同时被 merge、review、notes 使用。必须保证同一时间只有一个写者，或者至少 merge 串行。

## 13. Acceptance criteria

1. 跑完 `implement-spec` 后，主工作区的分支与 `git status` 与开始前一致。

2. integration branch 只存在于 `.agents/worktree/<effort>/integration`。

3. 每个 ticket 有独立 worktree，完成后 ticket worktree 被清理，分支按需保留。

4. code review 在 integration worktree 内完成，fixed point 是 base SHA。

5. 非平凡改动在 `.agents/notes/implemented/` 有记录，verify 全绿；纯机械改动在 `state.md` 有 no-note 理由。

6. `link-skills.sh` 后 `~/.agents/skills` 0 个 broken link，`ego-browser` 仍在。

7. `optional/antfu` 的 13 个 skill 不进入全局链接；在测试项目里可以通过 `.agents/skills` 启用。

8. `sync-optional.sh antfu` 在同一个 pin 的 commit 上重复执行，diff 为空。

9. 顶层 README、bucket README、`AGENTS.md`、`ask-matt` 与新布局一致。

## 14. Files likely touched

新增：

- `skills/global/engineering/agent-workspace/SKILL.md`
- `skills/global/engineering/agent-workspace/scripts/worktree.sh`
- `scripts/enable-optional.sh`
- `scripts/sync-optional.sh`
- `skills/optional/antfu/`
- `docs/adr/0002-agent-workspace-and-worktree-flow.md`

修改：

- `skills/engineering/implement-spec/SKILL.md`，移动后是 `skills/global/engineering/implement-spec/SKILL.md`
- `skills/engineering/implement/SKILL.md`
- `skills/engineering/wayfinder/SKILL.md`
- `skills/engineering/prototype/SKILL.md`
- `skills/engineering/to-spec/SKILL.md`
- `skills/engineering/ask-matt/SKILL.md`
- `scripts/link-skills.sh`
- `AGENTS.md`
- `README.md`
- 各 bucket README

## 15. 希望评审者重点挑战的点

1. `.agents/run` 与 `.agents/notes` 的分界是否真的能防止 notes 腐化。

2. 让 historian 在 code review 之后写 notes，是否会丢失 implementer 的决策上下文。候选笔记是否足够。

3. worktree 放在 repo 内是否会给 git、IDE、文件监听带来不可接受的开销。

4. `agent-workspace` 作为一个新 skill 是否过度抽象，还是应该把规则直接写进 `implement-spec`。

5. optional 的项目级软链方案是否足够跨工具。Codex 读 `.agents/skills`，Claude Code 读 `.claude/skills`，是否需要 `--target both`，还是只服务 Codex。

6. 有没有更简单的方案，能在不改五个 skill 的前提下解决 integration branch 落在主工作区的问题。

7. 迁移顺序是否可以更早地做仓库分层，让 worktree 改动直接落在新目录结构上，减少一次 `git mv`。
