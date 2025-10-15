# CLAUDE 开发指南

本文档为 Claude Code 提供项目的关键技术和开发约束。请在处理开发请求前仔细阅读本文档。

## 项目概述

本项目是使用现代化前端技术栈构建的 Next.js 应用程序，主要为 AI Persona Chat application。

**技术栈**: Next.js 15, React 19, TypeScript, TailwindCSS 4, Prisma ORM, Supabase PostgreSQL, Vercel AI SDK v5

## 开发命令

### 基础开发命令

```bash
# 启动开发服务器（使用 Turbopack）
pnpm dev

# 运行代码检查
pnpm lint

# 全面检查（推荐：完成功能后运行）
pnpm build
```

### 数据库操作

```bash
# 生成 Prisma 客户端
npx prisma generate

# 运行数据库迁移（开发环境）
npx prisma migrate dev

# 打开 Prisma Studio GUI
npx prisma studio
```

## 环境配置

项目需要配置以下环境变量：

```bash
# AI API 配置
OPENAI_BASE_URL="https://your-api-endpoint"
OPENAI_API_KEY="sk-your-key"

# 数据库配置
DATABASE_URL="postgresql://..."     # Supabase PostgreSQL 连接字符串
DIRECT_URL="postgresql://..."       # 用于迁移的直连数据库连接
```

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
- Prisma 客户端生成到 `src/generated/prisma/` (自定义输出位置)

## 3. UI 组件库: shadcn/ui

项目使用 **shadcn/ui** 作为组件库，基于 Radix UI 和 Tailwind CSS。

**规范**:

- 优先使用 shadcn/ui 提供的组件进行界面构建
- 严格遵循组件库的设计系统和最佳实践
- 保持组件的一致性和可复用性
- 新组件应采用相同的设计语言和模式
- 不要引入其他 UI 组件库，如 Material UI 或 Ant Design

## 4. AI 功能: Vercel AI SDK v5

项目使用 **Vercel AI SDK v5** 集成 AI 功能，支持流式响应。

**重要说明**: 项目使用 Vercel AI SDK v5，不使用 v4 版本。v5 的 API 与 v4 有重要差异，必须使用 v5 的正确方法。

**统一 SDK 方法**: 所有 AI 相关功能都应使用 AI SDK 提供的统一方法，例如：

- 文本生成：`streamText()` 和 `generateText()`
- 语音转录：`experimental_transcribe()` 和 `openai.transcription()`
- 其他 AI 功能也应使用对应的 SDK 方法，而不是直接调用各提供商的原生 API

### 依赖包安装

```bash
pnpm add ai @ai-sdk/openai-compatible @ai-sdk/react
```

### 正确用法要点 🚨

#### 1. 消息格式转换 (正确用法)

```typescript
// ❌ 错误：直接使用 messages 会导致格式不匹配
const result = streamText({ messages });

// ✅ 正确：必须转换 UIMessage[] 为 ModelMessage[]
import { convertToModelMessages } from "ai";
const result = streamText({
  messages: convertToModelMessages(messages), // 正确用法
});
```

#### 2. 流响应方法 (正确用法)

```typescript
// ❌ 错误：这些方法不存在或不兼容 useChat
result.toTextStreamResponse();
result.toDataStreamResponse();

// ✅ 正确：用于 useChat 集成的正确方法
result.toUIMessageStreamResponse(); // 正确用法
```

#### 3. 客户端传输配置 (正确用法)

```typescript
// ❌ 错误：直接使用 api 参数无法正常工作
const { messages, sendMessage } = useChat({
  api: "/api/chat",
});

// ✅ 正确：使用 DefaultChatTransport
import { DefaultChatTransport } from "ai";
const { messages, sendMessage } = useChat({
  transport: new DefaultChatTransport({
    // 正确用法
    api: "/api/chat",
    body: { model: selectedModel },
  }),
});
```

#### 4. 状态处理 (API 变更)

```typescript
// ❌ 错误：v4 模式，v5 中不存在 isLoading
const { messages, isLoading } = useChat();

// ✅ 正确：v5 使用 status
const { messages, status } = useChat();
// status 可能值: 'ready', 'submitted', 'streaming'
```

#### 5. 消息结构 (API 变更)

```typescript
// ❌ 错误：v4 模式，v5 中不存在 message.content
{
  message.content;
}

// ✅ 正确：v5 使用 parts 结构
{
  message.parts
    .filter((part) => part.type === "text")
    .map((part) => part.text)
    .join("");
}
```

