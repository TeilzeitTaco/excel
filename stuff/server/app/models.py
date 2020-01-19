from app import db

class Highscore(db.Model):
    id       = db.Column(db.Integer, primary_key=True)
    score    = db.Column(db.Integer, index=True, default=0)
    username = db.Column(db.String(32), index=True, default="")
    data     = db.Column(db.Text, default="")

db.create_all()
db.session.commit()
