class UserData {
  String phone;
  String address;
  String email;
  String username;
  String id;
  String token;

  UserData({
    required this.phone,
    required this.address,
    required this.email,
    required this.username,
    required this.id,
    required this.token,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      phone: json['phone'].toString(),
      address: json['address'].toString(),
      email: json['email'].toString(),
      username: json['username'].toString(),
      id: json['id'].toString(),
      token: json['access_token'].toString(),
    );
  }
}
