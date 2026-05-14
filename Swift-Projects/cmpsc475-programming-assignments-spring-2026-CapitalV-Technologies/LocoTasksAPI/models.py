from pydantic import BaseModel, Field, EmailStr

########################################################
#
# DB entities
# These are the models for the database entities
#
########################################################
class User(BaseModel):
    id: str
    email: EmailStr
    password_hash: str
    
class Group(BaseModel):
    id: str
    title: str
    owner_id: str
    members: list[EmailStr]

class Task(BaseModel):
    id: str
    title: str
    description: str
    difficulty: float
    longitude: float
    latitude: float
    completed: bool
    owner_id: str
    
class Entry(BaseModel):
    id: str
    title: str
    date: str
    journalEntry: str
    emotion: str
    longitude: float
    latitude: float
    owner_id: str


class Token(BaseModel):
    token: str
    user_id: str

########################################################
#
# API request/response schemas
# These are models for the API requests and responses
# These are NOT stored in the database
#
########################################################
class UserSignup(BaseModel):
    email: EmailStr
    password: str = Field(..., min_length=8, max_length=128)


class UserLogin(BaseModel):
    email: EmailStr
    password: str = Field(..., min_length=8, max_length=128)


class TokenResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    
class GroupCreate(BaseModel):
    title: str = Field(..., min_length=1, max_length=100)
    
class AddMember(BaseModel):
    email: EmailStr

class TaskCreate(BaseModel):
    title: str = Field(..., min_length=1, max_length=100)
    description: str = Field(..., min_length=0, max_length=500)
    difficulty: float
    longitude: float
    latitude: float
    
class EntryCreate(BaseModel):
    title: str = Field(..., min_length=1, max_length=100)
    date: str
    journalEntry: str = Field(..., min_length=0, max_length=500)
    emotion: str = Field(..., min_length=0, max_length=500)
    longitude: float
    latitude: float


class TaskUpdate(BaseModel):
    title: str = Field(..., min_length=1, max_length=100)
    description: str = Field(..., min_length=1, max_length=500)
    difficulty: float
    longitude: float
    latitude: float
    completed: bool



