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
  String _selectedRole = 'seller';
  String _selectedLanguage = 'hi';
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool _isOtpSent = false;
  bool _isLoading = false;

  final Map<String, Map<String, String>> localizedText = {
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
        const SnackBar(content: Text('कृपया सही 10 अंकों का नंबर दर्ज करें')),
      );
      return;
    }
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _isLoading = false;
        _isOtpSent = true;
        _otpController.text = '123456';
      });
    });
  }

  void _loginSuccess() {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 300), () {
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
              onPressed: _isLoading ? null : (_isOtpSent ? _loginSuccess : _sendOtp),
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

class RoleDashboardScreen extends StatefulWidget {
  final String role;
  final String phone;

  const RoleDashboardScreen({super.key, required this.role, required this.phone});

  @override
  State<RoleDashboardScreen> createState() => _RoleDashboardScreenState();
}

class _RoleDashboardScreenState extends State<RoleDashboardScreen> with SingleTickerProviderStateMixin {
  late TabController _sellerTabController;
  int _cartCount = 0;

  final List<Map<String, dynamic>> _sellerListings = [
    {
      'item': 'देसी ताज़ा अंडे (Desi Eggs)',
      'quantity': '20 Crates (600 Eggs)',
      'price': '₹190/Crate',
      'grade': 'A+ ग्रेड (55-60g)',
      'laidTime': 'आज सुबह 5:30 AM',
      'farm': 'पाटिल पोल्ट्री फार्म, प्लॉट 14',
    },
    {
      'item': 'ब्रायलर अंडे (Farm Fresh)',
      'quantity': '50 Crates (1500 Eggs)',
      'price': '₹155/Crate',
      'grade': 'स्टैंडर्ड टेबल एग्स',
      'laidTime': 'कल शाम 6:00 PM',
      'farm': 'पाटिल पोल्ट्री फार्म, प्लॉट 14',
    },
  ];

  final List<Map<String, dynamic>> _buyerDemands = [
    {
      'buyerName': 'शाही बेकर्स प्राइवेट लिमिटेड',
      'location': 'सेंट्रल मार्केट (दूरी 6 किमी)',
      'requirement': 'ताज़ा व्हाइट अंडे - 100 Crates',
      'targetRate': '₹152/Crate',
      'frequency': 'रोज़ाना सुबह डिलीवरी चाहिए',
    },
    {
      'buyerName': 'होटल ग्रीन पार्क & रेस्टोरेंट',
      'location': 'हाइवे जंक्शन (दूरी 3.5 किमी)',
      'requirement': 'देसी चिकन (लाइव ब्रायलर) - 80 Kg',
      'targetRate': '₹140/Kg',
      'frequency': 'हफ़्ते में 3 दिन',
    },
  ];

  final List<Map<String, dynamic>> _buyerProducts = [
    {
      'name': 'कड़कनाथ शुद्ध देसी अंडे',
      'price': '₹220/Crate',
      'farmName': 'आनंद पोल्ट्री फार्म',
      'farmer': 'आनंदराव देशमुख (प्रगतिशील किसान)',
      'location': 'पारस फाटा रोड (2.5 किमी दूर)',
      'stock': '35 Crates उपलब्ध',
      'details': '100% प्रोटीन व शुद्धता की गारंटी। पानी पर तैरने (Float-Test) की ताज़गी गारंटी।',
      'icon': Icons.egg,
    },
    {
      'name': 'फार्म फ्रेश टेबल एग्स (White)',
      'price': '₹150/Crate',
      'farmName': 'बालाजी एग्रो पोल्ट्री',
      'farmer': 'सुरेश पाटिल',
      'location': 'इंडस्ट्रियल एस्टेट के पास (5 किमी दूर)',
      'stock': '120 Crates उपलब्ध',
      'details': 'स्वच्छ और सैनिटाइज्ड क्रेट्स। रोजमर्रा के उपयोग और रिटेल दुकानों के लिए उपयुक्त।',
      'icon': Icons.egg_alt,
    },
    {
      'name': 'देसी चिकन (लाइव फार्म ब्रायलर)',
      'price': '₹135/Kg',
      'farmName': 'किसान मित्र फार्म',
      'farmer': 'विकास शिंदे',
      'location': 'अकोला बायपास (8 किमी दूर)',
      'stock': '250 पंछी (औसत वजन 1.8-2.2 Kg)',
      'details': 'स्वस्थ और प्राकृतिक दानों पर पले चिकन। ऑन-डिमांड लाइव वजन पर डिलीवरी।',
      'icon': Icons.scale,
    },
  ];

  final List<Map<String, dynamic>> _commuterTrips = [
    {
      'id': 'TRIP-802',
      'from': 'पाटिल पोल्ट्री फार्म, प्लॉट 14',
      'farmerName': 'रमेश पाटिल (+91 9822011223)',
      'to': 'सेंट्रल सिटी हब, गेट नं 2',
      'contactPerson': 'हब मैनेजर (+91 9422556677)',
      'distance': '12.4 किमी (लगभग 25 मिनट)',
      'crates': '40 Crates',
      'earning': '₹480',
      'vehicle': 'टू-व्हीलर या ऑटो पिकअप',
      'done': false,
    },
    {
      'id': 'TRIP-805',
      'from': 'ग्रीन वैली फार्म, गेट नं 1',
      'farmerName': 'दिनेश गायकवाड़ (+91 9766112233)',
      'to': 'लोकल होलसेल एग मार्केट, दुकान नं 18',
      'contactPerson': 'दुकानदार (+91 9988776655)',
      'distance': '7.8 किमी (लगभग 15 मिनट)',
      'crates': '25 Crates',
      'earning': '₹320',
      'vehicle': 'टू-व्हीलर उपयुक्त',
      'done': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _sellerTabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _sellerTabController.dispose();
    super.dispose();
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const CompleteLoginFlowScreen()),
    );
  }

  void _showAddBatchDialog() {
    final itemCtl = TextEditingController(text: 'देसी पोल्ट्री अंडे');
    final qtyCtl = TextEditingController(text: '15');
    final priceCtl = TextEditingController(text: '185');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('नई खेप लिस्ट करें (Add Lot)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TextField(controller: itemCtl, decoration: const InputDecoration(labelText: 'उत्पाद का प्रकार', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: qtyCtl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'मात्रा (Crates की संख्या)', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: priceCtl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'रेट प्रति Crate (₹)', border: OutlineInputBorder())),
            const SizedBox(height: 14),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD97706), foregroundColor: Colors.white),
              onPressed: () {
                setState(() {
                  _sellerListings.insert(0, {
                    'item': itemCtl.text.trim(),
                    'quantity': '${qtyCtl.text.trim()} Crates',
                    'price': '₹${priceCtl.text.trim()}/Crate',
                    'grade': 'A ग्रेड फ्रेश',
                    'laidTime': 'अभी-अभी पोस्ट किया',
                    'farm': 'आपका पोल्ट्री फार्म',
                  });
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('नई खेप सफलतापूर्वक लाइव हो गई!')));
              },
              child: const Text('खेप पोस्ट करें'),
            )
          ],
        ),
      ),
    );
  }

  void _showListingDetail(Map<String, dynamic> lot) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(lot['item'].toString(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('फार्म: ${lot['farm']}', style: const TextStyle(color: Colors.grey, fontSize: 13)),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('उपलब्ध स्टॉक: ${lot['quantity']}', style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(lot['price'].toString(), style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF15803D), fontSize: 16)),
              ],
            ),
            const SizedBox(height: 8),
            Text('ग्रेडिंग: ${lot['grade']}'),
            const SizedBox(height: 4),
            Text('समय: ${lot['laidTime']}'),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.edit),
                label: const Text('रेट या मात्रा बदलें'),
                onPressed: () => Navigator.pop(ctx),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBuyerProductDetail(Map<String, dynamic> prod) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(backgroundColor: const Color(0xFFFEF3C7), radius: 24, child: Icon(prod['icon'] as IconData, color: const Color(0xFFD97706), size: 28)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(prod['name'].toString(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text(prod['price'].toString(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF15803D))),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            const Text('पोल्ट्री फार्म का विवरण:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text('फार्म का नाम: ${prod['farmName']}'),
            Text('किसान: ${prod['farmer']}'),
            Text('स्थान/दूरी: ${prod['location']}'),
            Text('उपलब्ध मात्रा: ${prod['stock']}'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(8)),
              child: Text(prod['details'].toString(), style: const TextStyle(fontSize: 13, color: Color(0xFF374151))),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD97706), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
                icon: const Icon(Icons.shopping_cart_checkout),
                label: const Text('अभी ऑर्डर करें'),
                onPressed: () {
                  Navigator.pop(ctx);
                  setState(() => _cartCount++);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('ऑर्डर तैयार है! क
