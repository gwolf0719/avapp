# 使用 Python 3.11 作為基礎映像
FROM python:3.11-slim

# 設定工作目錄
WORKDIR /app

# 安裝系統依賴
RUN apt-get update && apt-get install -y \
    gcc \
    curl \
    && rm -rf /var/lib/apt/lists/*

# 複製 API 依賴檔案
COPY api/requirements.txt ./api/

# 安裝 Python 依賴
RUN pip install --no-cache-dir -r api/requirements.txt

# 複製整個專案
COPY . .

# 暴露 API 端口
EXPOSE 8000

# 設定環境變數
ENV PYTHONPATH=/app/api
ENV DEBUG=False
ENV LOG_LEVEL=INFO

# 健康檢查
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8000/api/v1/scraper/health || exit 1

# 啟動 API 服務
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
