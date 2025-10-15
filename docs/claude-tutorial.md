# Claude 教程：引导用户完成 Next.js 项目设置

本文档是 Claude Code 的内部指导文档，用于帮助用户完成开发环境设置和 Next.js 项目创建。

## 预备步骤：检查并安装必要工具

### 1. 检查并安装 GitHub CLI

检查 GitHub CLI 是否已安装：

```bash
# 检查 GitHub CLI 是否已安装
if ! command -v gh &> /dev/null; then
    echo "GitHub CLI 未安装，正在安装..."
    brew install gh
else
    echo "GitHub CLI 已安装，版本: $(gh --version | head -n 1)"
fi
```

如果尚未完成 GitHub 授权，运行以下命令：

```bash
# 检查 GitHub CLI 授权状态
if ! gh auth status &> /dev/null; then
    echo "GitHub CLI 未授权，开始授权流程..."
    gh auth login
else
    echo "GitHub CLI 已授权"
fi
```

### 2. 检查并安装 pnpm

检查 pnpm 包管理器是否已安装：

```bash
# 检查 pnpm 是否已安装
if ! command -v pnpm &> /dev/null; then
    echo "pnpm 未安装，正在安装..."
    npm install -g pnpm
else
    echo "pnpm 已安装，版本: $(pnpm --version)"
fi
```

## 第一步：创建工作目录

创建专门用于存放所有编程项目的文件夹：

```bash
mkdir -p ~/workspace/
```

## 第二步：进入工作目录

```bash
cd ~/workspace
```

## 第三步：克隆项目代码

推荐使用 HTTPS 链接克隆项目（适用于所有人，尤其是初学者）：

```bash
git clone https://github.com/web3nomad/abc-plus-vibe.git
```

可选方法（需要设置 SSH 密钥）：

```bash
git clone git@github.com:web3nomad/abc-plus-vibe.git
```

## 第四步：进入项目目录

```bash
cd abc-plus-vibe
```

## 第五步：使用 Zed 编辑器打开项目

```bash
zed -a .
```

## 重要：阅读技术栈指南

<!-- CLAUDE_READ_TECH_STACK -->

在继续创建新项目之前，阅读项目根目录下的 `docs/tech-guide.md` 文件，了解接下来需要使用的技术栈细节。

---

# 创建 Next.js 项目

<!-- CLAUDE_SELF_IDENTIFICATION_CHECK -->

**暂停并询问用户**：在继续之前，问用户："您想创建什么类型的应用？是博客、电商、社交媒体平台还是其他类型的应用？" 根据用户的回答，为他们推荐一个合适的项目名称，替换下面命令中的 `[ASK_USER_FOR_PROJECT_NAME]`。等待用户回答后再继续。

## 第一步：回到工作目录

确保在 `workspace` 目录中：

```bash
cd ~/workspace
```

## 第二步：创建 Next.js 项目

使用 pnpm 作为包管理器（而不是 npm 或 yarn）创建 Next.js 项目：

```bash
pnpm create next-app@latest [ASK_USER_FOR_PROJECT_NAME] --typescript --use-pnpm	--eslint --tailwind --app --src-dir --import-alias "@/*" --turbopack
```

此命令会自动配置以下功能：

- **TypeScript**: 类型安全
- **Pnpm**: pnpm 包管理器
- **ESLint**: 代码检查工具
- **Tailwind CSS**: 原子化 CSS 框架
- **App Router**: Next.js 最新路由系统
- **src 目录结构**: 代码组织
- **Import 别名**: `@/` 代替相对路径
- **Turbopack**: 高速开发服务器

将命令中的 `[ASK_USER_FOR_PROJECT_NAME]` 替换为实际的项目名称。

## 第三步：进入项目目录

```bash
cd [ASK_USER_FOR_PROJECT_NAME]
```

<!-- CLAUDE_INIT_COMMAND -->

进入项目目录后，提示用户手动运行 `/init` 命令初始化项目配置。等待命令执行完成后再继续。

## 第四步：使用 Zed 编辑器打开项目

```bash
zed -a .
```

## 下一步建议

告知用户可以：

1. 修改 `src/app/page.tsx` 文件，开始定制首页
2. 在 `src/app/` 目录下创建新的路由文件夹
3. 在 `src/components/` 目录下添加可复用组件
