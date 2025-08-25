#!/usr/bin/env python3
import asyncio
import sys
import os

# 添加專案路徑
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from app.core.scraper import JableScraper
import logging

# 設定日誌
logging.basicConfig(level=logging.INFO)

async def debug_video_detail():
    """調試影片詳情頁面"""
    print("開始調試影片詳情頁面...")
    
    async with JableScraper() as scraper:
        video_id = "pppe-356"
        url = f"https://jable.tv/videos/{video_id}/"
        
        print(f"獲取影片詳情頁面: {url}")
        content = scraper.fetch_page_selenium(url)
        
        if content:
            print(f"成功獲取頁面，內容長度: {len(content)}")
            
            # 保存 HTML 到檔案
            with open('debug_video_detail.html', 'w', encoding='utf-8') as f:
                f.write(content)
            print("HTML 已保存到 debug_video_detail.html")
            
            # 解析 HTML
            soup = scraper.parse_html(content)
            
            # 檢查頁面標題
            title = soup.find('title')
            print(f"頁面標題: {title.get_text() if title else '無標題'}")
            
            # 檢查所有可能的標題元素
            title_selectors = [
                'h1.video-title',
                'h1',
                'h2.video-title',
                'h2',
                '.video-title',
                '.title'
            ]
            
            for selector in title_selectors:
                elements = soup.select(selector)
                if elements:
                    print(f"找到標題元素使用選擇器: {selector}")
                    for elem in elements[:3]:  # 只顯示前3個
                        print(f"  標題: {elem.get_text(strip=True)[:100]}...")
                    break
            
            # 檢查所有可能的描述元素
            desc_selectors = [
                '.video-description',
                '.description',
                '.content',
                '.detail',
                'p'
            ]
            
            for selector in desc_selectors:
                elements = soup.select(selector)
                if elements:
                    print(f"找到描述元素使用選擇器: {selector}")
                    for elem in elements[:2]:  # 只顯示前2個
                        text = elem.get_text(strip=True)
                        if text and len(text) > 10:
                            print(f"  描述: {text[:100]}...")
                    break
            
            # 檢查演員資訊
            actor_selectors = [
                'a[href*="/actors/"]',
                '.actor',
                '.model',
                'a[href*="actor"]'
            ]
            
            for selector in actor_selectors:
                elements = soup.select(selector)
                if elements:
                    print(f"找到演員元素使用選擇器: {selector}")
                    for elem in elements[:3]:
                        print(f"  演員: {elem.get_text(strip=True)} - {elem.get('href', '')}")
                    break
            
            # 檢查播放相關腳本
            scripts = soup.find_all('script')
            for script in scripts:
                if script.string and ('playUrl' in script.string or 'playKey' in script.string):
                    print("找到播放相關腳本:")
                    print(script.string[:500] + "...")
                    break
        else:
            print("無法獲取頁面內容")

if __name__ == "__main__":
    asyncio.run(debug_video_detail())
