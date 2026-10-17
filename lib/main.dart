import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'constants/firebase_constants.dart';
import 'models/app_settings_model.dart';
import 'models/product_model.dart';
import 'services/firebase_service.dart';
import 'services/order_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase initialization with safe bypass for missing credentials
  try {
    await FirebaseService.initialize();
  } catch (e) {
    debugPrint("Firebase init bypassed: $e");
  }

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
          seedColor: const Color(0xFFFFB900), // Farm Egg Golden Yolk
          primary: const Color(0xFFD97706),
          secondary: const Color(0xFF15803D), // Farm Pasture Green
          surface: const Color(0xFFFFFFEE),
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

class AndaExpressHomeScreen extends ConsumerStatefulWidget {
  const AndaExpressHomeScreen({super.key});

  @override
  ConsumerState<AndaExpressHomeScreen> createState() => _AndaExpressHomeScreenState();
}

class _AndaExpressHomeScreenState extends ConsumerState<AndaExpressHomeScreen> {
  final OrderService _orderService = OrderService();
  AppSettingsModel? _appSettings;
  double _testAmount = 250.0;
  double _calculatedFee = 2.0;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final settings = await _orderService.getAppSettings();
      setState(() {
        _appSettings = settings;
        _calculatedFee = settings.calculatePlatformFee(_testAmount);
      });
    } catch (e) {
      debugPrint("Settings load bypassed: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AndaExpress'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.egg_outlined, size: 80, color: Color(0xFFD97706)),
              const SizedBox(height: 16),
              const Text(
                'Welcome to AndaExpress!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Platform Fee: ₹${_calculatedFee.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
