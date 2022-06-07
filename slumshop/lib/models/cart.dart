class Cart {
  String? cartid;
  String? prname;
  String? prqty;
  String? price;
  String? cartqty;
  String? prid;
  String? pricetotal;

  Cart(
      {this.cartid,
      this.prname,
      this.prqty,
      this.price,
      this.cartqty,
      this.prid,
      this.pricetotal});

  Cart.fromJson(Map<String, dynamic> json) {
    cartid = json['cartid'];
    prname = json['prname'];
    prqty = json['prqty'];
    price = json['price'];
    cartqty = json['cartqty'];
    prid = json['prid'];
    pricetotal = json['pricetotal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cartid'] = cartid;
    data['prname'] = prname;
    data['prqty'] = prqty;
    data['price'] = price;
    data['cartqty'] = cartqty;
    data['prid'] = prid;
    data['pricetotal'] = pricetotal;
    return data;
  }
}