---
name: create-ai-plugin
description: Scaffold an Agent Plugins package and hand off skill authoring. Use when creating an AI plugin with skills, MCP servers, or harness-specific extensions such as Copilot agents and hooks.
---

# Create AI plugin

1. Determine the plugin name, purpose, target directory, and target clients
   (harnesses) from the request and repository conventions. Default to Agent
   Plugins 1.0.0. Use a newer published specification only after checking the
   [specification](https://agent-plugins.org/specification), its canonical schemas,
   and support in every target client. Ask for missing details needed to create
   the package.
2. Create this layout (in this repository, use `plugins/<plugin-name>/`):

   ```text
   <plugin-name>/
   ├── plugin.json
   └── skills/          # Skills are authored separately after scaffolding.
   ```

3. Write the root `plugin.json`, replacing the example values. `$schema` selects
   the Agent Plugins specification version; `version` is the plugin's own release
   version. For a newer supported spec, use its documented canonical schema:

   ```json
   {
     "$schema": "https://agent-plugins.org/schemas/1.0.0/plugin.schema.json",
     "name": "my-plugin",
     "version": "1.0.0",
     "description": "What this plugin provides"
   }
   ```

4. If MCP servers are requested, consult the official
   [MCP guide](https://agent-plugins.org/plugin-authors/mcp-servers) and add a root
   `mcp.json`. Skills and MCP configuration are discovered at fixed locations;
   the manifest needs no component path lists. Use the MCP schema for the same
   specification version as the manifest.
5. If harness-specific features are requested, apply the client guidance below.
   Create only the requested extension directories and configuration.
6. Validate the manifest against its declared schema, any MCP configuration
   against its schema, and client extensions against the owning client's rules.
   Smoke-test discovery in each target client when available.
   In this repository, run `node .github/scripts/update-marketplace.js` to register
   the plugin in both marketplaces and update the README's available plugins.

Done when the plugin scaffold and requested MCP/client configuration exist,
validation passes, and the plugin is registered where required. Report the target
spec version, client-specific capabilities, and any client checks not performed.

## Harness-specific content

Keep portable skills in `skills/` and MCP configuration in `mcp.json`.
[Client extensions](https://agent-plugins.org/plugin-authors/client-extensions)
use top-level reverse-domain directories; any client-specific manifest data goes
under the matching `extensions` key. Other clients may ignore these extensions.
The namespace owner defines the file formats and discovery rules.

### GitHub Copilot

For Copilot custom agents and hooks, use the layout documented by
[VS Code](https://code.visualstudio.com/docs/agent-customization/agent-plugins):

```text
<plugin-name>/
└── com.github.copilot/
    ├── agents/
    │   └── test-reviewer.agent.md
    └── hooks/
        └── hooks.json
```

Custom agent instructions are distinct from portable skills. Follow the linked
client documentation for agent frontmatter and hook configuration. If additional
manifest configuration is needed, put it in `extensions.com.github.copilot`,
not in portable top-level fields such as `agents` or `hooks`. Verify support in
the specific Copilot harness being targeted; VS Code support alone is not proof
of support in every Copilot client.

### Claude Code

Claude Code's [native plugin format](https://code.claude.com/docs/en/plugins-reference)
documents root `agents/` and `hooks/hooks.json`, with an optional
`.claude-plugin/plugin.json` manifest. This is a separate layout, not a documented
Agent Plugins reverse-domain extension namespace. Do not invent a
`com.anthropic.*` directory or assume Copilot extensions work in Claude Code.
For Claude-specific features, first verify current Claude Code support for the
selected Agent Plugins version and its documented extension mechanism. If only
the native format supports the requested feature, explain the distinction and
ask before adding a separate native package or changing formats.

## Hand off skill authoring

Suggest that the user invoke a skill-writing skill of their choice in the same
chat, for example `/mattpocock-skills:writing-for-agents` if installed. Leave that
invocation to the user; this workflow creates the package, not the skill content.

End with a handoff stating the plugin's absolute root path, the absolute
`skills/` path, and any requested skill names and purposes. Provide a copy-ready
prompt with resolved paths so the next skill has an explicit destination:

> Use your skill-writing guidance to create [skill name and purpose] in
> [absolute plugin root]/skills/[skill-name]/SKILL.md. Keep bundled resources
> inside this plugin.

See the [authoring guide](https://agent-plugins.org/plugin-authors/build-an-agent-plugin)
and [specification](https://agent-plugins.org/specification) for optional metadata,
package boundaries, and client-specific extensions.
