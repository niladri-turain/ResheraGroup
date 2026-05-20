import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../widgets/custom_skeleton_widget.dart';
import '../../login/provider/login_provider.dart';
import '../provider/home_provider.dart';
import '../../../main_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final WebViewController _controller;
  bool _isPageLoading = true; // For WebView itself
  bool _isApiLoading = true;  // For initial dashboard API check

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
              _isPageLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isPageLoading = false;
            });
          },
        ),
      );
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeDashboard();
    });
  }

  Future<void> _initializeDashboard() async {
    final loginProvider = context.read<LoginProvider>();
    final homeProvider = context.read<HomeProvider>();

    // 1. Check if logged in
    if (loginProvider.userName == null) {
      // Redirect to Login (Account Tab)
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen(initialIndex: 3)),
          (route) => false,
        );
      }
      return;
    }

    // 2. Call Dashboard API
    final success = await homeProvider.fetchDashboard();

    if (success) {
      // 3. If 200 OK, Load WebView
      _controller.loadRequest(Uri.parse('https://resheragroup.in/dashboard'));
      if (mounted) {
        setState(() {
          _isApiLoading = false;
        });
      }
    } else {
      // Handle failure (maybe show error or redirect)
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(homeProvider.errorMessage ?? "Failed to initialize dashboard")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    AppSize.init(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            if (!_isApiLoading) WebViewWidget(controller: _controller),
            if (_isApiLoading || _isPageLoading) 
              const Center(child: CustomSkeletonWidget()),
          ],
        ),
      ),
    );
  }
}
