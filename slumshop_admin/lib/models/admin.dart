class Admin {
  String? id;
  String? name;
  String? email;
  String? role;
  String? datereg;

  Admin({this.id, this.name, this.email, this.role, this.datereg});

  Admin.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    role = json['role'];
    datereg = json['datereg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['role'] = role;
    data['datereg'] = datereg;
    return data;
  }
}
