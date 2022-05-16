import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:slumshop_admin/views/newproduct.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../models/admin.dart';
import '../models/product.dart';
import 'mainscreen.dart';
import 'package:intl/intl.dart';

import 'updprscreen.dart';

class ProductScreen extends StatefulWidget {
  final Admin admin;
  const ProductScreen({Key? key, required this.admin}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  List<Product> productList = <Product>[];
  String titlecenter = "No Product Available";
  late double screenHeight, screenWidth, resWidth;
  final df = DateFormat('dd/MM/yyyy hh:mm a');
  var _tapPosition;

  @override
  void initState() {
    super.initState();
    _loadProducts();
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
        title: const Text('My Product'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(widget.admin.name.toString()),
              accountEmail: Text(widget.admin.email.toString()),
              currentAccountPicture: const CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://cdn.myanimelist.net/r/360x360/images/characters/9/310307.jpg?s=56335bffa6f5da78c3824ba0dae14a26"),
              ),
            ),
            _createDrawerItem(
              icon: Icons.tv,
              text: 'My Dashboard',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (content) => MainScreen(
                              admin: widget.admin,
                            )));
              },
            ),
            _createDrawerItem(
              icon: Icons.list_alt,
              text: 'My Products',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (content) => ProductScreen(
                              admin: widget.admin,
                            )));
              },
            ),
            _createDrawerItem(
              icon: Icons.local_shipping_outlined,
              text: 'My Orders',
              onTap: () {},
            ),
            _createDrawerItem(
              icon: Icons.supervised_user_circle,
              text: 'My Customer',
              onTap: () {},
            ),
            _createDrawerItem(
              icon: Icons.verified_user,
              text: 'My Profile',
              onTap: () {},
            ),
            _createDrawerItem(
              icon: Icons.file_copy,
              text: 'My Report',
              onTap: () {},
            ),
            _createDrawerItem(
              icon: Icons.exit_to_app,
              text: 'Logout',
              onTap: () {},
            ),
          ],
        ),
      ),
      body: productList.isEmpty
          ? Center(
              child: Text(titlecenter,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)))
          : Column(
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text("Products Available",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                Expanded(
                    child: GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: (1 / 1),
                        children: List.generate(productList.length, (index) {
                          return InkWell(
                            splashColor: Colors.amber,
                            onTap: () => {_loadProductDetails(index)},
                            onLongPress: () => {
                              _delUpdMenu(index),
                            },
                            onTapDown: _storePosition,
                            child: Card(
                                child: Column(
                              children: [
                                Flexible(
                                  flex: 6,
                                  child: CachedNetworkImage(
                                    imageUrl: CONSTANTS.server +
                                        "/slumshop/mobile/assets/products/" +
                                        productList[index]
                                            .productId
                                            .toString() +
                                        '.jpg',
                                    fit: BoxFit.cover,
                                    width: resWidth,
                                    placeholder: (context, url) =>
                                        const LinearProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                                Flexible(
                                    flex: 4,
                                    child: Column(
                                      children: [
                                        Text(
                                          productList[index]
                                              .productName
                                              .toString(),
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text("RM " +
                                            double.parse(productList[index]
                                                    .productPrice
                                                    .toString())
                                                .toStringAsFixed(2)),
                                        Text(productList[index]
                                                .productQty
                                                .toString() +
                                            " units"),
                                        Text(productList[index]
                                            .productStatus
                                            .toString()),
                                      ],
                                    ))
                              ],
                            )),
                          );
                        })))
              ],
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        tooltip: "New Product",
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (content) => const NewProduct()));
        },
      ),
    );
  }

  Widget _createDrawerItem(
      {required IconData icon,
      required String text,
      required GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }

  void _loadProducts() {
    http.post(
        Uri.parse(CONSTANTS.server + "/slumshop/mobile/php/load_products.php"),
        body: {}).then((response) {
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        var extractdata = jsondata['data'];
        if (extractdata['products'] != null) {
          productList = <Product>[];
          extractdata['products'].forEach((v) {
            productList.add(Product.fromJson(v));
          });
          setState(() {});
        }
      }
    });
  }

  _loadProductDetails(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text(
              "Product Details",
              style: TextStyle(),
            ),
            content: SingleChildScrollView(
                child: Column(
              children: [
                CachedNetworkImage(
                  imageUrl: CONSTANTS.server +
                      "/slumshop/mobile/assets/products/" +
                      productList[index].productId.toString() +
                      '.jpg',
                  fit: BoxFit.cover,
                  width: resWidth,
                  placeholder: (context, url) =>
                      const LinearProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
                Text(
                  productList[index].productName.toString(),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text("Product Description: \n" +
                      productList[index].productDesc.toString()),
                  Text("Price: RM " +
                      double.parse(productList[index].productPrice.toString())
                          .toStringAsFixed(2)),
                  Text("Quantity Available: " +
                      productList[index].productQty.toString() +
                      " units"),
                  Text("Product Status: " +
                      productList[index].productStatus.toString()),
                  Text("Product Date: " +
                      df.format(DateTime.parse(
                          productList[index].productDate.toString()))),
                ])
              ],
            )),
            actions: [
              TextButton(
                child: const Text(
                  "Close",
                  style: TextStyle(),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  _delUpdMenu(int index) async {
    RenderBox renderBox = context.findRenderObject()! as RenderBox;

    showMenu(
      context: context,
      items: [
        PopupMenuItem(
          child: GestureDetector(
              onTap:() async {
                Navigator.of(context).pop();
                   await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (content) => UpdateProductScreen(
                                  product: productList[index],
                                )));
                                _loadProducts();
              },
              child: const Text(
                "Update Product",
                style: TextStyle(),
              )),
        ),
        PopupMenuItem(
          child: GestureDetector(
              onTap: () => {
                    Navigator.of(context).pop(),
                    _deleteProductDialog(index),
                  },
              child: const Text(
                "Delete Product",
                style: TextStyle(),
              )),
        ),
      ],
      position: RelativeRect.fromRect(
        _tapPosition & const Size(40, 40), // smaller rect, the touch area
        Offset.zero & renderBox.size, // Bigger rect, the entire screen
      ),
    );
  }

  _deleteProductDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text(
            "Delete " + productList[index].productName.toString(),
            style: const TextStyle(),
          ),
          content: const Text(
            "Are you sure?",
            style: TextStyle(),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteProduct(index);
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteProduct(int index) {
    http.post(
        Uri.parse(CONSTANTS.server + "/slumshop/mobile/php/delete_product.php"),
        body: {"prodid": productList[index].productId}).then((response) {
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
        _loadProducts();
      } else {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            fontSize: 16.0);
      }
    });
  }
}
