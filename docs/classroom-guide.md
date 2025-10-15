# 课堂教学指南

本文档记录了 ABC+ Vibe 课程的教学流程和学生练习步骤。

课程开始前，确保所有学生已经顺利完成 [mac-setup.md](mac-setup.md) 里面的所有步骤。

## 第一部分：初始化项目环境

### 步骤 1：启动 Claude Code 并执行教程

学生需要：

1. 打开这个 URL：https://github.com/web3nomad/abc-plus-vibe/blob/main/docs/claude-tutorial.md
2. 复制文件的所有内容 (点击文件右上角的 Copy raw file)
3. 粘贴到 Claude Code 里面
4. 回车执行

Claude Code 会按照教程指导学生：

1. 检查并安装必要工具（GitHub CLI, pnpm）
2. 创建工作目录
3. 克隆 abc-plus-vibe 项目
4. 进入项目目录
5. 使用 Zed 打开项目
6. 阅读技术栈指南
7. 询问学生想创建什么类型的应用
8. 创建 Next.js 项目

### 步骤 2：初始化项目配置

当 Next.js 项目安装完成后，学生在 Claude 中输入：

```
/init
```

此命令会在 Claude 中执行，用于创建项目的 `CLAUDE.md` 文件。这是项目的 Claude 工作指南，告诉 Claude 应该如何与你协作。你所有的开发需求、项目规范、代码风格等要求都可以放在这个文件里，Claude 会根据这个指南来协助你完成开发工作。

### 步骤 3：合并技术栈指南到 CLAUDE.md

在创建完基础的 `CLAUDE.md` 文件后，学生可以进一步完善这个文件，将技术栈指南合并进去：

```
请帮我将以下技术指南合并到项目的 CLAUDE.md 文件中，作为技术栈和开发规范部分：

https://raw.githubusercontent.com/web3nomad/abc-plus-vibe/refs/heads/main/docs/tech-guide.md

请保持现有的 CLAUDE.md 内容，将技术指南作为新的章节添加进去，形成一个完整的项目开发指南。
```

Claude Code 会：

1. 读取远程的技术指南内容
2. 将其整合到现有的 `CLAUDE.md` 文件中
3. 保持良好的文档结构和格式
4. 确保技术规范与项目配置一致

**教学意义**：让学生学会如何维护和完善项目文档，将分散的技术资料整合到一个统一的指南中。

---

## 第二部分：AI SDK 配置和聊天界面

### 步骤 3：安装 AI SDK 并配置模型

学生可以选择使用 **Zed** 或 **Claude Code** 来完成这个步骤，也可以交叉使用两种工具。

#### 使用 Claude Code 的方式

学生在 Claude Code 中输入：

```
请确保已充分阅读最新的 Vercel AI SDK v5 文档，特别关注 streamText 和 useChat 的使用方法。

任务分为三个步骤：

1. 安装依赖包
执行以下命令安装 Vercel AI SDK：
- pnpm add ai @ai-sdk/openai-compatible @ai-sdk/react

2. 配置环境变量
在项目根目录创建 .env 文件，添加：
OPENAI_BASE_URL=待上课时候补充
OPENAI_API_KEY=待上课时候补充

3. 实现聊天功能
将首页改造为聊天界面，需要支持：
- 支持切换 4 个模型：gpt-5, gpt-5-mini, gpt-5-nano, claude-sonnet-4
- 实现流式对话功能
- 添加模型选择器组件
```

如果遇到问题，和 claude code 一起调试程序的方法：`请运行 pnpm build，并修复问题`

#### 使用 Zed 的方式

如果学生选择使用 Zed，可以：

1. 在终端中手动安装依赖：

```bash
pnpm add ai @ai-sdk/openai-compatible @ai-sdk/react
```

2. 在 Zed 中创建 `.env` 文件，添加环境变量

3. 使用 Zed 的 AI 助手功能来帮助编写聊天界面代码

#### 预期结果

完成后，学生将拥有：

1. **AI SDK 依赖**：ai、@ai-sdk/openai-compatible 和 @ai-sdk/react 包
2. **环境配置**：支持5个AI模型的配置
3. **聊天界面**：可以切换模型进行对话的首页

---

## 第三部分：代码提交和测试

### 步骤 4：规划和提交代码

这个步骤用于演示 Git 的使用。**切换到 Claude Code**，让 Claude 帮助规划提交。

学生在 Claude Code 中输入：

```
请帮我规划一下现在没有提交的文件，每个提交应该包含一个独立的功能，然后逐个提交。

完成本地提交后，请使用 GitHub CLI 为我创建一个在线仓库，并将代码推送到 GitHub 上。

创建仓库时请使用以下配置：
- 仓库名称：根据项目名称自动生成
- 设置为 public 仓库
- 自动设置 remote origin
- 立即推送所有已提交的代码
```

Claude Code 会：

