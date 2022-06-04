import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:slumshop/views/registrationscreen.dart';
import '../constants.dart';
import '../models/customer.dart';
import '../models/product.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MainScreen extends StatefulWidget {
  final Customer customer;
  const MainScreen({
    Key? key,
     required this.customer,
  }) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Product> productList = <Product>[];
  String titlecenter = "Loading...";
  late double screenHeight, screenWidth, resWidth;
  final df = DateFormat('dd/MM/yyyy hh:mm a');
  var numofpage, curpage = 1;
  var color;
  TextEditingController searchController = TextEditingController();
  String search = "";
  String dropdownvalue = 'Beverage';
  var types = [
    'Baby',
    'Beverage',
    'Bread',
    'Breakfast',
    'Canned Food',
    'Condiment',
    'Care Product',
    'Dairy',
    'Dried Food',
    'Grains',
    'Frozen',
    'Snack',
    'Health',
    'Meat',
    'Miscellaneous',
    'Seafood',
    'Pet',
    'Produce',
    'Household',
    'Vegetables',
  ];

  @override
  void initState() {
    super.initState();
    _loadProducts(1, search);
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
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _loadSearchDialog();
            },
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(widget.customer.name.toString()),
              accountEmail: Text(widget.customer.email.toString()),
              currentAccountPicture: const CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://cdn.myanimelist.net/r/360x360/images/characters/9/310307.jpg?s=56335bffa6f5da78c3824ba0dae14a26"),
              ),
            ),
            _createDrawerItem(
              icon: Icons.tv,
              text: 'Products',
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (content) => MainScreen(
                              customer: widget.customer,
                            )));
              },
            ),
            _createDrawerItem(
              icon: Icons.local_shipping_outlined,
              text: 'My Cart',
              onTap: () {},
            ),
            _createDrawerItem(
              icon: Icons.supervised_user_circle,
              text: 'My Orders',
              onTap: () {},
            ),
            _createDrawerItem(
              icon: Icons.verified_user,
              text: 'My Profile',
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
          : Column(children: [
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
                          child: Card(
                              child: Column(
                            children: [
                              Flexible(
                                flex: 6,
                                child: CachedNetworkImage(
                                  imageUrl: CONSTANTS.server +
                                      "/slumshop/assets/products/" +
                                      productList[index].productId.toString() +
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
                      }))),
              SizedBox(
                height: 30,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: numofpage,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    if ((curpage - 1) == index) {
                      color = Colors.red;
                    } else {
                      color = Colors.black;
                    }
                    return SizedBox(
                      width: 40,
                      child: TextButton(
                          onPressed: () => {_loadProducts(index + 1, "")},
                          child: Text(
                            (index + 1).toString(),
                            style: TextStyle(color: color),
                          )),
                    );
                  },
                ),
              ),
            ]),
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

  void _loadProducts(int pageno, String _search) {
    curpage = pageno;
    numofpage ?? 1;
    http.post(
        Uri.parse(CONSTANTS.server + "/slumshop/mobile/php/load_products.php"),
        body: {
          'pageno': pageno.toString(),
          'search': _search,
        }).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    ).then((response) {
      var jsondata = jsonDecode(response.body);

      print(jsondata);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        var extractdata = jsondata['data'];
        numofpage = int.parse(jsondata['numofpage']);

        if (extractdata['products'] != null) {
          productList = <Product>[];
          extractdata['products'].forEach((v) {
            productList.add(Product.fromJson(v));
          });
        } else {
          titlecenter = "No Product Available";
        }
        setState(() {});
      } else {
        //do something
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
                      "/slumshop/assets/products/" +
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
                ]),
                ElevatedButton(onPressed: _addtocartDialog, child: Text("Add to cart"))
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

  void _loadSearchDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return StatefulBuilder(
            builder: (context, StateSetter setState) {
              return AlertDialog(
                title: const Text(
                  "Search ",
                ),
                content: SizedBox(
                  height: screenHeight / 3,
                  child: Column(
                    children: [
                      TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                            labelText: 'Search',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        height: 60,
                        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5.0))),
                        child: DropdownButton(
                          value: dropdownvalue,
                          underline: const SizedBox(),
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: types.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              dropdownvalue = newValue!;
                            });
                          },
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          search = searchController.text;
                          Navigator.of(context).pop();
                          _loadProducts(1, search);
                        },
                        child: const Text("Search"),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  _addtocartDialog() {

    if (widget.customer.email == "guest@slumberjer.com") {
      Navigator.of(context).pop();
      Fluttertoast.showToast(
          msg: "Please register an account",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);
      Navigator.push(
          context, MaterialPageRoute(builder: (content) => const RegistrationScreen()));
    }else{
      Fluttertoast.showToast(
          msg: "Added to cart success",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 16.0);
    }
  }
}
