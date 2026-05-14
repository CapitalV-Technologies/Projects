from contextlib import asynccontextmanager

from fastapi import FastAPI
from pickledb import PickleDB

from models import Task, User, Token, Entry, Group


db = PickleDB("taskly.db")


@asynccontextmanager
async def lifespan(app: FastAPI):
    await db.load()

    if await db.get("tasks") is None:
        await db.set("tasks", [])

    if await db.get("users") is None:
        await db.set("users", [])

    if await db.get("tokens") is None:
        await db.set("tokens", [])
        
    if await db.get("entries") is None:
        await db.set("entries", [])
        
    if await db.get("groups") is None:
        await db.set("groups", [])

    print("Database loaded and initialized.")
    yield
    print("Saving database...")
    await db.save()
    print("Goodbye!")


async def get_all_tasks() -> list[Task]:
    raw = await db.get("tasks") or []
    return [Task.model_validate(t) for t in raw]


async def get_all_groups() -> list[Group]:
    raw = await db.get("groups") or []
    return [Group.model_validate(t) for t in raw]


async def get_all_entries() -> list[Entry]:
    raw = await db.get("entries") or []
    return [Entry.model_validate(t) for t in raw]


async def get_all_users() -> list[User]:
    raw = await db.get("users") or []
    return [User.model_validate(u) for u in raw]


async def get_all_tokens() -> list[Token]:
    raw = await db.get("tokens") or []
    return [Token.model_validate(t) for t in raw]


async def save_tasks(tasks: list[Task]) -> None:
    await db.set("tasks", [t.model_dump() for t in tasks])
    await db.save()


async def save_entries(entries: list[Entry]) -> None:
    await db.set("entries", [t.model_dump() for t in entries])
    await db.save()


async def save_groups(groups: list[Group]) -> None:
    await db.set("groups", [t.model_dump() for t in groups])
    await db.save()


async def save_users(users: list[User]) -> None:
    await db.set("users", [u.model_dump() for u in users])
    await db.save()


async def save_tokens(tokens: list[Token]) -> None:
    await db.set("tokens", [t.model_dump() for t in tokens])
    await db.save()
