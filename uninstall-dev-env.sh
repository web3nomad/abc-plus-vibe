#!/bin/bash

# Mac 开发环境卸载脚本
# 用于测试环境：卸载 oh-my-zsh, brew, nvm, node
# 警告：此脚本会删除 Homebrew 和所有通过它安装的软件！

set -e

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 日志函数
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 确认提示
confirm() {
    echo ""
    log_warn "==================== 警告 ===================="
    log_warn "此脚本将卸载以下内容："
    log_warn "  - oh-my-zsh"
    log_warn "  - NVM 和所有 Node.js 版本"
    log_warn "  - Homebrew 和所有通过它安装的软件"
    log_warn "  - 相关配置文件（.zshrc 会备份）"
    log_warn ""
    log_warn "注意：SSH key 和 Xcode CLT 不会被删除"
    log_warn "=============================================="
    echo ""
    read -p "确认继续？(输入 'yes' 继续): " response
    if [ "$response" != "yes" ]; then
        log_info "取消卸载"
        exit 0
    fi
}

# 1. 卸载 oh-my-zsh
uninstall_oh_my_zsh() {
    log_info "卸载 oh-my-zsh..."

    if [ -d "$HOME/.oh-my-zsh" ]; then
        # 运行官方卸载脚本
        if [ -f "$HOME/.oh-my-zsh/tools/uninstall.sh" ]; then
            log_info "运行 oh-my-zsh 卸载脚本..."
            env ZSH="$HOME/.oh-my-zsh" sh "$HOME/.oh-my-zsh/tools/uninstall.sh" --skip-zwc || true
        fi

        # 手动删除（如果卸载脚本失败）
        rm -rf "$HOME/.oh-my-zsh"
        log_info "oh-my-zsh 已卸载"
    else
        log_info "oh-my-zsh 未安装，跳过"
    fi
}

# 2. 卸载 NVM 和 Node.js
uninstall_nvm() {
    log_info "卸载 NVM 和 Node.js..."

    # 如果是通过 brew 安装的，先卸载 brew 包
    if command -v brew &> /dev/null && brew list nvm &> /dev/null; then
        log_info "卸载 Homebrew 版本的 NVM..."
        brew uninstall nvm || true
    fi

    # 删除 NVM 目录
    if [ -d "$HOME/.nvm" ]; then
        rm -rf "$HOME/.nvm"
        log_info "NVM 目录已删除"
    fi

    log_info "NVM 和 Node.js 已卸载"
}

# 3. 备份并清理 .zshrc
backup_zshrc() {
    log_info "备份并清理 .zshrc..."

    ZSHRC="$HOME/.zshrc"
    if [ -f "$ZSHRC" ]; then
        # 备份
        BACKUP="$ZSHRC.backup.$(date +%Y%m%d_%H%M%S)"
        cp "$ZSHRC" "$BACKUP"
        log_info "已备份 .zshrc 到: $BACKUP"

        # 创建干净的 .zshrc
        cat > "$ZSHRC" << 'EOF'
# Clean zsh configuration
# Old config backed up with timestamp

# Enable colors
autoload -U colors && colors

# Basic prompt
PROMPT='%n@%m %1~ %# '

# History
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history
EOF
        log_info "已创建干净的 .zshrc"
    else
        log_info ".zshrc 不存在，跳过"
    fi
}

# 4. 卸载 Homebrew
uninstall_homebrew() {
    log_info "卸载 Homebrew..."

    if command -v brew &> /dev/null; then
        log_info "运行 Homebrew 卸载脚本..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)" -- --force || {
            log_error "Homebrew 卸载失败"
            return 1
        }

        # 手动清理残留目录
        log_info "清理 Homebrew 残留文件..."
        sudo rm -rf /opt/homebrew 2>/dev/null || true
        sudo rm -rf /usr/local/Homebrew 2>/dev/null || true
        sudo rm -rf /usr/local/Caskroom 2>/dev/null || true
        sudo rm -rf /usr/local/Cellar 2>/dev/null || true
        sudo rm -rf "$HOME/Library/Caches/Homebrew" 2>/dev/null || true
        sudo rm -rf "$HOME/Library/Logs/Homebrew" 2>/dev/null || true

        log_info "Homebrew 已完全卸载"
    else
        log_info "Homebrew 未安装，跳过"
    fi
}

# 5. 切换回默认 shell（可选）
reset_shell() {
    log_info "检查默认 shell..."

    # 如果当前是 zsh，给出提示但不强制切换
    if [ "$SHELL" = "/bin/zsh" ] || [ "$SHELL" = "/usr/bin/zsh" ]; then
        log_info "当前默认 shell 是 zsh (macOS 默认)"
        log_info "保持 zsh 作为默认 shell"
    fi
}

# 主函数
main() {
    log_info "==================================="
    log_info "Mac 开发环境卸载脚本"
    log_info "==================================="

    # 确认
    confirm

    echo ""
    log_info "开始卸载..."
    echo ""

    # 按顺序卸载
    uninstall_oh_my_zsh || log_warn "oh-my-zsh 卸载失败，继续..."
    echo ""

    uninstall_nvm || log_warn "NVM 卸载失败，继续..."
    echo ""

    backup_zshrc || log_warn "zshrc 处理失败，继续..."
    echo ""

    uninstall_homebrew || log_warn "Homebrew 卸载失败，继续..."
    echo ""

    reset_shell || log_warn "Shell 检查失败，继续..."
    echo ""

    log_info "==================================="
    log_info "卸载完成！"
    log_info "==================================="
    echo ""
    log_info "已保留的内容："
    log_info "  - Xcode Command Line Tools"
    log_info "  - SSH keys (~/.ssh/)"
    log_info "  - .zshrc 备份文件"
    echo ""
    log_warn "建议执行以下操作："
    log_warn "1. 重新打开终端或执行: source ~/.zshrc"
    log_warn "2. 如需完全重置，可以手动删除 .zshrc 备份文件"
    echo ""
}

# 执行主函数
main
