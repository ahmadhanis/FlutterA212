class Customer {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? state;
  String? address;
  String? credit;
  String? otp;
  String? datereg;

  Customer(
      {this.id,
      this.name,
      this.email,
      this.phone,
      this.state,
      this.address,
      this.credit,
      this.otp,
      this.datereg});

  Customer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    state = json['state'];
    address = json['address'];
    credit = json['credit'];
    otp = json['otp'];
    datereg = json['datereg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['state'] = state;
    data['address'] = address;
    data['credit'] = credit;
    data['otp'] = otp;
    data['datereg'] = datereg;
    return data;
  }
}
