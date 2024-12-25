from flask import Flask, request
import pyautogui

app = Flask(__name__)

@app.route('/mousemoverel', methods=['POST'])
def mouse_move_rel():
    try:
        data = request.json
        x = data.get('x', 0)
        y = data.get('y', 0)
        pyautogui.moveRel(x, y)  
        return {"status": "success", "message": ({x}, {y})"}, 200
    except Exception as e:
        return {"status": "error", "message": str(e)}, 500
@app.route('/')
def home():
    return '200'

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
