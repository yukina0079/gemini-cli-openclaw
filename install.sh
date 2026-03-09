#!/usr/bin/env bash
# Gemini CLI + OpenClaw 一键安装脚本
# 支持 macOS/Linux

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 打印函数
print_header() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}================================${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

# 检查命令是否存在
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# 主函数
main() {
    print_header "Gemini CLI + OpenClaw 一键安装"
    
    echo ""
    print_warning "⚠️  免责声明"
    echo "本脚本为非官方集成，未经 Google 官方认可"
    echo "部分用户报告使用第三方 Gemini CLI OAuth 客户端后账号受限"
    echo "请勿使用关键账号，建议使用测试账号"
    echo ""
    
    read -p "是否继续？(y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "已取消安装"
        exit 0
    fi
    
    # 步骤 1: 检查并安装 Gemini CLI
    print_header "步骤 1/5: 检查 Gemini CLI"
    if command_exists gemini; then
        print_success "Gemini CLI 已安装"
    else
        print_info "正在安装 Gemini CLI..."
        if command_exists brew; then
            brew install gemini-cli
            print_success "Gemini CLI 安装完成"
        elif command_exists npm; then
            npm install -g @google/gemini-cli
            print_success "Gemini CLI 安装完成"
        else
            print_error "未找到 brew 或 npm，请手动安装 Gemini CLI"
            exit 1
        fi
    fi
    
    # 步骤 2: 检查并安装 OpenClaw
    print_header "步骤 2/5: 检查 OpenClaw"
    if command_exists openclaw; then
        print_success "OpenClaw 已安装"
    else
        print_info "正在安装 OpenClaw..."
        if command_exists npm; then
            npm install -g openclaw
            print_success "OpenClaw 安装完成"
        else
            print_error "未找到 npm，请先安装 Node.js"
            exit 1
        fi
    fi
    
    # 步骤 3: 启用插件
    print_header "步骤 3/5: 启用 Gemini CLI Auth 插件"
    openclaw plugins enable google-gemini-cli-auth
    print_success "插件已启用"
    
    # 步骤 4: 重启 Gateway
    print_header "步骤 4/5: 重启 Gateway"
    print_info "正在重启 Gateway..."
    openclaw gateway restart || true
    sleep 3
    print_success "Gateway 已重启"
    
    # 步骤 5: 登录
    print_header "步骤 5/5: 登录 Gemini CLI"
    print_info "即将打开浏览器进行 Google OAuth 授权..."
    echo ""
    read -p "按回车键继续..." 
    
    openclaw models auth login --provider google-gemini-cli --set-default
    
    # 验证
    print_header "验证安装"
    print_info "当前模型："
    openclaw models status --plain
    
    echo ""
    print_success "安装完成！"
    echo ""
    print_info "可用模型："
    openclaw models list --all --provider google-gemini-cli --plain
    
    echo ""
    print_info "快速开始："
    echo "  openclaw models set google-gemini-cli/gemini-3.1-pro-preview"
    echo ""
}

main "$@"
