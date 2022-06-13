class Order {
  String? orderId;
  String? receiptId;
  String? orderStatus;
  String? orderDate;
  String? orderPaid;

  Order(
      {this.orderId,
      this.receiptId,
      this.orderStatus,
      this.orderDate,
      this.orderPaid});

  Order.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    receiptId = json['receipt_id'];
    orderStatus = json['order_status'];
    orderDate = json['order_date'];
    orderPaid = json['order_paid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_id'] = orderId;
    data['receipt_id'] = receiptId;
    data['order_status'] = orderStatus;
    data['order_date'] = orderDate;
    data['order_paid'] = orderPaid;
    return data;
  }
}
