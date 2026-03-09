@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

:: Gemini CLI + OpenClaw 一键安装器
:: Windows 批处理版本

title Gemini CLI + OpenClaw 安装器

echo.
echo ================================
echo Gemini CLI + OpenClaw 一键安装
echo ================================
echo.
echo [警告] 免责声明
echo 本脚本为非官方集成，未经 Google 官方认可
echo 部分用户报告使用第三方 Gemini CLI OAuth 客户端后账号受限
echo 请勿使用关键账号，建议使用测试账号
echo.

set /p continue="是否继续？(Y/N): "
if /i not "%continue%"=="Y" (
    echo 已取消安装
    pause
    exit /b 0
)

:: 检查 PowerShell
where powershell >nul 2>&1
if errorlevel 1 (
    echo [错误] 未找到 PowerShell
    pause
    exit /b 1
)

:: 下载并执行 PowerShell 脚本
echo.
echo [信息] 正在下载安装脚本...
powershell -ExecutionPolicy Bypass -Command "& {irm https://raw.githubusercontent.com/yukina0079/gemini-cli-openclaw/main/install.ps1 | iex}"

echo.
echo 按任意键退出...
pause >nul
