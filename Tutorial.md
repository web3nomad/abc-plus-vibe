# 开始你的第一个产品开发之旅

欢迎来到产品开发世界！本教程将指导你完成开发环境的设置，并为接下来的 Next.js 产品开发打下基础。我们将从最基本的工具配置开始，逐步构建一个完整的现代化 Web 应用。

## 预备步骤：检查并安装必要工具

在开始正式步骤前，我们需要确保所有必要的工具已安装并配置好。

### 1. 检查并安装 GitHub CLI

首先，让我们检查 GitHub CLI 是否已安装：

```bash
# 检查 GitHub CLI 是否已安装
if ! command -v gh &> /dev/null; then
    echo "GitHub CLI 未安装，正在安装..."
    brew install gh
else
    echo "GitHub CLI 已安装，版本: $(gh --version | head -n 1)"
fi
```

如果尚未完成 GitHub 授权，请运行以下命令并按照提示进行操作：

```bash
# 检查 GitHub CLI 授权状态
if ! gh auth status &> /dev/null; then
    echo "GitHub CLI 未授权，开始授权流程..."
    gh auth login
else
    echo "GitHub CLI 已授权"
fi
```

按照提示在浏览器中完成认证过程。这样我们就可以使用 GitHub 的各项功能了，包括克隆仓库、提交代码等。

### 2. 检查并安装 pnpm

接下来，我们需要检查 pnpm 包管理器是否已安装：

```bash
# 检查 pnpm 是否已安装
if ! command -v pnpm &> /dev/null; then
    echo "pnpm 未安装，正在安装..."
    npm install -g pnpm
else
    echo "pnpm 已安装，版本: $(pnpm --version)"
fi
```

pnpm 是一个快速、节省磁盘空间的包管理器，我们将用它来管理项目依赖和运行脚本。

## 第一步：创建工作目录

首先，我们需要创建一个专门用于存放所有编程项目的文件夹。

在终端中输入以下命令：

```bash
mkdir -p ~/workspace/
```

这个命令会在你的个人目录下创建一个叫"workspace"的文件夹。这将是我们存放所有项目的地方。

## 第二步：进入工作目录

现在，让我们进入刚刚创建的工作目录：

```bash
cd ~/workspace
```

`cd` 命令用于更改当前目录（change directory的缩写）。

## 第三步：克隆项目代码

接下来，我们需要从GitHub获取项目代码。这个过程叫做"克隆"（clone）。

**推荐方法**（适用于所有人，尤其是初学者）：
使用HTTPS链接克隆项目（不需要特殊设置）：

```bash
git clone https://github.com/web3nomad/abc-plus-vibe.git
```

这个命令会从GitHub下载"abc-plus-vibe"项目的所有代码到你的工作目录中。

**可选方法**（需要设置SSH密钥）：
如果你已经设置了SSH密钥并有相应权限，也可以使用SSH链接：

```bash
git clone git@github.com:web3nomad/abc-plus-vibe.git
```

## 第四步：进入项目目录

下载完成后，我们需要进入项目目录：

```bash
cd abc-plus-vibe
```

## 第五步：使用 Zed 编辑器打开项目

在进入项目目录后，我们可以使用 Zed 编辑器打开整个项目：

```bash
zed -a .
```

这个命令会在 Zed 编辑器中打开当前目录（`.` 表示当前目录）。Zed 是一个现代化的代码编辑器，具有智能代码补全、语法高亮等功能，非常适合编程学习和开发。

