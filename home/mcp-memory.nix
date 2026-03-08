{ config, ... }:

{
  # MCP Memory Service API key — used by Claude Code to authenticate with the
  # centralized memory service on miles VPS (http://miles:8765/mcp).
  # Key is generated once (openssl rand -hex 32) and shared between miles and clients.
  age.secrets.mcp-memory-api-key = {
    file = ../secrets/mcp-memory-api-key.age;
    path = "${config.home.homeDirectory}/.config/mcp-memory/api-key";
    mode = "0600";
  };
}
