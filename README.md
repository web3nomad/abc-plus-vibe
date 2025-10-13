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

## 卸载（测试用）

如需卸载开发环境（用于测试）：

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/web3nomad/abc-plus-vibe/main/uninstall-dev-env.sh)"
```

**注意**: 卸载脚本会删除 Homebrew 和所有通过它安装的软件，但会保留 SSH keys 和 Xcode CLT。

---

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

---

## 其他工具

### Zed 编辑器

1. 注册 https://zed.dev
2. 下载 zed 编辑器
3. 登录

### 内部工具

使用用户中心，登录 https://git.tezign.com
