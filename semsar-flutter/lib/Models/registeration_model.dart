class RegisterationModel {
  String email;
  String password;

  RegisterationModel({required this.email, required this.password});

  Map<String, dynamic> toMap() {
    return {
      "email": email,
      "password": password,
    };
  }
}
