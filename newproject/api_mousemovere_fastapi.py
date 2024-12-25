from fastapi import FastAPI, Request
import pyautogui

app = FastAPI()

@app.post("/mousemoverel")
async def mouse_move_rel(request: Request):
    try:
        data = await request.json()
        x = data.get("x", 0)
        y = data.get("y", 0)
        pyautogui.moveRel(x, y)  
        return {"status": "success", "message": f"Moved mouse by ({x}, {y})"}
    except Exception as e:
        return {"status": "error", "message": str(e)}

@app.get("/")
async def home():
    return {"status": "success", "message": "200"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="127.0.0.1", port=5000)
