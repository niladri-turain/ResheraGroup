import 'package:flutter/material.dart';
import '../../../../core/constants/app_sizes.dart';
import 'custom_login_text_field.dart';

class LoginCard extends StatefulWidget {
  const LoginCard({super.key});

  @override
  State<LoginCard> createState() => _LoginCardState();
}

class _LoginCardState extends State<LoginCard> {
  bool _rememberMe = false;
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSize.width(0.06)),
      decoration: BoxDecoration(
        color: const Color(0xFF121212).withOpacity(0.9), // Dark card background
        borderRadius: BorderRadius.circular(AppSize.width(0.05)),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Logo
          Container(
            width: AppSize.width(0.2),
            height: AppSize.width(0.2),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              gradient: RadialGradient(
                colors: [Colors.white, Color(0xFFFFDAB9)],
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(AppSize.width(0.03)),
              child: Image.asset(
                'assets/images/logo.png', // Fallback to available logo
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.business, color: Colors.orange, size: 40),
              ),
            ),
          ),
          SizedBox(height: AppSize.height(0.01)),
          
          // Title
          Text(
            "Login to Your Account",
            style: TextStyle(
              color: Colors.white,
              fontSize: AppSize.width(0.05),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppSize.height(0.003)),
          Text(
            "Enter your credentials to continue",
            style: TextStyle(
              color: Colors.white60,
              fontSize: AppSize.width(0.030),
            ),
          ),
          SizedBox(height: AppSize.height(0.03)),

          // Input Fields
          const CustomLoginTextField(
            hintText: "Username / Nickname",
          ),
          SizedBox(height: AppSize.height(0.02)),
          CustomLoginTextField(
            hintText: "Password",
            isPassword: _obscurePassword,
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: Colors.white38,
                size: 20,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
          ),
          SizedBox(height: AppSize.height(0.01)),

          // Remember Me & Forgot Password
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: Checkbox(
                      value: _rememberMe,
                      onChanged: (value) {
                        setState(() {
                          _rememberMe = value ?? false;
                        });
                      },
                      side: const BorderSide(color: Colors.white38),
                      activeColor: const Color(0xFF00BFA5),
                    ),
                  ),
                  SizedBox(width: AppSize.width(0.01)),
                  Text(
                    "Remember me",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: AppSize.width(0.032),
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(
                    color: const Color(0xFF00BFA5), // Teal color
                    fontSize: AppSize.width(0.032),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSize.height(0.01)),

          // Login Button
          SizedBox(
            width: double.infinity,
            height: AppSize.height(0.05),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF5722), // Orange color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSize.width(0.03)),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: AppSize.width(0.045),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: AppSize.width(0.02)),
                  const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
