# Gemini CLI + OpenClaw 一键安装脚本 (Windows)
# PowerShell 版本

$ErrorActionPreference = "Stop"

# 颜色函数
function Write-Header {
    param([string]$Message)
    Write-Host "`n================================" -ForegroundColor Blue
    Write-Host $Message -ForegroundColor Blue
    Write-Host "================================`n" -ForegroundColor Blue
}

function Write-Success {
    param([string]$Message)
    Write-Host "✓ $Message" -ForegroundColor Green
}

function Write-Error-Custom {
    param([string]$Message)
    Write-Host "✗ $Message" -ForegroundColor Red
}

function Write-Warning-Custom {
    param([string]$Message)
    Write-Host "⚠ $Message" -ForegroundColor Yellow
}

function Write-Info {
    param([string]$Message)
    Write-Host "ℹ $Message" -ForegroundColor Cyan
}

# 检查命令是否存在
function Test-Command {
    param([string]$Command)
    $null -ne (Get-Command $Command -ErrorAction SilentlyContinue)
}

# 主函数
function Main {
    Write-Header "Gemini CLI + OpenClaw 一键安装"
    
    Write-Warning-Custom "⚠️  免责声明"
    Write-Host "本脚本为非官方集成，未经 Google 官方认可"
    Write-Host "部分用户报告使用第三方 Gemini CLI OAuth 客户端后账号受限"
    Write-Host "请勿使用关键账号，建议使用测试账号`n"
    
    $continue = Read-Host "是否继续？(y/N)"
    if ($continue -notmatch '^[Yy]$') {
        Write-Info "已取消安装"
        exit 0
    }
    
    # 步骤 1: 检查并安装 Gemini CLI
    Write-Header "步骤 1/5: 检查 Gemini CLI"
    if (Test-Command "gemini") {
        Write-Success "Gemini CLI 已安装"
    } else {
        Write-Info "正在安装 Gemini CLI..."
        if (Test-Command "npm") {
            npm install -g @google/gemini-cli
            Write-Success "Gemini CLI 安装完成"
        } else {
            Write-Error-Custom "未找到 npm，请先安装 Node.js"
            Write-Info "下载地址: https://nodejs.org/"
            exit 1
        }
    }
    
    # 步骤 2: 检查并安装 OpenClaw
    Write-Header "步骤 2/5: 检查 OpenClaw"
    if (Test-Command "openclaw") {
        Write-Success "OpenClaw 已安装"
    } else {
        Write-Info "正在安装 OpenClaw..."
        if (Test-Command "npm") {
            npm install -g openclaw
            Write-Success "OpenClaw 安装完成"
        } else {
            Write-Error-Custom "未找到 npm，请先安装 Node.js"
            exit 1
        }
    }
    
    # 步骤 3: 启用插件
    Write-Header "步骤 3/5: 启用 Gemini CLI Auth 插件"
    openclaw plugins enable google-gemini-cli-auth
    Write-Success "插件已启用"
    
    # 步骤 4: 重启 Gateway
    Write-Header "步骤 4/5: 重启 Gateway"
    Write-Info "正在重启 Gateway..."
    try {
        openclaw gateway restart
    } catch {
        # 忽略错误
    }
    Start-Sleep -Seconds 3
    Write-Success "Gateway 已重启"
    
    # 步骤 5: 登录
    Write-Header "步骤 5/5: 登录 Gemini CLI"
    Write-Info "即将打开浏览器进行 Google OAuth 授权...`n"
    Read-Host "按回车键继续"
    
    openclaw models auth login --provider google-gemini-cli --set-default
    
    # 验证
    Write-Header "验证安装"
    Write-Info "当前模型："
    openclaw models status --plain
    
    Write-Host ""
    Write-Success "安装完成！"
    Write-Host ""
    Write-Info "可用模型："
    openclaw models list --all --provider google-gemini-cli --plain
    
    Write-Host ""
    Write-Info "快速开始："
    Write-Host "  openclaw models set google-gemini-cli/gemini-3.1-pro-preview"
    Write-Host ""
}

# 运行主函数
Main
