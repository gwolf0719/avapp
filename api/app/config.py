from pydantic_settings import BaseSettings
from typing import List


class Settings(BaseSettings):
    """應用程式設定"""
    
    # 應用程式基本設定
    app_name: str = "Web Scraper API"
    debug: bool = True
    
    # CORS 設定
    allowed_hosts: List[str] = ["*"]  # 允許所有來源，開發環境使用
    
    # 爬蟲設定
    request_timeout: int = 30
    max_retries: int = 3
    delay_between_requests: float = 1.0
    user_agent: str = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
    
    # 日誌設定
    log_level: str = "INFO"
    
    class Config:
        env_file = ".env"
        case_sensitive = False


# 全域設定實例
settings = Settings()
