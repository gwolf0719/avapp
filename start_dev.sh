#!/bin/bash

# 設定顏色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 函數：檢查命令是否存在
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# 函數：檢查端口是否被佔用
check_port() {
    local port=$1
    if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1; then
        return 0  # 端口被佔用
    else
        return 1  # 端口可用
    fi
}

# 函數：殺死佔用指定端口的進程
kill_port_process() {
    local port=$1
    echo -e "${YELLOW}檢查端口 $port 是否被佔用...${NC}"
    
    if check_port $port; then
        echo -e "${YELLOW}端口 $port 被佔用，正在終止相關進程...${NC}"
        local pids=$(lsof -ti:$port)
        if [ ! -z "$pids" ]; then
            echo "終止進程: $pids"
            kill -9 $pids
            sleep 2
            echo -e "${GREEN}端口 $port 已釋放${NC}"
        fi
    else
        echo -e "${GREEN}端口 $port 可用${NC}"
    fi
}

# 函數：啟動 API 服務
start_api_service() {
    echo -e "${BLUE}=== 啟動 API 服務 ===${NC}"
    
    # 檢查並建立 Python 虛擬環境
    if [ -d "api/.venv" ]; then
        echo -e "${GREEN}找到虛擬環境，使用 api/.venv${NC}"
        source api/.venv/bin/activate
    elif [ -d ".venv" ]; then
        echo -e "${GREEN}找到虛擬環境，使用 .venv${NC}"
        source .venv/bin/activate
    else
        echo -e "${YELLOW}未找到虛擬環境，正在建立新的虛擬環境...${NC}"
        
        # 檢查 Python 版本
        if command_exists python3; then
            echo -e "${BLUE}使用 Python3 建立虛擬環境...${NC}"
            python3 -m venv api/.venv
            source api/.venv/bin/activate
            echo -e "${GREEN}虛擬環境已建立並啟動${NC}"
        else
            echo -e "${RED}錯誤：Python3 未安裝，無法建立虛擬環境${NC}"
            exit 1
        fi
    fi
    
    # 檢查並安裝依賴
    if [ ! -f "api/requirements.txt" ]; then
        echo -e "${RED}錯誤：找不到 api/requirements.txt${NC}"
        exit 1
    fi
    
    echo -e "${BLUE}安裝 Python 依賴...${NC}"
    pip install -r api/requirements.txt
    
    # 檢查端口 8080
    kill_port_process 8080
    
    # 啟動 API 服務
    echo -e "${GREEN}啟動 API 服務在端口 8080...${NC}"
    cd api
    python -m uvicorn app.main:app --host 0.0.0.0 --port 8080 --reload &
    API_PID=$!
    cd ..
    
    echo -e "${GREEN}API 服務已啟動 (PID: $API_PID)${NC}"
    echo -e "${BLUE}API 文檔: http://localhost:8080/docs${NC}"
}

