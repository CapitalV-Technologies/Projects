from operator import ne
from uuid import uuid4

from fastapi import APIRouter, HTTPException, Depends, status

from models import TaskCreate, TaskUpdate, Task, User
from database import get_all_tasks, save_tasks
from auth import get_current_user, find_user_by_email

router = APIRouter()


@router.get("/tasks", tags=["tasks"])
async def get_tasks(current_user: User = Depends(get_current_user)):
    tasks = await get_all_tasks()
    user_tasks = [t for t in tasks if current_user.id == t.owner_id]
    return user_tasks
    
@router.get("/tasks/email/{email}", tags=["tasks"])
async def get_tasks_by_email(email: str, current_user: User = Depends(get_current_user)):
    tasks = await get_all_tasks()
    user = await find_user_by_email(email)
    user_tasks = [t for t in tasks if user.id == t.owner_id]
    return user_tasks


@router.post("/tasks", tags=["tasks"])
async def create_task(task: TaskCreate, current_user : User = Depends(get_current_user)):
    tasks = await get_all_tasks()
    print(tasks)
    new_task = Task(
        id= str(uuid4()),
        title= task.title,
        description=task.description,
        difficulty = task.difficulty,
        longitude = task.longitude,
        latitude = task.latitude,
        completed=False,
        owner_id=current_user.id
    )
    tasks.append(new_task)
    await save_tasks(tasks)
    return new_task
    
@router.post("/tasks/{email}", tags=["tasks"])
async def create_members_task(email: str, task: TaskCreate, current_user : User = Depends(get_current_user)):
    tasks = await get_all_tasks()
    user = await find_user_by_email(email)
    print(tasks)
    new_task = Task(
        id= str(uuid4()),
        title= task.title,
        description=task.description,
        difficulty = task.difficulty,
        longitude = task.longitude,
        latitude = task.latitude,
        completed=False,
        owner_id= user.id
    )
    tasks.append(new_task)
    await save_tasks(tasks)
    return new_task


@router.put("/tasks/{task_id}", tags=["tasks"])
async def update_task(task_id: str, task: TaskUpdate, current_user: User = Depends(get_current_user)):
    tasks = await get_all_tasks()
    for i, existing_task in enumerate(tasks):
        if existing_task.id == task_id:
            if existing_task.owner_id != current_user.id:
                raise HTTPException(
                    status_code=status.HTTP_403_FORBIDDEN,
                    detail="Not allowed to update this task"
                )
            updated_task = existing_task.model_copy(
                update={"title": task.title, "description": task.description,"difficulty": task.difficulty, "longitude": task.longitude, "latitude": task.latitude, "completed": task.completed}
            )
            tasks[i] = updated_task
            await save_tasks(tasks)
            return updated_task
    raise HTTPException(
        status_code=status.HTTP_404_NOT_FOUND,
        detail="Task not found"
    )


@router.delete("/tasks/{task_id}", tags=["tasks"])
async def delete_task(task_id: str, current_user: User = Depends(get_current_user)):
    tasks = await get_all_tasks()
    for i, existing_task in enumerate(tasks):
        if existing_task.id == task_id:
            if existing_task.owner_id != current_user.id:
                raise HTTPException(
                    status_code=status.HTTP_403_FORBIDDEN,
                    detail="Not allowed to delete this task"
                )
            tasks.pop(i)
            await save_tasks(tasks)
            return {"msg": "Task deleted successfully"}
    raise HTTPException(
        status_code=status.HTTP_404_NOT_FOUND,
        detail="Task not found"
    )


@router.patch("/tasks/{task_id}/complete", tags=["tasks"])
async def complete_task(task_id: str, current_user: User = Depends(get_current_user)):
    tasks = await get_all_tasks()
    for i, existing_task in enumerate(tasks):
        if existing_task.id == task_id:
            if existing_task.owner_id != current_user.id:
                raise HTTPException(
                    status_code=status.HTTP_403_FORBIDDEN,
                    detail="Not allowed to modify this task"
                )
            tasks[i] = existing_task.model_copy(update={"completed": True})
            await save_tasks(tasks)
            return tasks[i]
    raise HTTPException(
        status_code=status.HTTP_404_NOT_FOUND,
        detail="Task not found"
    )


@router.patch("/tasks/{task_id}/incomplete", tags=["tasks"])
async def incomplete_task(task_id: str, current_user: User = Depends(get_current_user)):
    tasks = await get_all_tasks()
    for i, existing_task in enumerate(tasks):
        if existing_task.id == task_id:
            if existing_task.owner_id != current_user.id:
                raise HTTPException(
                    status_code=status.HTTP_403_FORBIDDEN,
                    detail="Not allowed to modify this task"
                )
            tasks[i] = existing_task.model_copy(update={"completed": False})
            await save_tasks(tasks)
            return tasks[i]
    raise HTTPException(
        status_code=status.HTTP_404_NOT_FOUND,
        detail="Task not found"
    )
