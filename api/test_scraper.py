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

async def test_scraper():
    """測試爬蟲功能"""
    print("開始測試 Jable.tv 爬蟲...")
    
    async with JableScraper() as scraper:
        print("1. 測試獲取影片列表...")
        result = await scraper.get_video_list(page=1)
        
        print(f"狀態: {result['status']}")
        print(f"影片數量: {result['total_count']}")
        print(f"當前頁面: {result['current_page']}")
        print(f"是否有下一頁: {result['has_next_page']}")
        
        if result['status'] == 'success' and result['videos']:
            print("\n前3個影片:")
            for i, video in enumerate(result['videos'][:3]):
                print(f"  {i+1}. {video['title']}")
                print(f"     編號: {video['video_id']}")
                print(f"     連結: {video['video_url']}")
                print(f"     時長: {video['duration']}")
                print()
        elif result['status'] == 'error':
            print(f"錯誤: {result.get('error', '未知錯誤')}")
        
        # 如果有影片，測試獲取詳情
        if result['status'] == 'success' and result['videos']:
            first_video = result['videos'][0]
            if first_video['video_id']:
                print(f"2. 測試獲取影片詳情: {first_video['video_id']}")
                detail_result = await scraper.get_video_detail(first_video['video_id'])
                
                print(f"詳情狀態: {detail_result['status']}")
                if detail_result['status'] == 'success':
                    print(f"標題: {detail_result['title']}")
                    print(f"演員: {detail_result['actor']}")
                    print(f"播放連結: {detail_result['play_url']}")
                else:
                    print(f"詳情錯誤: {detail_result.get('error', '未知錯誤')}")

if __name__ == "__main__":
    asyncio.run(test_scraper())
