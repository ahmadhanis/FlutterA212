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
                Navigator.push(
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
                Navigator.push(
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
                        children: List.generate(productList.length, (index) {
                          return Card(
                              child: Column(
                            children: [
                              Flexible(
                                flex: 7,
                                child: CachedNetworkImage(
                                  imageUrl: CONSTANTS.server +
                                      "/slumshop/mobile/assets/products/" +
                                      productList[index].productId.toString() +
                                      '.jpg',
                                  fit: BoxFit.cover,
                                  width: resWidth,
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                              Flexible(
                                  flex: 3,
                                  child: Column(
                                    children: [
                                      Text(productList[index]
                                          .productName
                                          .toString()),
                                      Text("RM " +
                                          double.parse(productList[index]
                                                  .productPrice
                                                  .toString())
                                              .toStringAsFixed(2)),
                                              
                                    ],
                                  ))
                            ],
                          ));
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
}
