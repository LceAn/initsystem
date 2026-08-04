#!/usr/bin/env bash

# ============================================================================
# initsystem - Linux System Initialization Script
# Linux 系统初始化脚本
# 
# 功能：一键完成 Linux 服务器的基础配置和常用工具安装
# Features: One-click Linux server basic configuration and tool installation
#
# 作者 | Author: LceAn
# 版本 | Version: 1.0.0
# 许可证 | License: MIT
# ============================================================================

# 定义资源 | Resources
OH_MY_ZSH_INSTALL_SCRIPT=(
  "https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"
  "https://gitee.com/mirrors/oh-my-zsh/raw/master/tools/install.sh"
)

# 国内镜像源 | China Mirror Sources
MIRROR_SOURCES=(
  "GitHub (Default)"
  "Gitee (China)"
  "Aliyun (China)"
  "Tencent (China)"
  "USTC (China)"
)

Zsh_plugins=("zsh-users/zsh-autosuggestions" "zsh-users/zsh-completions" "zsh-users/zsh-syntax-highlighting" "zsh-users/zsh-history-substring-search" "MichaelAquilina/zsh-you-should-use")
version='1.1.0'

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
LOG_DIR=${INITSYSTEM_LOG_DIR:-"$SCRIPT_DIR/log"}
STATE_DIR=${INITSYSTEM_STATE_DIR:-"${XDG_STATE_HOME:-$HOME/.local/state}/initsystem"}
ZSHRC_BACKUP="$STATE_DIR/zshrc.before-initsystem"
ZSHRC_CREATED_MARKER="$STATE_DIR/zshrc-created"
OH_MY_ZSH_MARKER="$STATE_DIR/oh-my-zsh-installed"

# 定义颜色 | Define colors
yellow=""
white=""
green=""
blue=""
red=""
end=""

setupRuntime() {
  if [ -t 1 ] && command -v tput &> /dev/null; then
    yellow=$(tput setaf 3)
    white=$(tput setaf 7)
    green=$(tput setaf 2)
    blue=$(tput setaf 4)
    red=$(tput setaf 1)
    end=$(tput sgr0)
  fi

  mkdir -p "$LOG_DIR"
  local log_file
  log_file="$LOG_DIR/init_system_log_$(date +"%Y%m%d_%H%M%S").log"
  exec > >(tee -a "$log_file") 2>&1
}

runPrivileged() {
  if [ "$EUID" -eq 0 ]; then
    "$@"
  else
    sudo "$@"
  fi
}

recordZshrcState() {
  mkdir -p "$STATE_DIR"
  if [ -f "$ZSHRC_BACKUP" ] || [ -f "$ZSHRC_CREATED_MARKER" ]; then
    return
  fi

  if [ -f "$HOME/.zshrc" ]; then
    cp -p "$HOME/.zshrc" "$ZSHRC_BACKUP"
  else
    : > "$ZSHRC_CREATED_MARKER"
  fi
}

# ============================================================================
# 系统检测函数 | System Detection Functions
# ============================================================================

# 检测 Linux 发行版 | Detect Linux Distribution
detect_linux_distro() {
  if [ -f /etc/os-release ]; then
    # shellcheck disable=SC1091
    . /etc/os-release
    DISTRO=$ID
    DISTRO_VERSION=$VERSION_ID
    DISTRO_NAME=$PRETTY_NAME
  elif [ -f /etc/lsb-release ]; then
    # shellcheck disable=SC1091
    . /etc/lsb-release
    DISTRO=$DISTRIB_ID
    DISTRO_VERSION=$DISTRIB_RELEASE
    DISTRO_NAME=$DISTRIB_DESCRIPTION
  elif [ -f /etc/redhat-release ]; then
    DISTRO="rhel"
    DISTRO_VERSION=$(cat /etc/redhat-release | grep -oP '\d+\.\d+')
    DISTRO_NAME=$(cat /etc/redhat-release)
  else
    DISTRO="unknown"
    DISTRO_VERSION="unknown"
    DISTRO_NAME="Unknown Linux"
  fi
  
  export DISTRO DISTRO_VERSION DISTRO_NAME
}

