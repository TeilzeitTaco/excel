import os, json

from flask import send_file, render_template, make_response

from app import app, db
from app.models import Highscore


@app.route("/download/")
def download_file():
    return send_file(os.getcwd() + "/files/snake.xlsm", as_attachment=True)

@app.route("/")
@app.route("/index/")
def index():
    return(render_template("index.html"))

@app.route("/highscores/")
@app.route("/highscores/<int:count>/")
def highscores(count = 25):
    highscore_list = db.session.query(Highscore).order_by(Highscore.score.desc()).limit(count).all()

    template = render_template("highscores.xml", highscore_list=highscore_list)
    response = make_response(template)
    response.headers['Content-Type'] = 'application/xml'

    return(response)

@app.route("/submit_highscore/<string:hex>/<int:magic_number>/")
def submit_highscore(hex, magic_number):
    try:
        data_json = bytearray.fromhex(hex).decode()
    except ValueError:
        return("NOT OK", 422)

    try:
        data_obj = json.loads(data_json)
    except ValueError:
        return("NOT OK", 422)

    try:
        if len(data_obj["username"]) > 32:
            return("NOT OK", 422)

        hs = Highscore(username=data_obj["username"], score=data_obj["score"], data=data_json)
        db.session.add(hs)
        db.session.commit()

    except KeyError:
        return("NOT OK", 422)

    return("OK", 200)
