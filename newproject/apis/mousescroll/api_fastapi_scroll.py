from fastapi import FastAPI
from pydantic import BaseModel
import uvicorn
import win32api
import win32con

app = FastAPI()

class ScrollRequest(BaseModel):
    scroll: int

@app.post("/mousescroll")
async def mousescroll(request: ScrollRequest):
    scroll = request.scroll
    if scroll != 0:
        win32api.mouse_event(win32con.MOUSEEVENTF_WHEEL, 0, 0, scroll, 0)
    return {"status": "OK"}

@app.get("/")
async def home():
    return {"status": "200"}

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=5000)
