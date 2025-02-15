from flask import Flask
from flask_sqlalchemy import SQLAlchemy

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'postgresql://neondb_owner:npg_bytHLIA24lTF@ep-bold-salad-a1www4n4-pooler.ap-southeast-1.aws.neon.tech/neondb?sslmode=require'
db = SQLAlchemy(app)

class UserModel(db.Model):
  id = db.Column(db.Integer, primary_key=True)
  name = db.Column(db.String(80), unique=True, nullable=False)
  email = db.Column(db.String(80), unique=True, nullable=False)
  
  def __repr__(self):
    return f"User(name = {self.name}, email = {self.email})"
  

@app.route("/")
def home():
  return "<h1>Hello</h1>"

if __name__ == "__main__":
  app.run(debug=True)