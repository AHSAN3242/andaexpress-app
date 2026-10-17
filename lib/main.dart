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
    Future.delayed(const Duration(milliseconds: 400), () {
      setState(() {
        _isLoading = false;
        _isOtpSent = true;
        _otpController.text = '123456';
      });
    });
  }

  void _loginSuccess() {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 400), () {
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

class _RoleDashboardScreenState extends State<RoleDashboardScreen> {
  final List<Map<String, dynamic>> _sellerListings = [
    {'item': 'देसी ताज़ा अंडे (Desi Eggs)', 'quantity': '20 Crates', 'price': '₹190/Crate'},
    {'item': 'ब्रायलर अंडे (Farm Fresh)', 'quantity': '50 Crates', 'price': '₹155/Crate'},
  ];

  int _cartCount = 0;

  final List<Map<String, dynamic>> _commuterTrips = [
    {'from': 'पाटिल पोल्ट्री फार्म', 'to': 'सेंट्रल सिटी हब', 'crates': '40 Crates', 'earning': '₹480', 'done': false},
    {'from': 'ग्रीन वैली फार्म', 'to': 'लोकल मार्केट डिपो', 'crates': '25 Crates', 'earning': '₹320', 'done': false},
  ];

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
            const Text('नई खेप लिस्ट करें', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TextField(controller: itemCtl, decoration: const InputDecoration(labelText: 'उत्पाद का प्रकार', border: OutlineInputBorder())),
            const SizedBox(height: 10),
            TextField(controller: qtyCtl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'मात्रा (Crates)', border: OutlineInputBorder())),
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
                  });
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('खेप सफलतापूर्वक जोड़ी गई!')));
              },
              child: const Text('सबमिट करें'),
            )
          ],
        ),
      ),
    );
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const CompleteLoginFlowScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.role == 'seller') {
      return Scaffold(
        appBar: AppBar(title: const Text('सेलर डैशबोर्ड (Seller)'), actions: [IconButton(icon: const Icon(Icons.logout), onPressed: _logout)]),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFFD97706), borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('उपलब्ध वॉलेट बैलेंस', style: TextStyle(color: Colors.white70, fontSize: 13)),
                  const SizedBox(height: 4),
                  const Text('₹18,450.00', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('मोबाइल: +91 ${widget.phone}', style: const TextStyle(color: Colors.white, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('सक्रिय खेप (Listings)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ElevatedButton.icon(
                  onPressed: _showAddBatchDialog,
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('नई खेप'),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF15803D), foregroundColor: Colors.white),
                )
              ],
            ),
            const SizedBox(height: 10),
            ..._sellerListings.map((lot) => Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: const Icon(Icons.egg, color: Color(0xFFD97706), size: 36),
                title: Text(lot['item'], style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('${lot['quantity']} • ${lot['price']}'),
                trailing: const Chip(label: Text('सक्रिय', style: TextStyle(fontSize: 11, color: Colors.green))),
              ),
            )),
          ],
        ),
      );
    } else if (widget.role == 'commuter') {
      return Scaffold(
        appBar: AppBar(title: const Text('कम्यूटर डिलीवरी (Commuter)'), actions: [IconButton(icon: const Icon(Icons.logout), onPressed: _logout)]),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(8)),
              child: const Text('अपनी यात्रा के रूट पर अंडे पिक करें और कमाई करें!', style: TextStyle(color: Color(0xFF166534), fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 16),
            const Text('उपलब्ध ट्रिप्स', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ..._commuterTrips.map((trip) => Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('कमीशन: ${trip['earning']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF15803D))),
                        Chip(label: Text(trip['crates'])),
                      ],
                    ),
                    const Divider(),
                    Text('पिकअप: ${trip['from']}'),
                    Text('ड्रॉप: ${trip['to']}'),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: trip['done'] ? Colors.grey : const Color(0xFFD97706),
                          foregroundColor: Colors.white,
                        ),
                        onPressed: trip['done'] ? null : () {
                          setState(() => trip['done'] = true);
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('ट्रिप स्वीकार कर ली गई!')));
                        },
                        child: Text(trip['done'] ? 'स्वीकार किया जा चुका है' : 'ट्रिप स्वीकार करें'),
                      ),
                    )
                  ],
                ),
              ),
            )),
          ],
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('ग्राहक बाज़ार (Buyer Feed)'),
          actions: [
            IconButton(
              icon: Badge(
                label: Text('$_cartCount'),
                isLabelVisible: _cartCount > 0,
                child: const Icon(Icons.shopping_cart),
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('कार्ट में कुल $_cartCount आइटम हैं।')));
              },
            ),
            IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text('ताज़ा स्टॉक (Live Farm Batches)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buyerCard('कड़कनाथ शुद्ध देसी अंडे', 'आनंद पोल्ट्री फार्म', '₹220/Crate', Icons.egg),
            _buyerCard('फार्म फ्रेश टेबल एग्स (White)', 'बालाजी एग्रो फार्म', '₹150/Crate', Icons.egg_alt),
            _buyerCard('देसी चिकन (लाइव ब्रायलर)', 'किसान मित्र पोल्ट्री', '₹135/Kg', Icons.scale),
          ],
        ),
      );
    }
  }

  Widget _buyerCard(String name, String farm, String price, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: const Color(0xFFFEF3C7), child: Icon(icon, color: const Color(0xFFD97706))),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('$farm • $price'),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD97706), foregroundColor: Colors.white),
          onPressed: () {
            setState(() => _cartCount++);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$name कार्ट में जोड़ा गया!'), duration: const Duration(seconds: 1)));
          },
          child: const Text('जोड़ें'),
        ),
      ),
    );
  }
}
