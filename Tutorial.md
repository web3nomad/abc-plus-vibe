# 初学者编程环境设置教程

欢迎进入编程世界！今天我们将学习如何准备编程环境，为接下来的编程学习打下基础。

## 预备步骤：安装 GitHub CLI 并完成授权

在开始正式步骤前，我们需要安装 GitHub CLI 工具并完成授权，这将使我们能够更方便地与 GitHub 仓库交互。

```bash
# 使用 Homebrew 安装 GitHub CLI
brew install gh

# 完成 GitHub 授权
gh auth login
```

按照提示在浏览器中完成认证过程。这样我们就可以使用 GitHub 的各项功能了，包括克隆仓库、提交代码等。

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

## 第五步：启动Claude

现在我们可以启动Claude来开始我们的编程之旅：

```bash
claude
```

> 注意：如果你当前已经在Claude环境中执行这些命令，那么可以跳过这一步，而是通过命令 `cd` 来切换Claude的工作目录到当前项目路径。例如：
>
> ```bash
> cd ~/workspace/abc-plus-vibe
> ```

## 下一步

成功设置环境后，我们将：

1. 创建NextJS项目
2. 配置数据库
3. 设置LiteLLM API密钥和模型名称

祝贺你完成了编程环境的设置！这是成为开发者的第一步！
