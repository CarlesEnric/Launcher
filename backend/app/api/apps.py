from fastapi import APIRouter, HTTPException
from pydantic import BaseModel

router = APIRouter()


class AppCreate(BaseModel):
    id: str
    name: str
    action: str  # e.g., package name or custom action


class AppOut(AppCreate):
    pass


# In-memory store for PoC
_APPS = [
    {"id": "phone", "name": "Telèfon", "action": "tel"},
    {"id": "contacts", "name": "Contactes", "action": "contacts"},
    {"id": "messages", "name": "Missatges", "action": "messages"},
    {"id": "camera", "name": "Càmera", "action": "camera"},
    {"id": "browser", "name": "Navegador", "action": "browser"},
]


@router.get("/", response_model=list[AppOut])
def list_apps():
    return _APPS


@router.post("/", response_model=AppOut)
def create_app(app: AppCreate):
    if any(a["id"] == app.id for a in _APPS):
        raise HTTPException(status_code=400, detail="App id already exists")
    item = app.model_dump()
    _APPS.append(item)
    return item
