# Tint Agent Skills

Tint ships with [Agent Skills](https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview) that help Claude build TUI applications using the framework. When installed, Claude automatically knows how to use Tint's widgets, layouts, styles, and application lifecycle.

## Available Skills

| Skill | Description |
|-------|-------------|
| `building-tui-apps` | Build terminal UI apps with Tint — widgets, layouts, styles, key input, and the application loop |

## Installation

### Claude Code (project-level)

Skills are already included in `.claude/skills/` in this repository. Any Claude Code session in this project will discover them automatically.

To use Tint skills in **another project**, copy the skill directory:

```bash
mkdir -p .claude/skills
cp -r path/to/tint/.claude/skills/building-tui-apps .claude/skills/
```

### Claude Code (user-level)

To make the skill available across all your projects:

```bash
mkdir -p ~/.claude/skills
cp -r path/to/tint/.claude/skills/building-tui-apps ~/.claude/skills/
```

### Claude.ai

1. Zip the skill directory:
   ```bash
   cd .claude/skills
   zip -r building-tui-apps.zip building-tui-apps/
   ```
2. Go to **Settings > Features** in Claude.ai
3. Upload the zip file as a custom skill

Requires a Pro, Max, Team, or Enterprise plan with code execution enabled.

### Claude API

Upload using the Skills API:

```python
import anthropic

client = anthropic.Anthropic()

# Create the skill from the SKILL.md content
skill = client.beta.skills.create(
    name="building-tui-apps",
    description="Build terminal user interface applications with the Tint Swift framework.",
    content=open(".claude/skills/building-tui-apps/SKILL.md").read(),
    betas=["skills-2025-10-02"]
)

# Use it in a message
response = client.beta.messages.create(
    model="claude-sonnet-4-6",
    max_tokens=4096,
    betas=["code-execution-2025-08-25", "skills-2025-10-02"],
    container={
        "skills": [{"type": "workspace", "skill_id": skill.id, "version": "latest"}]
    },
    messages=[{"role": "user", "content": "Create a TUI dashboard with Tint"}],
    tools=[{"type": "code_execution_20250825", "name": "code_execution"}],
)
```

### Claude Agent SDK

Copy skills into your agent's `.claude/skills/` directory and include `"Skill"` in your `allowed_tools` configuration:

```typescript
import { Agent } from "claude-agent-sdk";

const agent = new Agent({
  allowed_tools: ["Skill", "Read", "Write", "Bash"],
  // skills in .claude/skills/ are auto-discovered
});
```

## Skill Structure

```
.claude/skills/building-tui-apps/
├── SKILL.md       # Main instructions (loaded when triggered)
├── WIDGETS.md     # Widget catalog — Text, Block, List, Table, etc.
├── LAYOUTS.md     # Layout system — constraints, directions, nesting
├── STYLES.md      # Colors, styles, themes
└── EXAMPLES.md    # Complete app examples
```

Claude loads `SKILL.md` when it detects a Tint-related task. The reference files (`WIDGETS.md`, `LAYOUTS.md`, etc.) are loaded on-demand only when Claude needs detailed information about a specific topic.
