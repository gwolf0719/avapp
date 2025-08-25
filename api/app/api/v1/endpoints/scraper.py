from fastapi import APIRouter, HTTPException, Query
from app.schemas.scraper import (
    VideoListResponse,
    VideoDetailRequest,
    VideoDetailResponse,
    ActorVideosRequest,
    ActorVideosResponse,
    ScrapeStatus
)
from app.core.scraper import JableScraper
import logging

logger = logging.getLogger(__name__)
router = APIRouter()


@router.get("/videos", response_model=VideoListResponse)
async def get_video_list(page: int = Query(1, ge=1, description="頁碼")):
    """獲取中文影片列表"""
    try:
        async with JableScraper() as scraper:
            result = await scraper.get_video_list(page)
        
        if result['status'] == 'success':
            # 轉換字段名稱以匹配新的 schema
            converted_videos = []
            for video in result['videos']:
                converted_videos.append({
                    'videoId': video.get('video_id'),
                    'title': video.get('title'),
                    'imageUrl': video.get('img_src'),
                    'videoUrl': video.get('video_url'),
                    'duration': video.get('duration')
                })
            
            return VideoListResponse(
                status=result['status'],
                videos=converted_videos,
                totalCount=result['total_count'],
                currentPage=result['current_page'],
                totalPages=result.get('total_pages', 1)
            )
        else:
            raise HTTPException(status_code=500, detail=result.get('error', '獲取影片列表失敗'))
            
    except Exception as e:
        logger.error(f"Video list error: {str(e)}")
        raise HTTPException(status_code=500, detail=f"獲取影片列表失敗: {str(e)}")


@router.post("/video/detail", response_model=VideoDetailResponse)
async def get_video_detail(request: VideoDetailRequest):
    """獲取影片詳情"""
    try:
        async with JableScraper() as scraper:
            result = await scraper.get_video_detail(request.videoId)
        
        if result['status'] == 'success':
            return VideoDetailResponse(
                status=result['status'],
                title=result.get('title'),
                description=result.get('description'),
                imageUrl=result.get('img_src'),
                duration=result.get('duration'),
                releaseDate=result.get('release_date'),
                actor=result.get('actor'),
                actorUrl=result.get('actor_url'),
                playUrl=result.get('play_url'),
                playKey=result.get('play_key')
            )
        else:
            return VideoDetailResponse(
                status=result['status'],
                error=result.get('error', '獲取影片詳情失敗')
            )
            
    except Exception as e:
        logger.error(f"Video detail error: {str(e)}")
        raise HTTPException(status_code=500, detail=f"獲取影片詳情失敗: {str(e)}")


@router.post("/actor/videos", response_model=ActorVideosResponse)
async def get_actor_videos(request: ActorVideosRequest):
    """獲取演員相關影片"""
    try:
        async with JableScraper() as scraper:
            result = await scraper.get_actor_videos(request.actorUrl, request.page)
        
        if result['status'] == 'success':
            # 轉換字段名稱以匹配新的 schema
            converted_videos = []
            for video in result['videos']:
                converted_videos.append({
                    'videoId': video.get('video_id'),
                    'title': video.get('title'),
                    'imageUrl': video.get('img_src'),
                    'videoUrl': video.get('video_url'),
                    'duration': video.get('duration')
                })
            
            return ActorVideosResponse(
                status=result['status'],
                actorName=result.get('actor_name'),
                videos=converted_videos,
                totalCount=result['total_count'],
                currentPage=result.get('current_page', 1),
                totalPages=result.get('total_pages', 1)
            )
        else:
            return ActorVideosResponse(
                status=result['status'],
                actorName=None,
                videos=[],
                totalCount=0,
                currentPage=1,
                totalPages=1,
                error=result.get('error', '獲取演員影片失敗')
            )
            
    except Exception as e:
        logger.error(f"Actor videos error: {str(e)}")
        raise HTTPException(status_code=500, detail=f"獲取演員影片失敗: {str(e)}")


@router.get("/health", response_model=ScrapeStatus)
async def health_check():
    """健康檢查端點"""
    return ScrapeStatus(
        status="healthy",
        message="Jable.tv 爬蟲服務運行正常"
    )
