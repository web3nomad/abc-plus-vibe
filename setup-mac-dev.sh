#!/bin/bash

# Mac 开发环境自动配置脚本
# 功能: 安装 zsh, oh-my-zsh, brew, git, nvm, node 22 并配置 SSH key

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

# 0. 安装 Xcode Command Line Tools
install_xcode_clt() {
    log_info "检查并安装 Xcode Command Line Tools..."

    # 检查是否已安装
    if xcode-select -p &> /dev/null; then
        log_info "Xcode Command Line Tools 已安装: $(xcode-select -p)"
    else
        log_info "安装 Xcode Command Line Tools..."
        # 触发安装（自动化，无需手动确认）
        touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
        PROD=$(softwareupdate -l | grep "\*.*Command Line" | tail -n 1 | sed 's/^[^C]* //')
        softwareupdate -i "$PROD" --verbose || {
            # 如果上面的方法失败，使用传统方法
            xcode-select --install
            log_warn "请在弹出的窗口中点击安装，然后等待安装完成..."
            # 等待安装完成
            until xcode-select -p &> /dev/null; do
                sleep 5
            done
        }
        rm -f /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress
        log_info "Xcode Command Line Tools 安装成功"
    fi
}

# 1. 切换 shell 到 zsh
setup_zsh() {
    log_info "检查并配置 zsh..."

    # 检查当前 shell
    if [ "$SHELL" = "/bin/zsh" ] || [ "$SHELL" = "/usr/bin/zsh" ]; then
        log_info "当前 shell 已经是 zsh"
    else
        log_info "切换默认 shell 到 zsh..."
        if [ -f /bin/zsh ]; then
            chsh -s /bin/zsh
            log_info "已切换到 zsh，请重新登录后生效"
        else
            log_error "未找到 zsh，请先安装"
            return 1
        fi
    fi
}

# 2. 安装 oh-my-zsh
install_oh_my_zsh() {
    log_info "检查并安装 oh-my-zsh..."

    if [ -d "$HOME/.oh-my-zsh" ]; then
        log_info "oh-my-zsh 已安装"
    else
        log_info "安装 oh-my-zsh..."
        RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || {
            log_error "oh-my-zsh 安装失败"
            return 1
        }
        log_info "oh-my-zsh 安装成功"
    fi
}

# 3. 安装 Homebrew
install_brew() {
    log_info "检查并安装 Homebrew..."

    if command -v brew &> /dev/null; then
        log_info "Homebrew 已安装，版本: $(brew --version | head -n 1)"
    else
        log_info "安装 Homebrew（无需确认）..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || {
            log_error "Homebrew 安装失败"
            return 1
        }

        # 配置 Homebrew 环境变量 (Apple Silicon Mac)
        if [ -f /opt/homebrew/bin/brew ]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zshrc"
        fi

        log_info "Homebrew 安装成功"
    fi
}

# 4. 安装 Git
install_git() {
    log_info "检查并安装 Git..."

    # 检查是否已有 git（可能是系统自带的）
    if command -v git &> /dev/null; then
        GIT_VERSION=$(git --version)
        log_info "Git 已安装: $GIT_VERSION"

        # 如果是系统自带的 git，建议通过 brew 安装更新版本
        if [[ "$GIT_VERSION" == *"Apple Git"* ]]; then
            log_info "检测到系统自带 Git，通过 Homebrew 安装最新版本..."
            brew install git || {
                log_warn "Homebrew Git 安装失败，使用系统自带版本"
            }
        fi
    else
        log_info "通过 Homebrew 安装 Git..."
        brew install git || {
            log_error "Git 安装失败"
            return 1
        }
        log_info "Git 安装成功"
    fi
}

# 5. 生成 SSH key
generate_ssh_key() {
    log_info "检查 SSH key..."

    SSH_KEY_PATH="$HOME/.ssh/id_ed25519"

    if [ -f "$SSH_KEY_PATH" ]; then
        log_info "SSH key 已存在: $SSH_KEY_PATH"
        log_info "跳过 SSH key 生成"
        return 0
    fi

    log_info "生成新的 SSH key..."

    # 确保 .ssh 目录存在
    mkdir -p "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"

    # 生成 ED25519 类型的 SSH key（GitHub 和 GitLab 都支持）
    ssh-keygen -t ed25519 -C "$(whoami)@$(hostname)" -f "$SSH_KEY_PATH" -N "" || {
        log_error "SSH key 生成失败"
        return 1
    }

    # 启动 ssh-agent 并添加 key
    eval "$(ssh-agent -s)"
    ssh-add "$SSH_KEY_PATH"

    # 配置 SSH config
    SSH_CONFIG="$HOME/.ssh/config"
    if ! grep -q "Host \*" "$SSH_CONFIG" 2>/dev/null; then
        cat >> "$SSH_CONFIG" << EOF

Host *
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile $SSH_KEY_PATH
EOF
        chmod 600 "$SSH_CONFIG"
    fi

    log_info "SSH key 生成成功"
}

