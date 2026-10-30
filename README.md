# claude-skills

One Claude Code plugin, `coding-rules`, that collects skills from other GitHub repos and keeps them current. A GitHub Action copies the latest skills from each source repo every day and commits them to `main`.

| Skill | From | What it does |
|---|---|---|
| `antislop`, `antislop-code`, `antislop-copywriting`, `antislop-human`, `antislop-layoutmobile`, `antislop-ui` | [miqdadbadjuber/anti-slop](https://github.com/miqdadbadjuber/anti-slop) | Stops generic AI-looking UI, copy, and code comments |
| `engineering-books` | [ciembor/agent-rules-books](https://github.com/ciembor/agent-rules-books) | Rules from 14 software engineering books. Claude picks the one book that fits the task instead of loading all of them |

## Install

In Claude Code (terminal, desktop app, or IDE extension):

```
/plugin marketplace add amanetize/claude-skills
/plugin install coding-rules@amanetize
```

To get the daily updates without reinstalling, open `/plugin`, go to Marketplaces, select `amanetize`, and turn on auto-update.

### Every session, without running commands

Add this to `~/.claude/settings.json` on each computer. For cloud sessions, write it from the environment's setup script:

```json
{
  "extraKnownMarketplaces": {
    "amanetize": {
      "source": { "source": "github", "repo": "amanetize/claude-skills" }
    }
  },
  "enabledPlugins": {
    "coding-rules@amanetize": true
  }
}
```

### claude.ai chat

Chat on claude.ai does not install plugins from GitHub. Zip a folder from `skills/` and upload it under Settings, Capabilities, Skills. Those uploads do not update on their own.

## Add another source repo

Add one line to [`upstream.tsv`](upstream.tsv) and push. The sync runs on that push and copies the new skills in.

```
owner/repo    skills    *
```

- `from` is the folder whose subfolders are skills. Use `.` when they sit at the repo root.
- `to` is `*` to keep each skill separate, or `name/sub` to bundle them all under one skill called `name` that routes to the right one.

## How the sync works

[`scripts/sync.sh`](scripts/sync.sh) clones each source, copies every folder that has a `SKILL.md`, and rebuilds `skills/` from scratch, so skills removed upstream disappear here too. It drops symlinks, copies each source's license into `licenses/`, records the exact upstream commits in `upstream.lock`, and bumps the plugin version so Claude Code notices the update. It stops without changing anything if two sources ship a skill with the same name, or if a source no longer has any skills.

Run it by hand with `scripts/sync.sh`, or from the Actions tab with "Run workflow".

Anything you edit inside `skills/` by hand is overwritten on the next sync.

## Licenses

Both source repos are MIT licensed. Their license texts are in [`licenses/`](licenses).
