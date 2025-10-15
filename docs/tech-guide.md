# CLAUDE 开发指南

本文档为 Claude Code 提供项目的关键技术和开发约束。请在处理开发请求前仔细阅读本文档。

## 项目概述

本项目是使用现代化前端技术栈构建的 Next.js 应用程序。作为开发助手，你应当遵循以下技术约定和最佳实践。

## 1. 包管理器: pnpm

项目严格使用 **pnpm** 作为包管理器，而非 npm 或 yarn。

**规范**:

- 必须使用 `pnpm install` 安装依赖，绝不使用 npm 或 yarn
- 使用 `pnpm add [package]` 添加新依赖
- 使用 `pnpm run [script]` 运行脚本命令
- 当用户请求安装或管理依赖时，主动提醒使用 pnpm

## 2. 数据库: Supabase + Prisma

项目使用 **Supabase** 作为数据库服务，通过 **Prisma ORM** 进行数据库操作。

**规范**:

- 使用 Supabase 提供的 PostgreSQL 云数据库服务
- 所有数据库交互必须通过 Prisma ORM 处理
- 严格遵循数据库模型定义，保持数据一致性
- 使用 Prisma 迁移功能管理数据库结构变更
- 数据库模式更改必须通过 Prisma 迁移实现
- 不需要本地安装 PostgreSQL，使用 Supabase 云服务
- 配置 DATABASE_URL 和 DIRECT_URL 用于连接池和直连
- 只需安装 prisma 和 @prisma/client，无需 @supabase/supabase-js

## 3. UI 组件库: shadcn/ui

项目使用 **shadcn/ui** 作为组件库，基于 Radix UI 和 Tailwind CSS。

**规范**:

- 优先使用 shadcn/ui 提供的组件进行界面构建
- 严格遵循组件库的设计系统和最佳实践
- 保持组件的一致性和可复用性
- 新组件应采用相同的设计语言和模式
- 不要引入其他 UI 组件库，如 Material UI 或 Ant Design

## 4. AI 功能: Vercel AI SDK

项目使用 **Vercel AI SDK v5** 集成 AI 功能，支持流式响应。

**规范**:

- 使用 `ai` 和 `@ai-sdk/openai-compatible` 包
- 使用项目提供的 OpenAI proxy 配置
- 当创建 AI 相关功能时，遵循 Vercel AI SDK v5 的最新 API 规范
- 优先使用流式响应模式提高用户体验

## 5. 服务端功能: Server Actions

项目使用 Next.js 的 **Server Actions** 处理表单提交和数据变更。

**规范**:

- 使用 `'use server'` 指令创建服务器端函数
- 所有数据提交和修改操作应通过 Server Actions 实现
- 遵循 React 表单与 Server Actions 集成的最佳实践
- 结合 Prisma 进行数据库操作

## 开发指导原则

1. **类型安全**：始终利用 TypeScript 提供的类型系统，避免使用 `any` 类型。
2. **代码质量**：遵循项目的 ESLint 和格式化规则，保持代码风格一致。
3. **性能优化**：注重组件渲染性能，避免不必要的重渲染。
4. **可访问性**：确保组件符合 WCAG 可访问性标准。
5. **响应式设计**：所有页面和组件应适配移动设备和桌面设备。
6. **Supabase 数据库最佳实践**：
   - 通过 Prisma 连接 Supabase PostgreSQL 数据库
   - 使用连接池模式提高性能（DATABASE_URL）
   - 使用直连模式进行数据库迁移（DIRECT_URL）
   - 遵循 Prisma 最佳实践进行数据模型设计

## 其他注意事项

- 避免过度使用客户端组件，尽可能使用服务器组件
- 根据功能需求合理拆分组件和文件
- 保持目录结构清晰，遵循项目现有的组织方式
- 编写清晰的注释，特别是对于复杂逻辑和业务规则
