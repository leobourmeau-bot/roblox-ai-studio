"""Top-level API router construction."""

from fastapi import APIRouter

from roblox_ai_backend.api.routes.health import create_health_router


def create_api_router() -> APIRouter:
    """Create a router containing every public API route."""
    router = APIRouter()
    router.include_router(create_health_router())
    return router