# 6. 安装 NVM
install_nvm() {
    log_info "检查并安装 NVM..."

    # 检查 NVM 是否已通过 brew 安装
    if brew list nvm &> /dev/null; then
        log_info "NVM 已通过 Homebrew 安装"
    else
        log_info "通过 Homebrew 安装 NVM..."
        brew install nvm || {
            log_error "NVM 安装失败"
            return 1
        }
        log_info "NVM 安装成功"
    fi

    # 创建 NVM 工作目录
    mkdir -p "$HOME/.nvm"

    # 配置 NVM 环境变量到 .zshrc
    ZSHRC="$HOME/.zshrc"
    if ! grep -q 'NVM_DIR' "$ZSHRC" 2>/dev/null; then
        log_info "配置 NVM 到 .zshrc..."
        cat >> "$ZSHRC" << 'EOF'

# NVM configuration (Homebrew)
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
EOF
    fi

    # 加载 NVM（兼容 Intel 和 Apple Silicon）
    export NVM_DIR="$HOME/.nvm"
    if [ -s "/opt/homebrew/opt/nvm/nvm.sh" ]; then
        \. "/opt/homebrew/opt/nvm/nvm.sh"
    elif [ -s "/usr/local/opt/nvm/nvm.sh" ]; then
        \. "/usr/local/opt/nvm/nvm.sh"
    fi
}

# 7. 安装 Node.js 22
install_node() {
    log_info "检查并安装 Node.js 22..."

    # 加载 NVM（兼容 Intel 和 Apple Silicon）
    export NVM_DIR="$HOME/.nvm"
    if [ -s "/opt/homebrew/opt/nvm/nvm.sh" ]; then
        \. "/opt/homebrew/opt/nvm/nvm.sh"
    elif [ -s "/usr/local/opt/nvm/nvm.sh" ]; then
        \. "/usr/local/opt/nvm/nvm.sh"
    fi

    if ! command -v nvm &> /dev/null; then
        log_error "NVM 未正确加载，请重新打开终端后手动运行: nvm install 22"
        return 1
    fi

    # 检查是否已安装 Node 22
    if nvm ls 22 &> /dev/null; then
        log_info "Node.js 22 已安装"
        nvm use 22
    else
        log_info "通过 NVM 安装 Node.js 22..."
        nvm install 22 || {
            log_error "Node.js 22 安装失败"
            return 1
        }
        nvm use 22
        nvm alias default 22
        log_info "Node.js 22 安装成功"
    fi

    log_info "当前 Node 版本: $(node -v)"
    log_info "当前 npm 版本: $(npm -v)"
}

# 8. 安装 GitHub CLI
install_gh_cli() {
    log_info "检查并安装 GitHub CLI..."

    if command -v gh &> /dev/null; then
        log_info "GitHub CLI 已安装，版本: $(gh --version | head -n 1)"
    else
        log_info "通过 Homebrew 安装 GitHub CLI..."
        brew install gh || {
            log_error "GitHub CLI 安装失败"
            return 1
        }
        log_info "GitHub CLI 安装成功"
    fi
}

# 主函数
main() {
    log_info "开始配置 Mac 开发环境..."
    echo ""

    # 执行各个安装步骤（容错处理）
    # 0. 先安装 Xcode Command Line Tools（Homebrew 和 Git 需要）
    install_xcode_clt || log_warn "Xcode CLT 安装失败，继续执行..."
    echo ""

    # 1. 安装 Homebrew（基础包管理器）
    install_brew || log_warn "Homebrew 安装失败，继续执行..."
    echo ""

    # 2. 安装 Git（oh-my-zsh 需要）
    install_git || log_warn "Git 安装失败，继续执行..."
    echo ""

    # 3. 配置 zsh
    setup_zsh || log_warn "zsh 配置失败，继续执行..."
    echo ""

    # 4. 安装 oh-my-zsh（需要 git）
    install_oh_my_zsh || log_warn "oh-my-zsh 安装失败，继续执行..."
    echo ""

    # 5. 生成 SSH key
    generate_ssh_key || log_warn "SSH key 生成失败，继续执行..."
    echo ""

    # 6. 安装 NVM
    install_nvm || log_warn "NVM 安装失败，继续执行..."
    echo ""

    # 7. 安装 Node.js 22
    install_node || log_warn "Node.js 安装失败，继续执行..."
    echo ""

    # 8. 安装 GitHub CLI
    install_gh_cli || log_warn "GitHub CLI 安装失败，继续执行..."
    echo ""

    log_info "==================================="
    log_info "Mac 开发环境配置完成！"
    log_info "==================================="
    echo ""
    log_warn "请执行以下操作："
    log_warn "1. 在当前终端里执行: source ~/.zshrc"
    echo ""

    # 如果存在 SSH key，显示提示
    SSH_KEY_PATH="$HOME/.ssh/id_ed25519"
    if [ -f "${SSH_KEY_PATH}.pub" ]; then
        log_warn "============================================"
        log_warn "2. 请复制以下 SSH 公钥："
        echo ""
        cat "${SSH_KEY_PATH}.pub"
        echo ""
        log_warn "将其添加到 GitHub: https://github.com/settings/keys"
        log_warn "============================================"
        echo ""
    fi

    # 添加 GitHub CLI 认证提示
    log_warn "3. 请运行以下命令完成 GitHub CLI 认证："
    log_warn "   gh auth login"
    log_warn "   然后按照提示在浏览器中完成 GitHub 账号认证"
    log_warn "============================================"
    echo ""
}

# 执行主函数
main
