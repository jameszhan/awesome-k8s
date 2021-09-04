from flask import Flask, request

app = Flask(__name__)

@app.route("/api/HAIQ_ESS_UNLOAD_BIN_REQUEST", methods=['GET', 'POST'])
def echo():
    print(request.headers)
    print(request.data)
    return '{"code":0,"msg":"success","data":"OK"}'