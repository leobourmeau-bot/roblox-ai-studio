"""Contract tests for the backend application."""

from fastapi.testclient import TestClient

from roblox_ai_backend.application import create_app
from roblox_ai_backend.config import AppSettings


def test_health_returns_exact_ok_contract() -> None:
    """The health endpoint returns only the public readiness contract."""
    with TestClient(create_app()) as client:
        response = client.get("/health")

    assert response.status_code == 200
    assert response.json() == {"status": "ok"}


def test_application_factory_uses_explicit_settings() -> None:
    """Each application can receive isolated immutable metadata."""
    application = create_app(AppSettings(title="Test Backend", version="9.9.9"))

    assert application.title == "Test Backend"
    assert application.version == "9.9.9"
