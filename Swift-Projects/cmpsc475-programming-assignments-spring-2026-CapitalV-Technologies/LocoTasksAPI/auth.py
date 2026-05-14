from uuid import uuid4
from typing import Optional

import bcrypt
from fastapi import HTTPException, Depends, status
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials

from models import User, Token
from database import get_all_users, get_all_tokens, save_tokens


security = HTTPBearer()

BCRYPT_MAX_PASSWORD_BYTES = 72


def _password_bytes(password: str) -> bytes:
    """
    Convert a password string to a bytes object
    """
    raw = password.encode("utf-8")
    # If the password is longer than the max password bytes, truncate it
    rtn = raw[:BCRYPT_MAX_PASSWORD_BYTES] if len(raw) > BCRYPT_MAX_PASSWORD_BYTES else raw
    return rtn


def hash_password(password: str) -> str:
    """
    Hash a password using bcrypt
    """
    return bcrypt.hashpw(_password_bytes(password), bcrypt.gensalt()).decode("utf-8")


def verify_password(password: str, password_hash: str) -> bool:
    """
    Verify a password against a password hash using bcrypt
    """
    return bcrypt.checkpw(_password_bytes(password), password_hash.encode("utf-8"))


########################################################
#
# Authentication functions
# These are helper functions for the authentication process
#
########################################################

async def find_user_by_email(email: str) -> Optional[User]:
    """
    Find a user by email
    """
    users = await get_all_users()
    for user in users:
        if user.email == email:
            return user
    return None


async def find_user_by_id(user_id: str) -> Optional[User]:
    """
    Find a user by ID
    """
    users = await get_all_users()
    for user in users:
        if user.id == user_id:
            return user
    return None


async def create_token_for_user(user_id: str) -> str:
    """
    Create a token for a user
    """
    tokens = await get_all_tokens()
    token_value = str(uuid4())
    tokens.append(Token(token=token_value, user_id=user_id))
    await save_tokens(tokens)
    return token_value


async def find_user_by_token(token: str) -> Optional[User]:
    """
    Find a user by token
    """
    tokens = await get_all_tokens()
    for entry in tokens:
        if entry.token == token:
            return await find_user_by_id(entry.user_id)
    return None


async def get_current_user(credentials: HTTPAuthorizationCredentials = Depends(security)) -> User:
    """
    Get the current user from the token
    """
    token = credentials.credentials
    user = await find_user_by_token(token)
    if user is None:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid or expired token"
        )
    return user
