# main.py
from flask import Flask
from e213d18250504ba584359829bd5deca1 import e213d18250504ba584359829bd5deca1
from db import db, init_db
from db_model import Todo

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///test.db'

# Connect db and app
db.init_app(app)
with app.app_context():
    init_db(app)

# Route to create package
@app.route('/')
def create_package():
    # 1. Create package
    pkg = e213d18250504ba584359829bd5deca1()
    print(pkg)

    # 2. Insert message to database
    new_todo = Todo(content=pkg)
    db.session.add(new_todo)
    db.session.commit()

    # 3. Check database and print
    total = Todo.query.count()
    return f"Insert package: {pkg}；Totally {total} packages"

if __name__ == '__main__':
    app.run(debug=True)