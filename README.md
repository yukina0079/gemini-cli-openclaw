# Gemini CLI + OpenClaw 接入方案

本仓库记录如何将 **Gemini CLI (Google Code Assist)** 通过 OAuth 方式接入 **OpenClaw**，实现免 API Key 调用 Gemini 模型。

## ⚠️ 免责声明

- 本方案为非官方集成，未经 Google 官方认可
- 部分用户报告使用第三方 Gemini CLI OAuth 客户端后账号受限或封禁
- **请勿使用关键账号**，建议使用测试账号
- 使用前请仔细阅读 Google 相关服务条款

## 📋 前置要求

1. **安装 Gemini CLI**
   ```bash
   # macOS/Linux
   brew install gemini-cli
   
   # 或使用 npm
   npm install -g @google/gemini-cli
   ```

2. **安装 OpenClaw**
   ```bash
   npm install -g openclaw
   ```

## 🚀 快速开始

### 方式一：一键安装脚本（推荐）

**macOS/Linux:**
```bash
curl -fsSL https://raw.githubusercontent.com/yukina0079/gemini-cli-openclaw/main/install.sh | bash
```

**Windows (PowerShell):**
```powershell
irm https://raw.githubusercontent.com/yukina0079/gemini-cli-openclaw/main/install.ps1 | iex
```

脚本会自动完成：
- ✓ 检查并安装 Gemini CLI
- ✓ 检查并安装 OpenClaw
- ✓ 启用 google-gemini-cli-auth 插件
- ✓ 重启 Gateway
- ✓ 引导完成 OAuth 登录

### 方式二：手动安装

#### 1. 启用 Gemini CLI Auth 插件

OpenClaw 内置了 `google-gemini-cli-auth` 插件，默认禁用，需要手动启用：

```bash
openclaw plugins enable google-gemini-cli-auth
```

#### 2. 重启 Gateway

```bash
openclaw gateway restart
```

#### 3. 登录 Gemini CLI

```bash
openclaw models auth login --provider google-gemini-cli --set-default
```

这会：
- 打开浏览器进行 Google OAuth 授权
- 启动本地回调服务器（默认 `localhost:8085`）
- 将凭据保存到 `~/.gemini/oauth_creds.json`
- 同步到 OpenClaw 的 auth profiles

#### 4. 设置默认模型

```bash
# 查看可用模型
openclaw models list --all --provider google-gemini-cli --plain

# 设置默认模型
openclaw models set google-gemini-cli/gemini-3.1-pro-preview
```

#### 5. 验证

```bash
# 查看当前模型
openclaw models status --plain

# 应该输出：
# google-gemini-cli/gemini-3.1-pro-preview
```

## 📦 可用模型

通过 `google-gemini-cli` provider 可用的模型：

- `google-gemini-cli/gemini-2.0-flash`
- `google-gemini-cli/gemini-2.5-flash`
- `google-gemini-cli/gemini-2.5-pro`
- `google-gemini-cli/gemini-3-flash-preview`
- `google-gemini-cli/gemini-3-pro-preview`
- `google-gemini-cli/gemini-3.1-pro-preview` ⭐ 推荐

## 🔧 配置示例

### OpenClaw 配置文件位置

- 主配置：`~/.openclaw/openclaw.json`
- Auth profiles：`~/.openclaw/agents/main/agent/auth-profiles.json`

### 完整配置示例

参考 [`config-example.json`](./config-example.json)

## 🐛 常见问题

### 1. `localhost:8085` 拒绝连接

**原因**：OAuth 回调服务器已经完成任务并退出

**解决**：这是正常现象，不影响登录结果。检查：
```bash
cat ~/.gemini/oauth_creds.json
```
如果文件存在且包含 `access_token` 和 `refresh_token`，说明登录成功。

### 2. 模型列表里看不到 Gemini

**原因**：`openclaw models list` 默认只显示已配置模型

**解决**：使用 `--all` 参数查看完整目录：
```bash
openclaw models list --all --provider google-gemini-cli
```

### 3. Session 文件锁定错误

**原因**：当前会话正在被其他进程使用

**解决**：
- 等待当前操作完成
- 或使用独立 session：`--session-id <custom-id>`

### 4. 切换模型后当前会话没生效

**原因**：已存在的 session 不会自动热切换模型

**解决**：
```bash
# 方法1：为当前 session 设置模型
openclaw session status --model google-gemini-cli/gemini-3.1-pro-preview

# 方法2：开新会话
openclaw agent --session-id new-session --message "test"
```

## 📝 工作原理

1. **Gemini CLI OAuth**
   - Gemini CLI 使用 Google OAuth 2.0 进行身份验证
   - 凭据存储在 `~/.gemini/oauth_creds.json`
   - 包含 `access_token`、`refresh_token` 和过期时间

2. **OpenClaw 集成**
   - `google-gemini-cli-auth` 插件读取 Gemini CLI 凭据
   - 自动同步到 OpenClaw auth profiles
   - 通过 `google-gemini-cli` provider 调用 Gemini API

3. **认证流程**
   ```
   用户 → openclaw models auth login
        → 启动本地回调服务器 (localhost:8085)
        → 打开浏览器 → Google OAuth
        → 回调到本地服务器
        → 保存凭据到 ~/.gemini/oauth_creds.json
        → 同步到 OpenClaw auth profiles
   ```

## 🔐 安全建议

1. **不要分享凭据文件**
   - `~/.gemini/oauth_creds.json`
   - `~/.openclaw/auth-profiles.json`

2. **定期检查授权**
   - 访问 [Google 账号安全设置](https://myaccount.google.com/permissions)
   - 检查第三方应用授权

3. **使用测试账号**
   - 避免使用主要 Google 账号
   - 建议创建专用测试账号

## 📚 参考资料

- [OpenClaw 官方文档](https://docs.openclaw.ai)
- [Gemini CLI GitHub](https://github.com/google-gemini/gemini-cli)
- [OpenClaw Gemini CLI Auth 插件](https://github.com/openclaw/openclaw/tree/main/extensions/google-gemini-cli-auth)

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

## 📄 许可

MIT License
