// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SafeWebView extends StatefulWidget {
  final String? url;

  const SafeWebView({Key? key, this.url}) : super(key: key);

  @override
  _SafeWebViewState createState() => _SafeWebViewState();
}

class _SafeWebViewState extends State<SafeWebView> {
  late WebViewController webViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebView(
        initialUrl: widget.url ?? 'https://www.example.com', // Default URL
        onWebViewCreated: (WebViewController webViewController) {
          webViewController = webViewController;
        },
        onPageStarted: (String url) {
          // Handle page loading started
          print("Page started loading: $url");
        },
        onPageFinished: (String url) {
          // Handle page loading finished
          print("Page finished loading: $url");
        },
        navigationDelegate: (NavigationRequest request) {
          // Handle navigation requests (e.g., opening a new link)
          print("Navigation request: ${request.url}");
          return NavigationDecision.navigate;
        },
      ),
    );
  }
}
