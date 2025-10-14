# 技术要点

本项目使用现代化前端技术栈，以下是开发中需要了解和遵循的关键技术要点。请在开始开发前仔细阅读本文档。

## 包管理器: pnpm

项目使用 pnpm 作为包管理器，而非 npm 或 yarn。

**要点**:
- 必须使用 `pnpm install` 安装依赖，不要使用 npm 或 yarn
- 使用 `pnpm add [package]` 添加新依赖
- 使用 `pnpm run [script]` 运行脚本命令

## 数据库: PostgreSQL + Prisma

项目使用 PostgreSQL 作为数据库，并通过 Prisma ORM 进行数据库操作。

**要点**:
- 使用 PostgreSQL 15 作为数据库系统
- 使用 Prisma ORM 处理数据库交互
- 定义清晰的数据模型和关系
- 使用 Prisma 迁移功能管理数据库结构变更

## UI 组件库: shadcn/ui

项目使用 shadcn/ui 作为组件库，它基于 Radix UI 和 Tailwind CSS，提供了一系列高度可定制的组件。

**要点**:
- 使用 shadcn/ui 提供的组件进行界面构建
- 遵循组件库的设计系统和最佳实践
- 合理使用和扩展组件，保持一致的用户界面风格

## AI 功能: Vercel AI SDK

项目使用 Vercel AI SDK v5 来集成 AI 功能，支持流式响应和多种 AI 模型。

**要点**:
- 使用 `ai` 和 `@ai-sdk/openai-compatible` 包
- 使用项目提供的 OpenAI proxy 配置
- 模型列表将在实际开发时提供
- 遵循 Vercel AI SDK v5 的最新 API 规范

## 服务端功能: Server Actions

项目使用 Next.js 的 Server Actions 来处理表单提交和数据变更操作，实现无需额外 API 路由的服务器端功能。

**要点**:
- 使用 'use server' 指令创建服务器端函数
- 实现表单提交和数据操作的服务器端逻辑
- 结合 Prisma 进行数据库操作
- 使用 revalidatePath 和 revalidateTag 进行缓存失效处理