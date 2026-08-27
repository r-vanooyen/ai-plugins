# AI Plugins

This repository contains custom AI skills by Robin van Ooyen. The skills are
reusable instructions that extend an AI assistant with focused capabilities,
currently centered on documentation and architecture work.

## Installation

1. add this repo as a custom marketplace of your ai tool
2. install plugin of your choice

### Github Copilot
#### VSCode

1. open setting `chat.plugins.marketplaces` 
2. put `r-vanooyen/ai-plugins` as additional marketplace
3. search for extension `@agentPlugins r-vanooyen/ai-plugins`
4. install plugin of your choice

#### Intellij

0. you might need to have a project opened
1. goto Settings → Tools → GitHub Copilot → Customizations → Plugins
2. put `r-vanooyen/ai-plugins` as additional marketplace
3. open the github copilot chat sidepanel 
4. click on "Customizations" (icon on the far upper right)
5. goto Plugins → Browse Marketplace and search for `r-vanooyen/ai-plugins`
6. install plugin of your choice

### Claude Code

Das Plugin verwendet das offene `agent-plugins.org`-Manifest. Eine
`.claude-plugin/plugin.json`-Datei ist für Claude Code nicht erforderlich.

1. start Claude Code in a terminal
2. add this repository as a marketplace:

   ```text
   /plugin marketplace add r-vanooyen/ai-plugins
   ```

3. install the plugin:

   ```text
   /plugin install rvo-documentation@rvo-ai-plugins
   ```

4. run `/reload-plugins` if Claude Code asks you to reload plugins


## Available plugin

- **rvo-documentation** — skills for documentation, architecture reviews,
  traceability, and Structurizr.

Each skill includes its own description and usage guidance in a `SKILL.md`
file.
