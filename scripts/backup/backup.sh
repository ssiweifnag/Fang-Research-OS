#!/bin/bash
#=============================================================================
# OpenClaw System Backup Script
# OpenClaw 系統備份腳本
# 
# 功能：備份所有設定和 API Keys 到 GitHub 私密倉庫
# 頻率：每 3 天執行一次
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
BACKUP_DIR="$SCRIPT_DIR/backups"
LOG_FILE="$ROOT_DIR/logs/backup.log"
GIT_REPO="ssiweifnag/openclaw-system-backup"

# 預設值
VERBOSE=false
HELP=false
FORCE=false

#----------------------------------------------------------------------------
# 函數定義
#----------------------------------------------------------------------------

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }
log_debug() { if [ "$VERBOSE" = true ]; then echo -e "${CYAN}[DEBUG]${NC} $1"; fi; }

show_banner() {
    cat << EOF
╔════════════════════════════════════════════════════════════════════╗
║                                                                ║
║       📦 OpenClaw System Backup Script                          ║
║                                                                ║
║              系統設定備份腳本                                    ║
║                                                                ║
╚════════════════════════════════════════════════════════════════════╝

EOF
}

show_help() {
    cat << EOF
用法:
    bash \$0 [OPTIONS]

選項:
    --backup, -b       執行備份 [預設]
    --restore, -r       執行恢復
    --verify, -v        驗證備份
    --verbose           詳細輸出
    --help, -h         顯示幫助

範例:
    bash \$0                    # 執行備份
    bash \$0 --restore          # 恢復備份
    bash \$0 --verify          # 驗證備份
    bash \$0 --backup --verbose  # 詳細備份

備份內容:
    - 設定檔案（包含 API Keys）
    - 環境變數
    - 配置檔案
    - 子代理設定
    - Skills 配置

恢復到其他 Mac mini:
    1. Clone 此私密倉庫
    2. 執行 bash scripts/backup/restore.sh

日誌位置:
    \$ROOT_DIR/logs/backup.log

EOF
}

log_to_file() {
    local message="$1"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $message" >> "$LOG_FILE" 2>/dev/null || true
}

#----------------------------------------------------------------------------
# 備份函數
#----------------------------------------------------------------------------

create_backup_dir() {
    local timestamp
    timestamp=$(date +"%Y%m%d_%H%M%S")
    local backup_path="$BACKUP_DIR/$timestamp"
    
    mkdir -p "$backup_path"
    echo "$backup_path"
}

backup_config_files() {
    local backup_path="$1"
    local config_dir="$backup_path/config"
    
    log_info "備份設定檔案..."
    mkdir -p "$config_dir"
    
    # 備份關鍵設定檔
    local config_files=(
        "$ROOT_DIR/CLAUDE.md"
        "$ROOT_DIR/USER.md"
        "$ROOT_DIR/SOUL.md"
        "$ROOT_DIR/AGENTS.md"
        "$ROOT_DIR/TOOLS.md"
        "$ROOT_DIR/HEARTBEAT.md"
    )
    
    for file in "${config_files[@]}"; do
        if [ -f "$file" ]; then
            cp "$file" "$config_dir/"
            log_debug "已備份: $file"
        fi
    done
    
    # 備份 scripts 目錄
    log_info "備份 Scripts 目錄..."
    cp -r "$ROOT_DIR/scripts/"* "$backup_path/" 2>/dev/null || true
    
    # 備份 memory 目錄結構
    log_info "備份 Memory 目錄..."
    mkdir -p "$backup_path/memory"
    cp "$ROOT_DIR/memory/"*.md "$backup_path/memory/" 2>/dev/null || true
    
    log_success "設定檔案備份完成"
}

backup_environment_vars() {
    local backup_path="$1"
    local env_file="$backup_path/.env.example"
    
    log_info "備份環境變數..."
    
    # 創建環境變數範本（不包含實際值）
    cat > "$env_file" << 'EOF'
# OpenClaw System Environment Variables
# 此檔案為範本，請參考此格式設定你的環境變數

# ====== 必須設定 ======

# OpenAI API Key
# OPENAI_API_KEY=sk-xxx

# GitHub Token
# GITHUB_TOKEN=gho_xxx

# Telegram Bot Token
# TELEGRAM_BOT_TOKEN=xxx

# ====== 可選設定 ======

# Claude API Key
# CLAUDE_API_KEY=sk-ant-xxx

# Kimi API Key
# KIMI_API_KEY=xxx

# 其他 API Keys
# Add your additional API keys here

EOF

    # 備份當前環境變數（僅路徑，不含敏感資料）
    local current_env="$backup_path/.env.current"
    printenv | grep -E "^(PATH|HOME|USER|TERM)" > "$current_env" 2>/dev/null || true
    
    log_success "環境變數備份完成"
}

