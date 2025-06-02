import copy
from flask_sqlalchemy import SQLAlchemy 
from flask import Flask, request, jsonify 

app = Flask(__name__)
app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///books.db"
db = SQLAlchemy(app) 

class Book(db.Model):
    id = db.Column(db.Integer, primary_key = True)
    name = db.Column(db.String(50), nullable = False)
    author = db.Column(db.String(50), nullable = False)

    def __repr__(self):
        return {
            "Name": self.name,
            "Author": self.author
        }

with app.app_context():
    db.create_all() 

# # CRUD - Create, Read, Update, Delete
# books = {
#     "1" : {
#         "Name" : "XYZ",
#         "Author" : "Someone who wrote XYZ" 
#     }
# }

# Root URL
@app.route("/")
def home():
    return "Hello World" 

# GET - Method the get all the books in the database - curl http://localhost:5000/books/
@app.route("/books/", methods = ["GET"])
def get_books():
    books = Book.query.all()

    output = []
    for book in books:
        temp = {
            book.id : {
                "Name": book.name,
                "Author": book.author
            } 
        }
        output.append(temp) 

    return jsonify(output)
        

# GET - Get book by id - curl http://localhost:5000/books/1
@app.route("/books/<id>", methods = ["GET"])
def get_books_by_id(id):
    book = Book.query.get_or_404(id) 
    return jsonify(
        {
            book.id : {
                "Name" : book.name,
                "Author" : book.author
            }
        }
    ) 

# POST - add a new entry - curl -X POST http://localhost:5000/books/add -H "Content-Type: application/json" -d '{"Name": "ABC", "Author": "Someone who rote ABC"}'
@app.route("/books/add", methods = ["POST"])
def add_new_book():
    name = request.json["Name"]
    author = request.json["Author"]

    new_book = Book(name = name, author = author) 
    db.session.add(new_book) 
    db.session.commit() 

    return jsonify({
        "message": "New book added",
        "id": new_book.id
    }), 200

# DELETE - deletes a record - curl -X DELETE http://localhost:5000/books/delete/1
@app.route("/books/delete/<id>", methods = ["DELETE"])
def delete_books(id):

    deleted_book = Book.query.get_or_404(id)
    db.session.delete(deleted_book)
    db.session.commit()

    return jsonify({
        "message": "deleted the book",
        "deleted_book": {
            "id": deleted_book.id,
            "Name" : deleted_book.name,
            "Author" : deleted_book.author
        }
        }
    ), 200 

# PUT - update a record - curl -X PUT http://localhost:5000/books/update/1 -H "Content-Type: application/json" -d '{"Name": "ABC-V1", "Author": "ABC-V1 Person"}'
@app.route("/books/update/<id>", methods = ["PUT"])
def update_record(id):
    record = Book.query.get_or_404(id) 

    previous_record = {
        "id": record.id,
        "Name" : record.name,
        "Author" : record.author
    }

    name = request.json["Name"]
    author = request.json["Author"]

    if name: record.name = name 
    if author: record.author = author

    db.session.commit() 

    record = Book.query.get_or_404(id) 

    new_record = {
        "id": record.id,
        "Name" : record.name,
        "Author" : record.author
    }

    return jsonify(
        {
            "message": "updated a record",
            "previous_record": previous_record,
            "updated_record": new_record
        }
    ), 200

if __name__ == "__main__":
    app.run(host = "0.0.0.0", port = 5000, debug = True)  