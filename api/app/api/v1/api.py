from fastapi import APIRouter
from app.api.v1.endpoints import scraper

api_router = APIRouter()

# 註冊爬蟲路由
api_router.include_router(scraper.router, prefix="/scraper", tags=["scraper"])
