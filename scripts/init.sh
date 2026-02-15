#!/bin/bash
# Fang Research OS v1.0 - 初始化腳本

echo "🚀 初始化 Fang Research OS v1.0"
echo "================================"

# 檢查目錄
echo "📁 檢查目錄結構..."
if [ -d "f-ros" ] && [ -d "config" ] && [ -d "scripts" ]; then
    echo "✅ 目錄結構正確"
else
    echo "❌ 目錄結構不完整，請重新 clone"
    exit 1
fi

# 檢查 Python
echo ""
echo "🐍 檢查 Python 版本..."
if command -v python3 &> /dev/null; then
    PYTHON_VERSION=$(python3 --version)
    echo "✅ $PYTHON_VERSION"
else
    echo "❌ Python 3 未安裝"
    exit 1
fi

# 設定權限
echo ""
echo "🔧 設定腳本權限..."
chmod +x scripts/*.sh
echo "✅ 權限設定完成"

# 複製配置範例
echo ""
echo "⚙️ 設定配置文件..."
if [ ! -f "config/f-ros.yaml" ]; then
    if [ -f "config/f-ros.yaml.example" ]; then
        cp config/f-ros.yaml.example config/f-ros.yaml
        echo "✅ 配置文件已建立，請編輯 config/f-ros.yaml"
    else
        echo "⚠️ 配置文件範例不存在"
    fi
else
    echo "✅ 配置文件已存在"
fi

# 初始化 Git（可選）
echo ""
echo "📦 Git 初始化..."
if [ ! -d ".git" ]; then
    git init
    echo "✅ Git 已初始化"
else
    echo "✅ Git 已初始化"
fi

echo ""
echo "================================"
echo "✅ 初始化完成！"
echo ""
echo "下一步："
echo "1. 編輯 config/f-ros.yaml"
echo "2. 執行 bash scripts/phd_deep_analysis.sh --help"
echo ""
