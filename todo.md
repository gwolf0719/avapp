# 專案任務清單

## 已完成 ✅

### Jable.tv 爬蟲 API 專案建構
- [x] 建立專案基本結構
- [x] 設定 Python 依賴 (requirements.txt)
- [x] 設定開發依賴 (requirements-dev.txt)
- [x] 建立環境變數範例 (env.example)
- [x] 建立 Git 忽略檔案 (.gitignore)
- [x] 建立應用程式配置 (app/config.py)
- [x] 建立 Jable.tv 專用爬蟲 (app/core/scraper.py)
- [x] 建立 Pydantic 模型 (app/schemas/scraper.py)
- [x] 建立 API 端點 (app/api/v1/endpoints/scraper.py)
- [x] 建立 API 路由整合 (app/api/v1/api.py)
- [x] 建立主應用程式 (app/main.py)
- [x] 建立輔助工具函數 (app/utils/helpers.py)
- [x] 建立測試檔案 (tests/test_scraper.py)
- [x] 建立 Docker 配置 (Dockerfile, docker-compose.yml)
- [x] 建立專案說明 (README.md)

### 核心功能實作
- [x] 中文影片列表爬取 (支援分頁)
- [x] 影片詳情和播放資訊提取
- [x] 演員相關影片查詢
- [x] HTML 解析和資料提取
- [x] 影片編號提取 (如 pppe-356)
- [x] 播放連結和金鑰提取

## 待完成 🔄

### 功能優化
- [ ] 實作請求重試機制
- [ ] 新增代理支援
- [ ] 優化 HTML 解析邏輯
- [ ] 新增更多錯誤處理
- [ ] 實作結果快取機制

### 測試與品質
- [ ] 執行實際網站測試
- [ ] 新增更多測試案例
- [ ] 設定程式碼品質檢查
- [ ] 設定 CI/CD 流程

### 部署與監控
- [ ] 設定詳細日誌記錄
- [ ] 新增監控端點
- [ ] 優化效能和記憶體使用
- [ ] 新增健康檢查機制

### 文件與維護
- [ ] 完善 API 文件
- [ ] 新增更多使用範例
- [ ] 建立部署指南
- [ ] 新增故障排除指南

## 技術細節

### HTML 解析目標
- 影片列表頁面: `https://jable.tv/categories/chinese-subtitle/`
- 影片詳情頁面: `https://jable.tv/videos/{video_id}/`
- 演員頁面: 從影片詳情頁面提取的演員連結

### 提取資料項目
- 影片標題、圖片、連結、編號、時長
- 影片描述、發布日期、演員資訊
- 播放連結和金鑰
- 演員相關影片列表

## 注意事項

- 確保在 .venv 虛擬環境中運行
- 遵循 Python 編碼規範
- 定期更新依賴套件
- 保持程式碼品質和測試覆蓋率
- 遵守網站使用條款和爬蟲規範
- 設定適當的請求延遲避免對伺服器造成負擔
