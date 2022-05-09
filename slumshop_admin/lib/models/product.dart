class Product {
  String? productId;
  String? productName;
  String? productDesc;
  String? productType;
  String? productQty;
  String? productPrice;
  String? productBarcode;
  String? productStatus;
  String? productDate;

  Product(
      {this.productId,
      this.productName,
      this.productDesc,
      this.productType,
      this.productQty,
      this.productPrice,
      this.productBarcode,
      this.productStatus,
      this.productDate});

  Product.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    productName = json['product_name'];
    productDesc = json['product_desc'];
    productType = json['product_type'];
    productQty = json['product_qty'];
    productPrice = json['product_price'];
    productBarcode = json['product_barcode'];
    productStatus = json['product_status'];
    productDate = json['product_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['product_name'] = productName;
    data['product_desc'] = productDesc;
    data['product_type'] = productType;
    data['product_qty'] = productQty;
    data['product_price'] = productPrice;
    data['product_barcode'] = productBarcode;
    data['product_status'] = productStatus;
    data['product_date'] = productDate;
    return data;
  }
}