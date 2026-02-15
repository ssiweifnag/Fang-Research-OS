#!/bin/bash
#=============================================================================
# Fang Research OS - Skill Automation Runner
# 技能自動化執行腳本
# 
# 用法:
#   bash scripts/automation-runner.sh [--mode all|watcher|search|trigger|analysis] [--verbose]
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
CONFIG_FILE="$SCRIPT_DIR/skill-automation.yaml"
LOG_FILE="$ROOT_DIR/logs/automation.log"

# 預設值
MODE="all"
VERBOSE=false
HELP=false

#----------------------------------------------------------------------------
# 函數
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
║       🧠 Fang Research OS - Skill Automation Runner             ║
║                                                                ║
║                    技能自動化執行腳本                            ║
║                                                                ║
╚════════════════════════════════════════════════════════════════════╝

EOF
}

show_help() {
    cat << EOF
用法:
    bash $0 [OPTIONS]

選項:
    --mode, -m <MODE>     執行模式 (all|watcher|search|trigger|analysis)
    --verbose, -v          詳細輸出
    --help, -h             顯示幫助

模式說明:
    all       - 執行所有自動化 [預設]
    watcher   - 執行監控類自動化
    search    - 執行搜尋類自動化
    trigger   - 執行觸發類自動化
    analysis  - 執行分析類自動化

示例:
    bash $0                    # 執行所有自動化
    bash $0 --mode watcher    # 只執行監控
    bash $0 --mode search     # 只執行搜尋
    bash $0 --verbose          # 詳細輸出

自動化腳本位置:
    \$ROOT_DIR/scripts/

日誌位置:
    \$ROOT_DIR/logs/automation.log

EOF
}

check_dependencies() {
    log_info "檢查依賴..."
    
    # 檢查 Python
    if ! command -v python3 &> /dev/null; then
        log_warning "Python 3 未安裝"
    else
        log_success "Python 3 已安裝"
    fi
    
    # 檢查配置文件
    if [ ! -f "$CONFIG_FILE" ]; then
        log_error "配置文件不存在: $CONFIG_FILE"
        exit 1
    fi
    
    log_success "依賴檢查完成"
}

create_output_dirs() {
    log_info "創建輸出目錄..."
    
    local dirs=(
        "$ROOT_DIR/outputs/arxiv_watcher"
        "$ROOT_DIR/outputs/stock_watcher"
        "$ROOT_DIR/outputs/topic_monitor"
        "$ROOT_DIR/outputs/research_tracker"
        "$ROOT_DIR/outputs/web_scraper"
        "$ROOT_DIR/outputs/daily_brief"
        "$ROOT_DIR/outputs/weekly_summary"
        "$ROOT_DIR/outputs/monthly_report"
    )
    
    for dir in "${dirs[@]}"; do
        mkdir -p "$dir" 2>/dev/null || true
    done
    
    log_success "輸出目錄就緒"
}

run_watcher_automation() {
    log_info "執行監控類自動化..."
    
    # ArXiv 監控
    log_info "  📄 ArXiv 論文監控..."
    if command -v arxiv-watcher &> /dev/null; then
        arxiv-watcher --topics "mmWave,IAQ,carbon" --output "$ROOT_DIR/outputs/arxiv_watcher" 2>/dev/null || \
        log_warning "  arxiv-watcher 未配置"
    else
        log_warning "  arxiv-watcher 未安裝"
    fi
    
    # 股票監控
    log_info "  📈 股票監控..."
    if command -v stock-watcher &> /dev/null; then
        stock-watcher --tickers "2330,2379" --output "$ROOT_DIR/outputs/stock_watcher" 2>/dev/null || \
        log_warning "  stock-watcher 未配置"
    else
        log_warning "  stock-watcher 未安裝"
    fi
    
    # 主題監控
    log_info "  🔍 主題監控..."
    if command -v topic-monitor &> /dev/null; then
        topic-monitor --keywords "IAQ,mmWave,Carbon" --output "$ROOT_DIR/outputs/topic_monitor" 2>/dev/null || \
        log_warning "  topic-monitor 未配置"
    else
        log_warning "  topic-monitor 未安裝"
    fi
    
    log_success "監控類自動化完成"
}

