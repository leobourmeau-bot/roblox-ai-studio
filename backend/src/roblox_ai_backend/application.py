"""FastAPI application construction."""

from fastapi import FastAPI

from roblox_ai_backend.api.router import create_api_router
from roblox_ai_backend.config import AppSettings


def create_app(settings: AppSettings | None = None) -> FastAPI:
    """Create an isolated backend application.

    Args:
        settings: Optional immutable metadata for the application instance.

    Returns:
        A fully configured FastAPI application.
    """
    resolved_settings = settings if settings is not None else AppSettings()
    application = FastAPI(
        title=resolved_settings.title,
        version=resolved_settings.version,
        description="Backend service for the Roblox AI Studio assistant.",
    )
    application.include_router(create_api_router())
    return application
