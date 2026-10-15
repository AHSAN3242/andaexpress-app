import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'constants/firebase_constants.dart';
import 'models/app_settings_model.dart';
import 'models/product_model.dart';
import 'services/firebase_service.dart';
import 'services/order_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase & Offline Persistence
  await FirebaseService.initialize();

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
          seedColor: const Color(0xFFE89005), // Farm Egg Golden Yolk
          primary: const Color(0xFFD97706),
          secondary: const Color(0xFF15803D), // Farm Pasture Green
          surface: const Color(0xFFFFFBEB),
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
    final settings = await _orderService.getAppSettings();
    setState(() {
      _appSettings = settings;
      _calculatedFee = settings.calculatePlatformFee(_testAmount);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.egg_alt_outlined),
            SizedBox(width: 8),
            Text(
              'AndaExpress',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Tagline
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFD97706), Color(0xFFB45309)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Farm-Fresh Eggs & Chicken Every Day',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Direct from verified bio-secure poultry farms within 24 hours of lay.',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              'Platform Fee Slab Engine (Admin Managed)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // Slabs Display Card
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    ...?_appSettings?.platformFeeSlabs.map(
                      (s) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('₹${s.min.toInt()} - ₹${s.max.toInt()}'),
                            Text(
                              'Fee: ₹${s.fee.toInt()}',
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFD97706)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Test Cart Amount: ₹${_testAmount.toStringAsFixed(0)}'),
                        Chip(
                          label: Text(
                            'Platform Fee: ₹${_calculatedFee.toStringAsFixed(0)}',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          backgroundColor: const Color(0xFF15803D),
                        ),
                      ],
                    ),
                    Slider(
                      value: _testAmount,
                      min: 0,
                      max: 2500,
                      divisions: 50,
                      activeColor: const Color(0xFFD97706),
                      onChanged: (val) {
                        setState(() {
                          _testAmount = val;
                          _calculatedFee = _appSettings?.calculatePlatformFee(val) ?? 0.0;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              'Float Test Freshness Guarantee & Dispute Workflow',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: const Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.science_outlined, color: Color(0xFF2563EB)),
                        SizedBox(width: 8),
                        Text(
                          'Float Test Proof Policy',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Fresh eggs sink horizontally. If an egg floats in water, submit a photo proof '
                      'via the Dispute screen to automatically trigger an instant refund or replacement.',
                      style: TextStyle(fontSize: 13, color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
