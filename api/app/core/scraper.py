import asyncio
import aiohttp
import requests
import re
from bs4 import BeautifulSoup
from typing import Dict, List, Optional, Any
from app.config import settings
import logging
from fake_useragent import UserAgent
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import time

logger = logging.getLogger(__name__)


class JableScraper:
    """Jable.tv 專用爬蟲類別"""
    
    def __init__(self):
        self.session = None
        self.driver = None
        self.ua = UserAgent()
        self.base_url = "https://jable.tv"
        self.headers = {
            'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
            'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7',
            'Accept-Language': 'zh-TW,zh;q=0.9,en;q=0.8',
            'Accept-Encoding': 'gzip, deflate, br',
            'Connection': 'keep-alive',
            'Referer': 'https://jable.tv/',
            'Sec-Ch-Ua': '"Not_A Brand";v="8", "Chromium";v="120", "Google Chrome";v="120"',
            'Sec-Ch-Ua-Mobile': '?0',
            'Sec-Ch-Ua-Platform': '"macOS"',
            'Sec-Fetch-Dest': 'document',
            'Sec-Fetch-Mode': 'navigate',
            'Sec-Fetch-Site': 'same-origin',
            'Sec-Fetch-User': '?1',
            'Upgrade-Insecure-Requests': '1',
        }
    
    async def __aenter__(self):
        """非同步上下文管理器進入"""
        # 設定更寬鬆的 SSL 驗證和更多選項
        connector = aiohttp.TCPConnector(
            ssl=False,  # 禁用 SSL 驗證
            limit=100,
            limit_per_host=30,
            ttl_dns_cache=300,
            use_dns_cache=True
        )
        
        self.session = aiohttp.ClientSession(
            headers=self.headers,
            timeout=aiohttp.ClientTimeout(total=settings.request_timeout),
            connector=connector
        )
        return self
    
    async def __aexit__(self, exc_type, exc_val, exc_tb):
        """非同步上下文管理器退出"""
        if self.session:
            await self.session.close()
        if self.driver:
            self.driver.quit()
    
    async def fetch_page(self, url: str) -> Optional[str]:
        """非同步獲取網頁內容"""
        try:
            # 添加延遲避免過於頻繁的請求
            await asyncio.sleep(settings.delay_between_requests)
            
            async with self.session.get(url) as response:
                if response.status == 200:
                    return await response.text()
                else:
                    logger.warning(f"HTTP {response.status} for URL: {url}")
                    return None
        except Exception as e:
            logger.error(f"Error fetching {url}: {str(e)}")
            return None
    
    def fetch_page_sync(self, url: str) -> Optional[str]:
        """同步獲取網頁內容"""
        try:
            # 添加延遲
            import time
            time.sleep(settings.delay_between_requests)
            
            response = requests.get(
                url, 
                headers=self.headers, 
                timeout=settings.request_timeout,
                verify=False  # 禁用 SSL 驗證
            )
            if response.status_code == 200:
                return response.text
            else:
                logger.warning(f"HTTP {response.status_code} for URL: {url}")
                return None
        except Exception as e:
            logger.error(f"Error fetching {url}: {str(e)}")
            return None
    
    def parse_html(self, html_content: str) -> BeautifulSoup:
        """解析 HTML 內容"""
        return BeautifulSoup(html_content, 'html.parser')
    
    def fetch_page_selenium(self, url: str) -> Optional[str]:
        """使用 Selenium 獲取網頁內容"""
        try:
            if not self.driver:
                # 設定 Chrome 選項
                chrome_options = Options()
                chrome_options.add_argument('--headless')  # 無頭模式
                chrome_options.add_argument('--no-sandbox')
                chrome_options.add_argument('--disable-dev-shm-usage')
                chrome_options.add_argument('--disable-gpu')
                chrome_options.add_argument('--window-size=1920,1080')
                chrome_options.add_argument(f'--user-agent={self.headers["User-Agent"]}')
                chrome_options.add_argument('--disable-blink-features=AutomationControlled')
                chrome_options.add_experimental_option("excludeSwitches", ["enable-automation"])
                chrome_options.add_experimental_option('useAutomationExtension', False)
                
                # 設定 Chrome 路徑 (macOS)
                chrome_path = "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
                chrome_options.binary_location = chrome_path
                
                self.driver = webdriver.Chrome(options=chrome_options)
                self.driver.execute_script("Object.defineProperty(navigator, 'webdriver', {get: () => undefined})")
            
            # 訪問頁面
            self.driver.get(url)
            
            # 等待頁面加載
            time.sleep(3)
            
            # 獲取頁面內容
            page_source = self.driver.page_source
            return page_source
            
        except Exception as e:
            logger.error(f"Selenium error fetching {url}: {str(e)}")
            return None
    
    async def get_video_list(self, page: int = 1) -> Dict[str, Any]:
        """獲取中文影片列表"""
        url = f"{self.base_url}/categories/chinese-subtitle/"
        if page > 1:
            url += f"?page={page}"
        
        try:
            # 首先嘗試非同步方法
            content = await self.fetch_page(url)
            
            # 如果非同步失敗，嘗試同步方法
            if not content:
                logger.info("非同步方法失敗，嘗試同步方法...")
                content = self.fetch_page_sync(url)
            
            # 如果同步方法也失敗，嘗試 Selenium
            if not content:
                logger.info("同步方法失敗，嘗試 Selenium...")
                content = self.fetch_page_selenium(url)
            
            if not content:
                return {
                    'videos': [],
                    'total_count': 0,
                    'current_page': page,
                    'has_next_page': False,
                    'status': 'failed',
                    'error': '無法獲取網頁內容'
                }
            
            soup = self.parse_html(content)
            videos = []
            
            # 嘗試不同的選擇器來解析影片列表
            video_items = soup.find_all('div', class_='col-6 col-sm-4 col-lg-3') or \
                         soup.find_all('div', class_='video-item') or \
                         soup.find_all('div', class_='item') or \
                         soup.find_all('div', class_='video') or \
                         soup.select('.col-6.col-sm-4.col-lg-3, .video-item, .item, .video')
            
            logger.info(f"Found {len(video_items)} video items")
            
            for item in video_items:
                try:
                    # 提取影片資訊 - 根據實際 HTML 結構
                    title_elem = item.find('h6', class_='title') or \
                                item.find('h6') or \
                                item.find('h5') or \
                                item.find('h4') or \
                                item.find('a', class_='title')
                    title = title_elem.get_text(strip=True) if title_elem else ''
                    
                    img_elem = item.find('img')
                    img_src = ''
                    if img_elem:
                        # 優先獲取 data-src (懶加載圖片)，然後是 src
                        img_src = (img_elem.get('data-src') or 
                                 img_elem.get('data-original') or 
                                 img_elem.get('src') or '')
                    
                    link_elem = item.find('a')
                    video_url = link_elem.get('href', '') if link_elem else ''
                    
                    # 提取影片編號
                    video_id = ''
                    if video_url:
                        video_id_match = re.search(r'/videos/([^/]+)/?$', video_url)
                        if video_id_match:
                            video_id = video_id_match.group(1)
                    
                    # 提取時長 - 根據實際結構
                    duration_elem = item.find('span', class_='label') or \
                                   item.find('span', class_='duration') or \
                                   item.find('span', class_='time') or \
                                   item.find('div', class_='duration')
                    duration = duration_elem.get_text(strip=True) if duration_elem else ''
                    
                    if title and video_url:  # 只添加有標題和連結的項目
                        videos.append({
                            'title': title,
                            'img_src': img_src,
                            'video_url': video_url,
                            'video_id': video_id,
                            'duration': duration
                        })
                    
                except Exception as e:
                    logger.error(f"Error parsing video item: {str(e)}")
                    continue
            
            # 檢查是否有下一頁
            has_next_page = bool(soup.find('a', class_='next') or 
                               soup.find('a', string=re.compile(r'下一頁|next', re.I)))
            
            logger.info(f"Successfully parsed {len(videos)} videos")
            
            return {
                'videos': videos,
                'total_count': len(videos),
                'current_page': page,
                'has_next_page': has_next_page,
                'status': 'success'
            }
            
        except Exception as e:
            logger.error(f"Error getting video list: {str(e)}")
            return {
                'videos': [],
                'total_count': 0,
                'current_page': page,
                'has_next_page': False,
                'status': 'error',
                'error': str(e)
            }
    
    async def get_video_detail(self, video_id: str) -> Dict[str, Any]:
        """獲取影片詳情"""
        url = f"{self.base_url}/videos/{video_id}/"
        
        try:
            # 首先嘗試非同步方法
            content = await self.fetch_page(url)
            
            # 如果非同步失敗，嘗試同步方法
            if not content:
                logger.info("非同步方法失敗，嘗試同步方法...")
                content = self.fetch_page_sync(url)
            
            # 如果同步方法也失敗，嘗試 Selenium
            if not content:
                logger.info("同步方法失敗，嘗試 Selenium...")
                content = self.fetch_page_selenium(url)
            
            if not content:
                return {
                    'video_id': video_id,
                    'status': 'failed',
                    'error': '無法獲取影片內容'
                }
            
            soup = self.parse_html(content)
            
            # 提取影片標題 - 根據實際 HTML 結構
            title_elem = soup.find('h4')
            title = title_elem.get_text(strip=True) if title_elem else ''
            
            # 提取描述 - 根據實際 HTML 結構
            desc_elem = soup.find('h5', class_='desc')
            description = desc_elem.get_text(strip=True) if desc_elem else ''
            
            # 提取時長 - 從頁面中查找第一個時間格式
            duration = ''
            time_spans = soup.find_all('span', string=re.compile(r'\d{1,2}:\d{2}:\d{2}'))
            if time_spans:
                duration = time_spans[0].get_text(strip=True)
            
            # 提取發布日期 - 從頁面中查找
            release_date = ''
            time_elem = soup.find('span', string=re.compile(r'\d+\s*小時前|\d+\s*天前'))
            if time_elem:
                release_date = time_elem.get_text(strip=True)
            
            # 提取封面圖片
            img_src = ''
            img_elem = soup.find('img', {'id': 'player-cover'}) or \
                      soup.find('img', class_='poster') or \
                      soup.find('div', class_='player-container').find('img') if soup.find('div', class_='player-container') else None
            if img_elem:
                img_src = img_elem.get('src', '') or img_elem.get('data-src', '')
            
            # 提取演員資訊 - 根據實際 HTML 結構
            actor = ''
            actor_url = ''
            actor_link = soup.find('a', class_='model')
            if actor_link:
                actor = actor_link.get_text(strip=True)
                actor_url = actor_link.get('href', '')
            
            # 提取播放連結和金鑰
            play_url = ''
            play_key = ''

            # 優先從 script 中解析 hlsUrl / playUrl / m3u8
            scripts = soup.find_all('script')
            for script in scripts:
                script_text = script.string or ''
                if not script_text:
                    continue

                # 1) 直接變數指定的 hlsUrl
                hls_assign = re.search(r"hlsUrl\s*=\s*['\"]([^'\"]+?\.m3u8)['\"]", script_text)
                if hls_assign:
                    play_url = hls_assign.group(1)
                    break

                # 2) 結構化的 playUrl/playKey
                if 'playUrl' in script_text or 'playKey' in script_text:
                    play_url_match = re.search(r'playUrl["\']?\s*[:=]\s*["\']([^"\']+)["\']', script_text)
                    if play_url_match:
                        play_url = play_url_match.group(1)
                    play_key_match = re.search(r'playKey["\']?\s*[:=]\s*["\']([^"\']+)["\']', script_text)
                    if play_key_match:
                        play_key = play_key_match.group(1)
                    if play_url:
                        break

            # 3) 從整頁文字兜底擷取 m3u8 連結
            if not play_url:
                page_text = content
                any_m3u8 = re.search(r"https?://[^'\"\s]+?\.m3u8", page_text)
                if any_m3u8:
                    play_url = any_m3u8.group(0)

            # 從 play_url 中嘗試萃取金鑰（常見為 /hls/<token>/<expires>/...）或 query 中的 token/key
            if play_url and not play_key:
                token_in_path = re.search(r"/hls/([^/]+)/\d+/", play_url)
                if token_in_path:
                    play_key = token_in_path.group(1)
                else:
                    token_in_query = re.search(r"(?:token|key)=([^&]+)", play_url)
                    if token_in_query:
                        play_key = token_in_query.group(1)
            
            status_value = 'success' if (title or actor or play_url) else 'failed'

            return {
                'video_id': video_id,
                'title': title,
                'description': description,
                'img_src': img_src,
                'duration': duration,
                'release_date': release_date,
                'actor': actor,
                'actor_url': actor_url,
                'play_url': play_url,
                'play_key': play_key,
                'status': status_value
            }
            
        except Exception as e:
            logger.error(f"Error getting video detail: {str(e)}")
            return {
                'video_id': video_id,
                'status': 'error',
                'error': str(e)
            }
    
    async def get_actor_videos(self, actor_url: str, page: int = 1) -> Dict[str, Any]:
        """獲取演員相關影片"""
        try:
            # 處理分頁 URL
            if page > 1:
                if '?' in actor_url:
                    actor_url = f"{actor_url}&page={page}"
                else:
                    actor_url = f"{actor_url}?page={page}"
            
            # 先嘗試非同步請求
            content = await self.fetch_page(actor_url)
            # 失敗則同步
            if not content:
                logger.info("非同步方法失敗，嘗試同步方法(演員頁)...")
                content = self.fetch_page_sync(actor_url)
            # 再失敗則 Selenium
            if not content:
                logger.info("同步方法失敗，嘗試 Selenium(演員頁)...")
                content = self.fetch_page_selenium(actor_url)
            if not content:
                return {
                    'actor_name': '',
                    'videos': [],
                    'total_count': 0,
                    'current_page': page,
                    'total_pages': 1,
                    'status': 'failed',
                    'error': '無法獲取演員頁面'
                }
            
            soup = self.parse_html(content)
            
            # 提取演員名稱
            actor_name_elem = soup.find('h1', class_='actor-name')
            actor_name = actor_name_elem.get_text(strip=True) if actor_name_elem else ''
            
            # 提取演員影片列表
            videos = []
            video_items = soup.find_all('div', class_='col-6 col-sm-4 col-lg-3') or \
                         soup.find_all('div', class_='video-item') or \
                         soup.find_all('div', class_='item') or \
                         soup.find_all('div', class_='video') or \
                         soup.select('.col-6.col-sm-4.col-lg-3, .video-item, .item, .video')
            
            for item in video_items:
                try:
                    # 與列表頁一致的解析
                    title_elem = item.find('h6', class_='title') or \
                                item.find('h6') or \
                                item.find('a', class_='title')
                    title = title_elem.get_text(strip=True) if title_elem else ''
                    
                    img_elem = item.find('img')
                    img_src = ''
                    if img_elem:
                        # 優先獲取 data-src (懶加載圖片)，然後是 src
                        img_src = (img_elem.get('data-src') or 
                                 img_elem.get('data-original') or 
                                 img_elem.get('src') or '')
                    
                    link_elem = item.find('a')
                    video_url = link_elem.get('href', '') if link_elem else ''
                    
                    video_id = ''
                    if video_url:
                        video_id_match = re.search(r'/videos/([^/]+)/?$', video_url)
                        if video_id_match:
                            video_id = video_id_match.group(1)
                    
                    duration_elem = item.find('span', class_='label') or \
                                   item.find('span', class_='duration') or \
                                   item.find('span', class_='time')
                    duration = duration_elem.get_text(strip=True) if duration_elem else ''
                    
                    if title and video_url:
                        videos.append({
                            'title': title,
                            'img_src': img_src,
                            'video_url': video_url,
                            'video_id': video_id,
                            'duration': duration
                        })
                except Exception as e:
                    logger.error(f"Error parsing actor video item: {str(e)}")
                    continue
            
            return {
                'actor_name': actor_name,
                'videos': videos,
                'total_count': len(videos),
                'current_page': page,
                'total_pages': 1,  # 暫時設為1，可以後續優化
                'status': 'success'
            }
            
        except Exception as e:
            logger.error(f"Error getting actor videos: {str(e)}")
            return {
                'actor_name': '',
                'videos': [],
                'total_count': 0,
                'current_page': page,
                'total_pages': 1,
                'status': 'error',
                'error': str(e)
            }
