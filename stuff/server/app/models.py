from app import db

class highscore(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    score = db.Column(db.Integer, default="")
    data = db.Column(db.Text, default="")

db.create_all()
