from uuid import uuid4

from fastapi import APIRouter, HTTPException, status

from models import UserSignup, UserLogin, TokenResponse, User
from database import get_all_users, save_users
from auth import (
    hash_password,
    verify_password,
    find_user_by_email,
    create_token_for_user,
)

router = APIRouter()


@router.post("/signup", response_model=TokenResponse, status_code=status.HTTP_201_CREATED, tags=["auth"])
async def signup(payload: UserSignup):
    existing_user = await find_user_by_email(payload.email)
    if existing_user is not None:
        raise HTTPException(
            status_code= status.HTTP_400_BAD_REQUEST,
            detail="Email already registred"
       )

    users = await get_all_users()
    new_user = User(
        id=str(uuid4()) ,
        email= payload.email,
        password_hash= hash_password(payload.password)
    )
    users.append(new_user)
    await save_users(users)

    token = await create_token_for_user(new_user.id)
    return TokenResponse(access_token=token)


@router.post("/login", response_model=TokenResponse, tags=["auth"])
async def login(payload: UserLogin):
    user = await find_user_by_email(payload.email)
    if user is None or not verify_password(payload.password, user.password_hash):
        raise HTTPException(
            status_code= status.HTTP_401_UNAUTHORIZED,
            detail="Invalid email or password"
       )
    
    token = await create_token_for_user(user.id)
    return TokenResponse(access_token=token)





