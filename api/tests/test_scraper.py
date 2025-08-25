import pytest
from httpx import AsyncClient
from app.main import app


@pytest.mark.asyncio
async def test_health_check():
    """測試健康檢查端點"""
    async with AsyncClient(app=app, base_url="http://test") as ac:
        response = await ac.get("/api/v1/scraper/health")
        assert response.status_code == 200
        data = response.json()
        assert data["status"] == "healthy"


@pytest.mark.asyncio
async def test_get_video_list():
    """測試獲取影片列表"""
    async with AsyncClient(app=app, base_url="http://test") as ac:
        response = await ac.get("/api/v1/scraper/videos?page=1")
        assert response.status_code == 200
        data = response.json()
        assert "videos" in data
        assert "total_count" in data
        assert "current_page" in data
        assert "has_next_page" in data


@pytest.mark.asyncio
async def test_get_video_detail():
    """測試獲取影片詳情"""
    test_video_id = "test-123"
    async with AsyncClient(app=app, base_url="http://test") as ac:
        response = await ac.post("/api/v1/scraper/video/detail", json={"video_id": test_video_id})
        assert response.status_code == 200
        data = response.json()
        assert data["video_id"] == test_video_id
        assert "status" in data


@pytest.mark.asyncio
async def test_get_actor_videos():
    """測試獲取演員影片"""
    test_actor_url = "https://jable.tv/actors/test-actor/"
    async with AsyncClient(app=app, base_url="http://test") as ac:
        response = await ac.post("/api/v1/scraper/actor/videos", json={"actor_url": test_actor_url})
        assert response.status_code == 200
        data = response.json()
        assert "actor_name" in data
        assert "videos" in data
        assert "total_count" in data
        assert "status" in data


@pytest.mark.asyncio
async def test_get_video_detail_empty_id():
    """測試空影片編號"""
    async with AsyncClient(app=app, base_url="http://test") as ac:
        response = await ac.post("/api/v1/scraper/video/detail", json={"video_id": ""})
        assert response.status_code == 422  # 驗證錯誤


@pytest.mark.asyncio
async def test_get_actor_videos_empty_url():
    """測試空演員連結"""
    async with AsyncClient(app=app, base_url="http://test") as ac:
        response = await ac.post("/api/v1/scraper/actor/videos", json={"actor_url": ""})
        assert response.status_code == 422  # 驗證錯誤
