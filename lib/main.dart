import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Directly start the app UI so it never freezes on white or black screen
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
      home: const AndaExpressHomeScreen(),
    );
  }
}

class AndaExpressHomeScreen extends StatefulWidget {
  const AndaExpressHomeScreen({super.key});

  @override
  State<AndaExpressHomeScreen> createState() => _AndaExpressHomeScreenState();
}

class _AndaExpressHomeScreenState extends State<AndaExpressHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AndaExpress'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.egg_alt_outlined, 
                size: 90, 
                color: Color(0xFFD97706),
              ),
              const SizedBox(height: 20),
              const Text(
                'AndaExpress',
                style: TextStyle(
                  fontSize: 28, 
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Farm-Fresh Eggs & Chicken Every Day',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.shopping_cart),
                label: const Text('Start Order'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD97706),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
