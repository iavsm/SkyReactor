import 'dart:async' show StreamSubscription;

import 'package:copy_trading/shared_widgets/default_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class PaymentWebview extends StatefulWidget {
  final String url;
  const PaymentWebview({Key key, @required this.url}) : super(key: key);

  @override
  _PaymentWebviewState createState() => _PaymentWebviewState();
}

class _PaymentWebviewState extends State<PaymentWebview> {
  FlutterWebviewPlugin flutterWebViewPlugin;

  StreamSubscription<String> _onUrlChanged;

  bool isLoading = false;

  @override
  void initState() {
    flutterWebViewPlugin = FlutterWebviewPlugin();
    init();
    super.initState();
  }

  @override
  void dispose() {
    _onUrlChanged?.cancel();
    flutterWebViewPlugin?.dispose();
    super.dispose();
  }

  void init() {
    showLoader();
    initPaymentForm();
  }

  void initPaymentForm() {
    _onUrlChanged = flutterWebViewPlugin.onUrlChanged.listen((String url) async {
      if (url.contains('&resourcePath=')) {
        flutterWebViewPlugin.close();
        Navigator.pop(context);
      }
    });
    hideLoader();
  }

  void showLoader() {
    if (!mounted) return;
    setState(() {
      isLoading = true;
    });
  }

  void hideLoader() {
    if (!mounted) return;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment'), elevation: 0),
      body: isLoading
          ? DefaultLoader()
          : WebviewScaffold(
              clearCache: true,
              clearCookies: true,
              withJavascript: true,
              geolocationEnabled: true,
              initialChild: DefaultLoader(),
              url: widget.url,
            ),
    );
  }
}
