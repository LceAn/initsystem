# initsystem

[![Shell](https://img.shields.io/badge/Shell-Script-blue)]()
[![License](https://img.shields.io/badge/License-MIT-green)]()
[![Platform](https://img.shields.io/badge/Platform-Linux-orange)]()
[![Version](https://img.shields.io/badge/Version-1.0.2-red)]()
[![Tested](https://img.shields.io/badge/Tested-Ubuntu%2024.04-brightgreen)]()
[![Mirrors](https://img.shields.io/badge/Mirrors-5%20Sources-purple)]()

**Linux System Initialization Script**

One-click script to complete basic Linux server configuration and common tool installation, with automatic detection and adaptation for multiple distributions.

---

## 📖 Features

### ✅ Implemented

- **Smart System Detection** - Auto-detect Ubuntu/Debian/CentOS/RHEL/Fedora/Arch/Alpine
- **Permission Management** - Auto-detect root privilege, seamless sudo switch
- **Multi-Mirror Support** - 5 mirror sources (GitHub/Gitee/Aliyun/Tencent/USTC)
- **Auto/Manual Mode** - Auto-detect or manual select mirror source
- **System Info Display** - Show user, timezone, system version details
- **Dependency Check** - Auto-detect and install sudo, wget, git, zsh, etc.
- **Zsh Auto-Install** - Auto-install Zsh before Oh My Zsh
- **Zsh Beautification** - Auto-install Oh My Zsh and common plugins
- **One-click Uninstall** - Complete cleanup of all installed files and programs

---

## 🚀 Quick Start

### Install

```bash
# Clone the repository
git clone https://github.com/LceAn/initsystem.git
cd initsystem

# Make script executable
chmod +x init_system.sh

# Run installation (auto-detect mirror)
./init_system.sh install

# Or with manual mirror selection
./init_system.sh --manual

# Or interactive mode
./init_system.sh
```

### Uninstall

```bash
# One-click uninstall (removes all installed files and configurations)
./init_system.sh uninstall
```

---

## 📋 Supported Distributions

| Distribution | Package Manager | Status |
|--------------|-----------------|--------|
| Ubuntu | apt | ✅ Supported |
| Debian | apt | ✅ Supported |
| CentOS | yum/dnf | ✅ Supported |
| RHEL | yum/dnf | ✅ Supported |
| Fedora | dnf | ✅ Supported |
| Arch Linux | pacman | ✅ Supported |
| Alpine | apk | ✅ Supported |

---

## 🔧 Features Detail

### 1. System Detection

Auto-detect Linux distribution and version, use different package managers:

```bash
# Ubuntu/Debian
apt update && apt install -y xxx

# CentOS/RHEL/Fedora
yum install -y xxx or dnf install -y xxx

# Arch Linux
pacman -S xxx

# Alpine
apk add xxx
```

### 2. Installed Tools

| Tool | Purpose | Optional |
|------|---------|----------|
| Oh My Zsh | Terminal beautification | Yes |
| zsh-autosuggestions | Auto-completion plugin | Yes |
| zsh-syntax-highlighting | Syntax highlighting plugin | Yes |
| sudo, wget, git | Base tools | No |

### 3. Uninstall Features

One-click cleanup includes:

- Oh My Zsh and plugins
- Custom configuration files
- Temporary files created by script
- Environment variable configurations

---

## 📝 Usage

### Parameters

| Parameter | Description | Example |
|-----------|-------------|---------|
| `install` | Execute installation | `./init_system.sh install` |
| `uninstall` | Execute uninstallation | `./init_system.sh uninstall` |
| `help` | Show help message | `./init_system.sh help` |
| No parameter | Interactive selection | `./init_system.sh` |

### Execution Flow

```
Start
  ↓
Check root privilege
  ↓
Detect system version
  ↓
Install base dependencies
  ↓
Install Oh My Zsh
  ↓
Install plugins
  ↓
Complete
```

---

## ⚠️ Notes

1. **Root Privilege** - Script requires root or sudo privilege
2. **Network** - Stable network connection required
3. **Backup** - Backup important configuration files first
4. **Uninstall Carefully** - Uninstall will remove Oh My Zsh config, backup first

---

## 🧪 测试结果 | Test Results

**测试服务器 | Test Server:** Ubuntu 24.04.4 LTS  
**测试时间 | Test Date:** 2026-03-17  
**测试版本 | Test Version:** v1.0.1

### ✅ 通过项 | Passed Tests

| 测试项 | 状态 |
|--------|------|
| 系统检测 System Detection | ✅ 完美 Perfect |
| 网络检测 Network Detection | ✅ 完美 Perfect |
| 权限管理 Permission Management | ✅ 完美 Perfect |
| 工具检查 Tool Check | ✅ 完美 Perfect |
| Oh My Zsh 安装 | ✅ 已修复 Fixed |
| 插件安装 Plugin Installation | ✅ 完美 Perfect |

**总体评分 | Overall Rating:** ⭐⭐⭐⭐⭐ (5/5)

📖 **详细测试报告 | Detailed Test Report:** [TEST_REPORT.md](TEST_REPORT.md)

---

## 🤝 Contributing

Issues and Pull Requests are welcome!

---

## 📄 License

MIT License

---

## 📊 Stats

![GitHub stars](https://img.shields.io/github/stars/LceAn/initsystem)
![GitHub forks](https://img.shields.io/github/forks/LceAn/initsystem)
![GitHub issues](https://img.shields.io/github/issues/LceAn/initsystem)

---

## 🔗 Links

- [GitHub Repository](https://github.com/LceAn/initsystem)
- [Chinese README](README_CN.md) - 中文版本

---

**Last Updated:** 2026-03-17  
**Maintainer:** [@LceAn](https://github.com/LceAn)  
**Version:** 1.0.0

---

## 仓库结构

- `README.md`
- `README_CN.md`
- `TEST_REPORT.md`
- `init_system.sh`

<!-- repo-readme-standard:v1 -->
## 仓库维护信息

- 项目类型：产品/工具
- 当前状态：待复盘
- 可见性：public
- 维护节奏：每月只选 1-2 个小更新
- 相关仓库：无已确认的重复仓库关系；如需合并请先核对功能边界。
- 维护边界：普通文档和代码更新可直接提交；归档、删除、历史重写或强制推送需单独确认。
