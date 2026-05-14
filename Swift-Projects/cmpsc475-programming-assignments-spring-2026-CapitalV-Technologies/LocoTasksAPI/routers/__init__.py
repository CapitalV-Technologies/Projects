from .health import router as health_router
from .auth import router as auth_router
from .tasks import router as tasks_router
from .entry import router as entry_router
from .groups import router as groups_router

__all__ = ["health_router", "auth_router", "tasks_router", "entry_router", "groups_router"]
