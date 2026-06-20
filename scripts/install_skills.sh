npx skills add https://github.com/vercel-labs/skills --skill find-skills -a codex trae-cn -y


npx skills add https://github.com/obra/superpowers -a codex trae-cn -y --skill \
    using-superpowers \
    brainstorming \
    systematic-debugging \
    writing-plans \
    requesting-code-review \
    receiving-code-review \
    test-driven-development \
    executing-plans \
    subagent-driven-development \
    verification-before-completion \
    dispatching-parallel-agents \
    using-git-worktrees \
    finishing-a-development-branch \
    writing-skills

npx skills add https://github.com/anthropics/skills -a codex trae-cn -y --skill \
    skill-creator \
    frontend-design \
    webapp-testing

npx skills add https://github.com/vercel-labs/agent-skills -a codex trae-cn -y --skill \
    vercel-react-best-practices \
    vercel-composition-patterns \
    web-design-guidelines


cd ~/.openclaw/workspaces/
npx skills add https://github.com/vercel-labs/agent-browser --skill agent-browser -a openclaw -y
npx skills add https://github.com/jackwener/opencli --skill opencli-browser -a openclaw -y
npx skills add https://github.com/jackwener/opencli --skill opencli-usage -a openclaw -y

openclaw config set skills.entries.using-superpowers.enabled false
openclaw config set skills.entries.brainstorming.enabled false
openclaw config set skills.entries.systematic-debugging.enabled false
openclaw config set skills.entries.writing-plans.enabled false
openclaw config set skills.entries.requesting-code-review.enabled false
openclaw config set skills.entries.receiving-code-review.enabled false
openclaw config set skills.entries.test-driven-development.enabled false
openclaw config set skills.entries.executing-plans.enabled false
openclaw config set skills.entries.subagent-driven-development.enabled false
openclaw config set skills.entries.verification-before-completion.enabled false
openclaw config set skills.entries.dispatching-parallel-agents.enabled false
openclaw config set skills.entries.using-git-worktrees.enabled false
openclaw config set skills.entries.finishing-a-development-branch.enabled false
openclaw config set skills.entries.writing-skills.enabled false

openclaw config set skills.entries.frontend-design.enabled false
openclaw config set skills.entries.webapp-testing.enabled false

openclaw config set skills.entries.vercel-react-best-practices.enabled false
openclaw config set skills.entries.vercel-composition-patterns.enabled false
openclaw config set skills.entries.web-design-guidelines.enabled false