1. 分析当前未提交的文件
2. 将文件按功能分组
3. 为每个提交创建有意义的提交信息
4. 逐个执行提交命令
5. 使用 GitHub CLI 创建在线仓库：
   ```bash
   gh repo create [项目名称] --public --source=. --remote=origin --push
   ```
6. 验证代码是否成功推送到 GitHub
7. 提供 GitHub 仓库链接给学生查看

### 步骤 5：创建 GitHub 仓库并推送

这个步骤演示如何将本地代码发布到 GitHub：

1. **使用 GitHub CLI 创建仓库**：
   - 自动根据项目名称创建仓库
   - 设置为公开仓库，便于分享和展示
   - 自动配置远程仓库地址
   - 立即推送所有提交的代码

2. **验证发布结果**：
   - 检查所有文件是否成功上传
   - 确认提交历史完整保留
   - 获取可访问的 GitHub 仓库链接

**教学重点**：让学生理解本地 Git 和远程 GitHub 的关系，学会将代码发布到互联网上

### 步骤 6：测试功能

代码推送完成后，测试聊天功能：

1. 启动开发服务器：`pnpm dev`
2. 访问首页，测试模型切换功能
3. 尝试与不同模型进行对话
4. 验证所有功能是否正常工作

---

## 第四部分：实现核心功能

### 步骤 7：配置 Supabase 数据库（可选扩展）

#### Supabase 配置教学流程

**1. 创建 Supabase 项目**

- 引导学生访问 https://supabase.com
- 注册/登录账户
- 创建新项目
- 设置项目名称和数据库密码

**2. 获取数据库连接信息**

- 在 Supabase 项目详情页上方点击 "Connect" 按钮
- 选择 "ORMs" 选项
- 选择 "Prisma"
- 复制提供的两个连接字符串

**3. 配置项目环境变量**

- 在 `.env` 文件中添加：

```
# Connect to Supabase via connection pooling
DATABASE_URL="postgresql://postgres.[PROJECT_ID]:[YOUR-PASSWORD]@aws-1-us-east-2.pooler.supabase.com:6543/postgres?pgbouncer=true"

# Direct connection to the database. Used for migrations
DIRECT_URL="postgresql://postgres.[PROJECT_ID]:[YOUR-PASSWORD]@aws-1-us-east-2.pooler.supabase.com:5432/postgres"
```

#### Prisma 集成教学流程

当学生已经创建了 Supabase 数据库并获得了连接字符串后，需要在项目中集成 Prisma ORM。

学生在 Claude Code 中输入：

```
现在我已经创建好了 Supabase 数据库并获得了连接信息 (DATABASE_URL 和 DIRECT_URL)，并配置在 .env 文件中。

请按照 Prisma 推荐的 Next.js 项目集成步骤：
1. 安装依赖并初始化
2. 配置 schema.prisma 文件
3. 创建用户模型
4. 同步数据库并生成客户端

然后实现一个简单的用户管理系统：
- 姓名和邮箱输入表单
- 保存用户信息到数据库
- 页面显示用户列表

使用 Server Actions 演示数据库操作。
```

### 步骤 8：实现音频素材库

学生输入以下完整需求：

```
请帮我实现一个简易的音频素材库，支持上传音频，解析成文本，提取要点，并且支持要点对应的音频回放。

使用 serveraction 进行后端功能实现。

请使用 Vercel AI SDK 实现 AI 功能，（注意：此时环境变量已在第二部分配置完成）

### 功能要求说明

Claude Code 会实现以下功能：

1. **音频上传**
   - 支持音频文件上传（mp3, wav, m4a 等格式）
   - 存储音频文件

2. **音频转文本**
   - 使用 Whisper (模型名称叫 whisper) 模型将音频转换为文本
   - 将转录结果保存到数据库

3. **提取要点**
   - 使用 GPT 模型分析音频文本
   - 提取关键要点和时间戳
   - 保存要点到数据库

4. **音频回放**
   - 支持播放音频
   - 点击要点时跳转到对应时间点
   - 显示当前播放位置对应的要点

### 技术实现要点

- **Server Actions**: 所有后端逻辑通过 Next.js Server Actions 实现
- **Prisma**: 数据库操作使用 Prisma ORM
- **Vercel AI SDK**: AI 功能使用 Vercel AI SDK v5
- **shadcn/ui**: UI 组件使用 shadcn/ui 组件库
- **文件存储**: 音频文件存储在 public/uploads 目录或使用云存储服务
```

---

## 教学注意事项

1. **分步指导**：每个步骤完成后都要暂停，让学生观察结果
2. **代码审查**：鼓励学生阅读 Claude 生成的代码，理解实现逻辑
3. **提交管理**：强调良好的 Git 提交习惯
4. **测试验证**：每个功能完成后都要进行测试
5. **问题讨论**：遇到问题时引导学生思考解决方案

## 扩展练习

完成基础功能后，可以让学生尝试：

1. 添加音频列表搜索和筛选功能
2. 支持多语言音频转录
3. 添加音频波形可视化
4. 实现要点的编辑和删除功能
5. 添加音频分享功能
6. 支持批量上传和处理
