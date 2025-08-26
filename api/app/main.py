from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.config import settings
from app.api.v1.api import api_router
import logging

# 設定日誌
logging.basicConfig(
    level=getattr(logging, settings.log_level),
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)

# 建立 FastAPI 應用程式
app = FastAPI(
    title=settings.app_name,
    description="網路爬蟲 API 服務",
    version="1.0.0",
    debug=settings.debug
)

# 設定 CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.allowed_hosts,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# 註冊路由
app.include_router(api_router, prefix="/api/v1")


@app.get("/")
async def root():
    """根路徑"""
    return {
        "message": "歡迎使用網路爬蟲 API",
        "version": "1.0.0",
        "docs": "/docs"
    }


@app.get("/info")
async def info():
    """應用程式資訊"""
    return {
        "app_name": settings.app_name,
        "debug": settings.debug,
        "log_level": settings.log_level
    }


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(
        "app.main:app",
        host="0.0.0.0",
        port=settings.port,
        reload=settings.debug
    )
