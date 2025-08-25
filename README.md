# AVPlayer App

一個完整的影片播放應用程式，包含 FastAPI 後端爬蟲服務和 Flutter 前端應用程式。

## 🎯 專案特色

- **FastAPI 後端** - 強大的網路爬蟲 API 服務
- **Flutter 前端** - 跨平台 Android 應用程式（手機 + TV）
- **響應式設計** - 完美適配手機和 Android TV
- **影片播放** - 完整的 HLS 播放器功能
- **智能推薦** - 暫停時顯示演員其他作品
- **TV 遙控器支援** - D-Pad 導覽和焦點管理

## 🏗️ 專案架構

```
avapp/
├── api/                    # FastAPI 後端服務
│   ├── app/
│   │   ├── api/v1/        # API 路由
│   │   ├── core/          # 核心爬蟲邏輯
│   │   ├── schemas/       # Pydantic 模型
│   │   └── utils/         # 工具函數
│   ├── requirements.txt   # Python 依賴
│   └── Dockerfile        # Docker 配置
├── flutter/avplayer_app/  # Flutter 前端應用
│   ├── lib/
│   │   ├── core/          # 核心服務和工具
│   │   ├── data/          # 數據層（模型、倉庫）
│   │   └── presentation/  # 表現層（頁面、組件）
│   └── pubspec.yaml      # Flutter 依賴
└── todo.md               # 開發任務追蹤
```

## 🚀 快速開始

### 後端服務啟動

1. **進入 API 目錄**
```bash
cd api
```

2. **創建虛擬環境**
```bash
python3 -m venv .venv
source .venv/bin/activate  # macOS/Linux
# 或 .venv\Scripts\activate  # Windows
```

3. **安裝依賴**
```bash
pip install -r requirements.txt
```

4. **啟動服務**
```bash
uvicorn app.main:app --reload --host 0.0.0.0 --port 8080
```

服務將在 `http://localhost:8080` 啟動

### 前端應用啟動

1. **進入 Flutter 目錄**
```bash
cd flutter/avplayer_app
```

2. **安裝依賴**
```bash
flutter pub get
```

3. **啟動 Android 模擬器**
```bash
flutter emulators --launch Pixel_9_Pro_XL
```

4. **運行應用程式**
```bash
flutter run -d emulator-5554
```

## 📱 功能說明

### 影片列表
- Grid 佈局顯示影片縮圖和標題
- 支援分頁載入
- 響應式設計適配不同螢幕尺寸

### 影片播放
- 完整的 HLS 播放器功能
- 支援全螢幕播放
- 播放速度控制
- 暫停時顯示演員其他作品推薦

### TV 遙控器支援
- D-Pad 方向鍵導覽
- 焦點管理和視覺反饋
- OK 鍵切換播放/暫停
- 方向鍵快轉/後退（短按 ±10s，長按 ±60s）

## 🔧 API 端點

### 影片列表
```
GET /api/v1/scraper/videos?page=1
```

### 影片詳情
```
POST /api/v1/scraper/video/detail
{
  "videoId": "pppe-356"
}
```

### 演員影片
```
POST /api/v1/scraper/actor/videos
{
  "actorUrl": "https://jable.tv/models/...",
  "page": 1
}
```

## 🛠️ 技術棧

### 後端
- **FastAPI** - 現代化 Python Web 框架
- **aiohttp** - 異步 HTTP 客戶端
- **BeautifulSoup4** - HTML 解析
- **Selenium** - 反爬蟲機制
- **Pydantic** - 數據驗證和序列化

### 前端
- **Flutter** - 跨平台 UI 框架
- **Riverpod** - 狀態管理
- **Dio** - HTTP 客戶端
- **video_player** - 影片播放
- **chewie** - 播放器 UI 組件

## 📦 依賴管理

### Python 依賴
```
fastapi==0.104.1
uvicorn[standard]==0.24.0
requests==2.31.0
beautifulsoup4==4.12.2
selenium==4.15.2
aiohttp==3.9.1
brotli==1.1.0
```

### Flutter 依賴
```yaml
flutter_riverpod: ^2.4.10
dio: ^5.4.1
video_player: ^2.8.2
chewie: ^1.7.5
cached_network_image: ^3.3.1
```

## 🔍 開發工具

### 代碼生成
```bash
# 生成 Flutter 模型代碼
flutter packages pub run build_runner build

# 清理生成文件
flutter packages pub run build_runner clean
```

### 測試
```bash
# 後端測試
cd api
pytest

# 前端測試
cd flutter/avplayer_app
flutter test
```

## 🐳 Docker 部署

### 後端服務
```bash
cd api
docker build -t avapp-api .
docker run -p 8080:8080 avapp-api
```

### 使用 Docker Compose
```bash
cd api
docker-compose up -d
```

## 📋 開發任務

詳細的開發任務和進度請查看 [todo.md](todo.md)

## 🤝 貢獻

1. Fork 專案
2. 創建功能分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 開啟 Pull Request

## 📄 授權

本專案僅供學習和研究使用。

## 🔗 相關連結

- [FastAPI 文檔](https://fastapi.tiangolo.com/)
- [Flutter 文檔](https://flutter.dev/docs)
- [Riverpod 文檔](https://riverpod.dev/)

---

**注意**: 本專案僅用於技術學習，請遵守相關網站的使用條款和版權規定。
