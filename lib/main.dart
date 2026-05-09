import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resheragroup/features/quickPick/provider/vendor_provider.dart';
import 'package:resheragroup/main_screen.dart';
import 'core/di/injection_container.dart' as di;
import 'features/quickPick/provider/cart_provider.dart';
import 'features/quickPick/provider/category_provider.dart';

import 'features/quickPick/provider/sub_category_provider.dart';
import 'features/quickPick/provider/vendor_category_provider.dart';
import 'features/quickPick/provider/product_provider.dart';
import 'features/quickPick/provider/product_details_provider.dart';
import 'features/quickPick/provider/view_cart_list_provider.dart';
import 'features/quickPick/provider/update_cart_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => SubCategoryProvider()),
        ChangeNotifierProvider(create: (_) => VendorProvider()),
        ChangeNotifierProvider(create: (_) => VendorCategoryProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => ProductDetailsProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ViewCartListProvider()),
        ChangeNotifierProvider(create: (_) => UpdateCartProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reshera Group',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}
