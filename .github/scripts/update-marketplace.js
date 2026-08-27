#!/usr/bin/env node
/**
 * Scans the `plugins/` folder for plugin.json files and regenerates
 * marketplace.json files with an up-to-date `plugins` list, preserving
 * the existing marketplace metadata (name, metadata, owner).
 */
const fs = require("fs");
const path = require("path");

const repoRoot = path.resolve(__dirname, "..", "..");
const pluginsDir = path.join(repoRoot, "plugins");
const marketplacePaths = [
  path.join(repoRoot, ".github", "plugin", "marketplace.json"),
  path.join(repoRoot, ".claude-plugin", "marketplace.json"),
];

function findPluginJsonFiles(dir) {
  const results = [];
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    if (!entry.isDirectory()) continue;
    const pluginJsonPath = path.join(dir, entry.name, "plugin.json");
    if (fs.existsSync(pluginJsonPath)) {
      results.push({ dir: entry.name, file: pluginJsonPath });
    }
  }
  return results.sort((a, b) => a.dir.localeCompare(b.dir));
}

function loadJson(filePath) {
  return JSON.parse(fs.readFileSync(filePath, "utf8"));
}

const marketplace = loadJson(marketplacePaths[0]);
const pluginEntries = findPluginJsonFiles(pluginsDir);

marketplace.plugins = pluginEntries.map(({ dir, file }) => {
  const plugin = loadJson(file);
  return {
    name: plugin.name,
    source: `plugins/${dir}`,
    version: plugin.version,
    description: plugin.description,
  };
});

for (const marketplacePath of marketplacePaths) {
  fs.mkdirSync(path.dirname(marketplacePath), { recursive: true });
  fs.writeFileSync(marketplacePath, JSON.stringify(marketplace, null, 4) + "\n");
  console.log(`Updated ${marketplacePath} with ${marketplace.plugins.length} plugin(s).`);
}
