import 'dart:async';

import 'package:flutter/material.dart';
import 'package:slumshop/constants.dart';
import 'package:slumshop/models/customer.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentScreen extends StatefulWidget {
  final Customer customer;
  final double totalpayable;

  const PaymentScreen(
      {Key? key, required this.customer, required this.totalpayable})
      : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Payment'),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: WebView(
                initialUrl: CONSTANTS.server +
                    '/slumshop/mobile/php/payment.php?email=' +
                    widget.customer.email.toString() +
                    '&mobile=' +
                    widget.customer.phone.toString() +
                    '&name=' +
                    widget.customer.name.toString() +
                    '&amount=' +
                    widget.totalpayable.toString(),
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  _controller.complete(webViewController);
                },
                
              ),
            )
          ],
        ));
  }
}
