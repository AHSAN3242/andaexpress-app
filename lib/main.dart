import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AndaExpressApp());
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
        primaryColor: const Color(0xFFD97706),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFFB900),
          primary: const Color(0xFFD97706),
          secondary: const Color(0xFF15803D),
        ),
        scaffoldBackgroundColor: const Color(0xFFF9FAFB),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Color(0xFFD97706),
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
      ),
      home: const CompleteLoginFlowScreen(),
    );
  }
}

class CompleteLoginFlowScreen extends StatefulWidget {
  const CompleteLoginFlowScreen({super.key});

  @override
  State<CompleteLoginFlowScreen> createState() => _CompleteLoginFlowScreenState();
}

class _CompleteLoginFlowScreenState extends State<CompleteLoginFlowScreen> {
  String _selectedRole = 'buyer'; // 'buyer', 'seller', 'commuter'
  String _selectedLanguage = 'hi'; // 'hi', 'en', 'mr'
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool _isOtpSent = false;
  bool _isLoading = false;

  Map<String, Map<String, String>> localizedText = {
    'hi': {
      'title': 'अंडा एक्सप्रेस (AndaExpress)',
      'subtitle': 'खेत से सीधे ताज़ा अंडे और चिकन',
      'roleTitle': 'अपनी प्रोफाइल चुनें:',
      'buyer': 'खरीदार (Buyer)',
      'seller': 'पोल्ट्री किसान (Seller)',
      'commuter': 'डिलीवरी पार्टनर (Commuter)',
      'phoneHint': '10 अंकों का मोबाइल नंबर',
      'getOtp': 'ओटीपी प्राप्त करें',
      'otpHint': '6 अंकों का ओटीपी दर्ज करें',
      'verify': 'लॉगिन करें और आगे बढ़ें',
      'changeNum': 'नंबर बदलें',
    },
    'en': {
      'title': 'AndaExpress',
      'subtitle': 'Farm-Fresh Eggs & Chicken Every Day',
      'roleTitle': 'Select Your Profile:',
      'buyer': 'Buyer / Customer',
      'seller': 'Poultry Farmer / Seller',
      'commuter': 'Delivery Commuter',
      'phoneHint': 'Enter 10-digit Mobile Number',
      'getOtp': 'Get OTP',
      'otpHint': 'Enter 6-digit OTP',
      'verify': 'Verify & Continue',
      'changeNum': 'Change Number',
    },
    'mr': {
      'title': 'अंडा एक्सप्रेस (AndaExpress)',
      'subtitle': 'थेट पोल्ट्री फार्ममधून ताजी अंडी आणि चिकन',
      'roleTitle': 'आपली भूमिका निवडा:',
      'buyer': 'ग्राहक (Buyer)',
      'seller': 'शेतकरी / विक्रेता (Seller)',
      'commuter': 'डिलिव्हरी पार्टनर (Commuter)',
      'phoneHint': '10 अंकी मोबाईल नंबर',
      'getOtp': 'ओटीपी मिळवा',
      'otpHint': '6 अंकी ओटीपी टाका',
      'verify': 'लॉगिन करा',
      'changeNum': 'नंबर बदला',
    }
  };

