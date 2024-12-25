from flask import Flask, request, jsonify
import pyautogui

app = Flask(__name__)

@app.route('/mousemoveabs', methods=['POST'])
def mouse_move_abs():
    try:
        data = request.json
        x = data.get("x", 0)
        y = data.get("y", 0)
        pyautogui.moveTo(x, y) 
        return jsonify({"status": "success", "message": f"sucess 200 ({x}, {y})"}), 200
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500
    
@app.route('/')
def home():
    return '200'

if __name__ == '__main__':
    app.run(host='127.0.0.1', port=5000)
