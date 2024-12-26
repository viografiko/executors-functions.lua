from flask import Flask, request
import win32api
import win32con

app = Flask(__name__)

@app.route('/mousescroll', methods=['POST'])
def mousescroll():
    scroll = request.json.get('scroll', 0)
    if scroll != 0:
        win32api.mouse_event(win32con.MOUSEEVENTF_WHEEL, 0, 0, scroll, 0)
    return 'OK', 200

@app.route('/')
def home():
  return '200'
  
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
