from pydantic_settings import BaseSettings
from typing import List
import os


class Settings(BaseSettings):
    """應用程式設定"""
    
    # 應用程式基本設定
    app_name: str = "Web Scraper API"
    debug: bool = True
    port: int = int(os.getenv("PORT", "8080"))  # 動態讀取環境變數 PORT，預設 8080
    
    # CORS 設定
    allowed_hosts: List[str] = ["*"]  # 允許所有來源，開發環境使用
    
    # 爬蟲設定
    request_timeout: int = 30
    max_retries: int = 3
    delay_between_requests: float = 0.1  # 減少延遲到 0.1 秒以提升速度
    user_agent: str = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
    
    # 日誌設定
    log_level: str = "INFO"
    
    class Config:
        env_file = ".env"
        case_sensitive = False


# 全域設定實例
settings = Settings()
