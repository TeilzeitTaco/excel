from flask import send_file, render_template

from app import app
from app.shared import csv_to_list

@app.route("/download")
def download_file():
    return send_file("\\files\\snake.xlsm", as_attachment=True)

@app.route("/")
@app.route("/index")
def index():
    return(render_template("index.html"))

@app.route("/submit_highscore/<string:hex>/<int:magic_number>/")
def submit_highscore(hex, magic_number):
    list_csv = bytearray.fromhex(hex).decode()
    list_obj = csv_to_list(list_csv)
    print(list_obj)

    return("OK")