  void _sendOtp() {
    if (_phoneController.text.trim().length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('कृपया सही 10 अंकों का नंबर डालें / Enter valid 10-digit number')),
      );
      return;
    }
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 600), () {
      setState(() {
        _isLoading = false;
        _isOtpSent = true;
      });
    });
  }

  void _loginSuccess() {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 600), () {
      setState(() => _isLoading = false);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => RoleDashboardScreen(
            role: _selectedRole,
            phone: _phoneController.text.trim(),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = localizedText[_selectedLanguage]!;

    return Scaffold(
      appBar: AppBar(
        title: Text(t['title']!),
        actions: [
          DropdownButton<String>(
            value: _selectedLanguage,
            underline: const SizedBox(),
            dropdownColor: const Color(0xFFD97706),
            icon: const Icon(Icons.language, color: Colors.white),
            items: const [
              DropdownMenuItem(value: 'hi', child: Text('हिंदी', style: TextStyle(color: Colors.white))),
              DropdownMenuItem(value: 'en', child: Text('English', style: TextStyle(color: Colors.white))),
              DropdownMenuItem(value: 'mr', child: Text('मराठी', style: TextStyle(color: Colors.white))),
            ],
            onChanged: (val) {
              if (val != null) setState(() => _selectedLanguage = val);
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),
            const Icon(Icons.egg_alt, size: 70, color: Color(0xFFD97706)),
            const SizedBox(height: 10),
            Text(
              t['subtitle']!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF374151)),
            ),
            const SizedBox(height: 24),
            Text(
              t['roleTitle']!,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 10),

            // Profile Selection Options
            Row(
              children: [
                Expanded(child: _buildRoleCard('buyer', t['buyer']!, Icons.shopping_bag)),
                const SizedBox(width: 8),
                Expanded(child: _buildRoleCard('seller', t['seller']!, Icons.storefront)),
                const SizedBox(width: 8),
                Expanded(child: _buildRoleCard('commuter', t['commuter']!, Icons.delivery_dining)),
              ],
            ),
            const SizedBox(height: 28),

            // Phone Field
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              enabled: !_isOtpSent,
              decoration: InputDecoration(
                prefixText: '+91 ',
                labelText: t['phoneHint'],
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.phone),
              ),
            ),
            const SizedBox(height: 16),

            // OTP Field if sent
            if (_isOtpSent) ...[
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: t['otpHint'],
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lock_clock),
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => setState(() => _isOtpSent = false),
                  child: Text(t['changeNum']!),
                ),
              ),
            ],

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : (_isOtpSent ? _loginSuccess : _sendOtp),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD97706),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                      _isOtpSent ? t['verify']! : t['getOtp']!,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleCard(String role, String label, IconData icon) {
    final isSelected = _selectedRole == role;
    return GestureDetector(
      onTap: () => setState(() => _selectedRole = role),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFEF3C7) : Colors.white,
          border: Border.all(
            color: isSelected ? const Color(0xFFD97706) : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? const Color(0xFFD97706) : Colors.grey, size: 30),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? const Color(0xFFB45309) : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Role Dashboard Screen
class RoleDashboardScreen extends StatelessWidget {
  final String role;
  final String phone;

  const RoleDashboardScreen({super.key, required this.role, required this.phone});

  @override
  Widget build(BuildContext context) {
    String title = role == 'seller'
        ? 'सेलर डैशबोर्ड (Seller Panel)'
        : role == 'commuter'
            ? 'कम्यूटर डैशबोर्ड (Commuter Panel)'
            : 'ग्राहक फ़ीड (Buyer Feed)';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const CompleteLoginFlowScreen()),
              );
            },
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                role == 'seller'
                    ? Icons.storefront
                    : role == 'commuter'
                        ? Icons.delivery_dining
                        : Icons.shopping_basket,
                size: 80,
                color: const Color(0xFFD97706),
              ),
              const SizedBox(height: 16),
              Text(
                'लॉगिन सफल! (Role: ${role.toUpperCase()})',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('मोबाइल: +91 $phone', style: const TextStyle(color: Colors.grey, fontSize: 16)),
              const SizedBox(height: 24),
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    role == 'seller'
                        ? 'यहाँ से आप अपने पोल्ट्री फार्म के अंडे/चिकन की ताज़ा खेप लिस्ट कर सकते हैं।'
                        : role == 'commuter'
                            ? 'यहाँ आपको नजदीकी डिलीवरी रूट्स और पिकअप ऑर्डर्स दिखेंगे।'
                            : 'यहाँ ताज़ा अंडे और पोल्ट्री प्रोडक्ट्स की लाइव लिस्टिंग दिख रही है।',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
