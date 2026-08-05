"""Service health endpoint."""

from fastapi import APIRouter, status

from roblox_ai_backend.schemas.health import HealthResponse


def get_health() -> HealthResponse:
    """Report that the process is ready to serve requests."""
    return HealthResponse()


def create_health_router() -> APIRouter:
    """Create the health router without retaining mutable module state."""
    router = APIRouter(tags=["health"])
    router.add_api_route(
        "/health",
        get_health,
        methods=["GET"],
        response_model=HealthResponse,
        status_code=status.HTTP_200_OK,
        summary="Check service health",
    )
    return router
