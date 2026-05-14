from fastapi import FastAPI

from database import lifespan
from routers import health_router, auth_router, tasks_router, entry_router, groups_router

app = FastAPI(lifespan=lifespan)

app.include_router(health_router)
app.include_router(auth_router)
app.include_router(tasks_router)
app.include_router(entry_router)
app.include_router(groups_router)
