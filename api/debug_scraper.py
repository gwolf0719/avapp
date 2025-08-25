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

async def debug_scraper():
    """調試爬蟲功能"""
    print("開始調試 Jable.tv 爬蟲...")
    
    async with JableScraper() as scraper:
        print("使用 Selenium 獲取頁面...")
        url = "https://jable.tv/categories/chinese-subtitle/"
        content = scraper.fetch_page_selenium(url)
        
        if content:
            print(f"成功獲取頁面，內容長度: {len(content)}")
            
            # 保存 HTML 到檔案
            with open('debug_page.html', 'w', encoding='utf-8') as f:
                f.write(content)
            print("HTML 已保存到 debug_page.html")
            
            # 解析 HTML
            soup = scraper.parse_html(content)
            
            # 檢查頁面標題
            title = soup.find('title')
            print(f"頁面標題: {title.get_text() if title else '無標題'}")
            
            # 檢查所有可能的影片容器
            selectors = [
                'div.video-item',
                'div.item',
                'div.video',
                'div.movie-item',
                'div.film-item',
                'article',
                '.video-item',
                '.item',
                '.video'
            ]
            
            for selector in selectors:
                items = soup.select(selector)
                if items:
                    print(f"找到 {len(items)} 個項目使用選擇器: {selector}")
                    if len(items) > 0:
                        print(f"第一個項目的 HTML: {items[0][:500]}...")
                        break
            
            # 檢查所有連結
            links = soup.find_all('a', href=True)
            video_links = [link for link in links if '/videos/' in link.get('href', '')]
            print(f"找到 {len(video_links)} 個影片連結")
            
            if video_links:
                print("前3個影片連結:")
                for i, link in enumerate(video_links[:3]):
                    print(f"  {i+1}. {link.get('href')} - {link.get_text(strip=True)[:50]}")
        else:
            print("無法獲取頁面內容")

if __name__ == "__main__":
    asyncio.run(debug_scraper())
