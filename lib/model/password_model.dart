import 'dart:convert';

Password passwordFromJson(String str) {
  final jsonData = json.decode(str);
  return Password.fromJson(jsonData);
}

String passwordToJson(Password data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class Password {
  String id;
  String title;
  String username;
  String email;
  String password;
  String pin;
  String tele;
  String remark;

  Password(
      {this.id,
      this.title,
      this.username,
      this.email,
      this.password,
      this.pin,
      this.tele,
      this.remark});

  Password.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    username = json['username'];
    email = json['email'];
    password = json['password'];
    pin = json['pin'];
    tele = json['tele'];
    remark = json['remark'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['username'] = this.username;
    data['email'] = this.email;
    data['password'] = this.password;
    data['pin'] = this.pin;
    data['tele'] = this.tele;
    data['remark'] = this.remark;
    return data;
  }
}