# 函數：啟動 Android 模擬器
start_android_emulator() {
    echo -e "${BLUE}=== 啟動 Android 模擬器 ===${NC}"
    
    # 檢查 Flutter 是否安裝
    if ! command_exists flutter; then
        echo -e "${RED}錯誤：Flutter 未安裝或不在 PATH 中${NC}"
        exit 1
    fi
    
    # 檢查 Android SDK 是否配置
    if ! command_exists adb; then
        echo -e "${RED}錯誤：ADB 未安裝或不在 PATH 中${NC}"
        echo -e "${YELLOW}請確保 Android SDK 已正確配置${NC}"
        exit 1
    fi
    
    # 檢查 Flutter 專案
    if [ ! -d "flutter/avplayer_app" ]; then
        echo -e "${RED}錯誤：找不到 Flutter 專案目錄${NC}"
        exit 1
    fi
    
    # 列出可用的模擬器
    echo -e "${BLUE}檢查可用的 Android 模擬器...${NC}"
    emulator -list-avds
    
    # 檢查是否有運行中的模擬器
    local running_emulators=$(adb devices | grep emulator | wc -l)
    if [ $running_emulators -gt 0 ]; then
        echo -e "${GREEN}發現運行中的模擬器${NC}"
        adb devices
    else
        echo -e "${YELLOW}沒有運行中的模擬器，嘗試啟動模擬器...${NC}"
        
        # 優先嘗試啟動 Pixel 9 Pro XL
        local target_avd=""
        local available_avds=$(emulator -list-avds)
        
        if echo "$available_avds" | grep -q "Pixel_9_Pro_XL"; then
            target_avd="Pixel_9_Pro_XL"
            echo -e "${GREEN}找到 Pixel 9 Pro XL 模擬器${NC}"
        elif echo "$available_avds" | grep -q "Pixel.*Pro.*XL"; then
            target_avd=$(echo "$available_avds" | grep "Pixel.*Pro.*XL" | head -n 1)
            echo -e "${GREEN}找到 Pixel Pro XL 模擬器: $target_avd${NC}"
        elif echo "$available_avds" | grep -q "Pixel"; then
            target_avd=$(echo "$available_avds" | grep "Pixel" | head -n 1)
            echo -e "${GREEN}找到 Pixel 模擬器: $target_avd${NC}"
        else
            # 如果沒有找到 Pixel 系列，使用第一個可用的模擬器
            target_avd=$(echo "$available_avds" | head -n 1)
            if [ -z "$target_avd" ]; then
                echo -e "${RED}錯誤：沒有找到可用的 Android 模擬器${NC}"
                echo -e "${YELLOW}請使用 Android Studio 創建模擬器${NC}"
                echo -e "${BLUE}建議創建 Pixel 9 Pro XL 模擬器以獲得最佳體驗${NC}"
                exit 1
            fi
            echo -e "${GREEN}使用可用的模擬器: $target_avd${NC}"
        fi
        
        echo -e "${GREEN}啟動模擬器: $target_avd${NC}"
        emulator -avd "$target_avd" &
        EMULATOR_PID=$!
        
        # 等待模擬器啟動
        echo -e "${BLUE}等待模擬器啟動...${NC}"
        sleep 10
        
        # 檢查模擬器是否成功啟動
        local attempts=0
        while [ $attempts -lt 30 ]; do
            if adb devices | grep -q emulator; then
                echo -e "${GREEN}模擬器已成功啟動${NC}"
                adb devices
                break
            fi
            echo -e "${YELLOW}等待模擬器啟動... (嘗試 $((attempts + 1))/30)${NC}"
            sleep 5
            attempts=$((attempts + 1))
        done
        
        if [ $attempts -eq 30 ]; then
            echo -e "${RED}錯誤：模擬器啟動超時${NC}"
            exit 1
        fi
    fi
}

# 函數：啟動 Flutter 應用
start_flutter_app() {
    echo -e "${BLUE}=== 啟動 Flutter 應用 ===${NC}"
    
    cd flutter/avplayer_app
    
    # 檢查依賴
    echo -e "${BLUE}檢查 Flutter 依賴...${NC}"
    flutter pub get
    
    # 啟動 Flutter 應用 (啟用熱加載)
    echo -e "${GREEN}啟動 Flutter 應用 (熱加載已啟用)...${NC}"
    flutter run --hot &
    FLUTTER_PID=$!
    
    cd ../..
    
    echo -e "${GREEN}Flutter 應用已啟動 (PID: $FLUTTER_PID)${NC}"
}

# 函數：清理函數
cleanup() {
    echo -e "${YELLOW}正在清理進程...${NC}"
    
    if [ ! -z "$API_PID" ]; then
        echo -e "${YELLOW}終止 API 服務 (PID: $API_PID)${NC}"
        kill -9 $API_PID 2>/dev/null
    fi
    
    if [ ! -z "$EMULATOR_PID" ]; then
        echo -e "${YELLOW}終止模擬器 (PID: $EMULATOR_PID)${NC}"
        kill -9 $EMULATOR_PID 2>/dev/null
    fi
    
    if [ ! -z "$FLUTTER_PID" ]; then
        echo -e "${YELLOW}終止 Flutter 應用 (PID: $FLUTTER_PID)${NC}"
        kill -9 $FLUTTER_PID 2>/dev/null
    fi
    
    echo -e "${GREEN}清理完成${NC}"
    exit 0
}

# 設定信號處理
trap cleanup SIGINT SIGTERM

# 主程序
echo -e "${BLUE}=== AV Player 開發環境啟動腳本 ===${NC}"
echo -e "${BLUE}時間: $(date)${NC}"
echo ""

# 檢查必要工具
echo -e "${BLUE}檢查必要工具...${NC}"
if ! command_exists python3; then
    echo -e "${RED}錯誤：Python3 未安裝${NC}"
    exit 1
fi

if ! command_exists pip; then
    echo -e "${RED}錯誤：pip 未安裝${NC}"
    exit 1
fi

echo -e "${GREEN}必要工具檢查完成${NC}"
echo ""

# 啟動服務
start_api_service
echo ""

start_android_emulator
echo ""

start_flutter_app
echo ""

echo -e "${GREEN}=== 所有服務已啟動 ===${NC}"
echo -e "${BLUE}API 服務: http://localhost:8080${NC}"
echo -e "${BLUE}API 文檔: http://localhost:8080/docs${NC}"
echo -e "${BLUE}按 Ctrl+C 停止所有服務${NC}"
echo ""

# 等待用戶中斷
wait