# 检测包管理器 | Detect Package Manager
detect_package_manager() {
  if command -v apt &> /dev/null; then
    PKG_MANAGER="apt"
  elif command -v dnf &> /dev/null; then
    PKG_MANAGER="dnf"
  elif command -v yum &> /dev/null; then
    PKG_MANAGER="yum"
  elif command -v pacman &> /dev/null; then
    PKG_MANAGER="pacman"
  elif command -v zypper &> /dev/null; then
    PKG_MANAGER="zypper"
  elif command -v apk &> /dev/null; then
    PKG_MANAGER="apk"
  else
    PKG_MANAGER="unknown"
  fi
  
  export PKG_MANAGER
}

# 根据系统版本选择不同的包管理器 | Select package manager based on system
installPackage() {
  local package_name=$1
  
  case $PKG_MANAGER in
    apt)
      runPrivileged apt update && runPrivileged apt install -y "$package_name"
      ;;
    dnf|yum)
      runPrivileged "$PKG_MANAGER" install -y "$package_name"
      ;;
    pacman)
      runPrivileged pacman -S --noconfirm "$package_name"
      ;;
    zypper)
      runPrivileged zypper install -y "$package_name"
      ;;
    apk)
      runPrivileged apk add "$package_name"
      ;;
    *)
      echo "${red}不支持的包管理器：$PKG_MANAGER${end}"
      return 1
      ;;
  esac
}

# ============================================================================
# 基础功能函数 | Basic Function Functions
# ============================================================================

# 初始化信息输出 | Initialization output
start(){
  echo "${yellow}"
  echo " _       _ _                   _                 "
  echo "(_)_ __ (_) |_   ___ _   _ ___| |_ ___ _ __ ___  "
  echo "| | '_ \| | __| / __| | | / __| __/ _ \ '_ \` _ \ ${white}{${red}$version${white}}"
  echo "| | | | | | |_  \__ \ |_| \__ \ ||  __/ | | | | |${blue}"
  echo "|_|_| |_|_|\__|_|___/\__, |___/\__\___|_| |_| |_|"
  echo "                     |___/                      "
  echo "${end}"
  echo "${green}Linux System Initialization Script${end}"
  echo "${green}Linux 系统初始化脚本${end}"
  echo ""
}

# 显示系统信息 | Show system info
showSystemInfo() {
  echo "${yellow}========================================${end}"
  echo "${yellow}系统信息 | System Information${end}"
  echo "${yellow}========================================${end}"
  echo "${yellow}当前用户 | User:${end} $(whoami)"
  echo "${yellow}当前时区时间 | Time:${end} $(date)"
  echo "${yellow}发行版 | Distribution:${end} ${DISTRO_NAME}"
  echo "${yellow}包管理器 | Package Manager:${end} ${PKG_MANAGER}"
  echo "${yellow}主机名 | Hostname:${end} $(hostname)"
  echo "${yellow}内核版本 | Kernel:${end} $(uname -r)"
  echo "${yellow}架构 | Architecture:${end} $(uname -m)"
  echo ""
}

