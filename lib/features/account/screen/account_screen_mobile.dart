import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/service/shared_pref_service.dart';
import '../../../core/di/injection_container.dart';
import '../../quickPick/provider/login_provider.dart';
import '../../quickPick/provider/view_cart_list_provider.dart';
import '../../login/screen/login_screen.dart';

class AccountScreenMobile extends StatefulWidget {
  const AccountScreenMobile({super.key});

  @override
  State<AccountScreenMobile> createState() => _AccountScreenMobileState();
}

class _AccountScreenMobileState extends State<AccountScreenMobile> {
  final SharedPrefService _prefService = sl<SharedPrefService>();
  
  String? name;
  String? email;
  String? phone;
  String? username;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final n = await _prefService.getName();
    final e = await _prefService.getEmail();
    final p = await _prefService.getPhone();
    final u = await _prefService.getUsername();
    if (mounted) {
      setState(() {
        name = n;
        email = e;
        phone = p;
        username = u;
      });
    }
  }

  Future<void> _handleLogout() async {
    await context.read<LoginProvider>().logout();
    if (mounted) {
      await context.read<ViewCartListProvider>().clearCartLocal();
      // Reset local state
      setState(() {
        name = null;
        email = null;
        phone = null;
        username = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    AppSize.init(context);

    return Consumer<LoginProvider>(
      builder: (context, loginProvider, child) {
        // If not logged in, show LoginScreen within the current tab structure
        if (loginProvider.userName == null) {
          return const LoginScreen();
        }

        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            automaticallyImplyLeading: false,
            title: const Text("My Account", style: TextStyle(color: Colors.white)),
            actions: [
              IconButton(
                onPressed: _handleLogout,
                icon: const Icon(Icons.logout, color: Colors.redAccent),
              )
            ],
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(AppSize.width(0.05)),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.orange,
                  child: Icon(Icons.person, size: 60, color: Colors.white),
                ),
                const SizedBox(height: 20),
                _buildInfoCard("Name", name ?? loginProvider.userName ?? "N/A", Icons.person_outline),
                _buildInfoCard("Username", username ?? "N/A", Icons.alternate_email),
                _buildInfoCard("Email", email ?? "N/A", Icons.email_outlined),
                _buildInfoCard("Phone", phone ?? "N/A", Icons.phone_android_outlined),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _handleLogout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text("Logout", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.orange, size: 24),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
