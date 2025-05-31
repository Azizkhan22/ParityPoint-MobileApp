import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;

class ArticleWebView extends StatefulWidget {
  final String url;
  final String title;
  const ArticleWebView({required this.url, required this.title, Key? key})
    : super(key: key);

  @override
  State<ArticleWebView> createState() => _ArticleWebViewState();
}

class _ArticleWebViewState extends State<ArticleWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    if (!_isWebViewSupported()) return;
    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..loadRequest(Uri.parse(widget.url));
  }

  bool _isWebViewSupported() {
    if (kIsWeb) return false;
    try {
      return Platform.isAndroid || Platform.isIOS;
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isWebViewSupported()) {
      // On web or unsupported platforms, open in browser or show a message
      return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: Center(
          child: ElevatedButton(
            onPressed: () => launchUrl(Uri.parse(widget.url)),
            child: Text('Open in browser'),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: WebViewWidget(controller: _controller),
    );
  }
}