# 检查网络连接并选择镜像源 | Check network and select mirror
checkNetwork() {
  echo "${blue}检测网络连接... | Checking network connection...${end}"
  
  # 自动检测模式 | Auto-detect mode
  if [ "${1:-auto}" = "auto" ]; then
    echo "${yellow}自动检测模式 | Auto-detect mode${end}"
    
    # 测试 GitHub 连接
    if curl -Is --connect-timeout 3 https://github.com/robots.txt 2>/dev/null | head -n 1 | grep -q 200; then
      echo "${green}✓ 可以访问 GitHub，使用默认源${end}"
      echo "${green}✓ GitHub accessible, using default source${end}"
      OH_MY_ZSH_INSTALL="${OH_MY_ZSH_INSTALL_SCRIPT[0]}"
      MIRROR_SOURCE="GitHub"
    else
      echo "${yellow}GitHub 访问受限，切换到 Gitee 源${end}"
      echo "${yellow}GitHub restricted, switching to Gitee source${end}"
      OH_MY_ZSH_INSTALL="${OH_MY_ZSH_INSTALL_SCRIPT[1]}"
      MIRROR_SOURCE="Gitee"
    fi
  else
    # 手动选择模式 | Manual selection mode
    echo "${yellow}请选择镜像源 | Please select mirror source:${end}"
    echo ""
    for i in "${!MIRROR_SOURCES[@]}"; do
      echo "  $((i+1))) ${MIRROR_SOURCES[$i]}"
    done
    echo ""
    
    read -r -p "请输入选项 (1-5, 默认 1): " mirror_choice
    mirror_choice=${mirror_choice:-1}
    
    case $mirror_choice in
      1)
        OH_MY_ZSH_INSTALL="${OH_MY_ZSH_INSTALL_SCRIPT[0]}"
        MIRROR_SOURCE="GitHub"
        echo "${green}已选择 GitHub 源${end}"
        ;;
      2)
        OH_MY_ZSH_INSTALL="${OH_MY_ZSH_INSTALL_SCRIPT[1]}"
        MIRROR_SOURCE="Gitee"
        echo "${green}已选择 Gitee 源${end}"
        ;;
      3)
        OH_MY_ZSH_INSTALL="${OH_MY_ZSH_INSTALL_SCRIPT[1]}"
        MIRROR_SOURCE="Aliyun"
        echo "${green}已选择阿里云源（部分资源）${end}"
        ;;
      4)
        OH_MY_ZSH_INSTALL="${OH_MY_ZSH_INSTALL_SCRIPT[1]}"
        MIRROR_SOURCE="Tencent"
        echo "${green}已选择腾讯云源（部分资源）${end}"
        ;;
      5)
        OH_MY_ZSH_INSTALL="${OH_MY_ZSH_INSTALL_SCRIPT[1]}"
        MIRROR_SOURCE="USTC"
        echo "${green}已选择中科大源（部分资源）${end}"
        ;;
      *)
        OH_MY_ZSH_INSTALL="${OH_MY_ZSH_INSTALL_SCRIPT[0]}"
        MIRROR_SOURCE="GitHub"
        echo "${yellow}无效选项，使用默认 GitHub 源${end}"
        ;;
    esac
  fi
  
  echo ""
  echo "${green}当前镜像源 | Current mirror: ${MIRROR_SOURCE}${end}"
  echo ""
}

# 检查 root 权限 | Check root privilege
checkRoot() {
  if [ "$EUID" -ne 0 ] && ! command -v sudo &> /dev/null; then
    echo "${red}错误：需要 root 权限或 sudo 权限${end}"
    echo "${red}Error: Root or sudo privilege required${end}"
    exit 1
  fi
}

# ============================================================================
# 安装功能函数 | Installation Functions
# ============================================================================

# 更新并安装必要的实用程序 | Update and install necessary utilities
installUtils(){
  echo "${blue}检查并安装基础工具... | Checking and installing base tools...${end}"
  local utils=("curl" "wget" "git")
  
  # 根据包管理器安装 sudo（如果需要）
  if ! command -v sudo &> /dev/null; then
    echo "${yellow}安装 sudo...${end}"
    installPackage "sudo"
  fi
  
  for util in "${utils[@]}"; do
    if ! command -v "$util" &> /dev/null; then
      echo "${yellow}正在安装：${util}...${end}"
      installPackage "$util"
    else
      echo "${green}✓ ${util} 已安装 | installed${end}"
    fi
  done
  echo ""
}

# 安装 Zsh | Install Zsh
installZsh(){
  echo "${blue}检查 Zsh... | Checking Zsh...${end}"
  if ! command -v zsh &> /dev/null; then
    echo "${yellow}Zsh 未安装，正在安装... | Zsh not found, installing...${end}"
    installPackage "zsh"
    if command -v zsh &> /dev/null; then
      echo "${green}✓ Zsh 安装完成 | Zsh installation complete${end}"
    else
      echo "${red}✗ Zsh 安装失败 | Zsh installation failed${end}"
      return 1
    fi
  else
    echo "${green}✓ Zsh 已安装 | Zsh already installed${end}"
  fi
  echo ""
}

# Oh My Zsh 安装 | Oh My Zsh installation
Oh_my_zsh_install(){
  echo "${blue}检查 Oh My Zsh... | Checking Oh My Zsh...${end}"
  if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "${green}✓ Oh My Zsh 已安装，跳过 | already installed, skipping${end}"
  else
    echo "${yellow}正在安装 Oh My Zsh...${end}"
    echo "${yellow}Installing Oh My Zsh...${end}"
    installZsh
    recordZshrcState

    local installer
    installer=$(mktemp)
    if ! curl -fsSL --proto '=https' --tlsv1.2 "$OH_MY_ZSH_INSTALL" -o "$installer"; then
      rm -f -- "$installer"
      echo "${red}✗ Oh My Zsh 安装脚本下载失败${end}"
      return 1
    fi
    if ! env RUNZSH=no CHSH=no KEEP_ZSHRC=yes bash "$installer"; then
      rm -f -- "$installer"
      echo "${red}✗ Oh My Zsh 安装失败${end}"
      return 1
    fi
    rm -f -- "$installer"
    : > "$OH_MY_ZSH_MARKER"
    echo "${green}✓ Oh My Zsh 安装完成 | installation complete${end}"
  fi
  echo ""
}