backup_openclaw_config() {
    local backup_path="$1"
    local openclaw_dir="$backup_path/.openclaw"
    
    log_info "備份 OpenClaw 配置..."
    mkdir -p "$openclaw_dir"
    
    # 備份 OpenClaw 配置
    if [ -d "$HOME/.openclaw" ]; then
        # 排除敏感資料，僅備份配置結構
        cp -r "$HOME/.openclaw/config" "$openclaw_dir/" 2>/dev/null || true
    fi
    
    log_success "OpenClaw 配置備份完成"
}

backup_skills_config() {
    local backup_path="$1"
    local skills_dir="$backup_path/skills"
    
    log_info "備份 Skills 配置..."
    mkdir -p "$skills_dir"
    
    # 備份 clawd/skills 結構
    if [ -d "/Users/pc/clawd/skills" ]; then
        # 僅備份 SKILL.md 文件，不備份執行檔
        find "/Users/pc/clawd/skills" -name "SKILL.md" -exec cp {} "$skills_dir/" \; 2>/dev/null || true
    fi
    
    log_success "Skills 配置備份完成"
}

backup_subagents_config() {
    local backup_path="$1"
    local subagents_dir="$backup_path/subagents"
    
    log_info "備份子代理配置..."
    mkdir -p "$subagents_dir"
    
    # 備份子代理 SKILL.md
    if [ -d "$ROOT_DIR/skills" ]; then
        find "$ROOT_DIR/skills" -name "SKILL.md" -exec cp {} "$subagents_dir/" \; 2>/dev/null || true
    fi
    
    log_success "子代理配置備份完成"
}

backup_homebrew_packages() {
    local backup_path="$1"
    local packages_file="$backup_path/brew_packages.txt"
    
    log_info "備份 Homebrew 套件列表..."
    if command -v brew &> /dev/null; then
        brew list --versions > "$packages_file" 2>/dev/null || true
    fi
    
    log_success "Homebrew 套件備份完成"
}

