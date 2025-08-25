# 開發環境設定指南

## 快速啟動

### 使用自動化腳本（推薦）

我們提供了一個自動化腳本來快速啟動整個開發環境：

```bash
# 執行啟動腳本
./start_dev.sh
```

這個腳本會自動：
1. 啟動 API 服務在端口 8080
2. 自動建立 Python 虛擬環境（如果不存在）
3. 優先啟動 Pixel 9 Pro XL 模擬器（如果可用）
4. 啟動 Flutter 應用
5. 處理端口衝突
6. 管理進程清理

### 手動啟動

如果您想手動控制每個組件，可以分別執行：

#### 1. 啟動 API 服務

```bash
# 進入 API 目錄
cd api

# 啟動虛擬環境（如果存在）
source .venv/bin/activate  # 或 source ../.venv/bin/activate

# 如果沒有虛擬環境，腳本會自動建立
# python3 -m venv .venv
# source .venv/bin/activate

# 安裝依賴
pip install -r requirements.txt

# 啟動服務
python -m uvicorn app.main:app --host 0.0.0.0 --port 8080 --reload
```

#### 2. 啟動 Android 模擬器

```bash
# 列出可用的模擬器
emulator -list-avds

# 啟動模擬器（替換 YOUR_AVD_NAME 為實際的模擬器名稱）
emulator -avd YOUR_AVD_NAME
```

#### 3. 啟動 Flutter 應用

```bash
# 進入 Flutter 專案目錄
cd flutter/avplayer_app

# 安裝依賴
flutter pub get

# 啟動應用
flutter run
```

## 環境需求

### 必要工具

- **Python 3.8+** - 用於 API 服務
- **Flutter SDK** - 用於 Flutter 應用開發
- **Android SDK** - 用於 Android 模擬器
- **ADB** - Android Debug Bridge

### 檢查環境

執行測試腳本來檢查您的環境是否準備就緒：

```bash
./test_start_dev.sh
```

## 端口配置

- **API 服務**: 8080
- **Flutter 開發伺服器**: 自動分配
- **Android 模擬器**: 自動分配

## 故障排除

### 端口衝突

如果遇到端口衝突，腳本會自動處理。您也可以手動檢查：

```bash
# 檢查端口 8080 是否被佔用
lsof -i :8080

# 終止佔用端口的進程
kill -9 $(lsof -ti:8080)
```

### 模擬器問題

如果模擬器無法啟動：

1. 確保 Android Studio 已安裝
2. 使用 Android Studio 創建模擬器
3. 建議創建 Pixel 9 Pro XL 模擬器以獲得最佳體驗
4. 檢查 AVD 列表：`emulator -list-avds`

腳本會按以下優先順序選擇模擬器：
1. Pixel_9_Pro_XL
2. 任何 Pixel Pro XL 系列
3. 任何 Pixel 系列
4. 第一個可用的模擬器

### Flutter 問題

如果 Flutter 應用無法啟動：

1. 檢查 Flutter 安裝：`flutter doctor`
2. 更新依賴：`flutter pub get`
3. 清理快取：`flutter clean`

## 開發工作流程

1. **啟動開發環境**：`./start_dev.sh`
2. **修改程式碼**：API 和 Flutter 都支援熱重載
3. **測試功能**：在模擬器中測試應用
4. **停止服務**：按 `Ctrl+C` 停止所有服務

## 有用的命令

```bash
# 檢查所有進程
ps aux | grep -E "(uvicorn|flutter|emulator)"

# 檢查端口使用情況
lsof -i :8080

# 重新啟動 API 服務
cd api && python -m uvicorn app.main:app --host 0.0.0.0 --port 8080 --reload

# 重新啟動 Flutter 應用
cd flutter/avplayer_app && flutter run
```

## 注意事項

- 確保在專案根目錄執行腳本
- 首次執行可能需要較長時間來安裝依賴
- 模擬器啟動可能需要 1-2 分鐘
- 按 `Ctrl+C` 可以優雅地停止所有服務
