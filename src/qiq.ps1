# 设置 PowerShell 输出编码，确保中文显示正常
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
Clear-Host

# 检测 winget 是否可用
$wingetAvailable = $false
if (Get-Command winget -ErrorAction SilentlyContinue) {
    $wingetAvailable = $true
}

# 检测 choco 是否可用
$chocoAvailable = $false
if (Get-Command choco -ErrorAction SilentlyContinue) {
    $chocoAvailable = $true
}

# 统一安装软件逻辑
function Install-Software {
    param (
        [string]$wingetName,
        [string]$chocoName,
        [string]$manualURL
    )
    
    if ($wingetAvailable) {
        Write-Host "Using winget to install $wingetName..."
        winget install $wingetName -e
    }
    elseif ($chocoAvailable) {
        Write-Host "Using Chocolatey to install $chocoName..."
        choco install $chocoName -y
    }
    else {
        Write-Host "Download manually: $manualURL" -ForegroundColor Red
        Start-Process $manualURL
    }
    Pause
}

# 安装 Python（可选择版本）
function Install-Python {
    while ($true) {
        Clear-Host
        Write-Host "========== Python Management ==========" -ForegroundColor Green
        Write-Host "1. Install Latest Python"
        Write-Host "2. Install Specific Python Version"
        Write-Host "3. Install pipenv"
        Write-Host "4. Set Python Pip Mirror"
        Write-Host "5. Back to Main Menu"
        $py_choice = Read-Host "Enter your choice (1-5)"
        
        switch ($py_choice) {
            "1" { Install-Software "Python.Python" "python" "https://www.python.org/downloads/" }
            "2" { 
                $py_version = Read-Host "Enter the Python version (e.g., 3.11.5)"
                Install-Software "Python.Python --version $py_version" "python --version $py_version" "https://www.python.org/downloads/release/python-$py_version/"
            }
            "3" { python -m pip install --upgrade pip; python -m pip install pipenv; Pause }
            "4" { Set-Pip-Mirror }
            "5" { return }
            default { Write-Host "Invalid input!" -ForegroundColor Red; Pause }
        }
    }
}

# 设置 pip 源
function Set-Pip-Mirror {
    Write-Host "Choose a pip mirror:"
    Write-Host "1. Alibaba (阿里源)"
    Write-Host "2. Tsinghua (清华源)"
    Write-Host "3. USTC (中科大源)"
    Write-Host "4. Custom"
    Write-Host "5. Back"
    $mirror_choice = Read-Host "Enter choice"

    $mirrorURL = switch ($mirror_choice) {
        "1" { "https://mirrors.aliyun.com/pypi/simple/" }
        "2" { "https://pypi.tuna.tsinghua.edu.cn/simple/" }
        "3" { "https://pypi.mirrors.ustc.edu.cn/simple/" }
        "4" { Read-Host "Enter custom pip mirror URL" }
        "5" { return }
        default { Write-Host "Invalid input"; return }
    }

    $pipConfigPath = "$env:USERPROFILE\pip\pip.ini"
    if (-not (Test-Path "$env:USERPROFILE\pip")) {
        New-Item -ItemType Directory -Path "$env:USERPROFILE\pip" -Force
    }

    @"
[global]
index-url = $mirrorURL
"@ | Set-Content -Path $pipConfigPath -Encoding UTF8

    Write-Host "Pip mirror set to: $mirrorURL" -ForegroundColor Green
    Pause
}

# 常用软件安装
function Install-Common-Software {
    while ($true) {
        Clear-Host
        Write-Host "====== Common Software Installation ======" -ForegroundColor Cyan
        Write-Host "1. Install 7-Zip"
        Write-Host "2. Install Notepad++"
        Write-Host "3. Install VS Code"
        Write-Host "4. Back to Main Menu"
        $soft_choice = Read-Host "Enter your choice (1-4)"
        
        switch ($soft_choice) {
            "1" { Install-Software "7zip.7zip" "7zip" "https://www.7-zip.org/download.html" }
            "2" { Install-Software "Notepad++.Notepad++" "notepadplusplus" "https://notepad-plus-plus.org/downloads/" }
            "3" { Install-Software "Microsoft.VisualStudioCode" "vscode" "https://code.visualstudio.com/download" }
            "4" { return }
            default { Write-Host "Invalid input!" -ForegroundColor Red; Pause }
        }
    }
}

# 系统设置
function System-Settings {
    while ($true) {
        Clear-Host
        Write-Host "======= System Settings =======" -ForegroundColor Yellow
        Write-Host "1. Set PowerShell Execution Policy"
        Write-Host "2. Enable OpenSSH Service"
        Write-Host "3. Set Default Shell to pwsh"
        Write-Host "4. Back to Main Menu"
        $sys_choice = Read-Host "Enter your choice (1-4)"
        
        switch ($sys_choice) {
            "1" { Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force; Write-Host "Execution policy set!"; Pause }
            "2" { Enable-OpenSSH }
            "3" { Set-DefaultShell-Pwsh }
            "4" { return }
            default { Write-Host "Invalid input!" -ForegroundColor Red; Pause }
        }
    }
}

# 启用 OpenSSH 服务
function Enable-OpenSSH {
    Write-Host "Enabling OpenSSH server..."
    Add-WindowsFeature -Name OpenSSH-Server
    Set-Service -Name sshd -StartupType Automatic
    Start-Service sshd
    Write-Host "OpenSSH is enabled!" -ForegroundColor Green
    Pause
}

# 设置 PowerShell 7 为默认 shell
function Set-DefaultShell-Pwsh {
    if (Get-Command pwsh -ErrorAction SilentlyContinue) {
        $pwshPath = (Get-Command pwsh).Source
        New-ItemProperty -Path "HKCU:\Software\Microsoft\Command Processor" -Name "AutoRun" -Value "$pwshPath" -PropertyType String -Force
        Write-Host "Default shell set to PowerShell 7 (pwsh)." -ForegroundColor Green
    } else {
        Write-Host "PowerShell 7 is not installed! Install it first." -ForegroundColor Red
    }
    Pause
}

# 菜单界面
function Show-Menu {
    Clear-Host
    Write-Host "========== Tool Menu ==========" -ForegroundColor Cyan
    Write-Host "1. Python Management"
    Write-Host "2. Common Software Installation"
    Write-Host "3. System Settings"
    Write-Host "4. Exit"
}

# 菜单循环
while ($true) {
    Show-Menu
    $choice = Read-Host "Enter your choice (1-4)"
    switch ($choice) {
        "1" { Install-Python }
        "2" { Install-Common-Software }
        "3" { System-Settings }
        "4" { exit }
        default { Write-Host "Invalid input!" -ForegroundColor Red; Pause }
    }
}
