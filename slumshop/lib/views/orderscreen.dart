import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants.dart';
import '../models/cart.dart';
import '../models/customer.dart';
import '../models/order.dart';
import 'package:http/http.dart' as http;

class OrderScreen extends StatefulWidget {
  final Customer customer;

  const OrderScreen({Key? key, required this.customer}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  List<Order> orderList = <Order>[];
  String titlecenter = "Loading...";
  late double screenHeight, screenWidth, resWidth;
  final df = DateFormat('dd/MM/yy hh:mm a');

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= 600) {
      resWidth = screenWidth;
      //rowcount = 2;
    } else {
      resWidth = screenWidth * 0.75;
      //rowcount = 3;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
      ),
      body: orderList.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(titlecenter,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            )
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Your Orders",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  const Divider(color: Colors.grey),
                  Expanded(
                      child: GridView.count(
                          crossAxisCount: 2,
                          childAspectRatio: (1 / 0.7),
                          children: List.generate(orderList.length, (index) {
                            return Card(
                              child: InkWell(
                                onTap: () {
                                  _onOrderDetails(index);
                                },
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 4, 8, 4),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Table(
                                          columnWidths: const {
                                            0: FlexColumnWidth(4),
                                            1: FlexColumnWidth(6),
                                          },
                                          // border: const TableBorder(
                                          //     verticalInside: BorderSide(
                                          //         width: 1,
                                          //         color: Colors.blue,
                                          //         style: BorderStyle.solid)),
                                          children: [
                                            TableRow(children: [
                                              const TableCell(
                                                child: Text(
                                                  "Order ID",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              TableCell(
                                                child: Text(
                                                  orderList[index]
                                                      .orderId
                                                      .toString(),
                                                ),
                                              )
                                            ]),
                                            TableRow(children: [
                                              const TableCell(
                                                child: Text(
                                                  "Receipt",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              TableCell(
                                                child: Text(
                                                  orderList[index]
                                                      .receiptId
                                                      .toString(),
                                                ),
                                              )
                                            ]),
                                            TableRow(children: [
                                              const TableCell(
                                                child: Text(
                                                  "Paid",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              TableCell(
                                                child: Text(
                                                  "RM " +
                                                      orderList[index]
                                                          .orderPaid
                                                          .toString(),
                                                ),
                                              )
                                            ]),
                                            TableRow(children: [
                                              const TableCell(
                                                child: Text(
                                                  "Status",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              TableCell(
                                                child: Text(
                                                  orderList[index]
                                                      .orderStatus
                                                      .toString(),
                                                ),
                                              )
                                            ]),
                                            TableRow(children: [
                                              const TableCell(
                                                child: Text(
                                                  "Date",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              TableCell(
                                                child: Text(
                                                  df.format(DateTime.parse(
                                                      orderList[index]
                                                          .orderDate
                                                          .toString())),
                                                ),
                                              )
                                            ]),
                                          ],
                                        ),
                                      ]),
                                ),
                              ),
                            );
                          }))),
                ]),
              ),
            ),
    );
  }

  void _loadOrders() {
    http.post(
        Uri.parse(CONSTANTS.server + "/slumshop/mobile/php/load_orders.php"),
        body: {
          'customer_email': widget.customer.email,
        }).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    ).then((response) {
      print(response.body);
      var jsondata = jsonDecode(response.body);
      var extractdata = jsondata['data'];
      if (extractdata['orders'] != null) {
        orderList = <Order>[];
        extractdata['orders'].forEach((v) {
          orderList.add(Order.fromJson(v));
        });
      } else {
        titlecenter = "No Order available";
      }
      setState(() {});
    });
  }

  _onOrderDetails(int index) {
    List<Cart> cartList = <Cart>[];
    http.post(
        Uri.parse(
            CONSTANTS.server + "/slumshop/mobile/php/load_orderdetails.php"),
        body: {
          'customer_email': widget.customer.email,
          'receipt_id': orderList[index].receiptId.toString(),
        }).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    ).then((response) {
      print(response.body);
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        var extractdata = jsondata['data'];
        cartList = <Cart>[];
        extractdata['cart'].forEach((v) {
          cartList.add(Cart.fromJson(v));
        });
        if (cartList.isNotEmpty) {
          _loadOrderDetailsDialog(cartList);
        }
      }
    });
  }

  void _loadOrderDetailsDialog(List<Cart> cartList) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text(
              "Order Details",
              style: TextStyle(),
            ),
            content: SizedBox(
              width: screenWidth,
              height: screenHeight,
              child: GridView.count(
                  crossAxisCount: 1,
                  childAspectRatio: (1 / 0.25),
                  children: List.generate(cartList.length, (index) {
                    return Card(
                        child: Column(
                      children: [
                        Text(
                          cartList[index].prname.toString(),
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Flexible(
                          flex: 4,
                          child: Column(children: [
                            Column(children: [
                              Text("Quantity: " +
                                  cartList[index].cartqty.toString()),
                              Text(
                                "RM " +
                                    double.parse(cartList[index]
                                            .pricetotal
                                            .toString())
                                        .toStringAsFixed(2),
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ]),
                          ]),
                        )
                      ],
                    ));
                  })),
            ),
          );
        });
  }
}