### 工作模板

**API 路由模板** (`src/app/api/chat/route.ts`):

```typescript
import { createOpenAICompatible } from "@ai-sdk/openai-compatible";
import { streamText, convertToModelMessages } from "ai";

const openaiCompatible = createOpenAICompatible({
  name: "OpenAI Compatible",
  baseURL: process.env.OPENAI_BASE_URL!,
  apiKey: process.env.OPENAI_API_KEY!,
});

export async function POST(req: Request) {
  const { messages, model = "gpt-5" } = await req.json();

  const result = streamText({
    model: openaiCompatible(model),
    messages: convertToModelMessages(messages), // 正确用法
    maxOutputTokens: 4000,
    temperature: 0.7,
  });

  return result.toUIMessageStreamResponse(); // 正确用法
}
```

**客户端组件模板**:

```typescript
import { useChat } from "@ai-sdk/react";
import { DefaultChatTransport } from "ai"; // 正确用法

const { messages, sendMessage, status } = useChat({
  transport: new DefaultChatTransport({
    // 正确用法
    api: "/api/chat",
    body: { model: selectedModel },
  }),
});
```

### 其他 AI 功能示例

**语音转录** (使用统一 SDK 方法):

```typescript
import { experimental_transcribe as transcribe } from "ai";
import { createOpenAI } from "@ai-sdk/openai";
import { readFile } from "fs/promises";

const openai = createOpenAI({
  baseURL: process.env.OPENAI_BASE_URL!,
  apiKey: process.env.OPENAI_API_KEY!,
});

const { text } = await transcribe({
  model: openai.transcription("whisper"),
  audio: await readFile("audio.mp3"),
});
```

**支持的 AI 模型**: gpt-5, gpt-5-mini, gpt-5-nano, claude-sonnet-4, whisper, gpt-4o-mini-transcribe

## 5. 服务端功能: Server Actions

项目使用 Next.js 的 **Server Actions** 处理表单提交和数据变更。

**规范**:

- 使用 `'use server'` 指令创建服务器端函数
- 所有数据提交和修改操作应通过 Server Actions 实现
- 遵循 React 表单与 Server Actions 集成的最佳实践
- 结合 Prisma 进行数据库操作

## 文档查阅协议

在使用 AI SDK 或任何外部库时，遵循以下协议：

1. **使用 Context7 MCP**: 通过 `resolve-library-id` 和 `get-library-docs` 查询最新文档
2. **检查 API 变更**: SDK 版本更新频繁，始终验证当前模式
3. **关注示例**: 查找官方文档中的可用代码示例
4. **迁移指南**: 遇到弃用方法时检查迁移指南

示例文档查询:

```bash
# 首先解析库 ID
resolve-library-id: "vercel ai sdk"
# 然后获取具体文档
get-library-docs: "/vercel/ai" with topic "useChat streamText"
```

## 服务器组件与客户端组件选择策略

### 默认选择：服务器组件

- 展示静态内容
- 数据获取和展示
- SEO 重要的页面
- 不需要用户交互的组件

### 按需使用：客户端组件 ('use client')

- 需要用户交互（按钮点击、表单输入）
- 需要状态管理（useState、useReducer）
- 需要浏览器 API（localStorage、geolocation 等）
- 需要实时数据（useChat、WebSocket 等）

**策略**：尽可能将客户端组件推到组件树的叶子节点，避免整个页面标记为客户端组件。

## 开发指导原则

1. **类型安全**：始终利用 TypeScript 提供的类型系统，避免使用 `any` 类型。
2. **代码质量**：遵循项目的 ESLint 和格式化规则，保持代码风格一致。
3. **性能优化**：注重组件渲染性能，避免不必要的重渲染。
4. **可访问性**：确保组件符合 WCAG 可访问性标准。
5. **响应式设计**：所有页面和组件应适配移动设备和桌面设备。
6. **日志输出**：复杂功能应该输出适当的日志信息，便于调试和监控，提醒用户关注控制台日志。

## 开发注意事项

- **错误处理**: 提供清晰的错误消息，便于问题定位和用户理解
- **组件拆分**: 避免过度使用客户端组件，尽可能使用服务器组件
- **目录组织**: 根据功能需求合理拆分组件和文件，保持目录结构清晰
- **注释规范**: 编写清晰的注释，特别是对于复杂逻辑和业务规则

- **开发检查**: 完成功能后运行 `pnpm build` 进行全面检查，比单独的 `lint` 和 `tsc` 更全面
