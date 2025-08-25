#!/usr/bin/env python3
import asyncio
import sys
import os
import re

# 添加專案路徑
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from app.core.scraper import JableScraper
from bs4 import BeautifulSoup
import logging

# 設定日誌
logging.basicConfig(level=logging.INFO)

async def simple_test():
    """簡單測試"""
    print("開始簡單測試...")
    
    async with JableScraper() as scraper:
        video_id = "pppe-356"
        url = f"https://jable.tv/videos/{video_id}/"
        
        print(f"獲取影片詳情頁面: {url}")
        content = scraper.fetch_page_selenium(url)
        
        if content:
            print(f"成功獲取頁面，內容長度: {len(content)}")
            
            # 解析 HTML
            soup = BeautifulSoup(content, 'lxml')
            
            # 直接測試解析
            print("\n=== 直接解析測試 ===")
            
            # 標題
            title_elem = soup.find('h4')
            title = title_elem.get_text(strip=True) if title_elem else ''
            print(f"標題: {title[:50]}...")
            
            # 描述
            desc_elem = soup.find('h5', class_='desc')
            description = desc_elem.get_text(strip=True) if desc_elem else ''
            print(f"描述: {description}")
            
            # 時長
            time_spans = soup.find_all('span', string=re.compile(r'\d{1,2}:\d{2}:\d{2}'))
            duration = time_spans[0].get_text(strip=True) if time_spans else ''
            print(f"時長: {duration}")
            
            # 發布日期
            time_elem = soup.find('span', string=re.compile(r'\d+\s*小時前|\d+\s*天前'))
            release_date = time_elem.get_text(strip=True) if time_elem else ''
            print(f"發布日期: {release_date}")
            
            # 演員
            actor_link = soup.find('a', class_='model')
            actor = actor_link.get_text(strip=True) if actor_link else ''
            actor_url = actor_link.get('href', '') if actor_link else ''
            print(f"演員: {actor}")
            print(f"演員連結: {actor_url}")
            
            # 播放腳本
            scripts = soup.find_all('script')
            play_url = ''
            play_key = ''
            for script in scripts:
                if script.string and ('playUrl' in script.string or 'playKey' in script.string):
                    play_url_match = re.search(r'playUrl["\']?\s*:\s*["\']([^"\']+)["\']', script.string)
                    if play_url_match:
                        play_url = play_url_match.group(1)
                    
                    play_key_match = re.search(r'playKey["\']?\s*:\s*["\']([^"\']+)["\']', script.string)
                    if play_key_match:
                        play_key = play_key_match.group(1)
                    break
            
            print(f"播放連結: {play_url}")
            print(f"播放金鑰: {play_key}")
        else:
            print("無法獲取頁面內容")

if __name__ == "__main__":
    asyncio.run(simple_test())
