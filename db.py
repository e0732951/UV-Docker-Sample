# create database
from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

def init_db(app):
    """Receive a Flask app，enter app_context and create all tables"""
    with app.app_context():
        db.create_all()
        print("Database created successfully.")
