# Mac 开发环境快速配置

## 一键安装

直接通过 curl 执行安装脚本：

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/web3nomad/abc-plus-vibe/main/setup-mac-dev.sh)"
```

或者使用短链接：

```bash
curl -fsSL https://raw.githubusercontent.com/web3nomad/abc-plus-vibe/main/setup-mac-dev.sh | bash
```

## 安装内容

该脚本会自动安装和配置：

- Xcode Command Line Tools
- Homebrew（包管理器）
- Git
- Zsh + Oh-My-Zsh
- SSH Key（ED25519）
- NVM（Node 版本管理器）
- Node.js 22
- GitHub CLI

## 卸载（测试用）

如需卸载开发环境（用于测试）：

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/web3nomad/abc-plus-vibe/main/uninstall-dev-env.sh)"
```

**注意**: 卸载脚本会删除 Homebrew 和所有通过它安装的软件，但会保留 SSH keys 和 Xcode CLT。

## Claude Code 配置

配置 Claude Code 使用内部 API：

```bash
mkdir -p ~/.claude && cat > ~/.claude/settings.json << 'EOF'
{
  "env": {
    "ANTHROPIC_BASE_URL": "***",
    "ANTHROPIC_AUTH_TOKEN": "***",
    "ANTHROPIC_DEFAULT_SONNET_MODEL": "***",
    "ANTHROPIC_DEFAULT_HAIKU_MODEL": "***"
  }
}
EOF
```

配置完成后重启 Claude Code 即可生效。

## Claude Code 配置 Context7 MCP Server

看 https://github.com/upstash/context7?tab=readme-ov-file#claude-code-local-server-connection

在**Terminal/终端**中运行以下命令

```bash
claude mcp add context7 -- npx -y @upstash/context7-mcp
```

安装好以后，运行 `claude` 输入 “查一下最新的 Vercel AI SDK” 的文档。

## Zed 编辑器 Context7 MCP Server 配置

安装 Context7 MCP Server 来让 Zed 获取最新的文档信息，请按照以下步骤操作：

1. 打开 Zed 编辑器
2. 使用快捷键 `Cmd+,` 打开设置，会直接打开 `settings.json` 文件
3. 将以下配置粘贴到文件的 `{}` 中：

```json
{
  // 以下是新增的 MCP server 配置
  "context_servers": {
    "mcp-server-context7": {
      "source": "extension",
      "enabled": true,
      "settings": {
        "context7_api_key": ""
      }
    }
  }

  // 文件其他部分
}
```

4. 保存设置文件

配置完成后，Zed 编辑器将能够通过 Context7 MCP Server 获取最实时的文档信息，提供更准确的 AI 辅助开发体验。
