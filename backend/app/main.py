from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from .api import apps as apps_router, config as config_router

app = FastAPI(title="Launcher Accessibility API (PoC)")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(apps_router.router, prefix="/apps", tags=["apps"])
app.include_router(config_router.router, prefix="/config", tags=["config"])


@app.get("/")
def read_root():
    return {"message": "Launcher Accessibility API (PoC)"}
