 
class User {
  String? uid;
  String? username;
  String? email;
  String? profileImage;
  int? avatarIndex;
  String? creationDate;

  User(
      {this.uid,
      this.username,
      this.email,
      this.profileImage,
      this.avatarIndex,
      this.creationDate});

  User.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    username = json['username'];
    email = json['email'];
    profileImage = json['profileImage'];
    avatarIndex = json['avatarIndex'];
    creationDate = json['creationDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['uid'] = uid;
    data['username'] = username;
    data['email'] = email;
    data['profileImage'] = profileImage;
    data['avatarIndex'] = avatarIndex;
    data['creationDate'] = creationDate;
    return data;
  }
}