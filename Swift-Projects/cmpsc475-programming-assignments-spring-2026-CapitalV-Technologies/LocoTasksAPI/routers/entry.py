from operator import ne
from uuid import uuid4

from fastapi import APIRouter, HTTPException, Depends, status

from models import EntryCreate, Entry, User
from database import get_all_entries, save_entries
from auth import get_current_user

router = APIRouter()


@router.get("/entries", tags=["entries"])
async def get_entries(current_user: User = Depends(get_current_user)):
    entries = await get_all_entries()
    user_entries = [t for t in entries if current_user.id == t.owner_id]
    return user_entries


@router.post("/entries", tags=["entries"])
async def create_entry(entry: EntryCreate, current_user : User = Depends(get_current_user)):
    entries = await get_all_entries()
    print(entries)
    new_entry = Entry(
        id= str(uuid4()),
        title= entry.title,
        date= entry.date,
        journalEntry= entry.journalEntry,
        emotion= entry.emotion,
        longitude = entry.longitude,
        latitude = entry.latitude,
        owner_id=current_user.id
    )
    entries.append(new_entry)
    await save_entries(entries)
    return new_entry


@router.delete("/entries/{entry_id}", tags=["entries"])
async def delete_entry(entry_id: str, current_user: User = Depends(get_current_user)):
    entries = await get_all_entries()
    for i, existing_entry in enumerate(entries):
        if existing_entry.id == entry_id:
            if existing_entry.owner_id != current_user.id:
                raise HTTPException(
                    status_code=status.HTTP_403_FORBIDDEN,
                    detail="Not allowed to delete this entry"
                )
            entries.pop(i)
            await save_entries(entries)
            return {"msg": "Task deleted successfully"}
    raise HTTPException(
        status_code=status.HTTP_404_NOT_FOUND,
        detail="Entry not found"
    )
