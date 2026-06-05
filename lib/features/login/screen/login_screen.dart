import 'package:flutter/material.dart';
import '../../../../core/constants/app_images_png.dart';
import '../../../../core/constants/app_sizes.dart';
import '../widget/login_card.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback? onLoginSuccess;
  const LoginScreen({super.key, this.onLoginSuccess});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    AppSize.init(context);
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              AppImagesPng.dashboardBackground,
              fit: BoxFit.cover,
            ),
          ),
          // Dark Overlay for better contrast
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          // Login Card
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: AppSize.width(0.06)),
              child: LoginCard(onLoginSuccess: widget.onLoginSuccess),
            ),
          ),
          // Back button if onLoginSuccess is provided (meaning it's pushed as a standalone screen)
          if (widget.onLoginSuccess != null)
            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              left: 10,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
        ],
      ),
    );
  }
}
