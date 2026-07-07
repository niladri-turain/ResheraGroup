import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../core/constants/app_sizes.dart';
import 'custom_skeleton_widget.dart';

class CommonWebViewScreen extends StatefulWidget {
  final String url;
  final String? title;

  const CommonWebViewScreen({
    super.key,
    required this.url,
    this.title,
  });

  @override
  State<CommonWebViewScreen> createState() => _CommonWebViewScreenState();
}

class _CommonWebViewScreenState extends State<CommonWebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    AppSize.init(context);
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_isLoading)
              const Center(child: CustomSkeletonWidget()),
          ],
        ),
      ),
    );
  }
}
