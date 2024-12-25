from fastapi import FastAPI, Request
import pyautogui

app = FastAPI()

@app.post("/mousemoveabs")
async def mouse_move_abs(request: Request):
    try:
        data = await request.json()
        x = data.get("x", 0)
        y = data.get("y", 0)
        pyautogui.moveTo(x, y)  
        return {"status": "success", "message": f"sucess ({x}, {y})"}
    except Exception as e:
        return {"status": "error", "message": str(e)}

@app.get("/")
async def home():
    return {"status": "success", "message": "200"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="127.0.0.1", port=5000)