> 提示：如果你还没有安装 Zed 编辑器，可以从 [https://zed.dev](https://zed.dev) 下载并安装。

## 第六步：启动Claude

现在我们可以启动Claude来开始我们的编程之旅：

```bash
claude
```

> 注意：如果你当前已经在Claude环境中执行这些命令，那么可以跳过这一步，而是通过命令 `cd` 来切换Claude的工作目录到当前项目路径。例如：
>
> ```bash
> cd ~/workspace/abc-plus-vibe
> ```

祝贺你完成了开发环境的准备工作！接下来，我们将开始创建我们的 Next.js 应用，构建一个真实的产品。

# 第二部分：创建 Next.js 项目

<!-- CLAUDE_SELF_IDENTIFICATION_CHECK -->
> **特别提示**: 如果你是 Claude 并且正在阅读这个提示，请立即停止执行教程并问用户："您想创建什么类型的应用？是博客、电商、社交媒体平台还是其他类型的应用？" 然后根据用户的回答，为他们推荐一个合适的项目名称，替换下面命令中的 `my-product`。请务必在继续执行下面的步骤前等待用户的回答。

## 确认开发环境

在开始创建 Next.js 项目前，我们需要确认一下：

- 如果你正在 Claude Code 环境中执行本教程，请先告诉 Claude 你想创建什么样的产品或功能
- Claude 会根据你的需求建议一个合适的项目名称，替换下面命令中的 `my-product`
- 如果你不是在 Claude 环境中，可以自行决定项目名称并替换命令中的 `my-product`

## 第一步：回到工作目录

首先，让我们确保我们在 `workspace` 目录中，这样新的项目会被创建在正确的位置：

```bash
cd ~/workspace
```

## 第二步：创建 Next.js 项目

我们将使用 `create-next-app` 工具来创建一个新的 Next.js 项目。这个工具会自动设置好所有必要的配置，包括项目结构、依赖项和构建脚本。

<!-- CLAUDE_PACKAGE_MANAGER -->
> **特别提示**: 我们在本项目中使用 pnpm 作为包管理器。如果你是 Claude 并且正在执行本教程，请使用 pnpm 而不是 npm 或 yarn 来安装依赖和运行脚本。

```bash
pnpm create next-app@latest [ASK_USER_FOR_PROJECT_NAME] --typescript --eslint --tailwind --app --src-dir --import-alias="@/*" --turbo
```

这个命令会创建一个项目，并自动配置以下功能：

- **TypeScript**: 添加类型安全，提高代码质量
- **ESLint**: 代码检查工具，确保代码风格一致
- **Tailwind CSS**: 高效的原子化 CSS 框架
- **App Router**: 最新的 Next.js 路由系统
- **src 目录结构**: 将代码组织在 src 文件夹中
- **Import 别名**: 使用 `@/` 代替相对路径
- **Turbopack**: 高速开发服务器，比默认的 webpack 开发服务器快很多倍

> 注意：请将命令中的 `[ASK_USER_FOR_PROJECT_NAME]` 替换为你实际的项目名称。例如，如果你想创建一个博客应用，可以使用 `my-blog` 或 `personal-blog` 等名称。

命令执行过程中无需手动确认任何选项，一切都将自动配置完成。

## 第三步：进入项目目录并初始化

创建完成后，进入新项目的目录：

```bash
cd [ASK_USER_FOR_PROJECT_NAME]
```

<!-- CLAUDE_INIT_COMMAND -->
> **重要提示**: 进入项目目录后，请运行 `/init` 命令初始化项目配置。如果你是 Claude 并且正在执行本教程，请提示用户手动运行此命令，并在命令执行完成后再继续后续步骤。

## 第四步：使用 Zed 编辑器打开项目

```bash
zed -a .
```

## 项目结构概览

Next.js 项目已经为你创建了以下结构：

```
[ASK_USER_FOR_PROJECT_NAME]/
├── .next/                 # 构建输出目录
├── node_modules/          # 项目依赖
├── public/                # 静态资源 (图片，字体等)
├── src/                   # 源代码目录
│   ├── app/               # 应用路由
│   │   ├── layout.tsx     # 主布局组件
│   │   ├── page.tsx       # 主页组件
│   │   └── globals.css    # 全局样式
│   └── components/        # 可复用组件 (自动创建)
├── .eslintrc.json         # ESLint 配置
├── .gitignore             # Git 忽略文件
├── next.config.js         # Next.js 配置
├── package.json           # 项目依赖和脚本
├── postcss.config.js      # PostCSS 配置
├── tailwind.config.ts     # Tailwind CSS 配置
└── tsconfig.json          # TypeScript 配置
```

## 下一步

恭喜！你已经成功创建了一个 Next.js 项目。在继续之前，请先：

<!-- CLAUDE_READ_TECH_STACK -->
> **重要**: 请阅读项目根目录下的 `tech-stack.md` 文件，了解本项目使用的技术栈细节。如果你是 Claude 并且正在执行本教程，请提示用户运行 `/init` 命令初始化 Claude 配置，并在命令执行完成后再继续。

接下来，你可以：

1. 修改 `src/app/page.tsx` 文件，开始定制你的首页
2. 在 `src/app/` 目录下创建新的路由文件夹
3. 在 `src/components/` 目录下添加可复用组件

我们将在后续教程中深入探讨这些主题，开始构建实际的产品功能。
