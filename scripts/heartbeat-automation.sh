#!/bin/bash
#=============================================================================
# Fang Research OS - Heartbeat Automation Runner
# 心跳任務自動化執行腳本
# 
# 用法:
#   bash scripts/heartbeat-automation.sh [--task all|github_skill_search|system_health_check|knowledge_extraction] [--verbose]
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
CONFIG_FILE="$SCRIPT_DIR/heartbeat-automation.yaml"
LOG_FILE="$ROOT_DIR/logs/heartbeat_automation.log"

# 預設值
TASK="all"
VERBOSE=false
HELP=false

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
║       🧠 Fang Research OS - Heartbeat Automation Runner          ║
║                                                                ║
║                    心跳任務自動化執行腳本                        ║
║                                                                ║
╚════════════════════════════════════════════════════════════════════╝

EOF
}

show_help() {
    cat << EOF
用法:
    bash \$0 [OPTIONS]

選項:
    --task, -t <TASK>   任務 (all|github_skill_search|system_health_check|knowledge_extraction)
    --verbose, -v         詳細輸出
    --help, -h           顯示幫助

任務說明:
    all                      執行所有心跳任務 [預設]
    github_skill_search      GitHub 技能搜尋
    system_health_check     系統健康檢查
    knowledge_extraction    知識提取

範例:
    bash \$0                        # 執行所有任務
    bash \$0 --task github_skill_search  # 只執行技能搜尋
    bash \$0 --task system_health_check   # 只執行健康檢查
    bash \$0 --verbose               # 詳細輸出

心跳任務排程:
    08:00 - GitHub 技能搜尋、系統健康檢查
    14:00 - 系統健康檢查、知識提取
    20:00 - GitHub 技能搜尋、系統健康檢查

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
        log_warning "配置文件不存在: $CONFIG_FILE"
        log_info "使用預設配置..."
    fi
    
    # 檢查輸出目錄
    local output_dir="$ROOT_DIR/outputs/heartbeat"
    mkdir -p "$output_dir" 2>/dev/null || true
    
    log_success "依賴檢查完成"
}

create_output_dir() {
    local task_output_dir="$ROOT_DIR/outputs/heartbeat/$1"
    if [ ! -d "$task_output_dir" ]; then
        mkdir -p "$task_output_dir"
        log_info "創建輸出目錄: $task_output_dir"
    fi
}

generate_timestamp() {
    date +"%Y%m%d_%H%M%S"
}

log_to_file() {
    local message="$1"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $message" >> "$LOG_FILE" 2>/dev/null || true
}

#----------------------------------------------------------------------------
# 任務執行函數
#----------------------------------------------------------------------------

run_github_skill_search() {
    local task_name="github_skill_search"
    local timestamp=$(generate_timestamp)
    local output_file="$ROOT_DIR/outputs/heartbeat/github_skills/skill_search_$timestamp.md"
    
    log_info "========================================"
    log_info "  任務: GitHub 技能搜尋"
    log_info "========================================"
    
    create_output_dir "$task_name"
    
    # 執行主要腳本
    log_info "執行 GitHub 技能搜尋..."
    if python3 "$ROOT_DIR/scripts/github-skill-search.py" 2>&1 | tee "$output_file"; then
        log_success "GitHub 技能搜尋完成"
        log_debug "輸出檔案: $output_file"
        
        # 連動：安裝發現的技能
        log_info "檢查連動技能..."
        if command -v clawhub &> /dev/null; then
            log_info " clawhub 可用，可執行自動安裝"
        else
            log_warning " clawhub 未安裝"
        fi
        
        # 連動：更新技能庫
        log_info "連動到 OpenCode..."
        log_debug "可生成安裝腳本"
        
        log_to_file "github_skill_search completed successfully"
        return 0
    else
        log_error "GitHub 技能搜尋失敗"
        log_to_file "github_skill_search failed"
        return 1
    fi
}

run_system_health_check() {
    local task_name="system_health_check"
    local timestamp=$(generate_timestamp)
    local output_file="$ROOT_DIR/outputs/heartbeat/health_checks/health_$timestamp.json"
    
    log_info "========================================"
    log_info "  任務: 系統健康檢查"
    log_info "========================================"
    
    create_output_dir "$task_name"
    
    # 執行主要腳本
    log_info "執行系統健康檢查..."
    if python3 "$ROOT_DIR/scripts/heartbeat-check.py" 2>&1; then
        log_success "系統健康檢查完成"
        log_debug "輸出檔案: $output_file"
        
        # 連動：分析健康狀態
        log_info "連動到 healthcheck 技能..."
        if command -v healthcheck &> /dev/null; then
            log_info "  healthcheck 可用"
        else
            log_info "  healthcheck 已內建"
        fi
        
        # 連動：監控服務
        log_info "連動到 ping-monitor..."
        if command -v ping-monitor &> /dev/null; then
            log_info "  ping-monitor 可用"
        fi
        
        log_to_file "system_health_check completed successfully"
        return 0
    else
        log_error "系統健康檢查失敗"
        log_to_file "system_health_check failed"
        return 1
    fi
}

