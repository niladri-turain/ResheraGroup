import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../widgets/custom_skeleton_widget.dart';
import '../../../core/di/injection_container.dart';
import '../../../core/service/shared_pref_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
      );
    _loadPage();
  }

  Future<void> _loadPage() async {
    // Keeping it consistent with OrderScreen structure
    // final token = await sl<SharedPrefService>().getToken();
    _controller.loadRequest(
      Uri.parse('https://resheragroup.in/dashboard?platform=app'),
    );
  }

  @override
  Widget build(BuildContext context) {
    AppSize.init(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
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
