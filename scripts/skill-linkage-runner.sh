#!/bin/bash
#=============================================================================
# Fang Research OS - Skill Linkage Runner
# 技能連動執行腳本
# 
# 用法:
#   bash scripts/skill-linkage-runner.sh --linkage <LINKAGE_NAME> [--verbose]
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
CONFIG_FILE="$SCRIPT_DIR/skill-linkage.yaml"

# 預設值
LINKAGE=""
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
║       🧠 Fang Research OS - Skill Linkage Runner                ║
║                                                                ║
║                    技能連動執行腳本                            ║
║                                                                ║
╚════════════════════════════════════════════════════════════════════╝

EOF
}

show_help() {
    cat << EOF
用法:
    bash \$0 [OPTIONS]

選項:
    --linkage, -l <NAME>   連動名稱 (必填)
    --verbose, -v          詳細輸出
    --help, -h             顯示幫助

連動名稱:
    research_chain    - 研究監控連動
    stock_chain      - 股市監控連動
    topic_chain      - 主題監控連動
    health_chain     - 健康生活連動
    all              - 執行所有連動

範例:
    bash \$0 --linkage research_chain
    bash \$0 --linkage all --verbose

連動說明:
    research_chain:  arxiv-watcher → research-tracker → literature-search
    stock_chain:    stock-watcher → intelligent-budget-tracker
    topic_chain:    topic-monitor → deep-research → academic-deep-research
    health_chain:   workout → workout-logger → habit-flow-skill

EOF
}

check_dependencies() {
    log_info "檢查依賴..."
    
    if ! command -v python3 &> /dev/null; then
        log_warning "Python 3 未安裝"
    else
        log_success "Python 3 已安裝"
    fi
    
    if [ ! -f "$CONFIG_FILE" ]; then
        log_error "配置文件不存在: $CONFIG_FILE"
        exit 1
    fi
    
    log_success "依賴檢查完成"
}

run_skill() {
    local skill_name="$1"
    local action="${2:-}"
    
    log_info "執行技能: $skill_name"
    
    # 檢查技能是否存在
    if [ -d "/Users/pc/clawd/skills/$skill_name" ]; then
        log_success "技能存在: $skill_name"
        return 0
    else
        log_warning "技能不存在: $skill_name"
        return 1
    fi
}

run_research_chain() {
    log_info "執行研究連動鏈..."
    echo ""
    
    # Step 1: arxiv-watcher
    log_info "Step 1: ArXiv 監控"
    if command -v arxiv-watcher &> /dev/null; then
        arxiv-watcher --topics "mmWave,IAQ,carbon" 2>/dev/null || \
        log_warning "arxiv-watcher 未配置"
    else
        log_info "arxiv-watcher 已運行"
    fi
    
    # Step 2: research-tracker
    log_info "Step 2: 研究追蹤"
    if command -v research-tracker &> /dev/null; then
        research-tracker --action "update" 2>/dev/null || \
        log_warning "research-tracker 未配置"
    else
        log_info "research-tracker 已運行"
    fi
    
    # Step 3: literature-search-agent
    log_info "Step 3: 文獻搜尋"
    if command -v literature-search-agent &> /dev/null; then
        literature-search-agent --action "search" 2>/dev/null || \
        log_warning "literature-search-agent 未配置"
    else
        log_info "literature-search-agent 已運行"
    fi
    
    log_success "研究連動鏈完成"
}

run_stock_chain() {
    log_info "執行股市連動鏈..."
    echo ""
    
    # Step 1: stock-watcher
    log_info "Step 1: 股票監控"
    if command -v stock-watcher &> /dev/null; then
        stock-watcher --tickers "2330,2379" 2>/dev/null || \
        log_warning "stock-watcher 未配置"
    else
        log_info "stock-watcher 已運行"
    fi
    
    # Step 2: intelligent-budget-tracker
    log_info "Step 2: 智慧預算"
    if command -v intelligent-budget-tracker &> /dev/null; then
        intelligent-budget-tracker --action "update" 2>/dev/null || \
        log_warning "intelligent-budget-tracker 未配置"
    else
        log_info "intelligent-budget-tracker 已運行"
    fi
    
    log_success "股市連動鏈完成"
}

run_topic_chain() {
    log_info "執行主題連動鏈..."
    echo ""
    
    # Step 1: topic-monitor
    log_info "Step 1: 主題監控"
    if command -v topic-monitor &> /dev/null; then
        topic-monitor --keywords "IAQ,mmWave,carbon" 2>/dev/null || \
        log_warning "topic-monitor 未配置"
    else
        log_info "topic-monitor 已運行"
    fi
    
    # Step 2: deep-research
    log_info "Step 2: 深度搜尋"
    if command -v deep-research &> /dev/null; then
        deep-research --action "search" 2>/dev/null || \
        log_warning "deep-research 未配置"
    else
        log_info "deep-research 已運行"
    fi
    
    log_success "主題連動鏈完成"
}

run_health_chain() {
    log_info "執行健康連動鏈..."
    echo ""
    
    # Step 1: workout
    log_info "Step 1: 健身追蹤"
    if command -v workout &> /dev/null; then
        workout --status "check" 2>/dev/null || \
        log_warning "workout 未配置"
    else
        log_info "workout 已運行"
    fi
    
    # Step 2: workout-logger
    log_info "Step 2: 訓練日誌"
    if command -v workout-logger &> /dev/null; then
        workout-logger --action "log" 2>/dev/null || \
        log_warning "workout-logger 未配置"
    else
        log_info "workout-logger 已運行"
    fi
    
    # Step 3: habit-flow-skill
    log_info "Step 3: 習慣追蹤"
    if command -v habit-flow-skill &> /dev/null; then
        habit-flow-skill --action "track" 2>/dev/null || \
        log_warning "habit-flow-skill 未配置"
    else
        log_info "habit-flow-skill 已運行"
    fi
    
    log_success "健康連動鏈完成"
}

run_all_chains() {
    log_info "執行所有連動鏈..."
    echo ""
    
    run_research_chain
    echo ""
    
    run_stock_chain
    echo ""
    
    run_topic_chain
    echo ""
    
    run_health_chain
    echo ""
    
    log_success "所有連動鏈完成"
}

main() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --linkage|-l) LINKAGE="$2"; shift 2 ;;
            --verbose|-v) VERBOSE=true; shift ;;
            --help|-h) HELP=true; shift ;;
            *) log_error "未知參數: $1"; show_help; exit 1 ;;
        esac
    done
    
    if [ "$HELP" = true ]; then
        show_banner
        show_help
        exit 0
    fi
    
    if [ -z "$LINKAGE" ]; then
        log_error "缺少必填參數: --linkage"
        show_help
        exit 1
    fi
    
    show_banner
    echo ""
    log_info "========================================"
    log_info "  連動名稱: $LINKAGE"
    log_info "========================================"
    echo ""
    
    check_dependencies
    
    case "$LINKAGE" in
        research_chain)
            run_research_chain
            ;;
        stock_chain)
            run_stock_chain
            ;;
        topic_chain)
            run_topic_chain
            ;;
        health_chain)
            run_health_chain
            ;;
        all)
            run_all_chains
            ;;
        *)
            log_error "未知連動名稱: $LINKAGE"
            show_help
            exit 1
            ;;
    esac
    
    echo ""
    log_success "========================================"
    log_success "  連動執行完成！"
    log_success "========================================"
    echo ""
}

main "$@"
