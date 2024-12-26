from flask import Flask, request
import win32api
import win32con

app = Flask(__name__)

@app.route('/mouse1click', methods=['POST'])
def mouse1click():
    win32api.mouse_event(win32con.MOUSEEVENTF_LEFTDOWN, 0, 0, 0, 0)
    win32api.mouse_event(win32con.MOUSEEVENTF_LEFTUP, 0, 0, 0, 0)
    return 'OK', 200

@app.route('/')
def home():
    return '200'

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
