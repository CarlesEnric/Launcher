from fastapi import APIRouter
from pydantic import BaseModel

router = APIRouter()


class LauncherConfig(BaseModel):
    text_size: int = 20
    high_contrast: bool = True
    button_size: int = 64


_CONFIG = LauncherConfig()


@router.get("/", response_model=LauncherConfig)
def get_config():
    return _CONFIG


@router.put("/", response_model=LauncherConfig)
def update_config(cfg: LauncherConfig):
    global _CONFIG
    _CONFIG = cfg
    return _CONFIG
