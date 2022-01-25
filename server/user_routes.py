# from flask import jsonify, request
# from app import server, User

# @server.route("/api/user/all", methods=["GET"])
# def all_users():
#     req_success = False
#     message = ''
#     if request.method == "GET":
#         all_users = []
#         try:
#             all_users = [{"username":user.username, "email":user.email, "uid": user.uid} for user in User.query.all()]
#             req_success = True
#             message = 'all users are retrieved'
#         except Exception as e:
#             message = str(e)
#         return jsonify({'isSuccess': req_success, 'message': message, 'data': all_users})

# # returns one user with the given uid
# @server.route("/api/user/by_id/<string:uid>", methods=["GET"])
# def user_by_id(uid):
#     req_success = False
#     message = ''
#     if request.method == 'GET':
#         try:
#             user = User.query.filter_by(uid=uid).first()
#             message = 'user is fetched successfuly'
#             req_success = True
#         except Exception as e:
#             message = str(e)
#         return jsonify({'isSuccess': req_success, 'message': message, 'data': {"username":user.username, "email":user.email, "uid": user.uid}})
