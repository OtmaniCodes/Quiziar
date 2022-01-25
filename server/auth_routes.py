# from flask import jsonify, request
# from random import randint
# # my imports
# from app import server, db, bcryptor, User
# from validations.email_validation import EmailValidartor
# from validations.password_validation import PasswordValidartor


# check_validity = lambda x: True if x != None and len(x) != 0 else False
# def generate_uid(length):
#     uid = ''
#     text = 'abcdefghijklmnopqrstvwxxyz1234567890'
#     for _ in range(length):
#         uid += [i for i in text][randint(0, len(text)-1)]
#     return uid

# @server.route('/api/user/register', methods=['GET', 'POST'])
# def register():
#     req_success = False
#     message = ''
#     if request.method == 'POST':
#         try:
#             data = dict(request.form)
#             username = data['username']
#             email = data['email']
#             password = data['password']
#             if check_validity(username) and check_validity(password) and check_validity(email):
#                 uid = generate_uid(15)
#                 user_in_db = User.query.filter_by(uid=uid).first()
#                 if user_in_db is None:
#                     if username not in [user.username for user in User.query.filter_by(username=username).all()]:
#                         __passwordValidator = PasswordValidartor()
#                         __emailValidator = EmailValidartor()
#                         __passwordValidator.password = password
#                         __emailValidator.email = email
#                         if __passwordValidator.is_password_valid() and __emailValidator.is_email_valid():
#                             new_user = User(uid=uid, username=username, email=email, password=bcryptor.generate_password_hash(password).decode('utf-8'))
#                             db.session.add(new_user)
#                             db.session.commit()
#                             req_success = True
#                             message = 'user is successfuly registered'
#                         else:
#                             message = 'something wrong with the given credentials'
#                     else:
#                         message = 'a user already exists with the given username'
#                 else:
#                     message = 'a user already exists with the given uid'
#             else:
#                 message = 'credentials error'
#         except Exception as e:
#             message = f"an unknown error occured: {e}"
#         if req_success:
#             return jsonify({'isSuccess': req_success, 'message': message, 'data': {'uid': uid, 'username': username, 'email': email}})
#         else:
#             return jsonify({'isSuccess': req_success,'message': message, 'data': {}})

# # used for logging in existing users
# @server.route('/api/user/login', methods=['GET', 'POST'])
# def login():
#     req_success = False
#     message = ''
#     if request.method == 'POST':
#         try:
#             data = dict(request.form)
#             username = data['username']
#             password = data['password']
#             if check_validity(username) and check_validity(password):
#                 user_in_db = User.query.filter_by(username=username).first()
#                 if user_in_db is not None:
#                     __passwordValidator = PasswordValidartor()
#                     __passwordValidator.password = password
#                     if __passwordValidator.is_password_valid():
#                         if bcryptor.check_password_hash(user_in_db.password, password):
#                             message = 'user is successfuly logged in'
#                             req_success = True
#                         else:
#                             message = 'password is not correct'
#                     else:
#                         message = 'something wrong with the given password'
#                 else:
#                     message = 'user does not exist'
#         except Exception as e:
#             message = f"an unknown error occured {e}"
#         if req_success:
#             return jsonify({'isSuccess': req_success, 'message': message, 'data': {'uid': user_in_db.uid, 'username': user_in_db.username, 'email': user_in_db.email}})
#         else:
#             return jsonify({'isSuccess': req_success,'message': message, 'data': {}})

# # premeneatly deletes a user from the server
# @server.route('/api/user/delete', methods = ['GET', 'POST'])
# def delete():
#     req_success = False
#     message = ''
#     if request.method == 'POST':
#         try:
#             data = dict(request.form)
#             uid = data['uid']
#             deleted_user = User.query.get(uid)
#             if  deleted_user is not None:
#                 db.session.delete(deleted_user)
#                 db.session.commit()
#                 req_success = True
#                 message = 'user is successfuly deleted'
#             else:
#                 message = 'user does not exist'
#         except Exception as e:
#             message = str(e)
#         return jsonify({'isSuccess': req_success, 'message': message})