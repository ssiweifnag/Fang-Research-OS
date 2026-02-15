#!/bin/bash
#=============================================================================
# Fang Research OS v1.0 - Initialization Script
# 初始化腳本
# 
# 用法:
#   bash scripts/init.sh [--full]
#=============================================================================

set -euo pipefail

# 顏色定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# 配置
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

# 預設值
FULL=false
HELP=false

#----------------------------------------------------------------------------
# 函數
#----------------------------------------------------------------------------

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

show_banner() {
    cat << EOF
╔════════════════════════════════════════════════════════════════════╗
║                                                                    ║
║         🧠 Fang Research OS v1.0 - 初始化腳本                      ║
║                                                                    ║
║     博士級 × 期刊級 × OpenClaw 可執行 × SCI Agent 自動化            ║
║                                                                    ║
╚════════════════════════════════════════════════════════════════════╝

EOF
}

show_help() {
    cat << EOF
用法:
    bash $0 [OPTIONS]

選項:
    --full, -f     完整初始化 (包含可選配置)
    --help, -h     顯示幫助

示例:
    bash $0              # 快速初始化
    bash $0 --full       # 完整初始化

EOF
}

check_directory() {
    if [ ! -d "$ROOT_DIR" ]; then
        log_error "根目錄不存在: $ROOT_DIR"
        exit 1
    fi
}

check_dependencies() {
    log_info "檢查系統依賴..."
    
    # 檢查 Python
    if command -v python3 &> /dev/null; then
        PYTHON_VERSION=$(python3 --version 2>&1)
        log_success "Python: $PYTHON_VERSION"
    else
        log_warning "Python 3 未安裝 (可選)"
    fi
    
    # 檢查 Git
    if command -v git &> /dev/null; then
        GIT_VERSION=$(git --version | head -1)
        log_success "Git: $GIT_VERSION"
    else
        log_warning "Git 未安裝 (可選)"
    fi
    
    # 檢查 Claude/OpenAI CLI (可選)
    if command -v claude &> /dev/null; then
        log_success "Claude CLI: 已安裝"
    else
        log_info "Claude CLI: 未安裝 (可選)"
    fi
    
    log_success "依賴檢查完成"
}

check_structure() {
    log_info "檢查目錄結構..."
    
    local required_dirs=(
        "f-ros/phd_deep_mode"
        "f-ros/reviewer_killer"
        "f-ros/sci_agent"
        "config"
        "scripts"
        "tests"
        "outputs"
    )
    
    local all_ok=true
    
    for dir in "${required_dirs[@]}"; do
        if [ -d "$ROOT_DIR/$dir" ]; then
            log_success "$dir"
        else
            log_warning "$dir (不存在)"
            all_ok=false
        fi
    done
    
    if [ "$all_ok" = false ]; then
        log_warning "部分目錄不存在，將自動創建"
        mkdir -p "${required_dirs[@]}" 2>/dev/null || true
    fi
}

check_files() {
    log_info "檢查必要檔案..."
    
    local required_files=(
        "README.md"
        "config/f-ros.yaml"
        "f-ros/phd_deep_mode/prompt.md"
        "f-ros/reviewer_killer/prompt.md"
        "f-ros/sci_agent/prompt.md"
    )
    
    local all_ok=true
    
    for file in "${required_files[@]}"; do
        if [ -f "$ROOT_DIR/$file" ]; then
            log_success "$file"
        else
            log_warning "$file (不存在)"
            all_ok=false
        fi
    done
    
    if [ "$all_ok" = false ]; then
        log_error "必要檔案缺失，請確認 Repo 已完整 clone"
        exit 1
    fi
}

set_permissions() {
    log_info "設定腳本執行權限..."
    
    local scripts=(
        "$ROOT_DIR/scripts/init.sh"
        "$ROOT_DIR/scripts/phd_deep_analysis.sh"
        "$ROOT_DIR/scripts/reviewer_killer.sh"
        "$ROOT_DIR/scripts/sci_agent.sh"
    )
    
    for script in "${scripts[@]}"; do
        if [ -f "$script" ]; then
            chmod +x "$script"
            log_success "$(basename "$script")"
        fi
    done
}

setup_config() {
    log_info "設定配置文件..."
    
    local config_file="$ROOT_DIR/config/f-ros.yaml"
    local example_file="$ROOT_DIR/config/f-ros.yaml.example"
    
    if [ -f "$config_file" ]; then
        if [ ! -f "$example_file" ]; then
            cp "$config_file" "$example_file"
            log_success "配置範例已創建"
        fi
    else
        log_warning "配置文件不存在: $config_file"
    fi
}

setup_outputs() {
    log_info "建立輸出目錄..."
    
    local output_dir="$ROOT_DIR/outputs"
    local logs_dir="$ROOT_DIR/logs"
    
    mkdir -p "$output_dir" 2>/dev/null || true
    mkdir -p "$logs_dir" 2>/dev/null || true
    
    log_success "輸出目錄: $output_dir"
    log_success "日誌目錄: $logs_dir"
}

init_git() {
    log_info "檢查 Git 狀態..."
    
    if [ -d "$ROOT_DIR/.git" ]; then
        log_success "Git 已初始化"
        
        # 檢查遠端
        if git remote get-url origin &>/dev/null; then
            local remote_url
            remote_url=$(git remote get-url origin)
            log_success "遠端: $remote_url"
        else
            log_warning "無遠端倉庫，請手動設置"
            log_info "  git remote add origin <URL>"
        fi
    else
        log_warning "Git 未初始化"
        log_info "  cd $ROOT_DIR && git init"
    fi
}

show_summary() {
    echo ""
    echo "========================================"
    log_success "  Fang Research OS v1.0 初始化完成！"
    echo "========================================"
    echo ""
    echo "下一步:"
    echo ""
    echo "  1. 編輯配置文件:"
    echo "     vi $ROOT_DIR/config/f-ros.yaml"
    echo ""
    echo "  2. 執行分析:"
    echo "     bash $ROOT_DIR/scripts/phd_deep_analysis.sh --help"
    echo "     bash $ROOT_DIR/scripts/reviewer_killer.sh --help"
    echo "     bash $ROOT_DIR/scripts/sci_agent.sh --help"
    echo ""
    echo "  3. 查看文檔:"
    echo "     cat $ROOT_DIR/README.md"
    echo ""
    echo "========================================"
    echo ""
    log_info "GitHub: https://github.com/ssiweifnag/Fang-Research-OS"
    echo ""
}

main() {
    # 解析參數
    while [[ $# -gt 0 ]]; do
        case $1 in
            --full|-f) FULL=true; shift ;;
            --help|-h) show_help; exit 0 ;;
            *) log_error "未知參數: $1"; show_help; exit 1 ;;
        esac
    done
    
    show_banner
    
    check_directory
    check_dependencies
    check_structure
    check_files
    
    if [ "$FULL" = true ]; then
        log_info "執行完整初始化..."
        set_permissions
        setup_config
        setup_outputs
        init_git
    else
        log_info "執行快速初始化..."
        set_permissions
        setup_outputs
    fi
    
    show_summary
}

main "$@"