run_search_automation() {
    log_info "執行搜尋類自動化..."
    
    # 研究論文搜尋
    log_info "  📚 研究論文搜尋..."
    if command -v research-tracker &> /dev/null; then
        research-tracker --keywords "mmWave,IAQ,building" --output "$ROOT_DIR/outputs/research_papers" 2>/dev/null || \
        log_warning "  research-tracker 未配置"
    else
        log_warning "  research-tracker 未安裝"
    fi
    
    # 網頁爬蟲
    log_info "  🕷️ 網頁爬蟲..."
    if command -v web-scraper &> /dev/null; then
        python3 "$ROOT_DIR/scripts/web-scraper.py" scrape 2>/dev/null || \
        log_warning "  web-scraper 未配置"
    else
        log_warning "  web-scraper 未安裝"
    fi
    
    log_success "搜尋類自動化完成"
}

run_trigger_automation() {
    log_info "執行觸發類自動化..."
    
    log_info "  🔗 檢查觸發條件..."
    
    # 檢查是否有新論文
    if [ -n "$(ls -A "$ROOT_DIR/outputs/arxiv_watcher" 2>/dev/null)" ]; then
        log_info "  📄 發現新論文，觸發研究追蹤..."
        # 這裡可以串接 research-tracker
    fi
    
    # 檢查是否有股市變動
    if [ -n "$(ls -A "$ROOT_DIR/outputs/stock_watcher" 2>/dev/null)" ]; then
        log_info "  📈 監控股市變動..."
    fi
    
    log_success "觸發類自動化完成"
}

run_analysis_automation() {
    log_info "執行分析類自動化..."
    
    # 每日簡報
    log_info "  📊 生成每日研究簡報..."
    local timestamp
    timestamp=$(date +"%Y%m%d_%H%M%S")
    
    cat > "$ROOT_DIR/outputs/daily_brief/daily_brief_$timestamp.md" << EOF
# 每日研究簡報

## 生成時間
$(date "+%Y-%m-%d %H:%M:%S")

## 監控摘要

### ArXiv 論文
$(ls "$ROOT_DIR/outputs/arxiv_watcher" 2>/dev/null | wc -l) 篇新論文

### 股票監控
$(ls "$ROOT_DIR/outputs/stock_watcher" 2>/dev/null | wc -l) 條更新

### 主題監控
$(ls "$ROOT_DIR/outputs/topic_monitor" 2>/dev/null | wc -l) 條新內容

## 下一步行動
- [ ] 檢查 ArXiv 新論文
- [ ] 審視股市變動
- [ ] 更新研究筆記

---
*Generated by Fang Research OS v1.0*
EOF

    log_success "分析類自動化完成"
}

run_all_automation() {
    log_info "執行所有自動化..."
    
    run_watcher_automation
    run_search_automation
    run_trigger_automation
    run_analysis_automation
    
    log_success "所有自動化完成！"
}

log_to_file() {
    local message="$1"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $message" >> "$LOG_FILE" 2>/dev/null || true
}

main() {
    # 解析參數
    while [[ $# -gt 0 ]]; do
        case $1 in
            --mode|-m) MODE="$2"; shift 2 ;;
            --verbose|-v) VERBOSE=true; shift ;;
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
    echo ""
    log_info "========================================"
    log_info "  執行模式: $MODE"
    log_info "========================================"
    echo ""
    
    # 執行
    check_dependencies
    create_output_dirs
    
    log_to_file "開始執行自動化 (模式: $MODE)"
    
    case "$MODE" in
        all)
            run_all_automation
            ;;
        watcher)
            run_watcher_automation
            ;;
        search)
            run_search_automation
            ;;
        trigger)
            run_trigger_automation
            ;;
        analysis)
            run_analysis_automation
            ;;
        *)
            log_error "未知模式: $MODE"
            show_help
            exit 1
            ;;
    esac
    
    log_to_file "自動化執行完成"
    
    echo ""
    log_success "========================================"
    log_success "  技能自動化執行完成！"
    log_success "========================================"
    echo ""
    log_info "日誌位置: $LOG_FILE"
    log_info "輸出位置: $ROOT_DIR/outputs/"
    echo ""
}

main "$@"
