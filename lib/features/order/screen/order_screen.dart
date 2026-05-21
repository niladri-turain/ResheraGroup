import 'package:flutter/material.dart';
import 'package:resheragroup/core/constants/app_strings.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../core/di/injection_container.dart';
import '../../../core/service/shared_pref_service.dart';
import '../../../widgets/custom_skeleton_widget.dart';

import '../../../core/constants/app_sizes.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  // @override
  // void initState() {
  //   super.initState();
  //   _controller = WebViewController()
  //     ..setJavaScriptMode(JavaScriptMode.unrestricted)
  //     ..setBackgroundColor(const Color(0x00000000))
  //     ..setNavigationDelegate(
  //       NavigationDelegate(
  //         onProgress: (int progress) {
  //           // Update loading bar.
  //         },
  //         onPageStarted: (String url) {
  //           setState(() {
  //             _isLoading = true;
  //           });
  //         },
  //         onPageFinished: (String url) {
  //           setState(() {
  //             _isLoading = false;
  //           });
  //         },
  //         onWebResourceError: (WebResourceError error) {},
  //         onNavigationRequest: (NavigationRequest request) {
  //           return NavigationDecision.navigate;
  //         },
  //       ),
  //     );
  //   _loadPage();
  // }
  //
  // Future<void> _loadPage() async {
  //   final token = await sl<SharedPrefService>().getToken();
  //   _controller.loadRequest(
  //     Uri.parse('https://resheragroup.in/order-menu'),
  //     // headers: {
  //     //   'Authorization': 'Bearer ${token ?? ""}',
  //     //   'Accept': 'application/json',
  //     //   'Content-Type': 'application/json',
  //     //   'X-API-TOKEN': AppStrings.xApiTokenForLogin
  //     // },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    AppSize.init(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // if (!_isApiLoading) WebViewWidget(controller: _controller),
            // if (_isApiLoading || _isPageLoading)
            //   const Center(child: CustomSkeletonWidget()),
            Center(
              child: Text("Order Coming Soon",style: TextStyle(fontSize: 18,color: Colors.black),),
            )
          ],
        ),
      ),
    );
  }
}