run_knowledge_extraction() {
    local task_name="knowledge_extraction"
    local timestamp=$(generate_timestamp)
    local output_file="$ROOT_DIR/outputs/heartbeat/knowledge_extraction/extraction_$timestamp.md"
    
    log_info "========================================"
    log_info "  任務: 知識提取"
    log_info "========================================"
    
    create_output_dir "$task_name"
    
    # 執行主要腳本
    log_info "執行知識提取..."
    if bash "$ROOT_DIR/scripts/knowledge-extractor.sh" 2>&1 | tee "$output_file"; then
        log_success "知識提取完成"
        log_debug "輸出檔案: $output_file"
        
        # 連動：更新 Zettelkasten
        log_info "連動到 Zettelkasten..."
        if command -v zettelkasten &> /dev/null; then
            log_info "  zettelkasten 可用，可更新筆記"
        fi
        
        # 連動：回顧論文
        log_info "連動到 literature-review-agent..."
        if command -v literature-review-agent &> /dev/null; then
            log_info "  literature-review-agent 可用，可回顧論文"
        fi
        
        # 連動：組織記憶
        log_info "連動到 research-evolution..."
        if command -v research-evolution &> /dev/null; then
            log_info "  research-evolution 可用，可組織記憶"
        fi
        
        log_to_file "knowledge_extraction completed successfully"
        return 0
    else
        log_error "知識提取失敗"
        log_to_file "knowledge_extraction failed"
        return 1
    fi
}

run_all_tasks() {
    local total_tasks=3
    local completed_tasks=0
    local failed_tasks=0
    
    log_info "執行所有心跳任務..."
    echo ""
    
    # Task 1: GitHub Skill Search
    log_info "Task 1/3: GitHub 技能搜尋"
    if run_github_skill_search; then
        ((completed_tasks++))
    else
        ((failed_tasks++))
    fi
    echo ""
    
    # Task 2: System Health Check
    log_info "Task 2/3: 系統健康檢查"
    if run_system_health_check; then
        ((completed_tasks++))
    else
        ((failed_tasks++))
    fi
    echo ""
    
    # Task 3: Knowledge Extraction
    log_info "Task 3/3: 知識提取"
    if run_knowledge_extraction; then
        ((completed_tasks++))
    else
        ((failed_tasks++))
    fi
    echo ""
    
    # 總結
    log_info "========================================"
    log_info "  心跳任務完成統計"
    log_info "========================================"
    log_info "  完成: $completed_tasks/$total_tasks"
    log_info "  失敗: $failed_tasks/$total_tasks"
    
    if [ $failed_tasks -eq 0 ]; then
        log_success "所有任務完成！"
        return 0
    else
        log_warning "部分任務失敗"
        return 1
    fi
}

#----------------------------------------------------------------------------
# 主程式
#----------------------------------------------------------------------------

main() {
    # 解析參數
    while [[ $# -gt 0 ]]; do
        case $1 in
            --task|-t) TASK="$2"; shift 2 ;;
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
    log_info "  執行任務: $TASK"
    log_info "========================================"
    echo ""
    
    check_dependencies
    
    # 確保輸出目錄存在
    mkdir -p "$ROOT_DIR/outputs/heartbeat" 2>/dev/null || true
    mkdir -p "$ROOT_DIR/logs" 2>/dev/null || true
    
    log_to_file "Heartbeat automation started (task: $TASK)"
    
    # 執行任務
    case "$TASK" in
        all)
            run_all_tasks
            ;;
        github_skill_search)
            run_github_skill_search
            ;;
        system_health_check)
            run_system_health_check
            ;;
        knowledge_extraction)
            run_knowledge_extraction
            ;;
        *)
            log_error "未知任務: $TASK"
            show_help
            exit 1
            ;;
    esac
    
    local exit_code=$?
    
    log_to_file "Heartbeat automation finished (exit code: $exit_code)"
    
    echo ""
    log_info "========================================"
    if [ $exit_code -eq 0 ]; then
        log_success "  心跳任務自動化完成！"
    else
        log_warning "  部分任務失敗，請檢查日誌"
    fi
    log_info "========================================"
    echo ""
    log_info "日誌位置: $LOG_FILE"
    echo ""
}

main "$@"
