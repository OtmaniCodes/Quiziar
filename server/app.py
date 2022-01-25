from flask_sqlalchemy import SQLAlchemy 
from flask import Flask, jsonify, request
from flask_bcrypt import Bcrypt
import uuid
from datetime import datetime as dt
from validations.email_validation import EmailValidartor
from validations.password_validation import PasswordValidartor

#? db.create_all() #- should be run once from the terminal (DONE)
#? db.drop_all() #- should be run once from the terminal (DONE)

app = Flask(__name__)
sql_db = 'sqlite:///database.db'
app.config['SQLALCHEMY_DATABASE_URI'] = sql_db
db = SQLAlchemy(app)
bcryptor = Bcrypt(app)

class Game(db.Model):
    game_uid = db.Column(db.String(15), primary_key=True)
    gamer_uid = db.Column(db.String(15), nullable=False)
    questions_solved = db.Column(db.Integer, nullable=False, default=0)
    questions_failed = db.Column(db.Integer, nullable=False, default=0)

    def __repr__(self):
        return f'User id: {self.game_uid}'

    def __str__(self):
        return f'User id: {self.game_uid}'


class User(db.Model):
    uid = db.Column(db.String(100), primary_key=True)
    username = db.Column(db.String(20), nullable=False)
    email = db.Column(db.String(50), nullable=False)
    password = db.Column(db.String(60), nullable=False)
    profile_image_file = db.Column(db.Text)
    creationDate = db.Column(db.Date, nullable=False, default=dt.utcnow())

    def __repr__(self):
        return f'User id: {self.uid}'

    def __str__(self):
        return f'User id: {self.uid}'
 

check_validity = lambda x: True if x != None and len(x) != 0 else False

@app.route('/api/user/register', methods=['GET', 'POST'])
def register():
    req_success = False
    message = ''
    if request.method == 'POST':
        try:
            data = dict(request.form)
            username = data['username']
            email = data['email']
            password = data['password']
            if check_validity(username) and check_validity(password) and check_validity(email):
                uid = str(uuid.uuid4())
                user_in_db = User.query.filter_by(uid=uid).first()
                if user_in_db is None:
                    if username not in [user.username for user in User.query.filter_by(username=username).all()]:
                        __passwordValidator = PasswordValidartor()
                        __emailValidator = EmailValidartor()
                        __passwordValidator.password = password
                        __emailValidator.email = email
                        if __passwordValidator.is_password_valid() and __emailValidator.is_email_valid():
                            new_user = User(uid=uid, username=username, email=email, password=bcryptor.generate_password_hash(password).decode('utf-8'))
                            db.session.add(new_user)
                            db.session.commit()
                            req_success = True
                            message = 'user is successfuly registered'
                        else:
                            message = 'something wrong with the given credentials'
                    else:
                        message = 'a user already exists with the given username'
                else:
                    message = 'a user already exists with the given uid'
            else:
                message = 'credentials error'
        except Exception as e:
            message = f"an unknown error occured: {e}"
        if req_success:
            return jsonify({'isSuccess': req_success, 'message': message, 'data': {'uid': uid, 'username': username, 'email': email}})
        else:
            return jsonify({'isSuccess': req_success,'message': message, 'data': {}})

# used for logging in existing users
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
                    __passwordValidator = PasswordValidartor()
                    __passwordValidator.password = password
                    if __passwordValidator.is_password_valid():
                        if bcryptor.check_password_hash(user_in_db.password, password):
                            message = 'user is successfuly logged in'
                            req_success = True
                        else:
                            message = 'password is not correct'
                    else:
                        message = 'something wrong with the given password'
                else:
                    message = 'user does not exist'
        except Exception as e:
            message = f"an unknown error occured {e}"
        if req_success:
            return jsonify({'isSuccess': req_success, 'message': message, 'data': {'uid': user_in_db.uid, 'username': user_in_db.username, 'email': user_in_db.email}})
        else:
            return jsonify({'isSuccess': req_success,'message': message, 'data': {}})

# premeneatly deletes a user from the app
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
        return jsonify({'isSuccess': req_success, 'message': message})

@app.route("/api/user/all", methods=["GET"])
def all_users():
    req_success = False
    message = ''
    if request.method == "GET":
        all_users = []
        try:
            all_users = [{"username":user.username, "email":user.email, "uid": user.uid} for user in User.query.all()]
            req_success = True
            message = 'all users are retrieved'
        except Exception as e:
            message = str(e)
        return jsonify({'isSuccess': req_success, 'message': message, 'data': all_users})

# returns one user with the given uid
@app.route("/api/user/by_id/<string:uid>", methods=["GET"])
def user_by_id(uid):
    req_success = False
    message = ''
    if request.method == 'GET':
        try:
            user = User.query.filter_by(uid=uid).first()
            message = 'user is fetched successfuly'
            req_success = True
        except Exception as e:
            message = str(e)
        return jsonify({'isSuccess': req_success, 'message': message, 'data': {"username":user.username, "email":user.email, "uid": user.uid}})



if __name__ == '__main__':
    app.run(debug=True)
    # app.run(debug=True, host='0.0.0.0', port=800)