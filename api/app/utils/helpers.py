import re
from typing import List, Dict, Any
from urllib.parse import urlparse, urljoin


def is_valid_url(url: str) -> bool:
    """驗證 URL 是否有效"""
    try:
        result = urlparse(url)
        return all([result.scheme, result.netloc])
    except:
        return False


def clean_text(text: str) -> str:
    """清理文字內容"""
    if not text:
        return ""
    
    # 移除多餘的空白字元
    text = re.sub(r'\s+', ' ', text.strip())
    # 移除特殊字元
    text = re.sub(r'[^\w\s\u4e00-\u9fff]', '', text)
    return text


def extract_links(html_content: str, base_url: str) -> List[str]:
    """從 HTML 內容中提取連結"""
    import re
    links = []
    
    # 簡單的正則表達式提取 href
    href_pattern = r'href=["\']([^"\']+)["\']'
    matches = re.findall(href_pattern, html_content)
    
    for match in matches:
        if match.startswith('http'):
            links.append(match)
        elif match.startswith('/'):
            links.append(urljoin(base_url, match))
    
    return list(set(links))  # 移除重複


def format_scraping_result(url: str, title: str, content: str, status: str, error: str = None) -> Dict[str, Any]:
    """格式化爬蟲結果"""
    return {
        'url': url,
        'title': clean_text(title),
        'content': clean_text(content),
        'status': status,
        'error': error,
        'content_length': len(content) if content else 0
    }
