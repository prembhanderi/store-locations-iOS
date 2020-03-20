from flask_sqlalchemy import SQLAlchemy

db = SQLAlchemy()

# used so every file can call the same instance of SQLAlchemy()