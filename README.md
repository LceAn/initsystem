# initsystem

[![Shell](https://img.shields.io/badge/Shell-Script-blue)]()
[![License](https://img.shields.io/badge/License-MIT-green)]()
[![Platform](https://img.shields.io/badge/Platform-Linux-orange)]()

**Linux 系统初始化脚本 | Linux System Initialization Script**

一键完成 Linux 服务器的基础配置和常用工具安装，支持多发行版自动检测和适配。

One-click script to complete basic Linux server configuration and common tool installation, with automatic detection and adaptation for multiple distributions.

---

## 📖 功能特性 | Features

### ✅ 已实现 | Implemented

- **智能系统检测** - 自动识别 Ubuntu/Debian/CentOS/RHEL/Fedora/Arch 等主流发行版
- **权限管理** - 自动检测 root 权限，无缝切换 sudo
- **源切换** - 根据 GitHub 连接状态自动切换 GitHub/Gitee 源
- **系统信息展示** - 显示用户、时区、系统版本等详细信息
- **依赖检查** - 自动检测并安装 sudo、wget、git 等基础工具
- **Zsh 美化** - 自动安装 Oh My Zsh 及常用插件
- **一键卸载** - 完全清理脚本安装的所有文件和程序

- **Smart System Detection** - Auto-detect Ubuntu/Debian/CentOS/RHEL/Fedora/Arch and more
- **Permission Management** - Auto-detect root privilege, seamless sudo switch
- **Source Switch** - Auto-switch GitHub/Gitee based on connection status
- **System Info Display** - Show user, timezone, system version details
- **Dependency Check** - Auto-detect and install sudo, wget, git, etc.
- **Zsh Beautification** - Auto-install Oh My Zsh and common plugins
- **One-click Uninstall** - Complete cleanup of all installed files and programs

---

## 🚀 快速开始 | Quick Start

### 安装 | Install

```bash
# 下载脚本
wget https://raw.githubusercontent.com/LceAn/initsystem/main/init_system.sh
chmod +x init_system.sh

# 运行
./init_system.sh

# 或带参数运行
./init_system.sh install    # 执行安装
./init_system.sh uninstall  # 执行卸载
./init_system.sh help       # 显示帮助
```

### 卸载 | Uninstall

```bash
# 一键卸载（会删除所有安装的文件和配置）
./init_system.sh uninstall
```

---

## 📋 支持的发行版 | Supported Distributions

| 发行版 | 包管理器 | 状态 |
|--------|---------|------|
| Ubuntu | apt | ✅ 支持 |
| Debian | apt | ✅ 支持 |
| CentOS | yum/dnf | ✅ 支持 |
| RHEL | yum/dnf | ✅ 支持 |
| Fedora | dnf | ✅ 支持 |
| Arch Linux | pacman | ✅ 支持 |
| Alpine | apk | ✅ 支持 |

---

## 🔧 功能详情 | Features Detail

### 1. 系统检测 | System Detection

自动检测 Linux 发行版和版本，使用不同的包管理器：

Auto-detect Linux distribution and version, use different package managers:

```bash
# Ubuntu/Debian
apt update && apt install -y xxx

# CentOS/RHEL/Fedora
yum install -y xxx 或 dnf install -y xxx

# Arch Linux
pacman -S xxx

# Alpine
apk add xxx
```

### 2. 安装的工具 | Installed Tools

| 工具 | 用途 | 可选 |
|------|------|------|
| Oh My Zsh | 终端美化 | 是 |
| zsh-autosuggestions | 自动补全插件 | 是 |
| zsh-syntax-highlighting | 语法高亮插件 | 是 |
| sudo, wget, git | 基础工具 | 否 |

### 3. 卸载功能 | Uninstall Features

一键清理以下内容：

- Oh My Zsh 及插件
- 自定义配置文件
- 脚本创建的临时文件
- 环境变量配置

One-click cleanup:

- Oh My Zsh and plugins
- Custom configuration files
- Temporary files created by script
- Environment variable configurations

---

## 📝 使用说明 | Usage

### 参数说明 | Parameters

| 参数 | 说明 | 示例 |
|------|------|------|
| `install` | 执行安装 | `./init_system.sh install` |
| `uninstall` | 执行卸载 | `./init_system.sh uninstall` |
| `help` | 显示帮助信息 | `./init_system.sh help` |
| 无参数 | 交互式选择 | `./init_system.sh` |

### 执行流程 | Execution Flow

```
开始
  ↓
检测 root 权限
  ↓
检测系统版本
  ↓
安装基础依赖
  ↓
安装 Oh My Zsh
  ↓
安装插件
  ↓
完成
```

---

## ⚠️ 注意事项 | Notes

1. **root 权限** - 脚本需要 root 权限或 sudo 权限
2. **网络要求** - 需要稳定的网络连接以下载工具
3. **备份建议** - 建议先备份重要配置文件
4. **卸载谨慎** - 卸载会删除 Oh My Zsh 配置，请提前备份

1. **Root Privilege** - Script requires root or sudo privilege
2. **Network** - Stable network connection required
3. **Backup** - Backup important configuration files first
4. **Uninstall Carefully** - Uninstall will remove Oh My Zsh config, backup first

---

## 🤝 贡献 | Contributing

欢迎提交 Issue 和 Pull Request！

Issues and Pull Requests are welcome!

---

## 📄 许可证 | License

MIT License

---

## 📊 统计 | Stats

![GitHub stars](https://img.shields.io/github/stars/LceAn/initsystem)
![GitHub forks](https://img.shields.io/github/forks/LceAn/initsystem)
![GitHub issues](https://img.shields.io/github/issues/LceAn/initsystem)

---

**最后更新 | Last Updated:** 2026-03-17  
**维护者 | Maintainer:** [@LceAn](https://github.com/LceAn)

---

[English](#initsystem) | [中文](#initsystem)
