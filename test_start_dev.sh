#!/bin/bash

# 測試腳本：驗證 start_dev.sh 的基本功能

echo "=== 測試 start_dev.sh 腳本 ==="

# 檢查腳本是否存在
if [ ! -f "start_dev.sh" ]; then
    echo "❌ 錯誤：找不到 start_dev.sh"
    exit 1
fi

echo "✅ 找到 start_dev.sh"

# 檢查腳本權限
if [ ! -x "start_dev.sh" ]; then
    echo "❌ 錯誤：start_dev.sh 沒有執行權限"
    exit 1
fi

echo "✅ start_dev.sh 有執行權限"

# 檢查必要目錄
if [ ! -d "api" ]; then
    echo "❌ 錯誤：找不到 api 目錄"
    exit 1
fi

if [ ! -d "flutter/avplayer_app" ]; then
    echo "❌ 錯誤：找不到 flutter/avplayer_app 目錄"
    exit 1
fi

echo "✅ 找到必要目錄"

# 檢查必要檔案
if [ ! -f "api/requirements.txt" ]; then
    echo "❌ 錯誤：找不到 api/requirements.txt"
    exit 1
fi

if [ ! -f "flutter/avplayer_app/pubspec.yaml" ]; then
    echo "❌ 錯誤：找不到 flutter/avplayer_app/pubspec.yaml"
    exit 1
fi

echo "✅ 找到必要檔案"

# 檢查 Python 環境
if ! command -v python3 >/dev/null 2>&1; then
    echo "❌ 錯誤：Python3 未安裝"
    exit 1
fi

echo "✅ Python3 已安裝"

# 檢查 Flutter 環境
if ! command -v flutter >/dev/null 2>&1; then
    echo "⚠️  警告：Flutter 未安裝或不在 PATH 中"
else
    echo "✅ Flutter 已安裝"
fi

# 檢查 Android SDK 環境
if ! command -v adb >/dev/null 2>&1; then
    echo "⚠️  警告：ADB 未安裝或不在 PATH 中"
else
    echo "✅ ADB 已安裝"
fi

# 檢查端口 8080 是否可用
if lsof -Pi :8080 -sTCP:LISTEN -t >/dev/null 2>&1; then
    echo "⚠️  警告：端口 8080 已被佔用"
else
    echo "✅ 端口 8080 可用"
fi

echo ""
echo "=== 測試完成 ==="
echo "如果所有檢查都通過，可以執行 ./start_dev.sh 來啟動開發環境"
