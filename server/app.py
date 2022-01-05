from datetime import datetime as dt
from flask_sqlalchemy import SQLAlchemy 
from flask import Flask, jsonify, request
from random import randint
from flask_bcrypt import Bcrypt
import json

# my packages
# from models.user import User

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///database.db'
db = SQLAlchemy(app)
bcryptor = Bcrypt(app)

#? db.create_all() #- should be run once from the terminal (DONE)

class User(db.Model):
    uid = db.Column(db.String(15), primary_key=True)
    username = db.Column(db.String(20), nullable=False)
    email = db.Column(db.String(50), nullable=False)
    password = db.Column(db.String(60), nullable=False)
    profile_image_file = db.Column(db.Text)
    creationDate = db.Column(db.Date, nullable=False, default=dt.utcnow())

    def __repr__(self):
        return f'User id: {self.uid}'

def generate_uid(length):
    uid = ''
    text = 'abcdefghijklmnopqrstvwxxyz1234567890'
    for i in range(length):
        uid += text[randint(0, len(text)-1)]
    return uid

# decode_data = lambda data: json.loads(data.decode('utf-8')) 
# def decode_data(data):
#     return json.loads(data.decode('utf-8')) 

check_validity = lambda x: True if x != None and len(x) != 0 else False

@app.route('/api/user/register', methods=['GET', 'POST'])
def register():
    req_success = False
    message = ''
    if request.method == 'POST':
        try:
            # data = decode_data(request.data)
            data = dict(request.form)
            username = data['username']
            email = data['email']
            password = data['password']
            if check_validity(username) and check_validity(password) and check_validity(email):
                uid = generate_uid(15)
                user_in_db = User.query.filter_by(uid=uid).first()
                if user_in_db is None:
                    new_user = User(uid=uid, username=username, email=email, password=bcryptor.generate_password_hash(password).decode('utf-8'))
                    db.session.add(new_user)
                    db.session.commit()
                    req_success = True
                    message = 'user is successfuly registered'
                else:
                    message = 'user already exists'
            else:
                message = 'credentials error'
        except Exception as e:
            message = f"an unknown error occured: {e}"
        if req_success:
            return jsonify({'isSuccess': req_success, 'message': message, 'data': {'uid': uid, 'username': username, 'email': email}})
        else:
            return jsonify({'isSuccess': req_success,'message': message, 'data': {}})

@app.route('/api/user/login', methods=['GET', 'POST'])
def login():
    req_success = False
    message = ''
    if request.method == 'POST':
        try:
            data = dict(request.form)
            username = data['username']
            password = data['password']
            if check_validity(username) and check_validity(password):
                user_in_db = User.query.filter_by(username=username).first()
                if user_in_db is not None:
                    if bcryptor.check_password_hash(user_in_db.password, password):
                        message = 'user is successfuly logged in'
                        req_success = True
                    else:
                        message = 'password is uncorrect'
                else:
                    message = 'user does not exist'
        except Exception as e:
            message = f"an unknown error occured {e}"
        if req_success:
            return jsonify({'isSuccess': req_success, 'message': message, 'data': {'uid': user_in_db.uid, 'username': user_in_db.username, 'email': user_in_db.email}})
        else:
            return jsonify({'isSuccess': req_success,'message': message, 'data': {}})

@app.route('/api/user/delete', methods = ['GET', 'POST'])
def delete():
    req_success = False
    message = ''
    if request.method == 'POST':
        try:
            data = dict(request.form)
            uid = data['uid']
            deleted_user = User.query.get(uid)
            if  deleted_user is not None:
                db.session.delete(deleted_user)
                db.session.commit()
                req_success = True
                message = 'user is successfuly deleted'
            else:
                message = 'user does not exist'
        except Exception as e:
            message = str(e)
        return jsonify({'isError': not(req_success), 'message': message})


if __name__ == '__main__':
    app.run(debug=True)
    # app.run(debug=True, host='0.0.0.0', port=800)