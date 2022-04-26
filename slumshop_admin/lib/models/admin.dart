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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['role'] = this.role;
    data['datereg'] = this.datereg;
    return data;
  }
}