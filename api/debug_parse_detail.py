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

async def debug_parse_detail():
    """調試影片詳情解析"""
    print("開始調試影片詳情解析...")
    
    async with JableScraper() as scraper:
        video_id = "pppe-356"
        url = f"https://jable.tv/videos/{video_id}/"
        
        print(f"獲取影片詳情頁面: {url}")
        content = scraper.fetch_page_selenium(url)
        
        if content:
            print(f"成功獲取頁面，內容長度: {len(content)}")
            
            # 解析 HTML
            soup = BeautifulSoup(content, 'lxml')
            
            print("\n=== 解析標題 ===")
            # 嘗試不同的標題選擇器
            title_selectors = [
                'h4',
                'h1.video-title',
                'h1',
                '.video-title',
                '.title'
            ]
            
            for selector in title_selectors:
                elements = soup.select(selector)
                if elements:
                    print(f"找到標題元素使用選擇器: {selector}")
                    for i, elem in enumerate(elements[:3]):
                        text = elem.get_text(strip=True)
                        if text:
                            print(f"  標題 {i+1}: {text[:100]}...")
                    break
            
            print("\n=== 解析描述 ===")
            # 嘗試不同的描述選擇器
            desc_selectors = [
                'h5.desc',
                'h5',
                '.video-description',
                '.description',
                '.desc'
            ]
            
            for selector in desc_selectors:
                elements = soup.select(selector)
                if elements:
                    print(f"找到描述元素使用選擇器: {selector}")
                    for i, elem in enumerate(elements[:2]):
                        text = elem.get_text(strip=True)
                        if text and len(text) > 5:
                            print(f"  描述 {i+1}: {text[:100]}...")
                    break
            
            print("\n=== 解析演員資訊 ===")
            # 嘗試不同的演員選擇器
            actor_selectors = [
                '.models a.model',
                '.models a',
                'a.model',
                '.model',
                'a[href*="/models/"]'
            ]
            
            for selector in actor_selectors:
                elements = soup.select(selector)
                if elements:
                    print(f"找到演員元素使用選擇器: {selector}")
                    for i, elem in enumerate(elements[:3]):
                        text = elem.get_text(strip=True)
                        href = elem.get('href', '')
                        if text:
                            print(f"  演員 {i+1}: {text} - {href}")
                    break
            
            print("\n=== 解析時間資訊 ===")
            # 查找時間相關元素
            time_patterns = [
                r'\d+\s*小時前',
                r'\d+\s*天前',
                r'\d+:\d+:\d+'
            ]
            
            for pattern in time_patterns:
                elements = soup.find_all('span', string=re.compile(pattern))
                if elements:
                    print(f"找到時間元素使用模式: {pattern}")
                    for elem in elements:
                        print(f"  時間: {elem.get_text(strip=True)}")
            
            print("\n=== 解析播放腳本 ===")
            # 查找播放相關腳本
            scripts = soup.find_all('script')
            for i, script in enumerate(scripts):
                if script.string and ('playUrl' in script.string or 'playKey' in script.string):
                    print(f"找到播放腳本 {i+1}:")
                    script_content = script.string
                    print(f"  內容長度: {len(script_content)}")
                    print(f"  前200字: {script_content[:200]}...")
                    
                    # 嘗試提取 playUrl 和 playKey
                    play_url_match = re.search(r'playUrl["\']?\s*:\s*["\']([^"\']+)["\']', script_content)
                    if play_url_match:
                        print(f"  找到 playUrl: {play_url_match.group(1)}")
                    
                    play_key_match = re.search(r'playKey["\']?\s*:\s*["\']([^"\']+)["\']', script_content)
                    if play_key_match:
                        print(f"  找到 playKey: {play_key_match.group(1)}")
                    break
        else:
            print("無法獲取頁面內容")

if __name__ == "__main__":
    asyncio.run(debug_parse_detail())
