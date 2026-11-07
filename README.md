# Skills

本地维护的 agent skill library。skills 平铺在 `skills/` 下，通过
`scripts/link-skills.sh` 软链到 `~/.agents/skills`。

Fork 自 [mattpocock/skills](https://github.com/mattpocock/skills)，并加入了
[write-notes-like-deepseek](https://github.com/czm15053/write-notes-like-deepseek)。
这个仓库不是发布的 plugin，只是本地工作副本。

## 安装

```sh
./scripts/link-skills.sh
```

默认链接到 `~/.agents/skills`，也可以把目标路径作为第一个参数传入。每个条目都是指向本仓库的软链，改完立即生效。

## 工作流

默认路线是从一个想法走到一个可合并的 PR。

```
idea
  -> grill-with-docs / wayfinder
  -> prototype
  -> to-spec
  -> to-tickets
  -> implement-spec / implement
  -> code-review
  -> write-notes-like-deepseek
  -> pr
  -> retro
```

### 0. 初始化

每个 repo 第一次使用前跑 `setup-workflow`。它在 `docs/agents/` 下写 issue tracker、triage labels、domain docs 和 worktrees 的配置，后面的 skill 都读这些文件。

### 1. 把问题想清楚

小范围用 `grill-with-docs`。它会调 `grilling` 和 `domain-modeling`，一边追问一边把结论写进 `GLOSSARY.md` 和 `docs/adr/`。

大范围用 `wayfinder`。它把看不清的部分拆成 decision tickets，research 类型的 ticket 调 `research`，prototype 类型的调 `prototype`，需要讨论时调 `grilling` 和 `domain-modeling`。

需要看运行结果而不是只讨论时，用 `prototype`。要把上下文交给另一个 session 时，用 `handoff`。

### 2. 变成可执行的计划

`to-spec` 把已经讨论清楚的内容收敛成 spec。`to-tickets` 把 spec 拆成 tracer-bullet tickets，并标出 ticket 之间的阻塞边。

### 3. 实现

整个 spec 用 `implement-spec`。它把 tickets 当任务图，按 frontier 并行派 implementer，integration 和 ticket 都在 `.agents/worktree/` 里，主工作区不动。

单个 ticket 或小改动用 `implement`。两者内部都用 `tdd` 做红绿循环，需要讨论模块形状时用 `codebase-design`。

### 4. 审查与提交

`code-review` 从 Standards 和 Spec 两个轴 review diff。`pr` 负责写有证据和影响面的 PR body。

### 5. 记录决策

`write-notes-like-deepseek` 判断这次改动是否非平凡。非平凡就写进 `.agents/notes/`，记录问题、决定、放弃的备选、代价和验证方式。纯机械改动不写。

### 6. 改进工作流

`retro` 复盘一次会话，找 agent 环境的问题：导航、自动检查、编码规范、AGENTS.md 大小、工具经济性、无效指令、信息获取。采纳的结论用 `writing-for-agents` 写回 AGENTS.md 或 skill。

### 旁路

- `diagnosing-bugs`：硬 bug，先建反馈环再猜原因。
- `improve-codebase-architecture`：扫架构深化机会，产 HTML 报告。
- `triage`：外部 issue 和 PR 的分诊状态机，产 agent brief。只用于别人提的 issue，不用于 `to-tickets` 自己产出的 ticket。
- `teach`：多 session 教学，维护 mission、lessons 和 learning records。

## 技能目录

| 阶段 | Skill | 做什么 | 什么时候用 |
|---|---|---|---|
| 初始化 | [setup-workflow](./skills/setup-workflow/SKILL.md) | 配置 issue tracker、triage labels、domain docs 和 worktrees | 每个 repo 第一次使用前 |
| 想清楚 | [grill-with-docs](./skills/grill-with-docs/SKILL.md) | 访谈式澄清，边问边写 GLOSSARY 和 ADR | 想法还模糊，需要问清楚 |
| 想清楚 | [grilling](./skills/grilling/SKILL.md) | 访谈原语，一轮轮追问直到问题收敛 | 被其他 skill 调用，也可以单独用 |
| 想清楚 | [domain-modeling](./skills/domain-modeling/SKILL.md) | 维护领域词汇和 ADR | 术语混乱，或者要做难以回退的决定 |
| 想清楚 | [wayfinder](./skills/wayfinder/SKILL.md) | 大范围探索，建 decision ticket map | 工作超过一个 session，路径还不清楚 |
| 想清楚 | [research](./skills/research/SKILL.md) | 查一手资料，写带引用的笔记 | 某个决定卡在外部事实上 |
| 想清楚 | [prototype](./skills/prototype/SKILL.md) | 一次性代码验证状态模型或 UI | 需要看运行结果才能决定 |
| 想清楚 | [handoff](./skills/handoff/SKILL.md) | 把当前会话压成交接文档 | 上下文要交给另一个 session |
| 计划 | [to-spec](./skills/to-spec/SKILL.md) | 把讨论收敛成 spec | 方向已经清楚，要写下来 |
| 计划 | [to-tickets](./skills/to-tickets/SKILL.md) | 拆成带阻塞边的 tracer-bullet tickets | spec 要变成可执行任务 |
| 实现 | [implement-spec](./skills/implement-spec/SKILL.md) | 在 worktree 里按 ticket graph 并行实现整个 spec | 整个 spec 一次做完 |
| 实现 | [implement](./skills/implement/SKILL.md) | 实现单个 ticket 或小改动 | 只有一个任务，或者想手动逐条做 |
| 实现 | [tdd](./skills/tdd/SKILL.md) | 红绿重构循环 | 写具体行为时 |
| 实现 | [codebase-design](./skills/codebase-design/SKILL.md) | 模块、接口、深度、seam 的共享词汇 | 讨论模块形状时 |
| 审查 | [code-review](./skills/code-review/SKILL.md) | Standards 和 Spec 双轴 review | 实现完成，准备合并前 |
| 审查 | [pr](./skills/pr/SKILL.md) | 写有证据和影响面的 PR body | 开 PR 时 |
| 记录 | [write-notes-like-deepseek](./skills/write-notes-like-deepseek/SKILL.md) | 把非平凡改动的 why、备选和代价写进 `.agents/notes/` | 改动涉及行为、架构、契约或流程 |
| 改进 | [retro](./skills/retro/SKILL.md) | 复盘会话，改进 agent 环境 | 一次 run 结束后想改工作方式 |
| 改进 | [writing-for-agents](./skills/writing-for-agents/SKILL.md) | 写 skill 和 AGENTS.md 的规范 | 要把 retro 的结论写回文档 |
| 旁路 | [diagnosing-bugs](./skills/diagnosing-bugs/SKILL.md) | 硬 bug 的定位纪律，先建反馈环 | bug 难复现或难定位 |
| 旁路 | [improve-codebase-architecture](./skills/improve-codebase-architecture/SKILL.md) | 扫架构深化机会，产 HTML 报告 | 想找代码库的结构问题 |
| 旁路 | [triage](./skills/triage/SKILL.md) | 外部 issue 和 PR 的分诊状态机，产 agent brief | 有别人提的 issue 或 PR |
| 旁路 | [teach](./skills/teach/SKILL.md) | 多 session 教学 | 要系统学一个主题 |

## 目录结构

```
skills/
  <name>/
    SKILL.md
    agents/openai.yaml
    ...
```

所有 skill 平铺，没有分类目录，名字全局唯一。附属文件放在各自目录里，例如 `references/`、`scripts/`、`templates/`。

## 维护

- 添加 skill：新建 `skills/<name>/SKILL.md`，更新技能目录，运行 `scripts/link-skills.sh`。
- 删除 skill：`git rm -r skills/<name>`，更新技能目录，运行脚本。
- 改名：`git mv`，更新所有引用和技能目录，运行脚本。
- 不加上游 remote，不从原仓库同步。
- 不加 plugin manifest、marketplace metadata 或 release tooling。
- 保留每个 skill 的 `agents/openai.yaml`。
- `docs/agents/` 是每个宿主 repo 的运行时配置，保留。
- 散文不用 em-dash，代码不写注释。

## Credits

- [mattpocock/skills](https://github.com/mattpocock/skills), MIT.
- [czm15053/write-notes-like-deepseek](https://github.com/czm15053/write-notes-like-deepseek), MIT.
