# AVPlayer 構建指南

## 🚀 自動化構建腳本

`build.sh` 是一個自動化腳本，用於構建正式版 APK 並發布到 GitHub Releases。

## 📋 功能特色

- ✅ **環境切換**: 自動使用正式環境 API URL
- ✅ **版本管理**: 自動從 pubspec.yaml 獲取版本資訊
- ✅ **APK 構建**: 構建 release 版本 APK
- ✅ **檔案組織**: 自動重命名和整理 APK 檔案
- ✅ **Release Notes**: 自動生成發布說明
- ✅ **GitHub 發布**: 自動發布到 GitHub Releases

## 🔧 環境設定

### 必要工具

1. **Flutter SDK**
   ```bash
   flutter --version
   ```

2. **Git**
   ```bash
   git --version
   ```

3. **GitHub CLI** (可選，用於自動發布)
   ```bash
   # macOS
   brew install gh
   
   # 或下載安裝
   # https://cli.github.com/
   ```

### GitHub CLI 設定

如果您想使用自動發布功能，需要登入 GitHub CLI：

```bash
gh auth login
```

## 🏗️ 構建流程

### 1. 執行構建腳本

```bash
./build.sh
```

### 2. 腳本執行步驟

1. **檢查必要工具** - 確認 Flutter、Git、GitHub CLI 可用
2. **獲取版本資訊** - 從 pubspec.yaml 讀取版本號
3. **清理構建檔案** - 清理舊的構建產物
4. **構建 APK** - 使用正式環境 API URL 構建
5. **組織檔案** - 重命名和移動 APK 到 releases 目錄
6. **創建 Release Notes** - 生成發布說明文檔
7. **發布到 GitHub** - 創建 Git tag 和 GitHub Release

### 3. 輸出檔案

構建完成後，您會在 `releases/` 目錄找到：

```
releases/
├── avplayer-release-v1.0.0-abc1234.apk
└── release-notes-v1.0.0.md
```

## 🔄 開發 vs 正式環境

### 開發環境
- API URL: `http://10.0.2.2:8080` (Android 模擬器本機)
- 使用方式: `flutter run`

### 正式環境
- API URL: `https://avapp-760426583552.asia-east1.run.app`
- 使用方式: `./build.sh`

## 📝 版本號管理

版本號定義在 `flutter/avplayer_app/pubspec.yaml`：

```yaml
version: 1.0.0+1
```

- `1.0.0` - 版本名稱 (顯示給用戶)
- `+1` - 版本代碼 (內部使用)

## 🔧 自定義配置

### 修改 API URL

在 `build.sh` 中修改：

```bash
PRODUCTION_API_URL="https://your-api-url.com"
```

### 修改 GitHub 倉庫

```bash
GITHUB_REPO="your-username/your-repo"
```

## 📱 APK 檔案命名規則

```
avplayer-release-v{VERSION}-{COMMIT_HASH}.apk
```

例如：`avplayer-release-v1.0.0-abc1234.apk`

## 🐛 故障排除

### 常見問題

1. **Flutter 命令找不到**
   ```bash
   export PATH="$PATH:`which flutter`"
   ```

2. **GitHub CLI 未登入**
   ```bash
   gh auth login
   ```

3. **版本號格式錯誤**
   - 確保 pubspec.yaml 中版本號格式正確：`version: 1.0.0+1`

4. **APK 構建失敗**
   - 檢查 Flutter 項目是否可以正常運行
   - 確認所有依賴已安裝：`flutter pub get`

### 手動構建（不使用腳本）

```bash
cd flutter/avplayer_app

# 構建正式版 APK
flutter build apk \
  --release \
  --dart-define=API_BASE_URL="https://avapp-760426583552.asia-east1.run.app"
```

## 📞 技術支援

如有任何問題，請在 [GitHub Issues](https://github.com/gwolf0719/avapp/issues) 回報。

## 🎯 下一步

1. 修改版本號（如果需要）
2. 執行 `./build.sh`
3. 檢查 releases 目錄
4. 測試 APK 檔案
5. 分享給用戶！
