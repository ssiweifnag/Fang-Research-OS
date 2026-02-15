#!/bin/bash
#=============================================================================
# OpenClaw System Restore Script
# OpenClaw 系統恢復腳本
# 
# 用法:
#   bash scripts/backup/restore.sh
#=============================================================================

set -euo pipefail

# 顏色定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# 配置
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$SCRIPT_DIR"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

show_banner() {
    cat << EOF
╔════════════════════════════════════════════════════════════════════╗
║                                                                ║
║       📦 OpenClaw System Restore Script                         ║
║                                                                ║
║                    系統恢復腳本                                    ║
║                                                                ║
╚════════════════════════════════════════════════════════════════════╝

EOF
}

show_help() {
    cat << EOF
用法:
    bash \$0

說明:
    此腳本會從備份恢復 OpenClaw 系統設定。

步驟:
    1. 選擇要恢復的備份
    2. 恢復設定檔案
    3. 設定環境變數
    4. 安裝 Homebrew 套件

重要:
    - API Keys 需要手動輸入
    - 某些設定可能需要調整

EOF
}

select_backup() {
    log_info "選擇備份..."
    
    local backups=($(ls -1td "$BACKUP_DIR"/2*/ 2>/dev/null))
    
    if [ ${#backups[@]} -eq 0 ]; then
        log_error "找不到備份！"
        exit 1
    fi
    
    echo ""
    echo "可用備份："
    echo ""
    
    local i=1
    for backup in "${backups[@]}"; do
        local name=$(basename "$backup")
        echo "$i. $name"
        ((i++))
    done
    
    echo ""
    read -p "選擇備份 [1-${#backups[@]}]: " choice
    
    if [ "$choice" -ge 1 ] && [ "$choice" -le ${#backups[@]} ]; then
        BACKUP_PATH="${backups[$((choice-1))]}"
        log_info "選擇備份: $BACKUP_PATH"
    else
        log_error "無效選擇！"
        exit 1
    fi
}

restore_config_files() {
    log_info "恢復設定檔案..."
    
    local config_dir="$BACKUP_PATH/config"
    
    if [ -d "$config_dir" ]; then
        for file in "$config_dir"/*; do
            if [ -f "$file" ]; then
                local filename=$(basename "$file")
                cp "$file" "$ROOT_DIR/$filename"
                log_success "已恢復: $filename"
            fi
        done
    fi
    
    # 恢復 scripts
    if [ -d "$BACKUP_PATH/scripts" ]; then
        cp -r "$BACKUP_PATH/scripts/"* "$ROOT_DIR/scripts/" 2>/dev/null || true
        log_success "已恢復 scripts"
    fi
    
    log_success "設定檔案恢復完成"
}

restore_environment_vars() {
    log_info "設定環境變數..."
    
    local env_example="$BACKUP_PATH/.env.example"
    
    if [ -f "$env_example" ]; then
        cp "$env_example" "$ROOT_DIR/.env"
        log_success "已創建 .env 範本"
        echo ""
        log_warning "請編輯 .env 檔案並填入你的 API Keys！"
        echo ""
    fi
    
    log_success "環境變數設定完成"
}

install_homebrew_packages() {
    log_info "安裝 Homebrew 套件..."
    
    local packages_file="$BACKUP_PATH/brew_packages.txt"
    
    if [ -f "$packages_file" ] && command -v brew &> /dev/null; then
        log_info "閱讀套件列表..."
        # 僅顯示，不自動安裝（因為可能需要時間）
        head -20 "$packages_file"
        log_warning "請手動執行 brew install 來安裝套件"
    fi
    
    log_success "Homebrew 套件檢查完成"
}

show_summary() {
    echo ""
    echo "========================================"
    log_success "  恢復完成！"
    echo "========================================"
    echo ""
    echo "下一步："
    echo ""
    echo "1. 編輯 .env 檔案，填入 API Keys"
    echo "   vi $ROOT_DIR/.env"
    echo ""
    echo "2. 安裝 Homebrew 套件（如需要）"
    echo ""
    echo "3. 啟動 OpenClaw"
    echo "   openclaw start"
    echo ""
    echo "========================================"
}

main() {
    show_banner
    
    select_backup
    restore_config_files
    restore_environment_vars
    install_homebrew_packages
    show_summary
}

main "$@"
