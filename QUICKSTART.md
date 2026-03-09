# Gemini CLI + OpenClaw 接入方案

快速将 Gemini CLI 通过 OAuth 接入 OpenClaw，免 API Key 调用 Gemini 模型。

## 快速开始

```bash
# 1. 启用插件
openclaw plugins enable google-gemini-cli-auth

# 2. 重启 Gateway
openclaw gateway restart

# 3. 登录
openclaw models auth login --provider google-gemini-cli --set-default

# 4. 设置模型
openclaw models set google-gemini-cli/gemini-3.1-pro-preview

# 5. 验证
openclaw models status --plain
```

详细文档见 [README.md](./README.md)

## 故障排查

### localhost:8085 拒绝连接？
正常现象，检查 `~/.gemini/oauth_creds.json` 是否存在即可。

### 看不到模型？
```bash
openclaw models list --all --provider google-gemini-cli
```

### 切换模型没生效？
```bash
openclaw session status --model google-gemini-cli/gemini-3.1-pro-preview
```
