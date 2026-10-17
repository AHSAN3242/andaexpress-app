import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/login_screen.dart';
import 'screens/customer_feed_screen.dart';
import 'screens/seller_upload_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: AndaExpressApp(),
    ),
  );
}

class AndaExpressApp extends StatelessWidget {
  const AndaExpressApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AndaExpress',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFFB900),
          primary: const Color(0xFFD97706),
        ),
        scaffoldBackgroundColor: const Color(0xFFF9FAFB),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Color(0xFFD97706),
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
      ),
      home: LoginScreen(
        onLoginSuccess: (String phone, String role, String language) {
          // लॉगिन सफल होने पर रोल (Buyer या Seller) के अनुसार स्क्रीन खोलें
          runApp(
            ProviderScope(
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                home: role == 'seller'
                    ? const SellerUploadScreen()
                    : const CustomerFeedScreen(),
              ),
            ),
          );
        },
      ),
    );
  }
}
