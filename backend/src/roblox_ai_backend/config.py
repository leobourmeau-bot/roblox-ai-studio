"""Immutable backend configuration."""

from dataclasses import dataclass


@dataclass(frozen=True, slots=True)
class AppSettings:
    """Metadata used to construct one application instance."""

    title: str = "Roblox AI Backend"
    version: str = "0.1.0"