# 安装 Zsh 插件 | Install Zsh plugins
Install_zsh_plugins(){
  echo "${blue}安装 Zsh 插件... | Installing Zsh plugins...${end}"
  local plugins_dir="$HOME/.oh-my-zsh/custom/plugins"
  
  for plugin in "${Zsh_plugins[@]}"; do
    local plugin_name
    plugin_name=$(basename "$plugin")
    local plugin_path="$plugins_dir/$plugin_name"
    
    if [ -d "$plugin_path" ]; then
      echo "${green}✓ 插件 $plugin_name 已存在 | already exists${end}"
    else
      echo "${yellow}安装插件：$plugin_name...${end}"
      git clone "https://github.com/$plugin.git" "$plugin_path" 2>/dev/null || \
      git clone "https://gitee.com/mirrors/$plugin_name.git" "$plugin_path" 2>/dev/null || \
      echo "${red}✗ 插件 $plugin_name 安装失败 | installation failed${end}"
    fi
  done
  
  # 更新 .zshrc 配置文件
  if [ -f "$HOME/.zshrc" ]; then
    if ! grep -q "zsh-autosuggestions" "$HOME/.zshrc"; then
      recordZshrcState
      sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/g' "$HOME/.zshrc"
      echo "${green}✓ 已更新 .zshrc 配置 | .zshrc config updated${end}"
    fi
  fi
  echo ""
}

# ============================================================================
# 卸载功能函数 | Uninstall Functions
# ============================================================================

uninstallOhMyZsh() {
  echo "${yellow}卸载 Oh My Zsh...${end}"
  echo "${yellow}Uninstalling Oh My Zsh...${end}"
  
  if [ -z "$HOME" ] || [ "$HOME" = "/" ]; then
    echo "${red}拒绝在不安全的 HOME 路径执行卸载${end}"
    return 1
  fi

  if [ -f "$OH_MY_ZSH_MARKER" ] && [ -d "$HOME/.oh-my-zsh" ]; then
    rm -rf -- "$HOME/.oh-my-zsh"
    echo "${green}✓ 已删除 .oh-my-zsh 目录${end}"
  elif [ -d "$HOME/.oh-my-zsh" ]; then
    echo "${yellow}跳过 .oh-my-zsh：没有本脚本的安装记录${end}"
  fi

  if [ -f "$ZSHRC_BACKUP" ]; then
    cp -p "$ZSHRC_BACKUP" "$HOME/.zshrc"
    echo "${green}✓ 已恢复安装前的 .zshrc${end}"
  elif [ -f "$ZSHRC_CREATED_MARKER" ] && [ -f "$HOME/.zshrc" ]; then
    rm -f -- "$HOME/.zshrc"
    echo "${green}✓ 已删除由本脚本创建的 .zshrc${end}"
  elif [ -f "$HOME/.zshrc" ]; then
    echo "${yellow}保留 .zshrc：没有本脚本的备份或创建记录${end}"
  fi

  rm -f -- "$OH_MY_ZSH_MARKER" "$ZSHRC_BACKUP" "$ZSHRC_CREATED_MARKER"
  rmdir "$STATE_DIR" 2>/dev/null || true
  echo "${green}✓ Oh My Zsh 卸载完成${end}"
  echo ""
}

