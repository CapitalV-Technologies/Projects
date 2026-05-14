from operator import ne
from uuid import uuid4

from fastapi import APIRouter, HTTPException, Depends, status

from models import Group, GroupCreate, User, AddMember
from database import get_all_groups, save_groups
from auth import get_current_user, find_user_by_id, find_user_by_email

router = APIRouter()


@router.get("/groups", tags=["groups"])
async def get_groups(current_user: User = Depends(get_current_user)):
    groups = await get_all_groups()
    # Get all current groups that user is in, even if not owner.
    user_groups = [t for t in groups for i in t.members if i == current_user.email]
    return user_groups
    
@router.get("/members/(group_id)", tags=["groups"])
async def get_members(group_id: str, current_user: User = Depends(get_current_user)):
    groups = await get_all_groups()
    group = [t for t in groups if group_id == t.id]
    return group.members


@router.post("/groups", tags=["groups"])
async def create_group(group: GroupCreate, current_user : User = Depends(get_current_user)):
    print(GroupCreate)
    groups = await get_all_groups()
    print(groups)
    #Check if group has same name
    for i in groups:
        if i.title == group.title:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="You already have a group named that!"
            )
    user = await find_user_by_id(current_user.id)
    new_group = Group(
        id= str(uuid4()),
        title= group.title,
        owner_id=current_user.id,
        members= [user.email]
    )
    groups.append(new_group)
    await save_groups(groups)
    return new_group
    
    

@router.delete("/groups/{group_title}", tags=["groups"])
async def delete_group(group_title: str, current_user: User = Depends(get_current_user)):
    groups = await get_all_groups()
    for i, existing_group in enumerate(groups):
        if existing_group.title == group_title:
            if existing_group.owner_id != current_user.id:
                raise HTTPException(
                    status_code=status.HTTP_403_FORBIDDEN,
                    detail="Not allowed to delete this group. You are not the owner"
                )
            groups.pop(i)
            await save_groups(groups)
            return {"msg": "Group deleted successfully"}
    raise HTTPException(
        status_code=status.HTTP_404_NOT_FOUND,
        detail="Group not found"
    )


@router.put("/groups/{user_email}", tags=["groups"])
async def add_member(user_email: str, group: Group, current_user: User = Depends(get_current_user)):
    #Check for valid email first
    user = await find_user_by_email(user_email)
    if user == None:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not a valid email. No user Found. "
        )
    groups = await get_all_groups()
    for i, existing_group in enumerate(groups):
        if existing_group.id == group.id:
            if existing_group.owner_id != current_user.id:
                raise HTTPException(
                    status_code=status.HTTP_403_FORBIDDEN,
                    detail="Not allowed to update this group"
                )
            updated_members = existing_group.members + [user_email]
            updated_group = existing_group.model_copy(
                update={"members": updated_members }
            )
            groups[i] = updated_group
            await save_groups(groups)
            return updated_group
    raise HTTPException(
        status_code=status.HTTP_404_NOT_FOUND,
        detail="Group not found"
    )


#@router.patch("/tasks/{task_id}/complete", tags=["tasks"])
#async def complete_task(task_id: str, current_user: User = Depends(get_current_user)):
#    tasks = await get_all_tasks()
#    for i, existing_task in enumerate(tasks):
#        if existing_task.id == task_id:
#            if existing_task.owner_id != current_user.id:
#                raise HTTPException(
#                    status_code=status.HTTP_403_FORBIDDEN,
#                    detail="Not allowed to modify this task"
#                )
#            tasks[i] = existing_task.model_copy(update={"completed": True})
#            await save_tasks(tasks)
#            return tasks[i]
#    raise HTTPException(
#        status_code=status.HTTP_404_NOT_FOUND,
#        detail="Task not found"
#    )


#@router.patch("/tasks/{task_id}/incomplete", tags=["tasks"])
#async def incomplete_task(task_id: str, current_user: User = Depends(get_current_user)):
#    tasks = await get_all_tasks()
#    for i, existing_task in enumerate(tasks):
#        if existing_task.id == task_id:
#            if existing_task.owner_id != current_user.id:
#                raise HTTPException(
#                    status_code=status.HTTP_403_FORBIDDEN,
#                    detail="Not allowed to modify this task"
#                )
#            tasks[i] = existing_task.model_copy(update={"completed": False})
#            await save_tasks(tasks)
#            return tasks[i]
#    raise HTTPException(
#        status_code=status.HTTP_404_NOT_FOUND,
#        detail="Task not found"
#    )
