from pydantic import BaseModel, validator
from typing import List, Optional, Dict, Any


class VideoListItem(BaseModel):
    """影片列表項目模型"""
    videoId: str
    title: str
    imageUrl: str
    videoUrl: str
    duration: Optional[str] = None


class VideoListResponse(BaseModel):
    """影片列表回應模型"""
    status: str
    videos: List[VideoListItem]
    totalCount: int
    currentPage: int
    totalPages: int
    error: Optional[str] = None


class VideoDetailRequest(BaseModel):
    """影片詳情請求模型"""
    videoId: str
    
    @validator('videoId')
    def validate_video_id(cls, v):
        if not v:
            raise ValueError('影片編號不能為空')
        return v


class VideoDetailResponse(BaseModel):
    """影片詳情回應模型"""
    status: str
    title: Optional[str] = None
    description: Optional[str] = None
    imageUrl: Optional[str] = None
    duration: Optional[str] = None
    releaseDate: Optional[str] = None
    actor: Optional[str] = None
    actorUrl: Optional[str] = None
    playUrl: Optional[str] = None
    playKey: Optional[str] = None
    error: Optional[str] = None


class ActorVideosRequest(BaseModel):
    """演員影片請求模型"""
    actorUrl: str
    page: int = 1
    
    @validator('actorUrl')
    def validate_actor_url(cls, v):
        if not v:
            raise ValueError('演員連結不能為空')
        return v


class ActorVideosResponse(BaseModel):
    """演員影片回應模型"""
    status: str
    actorName: Optional[str] = None
    videos: List[VideoListItem]
    totalCount: int
    currentPage: int
    totalPages: int
    error: Optional[str] = None


class ScrapeStatus(BaseModel):
    """爬蟲狀態模型"""
    status: str
    message: str
    data: Optional[Dict[str, Any]] = None