uninstall() {
  echo "${red}========================================${end}"
  echo "${red}警告：即将执行卸载操作！${end}"
  echo "${red}Warning: Uninstall operation about to execute!${end}"
  echo "${red}========================================${end}"
  echo ""
  echo "此操作将删除以下内容："
  echo "This will remove:"
  echo "  - 本脚本安装的 Oh My Zsh 及其插件"
  echo "  - 恢复或移除本脚本管理的 .zshrc"
  echo "  - 脚本创建的日志文件"
  echo ""
  read -r -p "确定要继续吗？(y/N): " confirm
  
  if [[ $confirm =~ ^[Yy]$ ]]; then
    uninstallOhMyZsh
    
    if [ -d "$LOG_DIR" ]; then
      find "$LOG_DIR" -maxdepth 1 -type f -name 'init_system_log_*.log' -delete
      rmdir "$LOG_DIR" 2>/dev/null || true
      echo "${green}✓ 已清理日志文件 | log files cleaned${end}"
    fi
    
    echo ""
    echo "${green}========================================${end}"
    echo "${green}卸载完成！ | Uninstall complete!${end}"
    echo "${green}========================================${end}"
  else
    echo "${yellow}已取消卸载操作 | Uninstall cancelled${end}"
  fi
}

# ============================================================================
# 帮助信息 | Help Information
# ============================================================================

showHelp() {
  echo "用法 | Usage: ./init_system.sh [选项 | option]"
  echo ""
  echo "选项 | Options:"
  echo "  install    执行安装（自动检测镜像源） | Execute installation (auto-detect mirror)"
  echo "  uninstall  执行卸载 | Execute uninstallation"
  echo "  --manual   手动选择镜像源安装 | Manual select mirror source"
  echo "  -m         手动选择镜像源（简写）| Manual select mirror (shortcut)"
  echo "  help       显示此帮助信息 | Show this help message"
  echo ""
  echo "无参数时进入交互式安装 | Run without arguments for interactive installation"
  echo ""
  echo "镜像源 | Mirror Sources:"
  echo "  1) GitHub (默认 | Default)"
  echo "  2) Gitee (中国 | China)"
  echo "  3) Aliyun (阿里云 | Alibaba Cloud)"
  echo "  4) Tencent (腾讯云 | Tencent Cloud)"
  echo "  5) USTC (中科大 | University of Science and Technology)"
  echo ""
  echo "示例 | Examples:"
  echo "  ./init_system.sh           # 交互式安装"
  echo "  ./init_system.sh install   # 自动安装"
  echo "  ./init_system.sh --manual  # 手动选择镜像源"
  echo "  ./init_system.sh -m        # 手动选择（简写）"
  echo "  ./init_system.sh uninstall # 卸载"
  echo "  ./init_system.sh help      # 显示帮助"
}

# ============================================================================
# 主函数 | Main Function
# ============================================================================

main() {
  setupRuntime
  # 检测系统和包管理器
  detect_linux_distro
  detect_package_manager
  
  start
  showSystemInfo
  checkRoot
  
  # 处理命令行参数
  case "${1:-}" in
    install)
      echo "${green}开始安装... | Starting installation...${end}"
      checkNetwork "auto"
      installUtils
      Oh_my_zsh_install
      Install_zsh_plugins
      echo "${green}========================================${end}"
      echo "${green}安装完成！ | Installation complete!${end}"
      echo "${green}========================================${end}"
      ;;
    uninstall)
      uninstall
      ;;
    help|--help|-h)
      showHelp
      ;;
    --manual|-m)
      # 手动选择镜像源
      checkNetwork "manual"
      installUtils
      Oh_my_zsh_install
      Install_zsh_plugins
      echo "${green}========================================${end}"
      echo "${green}安装完成！ | Installation complete!${end}"
      echo "${green}========================================${end}"
      ;;
    "")
      # 交互式安装
      echo "${yellow}请选择操作 | Select operation:${end}"
      echo "  1) 安装 | Install"
      echo "  2) 卸载 | Uninstall"
      echo "  3) 退出 | Exit"
      echo ""
      read -r -p "请输入选项 (1-3): " choice
      
      case $choice in
        1)
          checkNetwork "manual"
          installUtils
          Oh_my_zsh_install
          Install_zsh_plugins
          echo "${green}========================================${end}"
          echo "${green}安装完成！ | Installation complete!${end}"
          echo "${green}========================================${end}"
          ;;
        2)
          uninstall
          ;;
        3)
          echo "${yellow}已退出 | Exited${end}"
          exit 0
          ;;
        *)
          echo "${red}无效选项 | Invalid option${end}"
          exit 1
          ;;
      esac
      ;;
    *)
      echo "${red}未知选项：$1${end}"
      echo "${red}Unknown option: $1${end}"
      showHelp
      exit 1
      ;;
  esac
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  main "$@"
fi