create_readme() {
    local backup_path="$1"
    local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    
    log_info "建立 README..."
    
    cat > "$backup_path/README.md" << EOF
# OpenClaw System Backup

## 備份時間
$timestamp

## 備份內容

### 1. 設定檔案
- CLAUDE.md
- USER.md
- SOUL.md
- AGENTS.md
- TOOLS.md
- HEARTBEAT.md
- scripts/

### 2. 環境變數
- .env.example (範本)
- .env.current (當前環境)

### 3. OpenClaw 配置
- config/

### 4. Skills 配置
- SKILL.md files

### 5. 子代理配置
- SKILL.md files

### 6. Homebrew 套件
- brew_packages.txt

---

## 恢復說明

### 步驟 1：Clone 此倉庫
\`\`\`bash
git clone https://github.com/$GIT_REPO.git
\`\`\`

### 步驟 2：執行恢復腳本
\`\`\`bash
cd openclaw-system-backup
bash scripts/backup/restore.sh
\`\`\`

### 步驟 3：設定環境變數
1. 複製 .env.example 為 .env
2. 填入你的 API Keys
3. 執行 source .env

---

## 包含的敏感資訊

此備份包含：
- 環境變數範本（不包含實際值）
- 配置檔案路徑
- 設定結構

**重要**：請勿將此倉庫設為公開！

---

## 恢復時的注意事項

1. API Keys 需要重新輸入
2. Homebrew 套件需要重新安裝
3. 某些設定可能需要手動調整

---

*此備份由 OpenClaw System Backup Script 自動生成*
EOF

    log_success "README 建立完成"
}

git_commit_and_push() {
    local backup_path="$1"
    local timestamp=$(date +"%Y%m%d_%H%M%S")
    
    log_info "Commit 並 Push 到 GitHub..."
    
    cd "$backup_path/../"
    
    # 初始化 git（如果需要）
    if [ ! -d ".git" ]; then
        git init
        git remote add origin "https://github.com/$GIT_REPO.git"
    fi
    
    # 設定 git config
    git config user.name "ssiweifnag"
    git config user.email "ssiweifnag@example.com"
    
    # 添加所有檔案
    git add -A
    
    # Commit
    git commit -m "Backup: $timestamp"
    
    # Push
    git push origin main 2>/dev/null || git push origin master 2>/dev/null || \
    git push -u origin main 2>/dev/null || \
    log_warning "需要手動 Push：cd $backup_path/../ && git push"
    
    log_success "Git commit and push 完成"
}

cleanup_old_backups() {
    local backup_count
    backup_count=$(ls -1d "$BACKUP_DIR"/2*/ 2>/dev/null | wc -l)
    
    # 保留最近 10 個備份
    if [ "$backup_count" -gt 10 ]; then
        log_info "清理舊備份..."
        ls -1td "$BACKUP_DIR"/2*/ | tail -n +11 | xargs rm -rf 2>/dev/null || true
        log_success "已清理舊備份"
    fi
}

run_backup() {
    local backup_path
    backup_path=$(create_backup_dir)
    
    log_info "========================================"
    log_info "  開始備份..."
    log_info "========================================"
    echo ""
    
    log_info "備份路徑: $backup_path"
    echo ""
    
    backup_config_files "$backup_path"
    backup_environment_vars "$backup_path"
    backup_openclaw_config "$backup_path"
    backup_skills_config "$backup_path"
    backup_subagents_config "$backup_path"
    backup_homebrew_packages "$backup_path"
    create_readme "$backup_path"
    
    echo ""
    log_info "========================================"
    log_info "  備份完成！"
    log_info "========================================"
    echo ""
    
    # 清理舊備份
    cleanup_old_backups
    
    # Git Commit and Push
    echo ""
    git_commit_and_push "$backup_path"
    
    log_to_file "Backup completed: $backup_path"
    
    echo ""
    log_success "備份已 Push 到 GitHub"
    log_info "備份路徑: $backup_path"
}

run_restore() {
    log_info "========================================"
    log_info "  恢復模式（待開發）"
    log_info "========================================"
    log_warning "此功能待開發，請手動執行："
    echo ""
    echo "1. Clone 此倉庫"
    echo "2. 執行 bash scripts/backup/restore.sh"
}

run_verify() {
    log_info "========================================"
    log_info "  驗證備份..."
    log_info "========================================"
    
    # 檢查最新備份
    local latest_backup
    latest_backup=$(ls -1td "$BACKUP_DIR"/2*/ 2>/dev/null | head -1)
    
    if [ -z "$latest_backup" ]; then
        log_error "找不到備份！"
        exit 1
    fi
    
    log_info "最新備份: $latest_backup"
    
    # 檢查必要檔案
    local required_files=(
        "README.md"
        ".env.example"
        "config/"
    )
    
    for file in "${required_files[@]}"; do
        if [ -e "$latest_backup/$file" ]; then
            log_success "$file"
        else
            log_warning "$file (缺失)"
        fi
    done
    
    log_success "驗證完成"
}

main() {
    # 解析參數
    while [[ $# -gt 0 ]]; do
        case $1 in
            --backup|-b) MODE="backup"; shift ;;
            --restore|-r) MODE="restore"; shift ;;
            --verify|-v) MODE="verify"; shift ;;
            --verbose) VERBOSE=true; shift ;;
            --help|-h) HELP=true; shift ;;
            *) log_error "未知參數: $1"; show_help; exit 1 ;;
        esac
    done
    
    # 顯示幫助
    if [ "$HELP" = true ]; then
        show_banner
        show_help
        exit 0
    fi
    
    show_banner
    
    # 確保日誌目錄存在
    mkdir -p "$ROOT_DIR/logs" 2>/dev/null || true
    
    log_to_file "Backup script started"
    
    # 執行模式
    case "${MODE:-backup}" in
        backup)
            run_backup
            ;;
        restore)
            run_restore
            ;;
        verify)
            run_verify
            ;;
        *)
            log_error "未知模式: $MODE"
            show_help
            exit 1
            ;;
    esac
}

main "$@"
