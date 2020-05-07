class UserModel {
  String idUser;
  String username;
  String password;
  String fullName;
  String status;
  String image;

  UserModel({
    this.idUser,
    this.username,
    this.password,
    this.fullName,
    this.status,
    this.image,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        idUser: json["id_user"],
        username: json["username"],
        password: json["password"],
        fullName: json["full_name"],
        status: json["status"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id_user": idUser,
        "username": username,
        "password": password,
        "full_name": fullName,
        "status": status,
        "image": image,
      };
}
