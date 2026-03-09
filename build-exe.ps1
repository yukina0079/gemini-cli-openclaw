# 将 PowerShell 脚本打包为 exe
# 使用 ps2exe 工具

# 安装 ps2exe
Install-Module -Name ps2exe -Scope CurrentUser -Force

# 打包
ps2exe -inputFile "C:\Users\35252\.openclaw\workspace\gemini-cli-openclaw\install.ps1" `
       -outputFile "C:\Users\35252\.openclaw\workspace\gemini-cli-openclaw\gemini-openclaw-installer.exe" `
       -title "Gemini CLI + OpenClaw Installer" `
       -description "One-click installer for Gemini CLI + OpenClaw integration" `
       -company "yukina0079" `
       -version "1.0.0.0" `
       -noConsole:$false `
       -requireAdmin:$false
