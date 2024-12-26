from fastapi import FastAPI
import uvicorn
import win32api
import win32con

app = FastAPI()

@app.post("/mouse1click")
async def mouse1click():
    win32api.mouse_event(win32con.MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0)
    win32api.mouse_event(win32con.MOUSEEVENTF_LEFTUP, 0, 0, 0, 0)
    return {"status": "OK"}

@app.get("/")
async def home():
    return {"status": "200"}

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=5000)
