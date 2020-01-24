import os, json

from flask import send_file, render_template, make_response

from app import app, db
from app.models import Highscore
from app.shared import make_mac


@app.route("/download/")
def download_file():
    return send_file(os.getcwd() + "/files/snake.xlsm", as_attachment=True)

@app.route("/")
@app.route("/index/")
def index():
    return(render_template("index.html"))

@app.route("/top/")
def top():
    highscore_list = db.session.query(Highscore).order_by(Highscore.score.desc()).limit(10).all()
    return(render_template("top.html", highscore_list=highscore_list))

@app.route("/highscores/")
@app.route("/highscores/<int:count>/")
def highscores(count = 25):
    highscore_list = db.session.query(Highscore).order_by(Highscore.score.desc()).limit(count).all()

    template = render_template("highscores.xml", highscore_list=highscore_list)
    response = make_response(template)
    response.headers['Content-Type'] = 'application/xml'

    return(response)

@app.route("/submit_highscore/<string:hex>/<string:mac>/")
def submit_highscore(hex, mac):
    # Verify message authentication code
    if make_mac(hex) != mac:
        return("NOT OK", 422)

    # Decode hex
    try:
        data_json = bytearray.fromhex(hex).decode()
    except ValueError:
        return("NOT OK", 422)

    # Decode json
    try:
        data_obj = json.loads(data_json)
    except ValueError:
        return("NOT OK", 422)

    # Check data & upload
    try:
        if (
            data_obj["inital_snake_length"]   != 10 or
            data_obj["points_for_moving"]     != 1 or
            data_obj["points_for_fruit"]      != 750 or
            data_obj["tick_speed_ms"]         != 50 or
            data_obj["movement_speed_cycles"] != 5 or
            data_obj["growing_speed_steps"]   != 10 or
            data_obj["increase_coefficients"] != 5000 or
            data_obj["version"] != "0.2a"):

            return("NOT OK", 422)


        if len(data_obj["username"]) > 32:
            return("NOT OK", 422)

        hs = Highscore(username=data_obj["username"], score=data_obj["score"], data=data_json)
        db.session.add(hs)
        db.session.commit()

    except KeyError:
        return("NOT OK - KEY ERROR", 422)

    return("OK", 200)
