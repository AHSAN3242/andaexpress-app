import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:image/image.dart' as img;

// ग्लोबल स्टेट
class AppState {
  static List<Map<String, dynamic>> orders = [];
  static double sellerWallet = 18450.0;
  static double escrowHold = 0.0;
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(
    title: "Anda Express",
    debugShowCheckedModeBanner: false,
    home: AndaRoot(),
  ));
}

class AndaRoot extends StatefulWidget {
  const AndaRoot({super.key});
  @override
  State<AndaRoot> createState() => _AndaRootState();
}

class _AndaRootState extends State<AndaRoot> {
  String _lang = "hi", _role = "buyer";
  final _phone = TextEditingController(), _otp = TextEditingController();
  bool _sent = false;

  final Map<String, List<String>> _t = {
    "hi": ["अंडा एक्सप्रेस", "खेत से ताज़ा अंडे और चिकन", "खरीदार", "किसान", "डिलीवरी", "10 अंकों का फोन नंबर", "ओटीपी प्राप्त करें", "लॉगिन करें"],
    "en": ["Anda Express", "Farm Fresh Eggs & Chicken", "Buyer", "Seller", "Commuter", "10-digit Phone", "Get OTP", "Login"],
    "mr": ["अंडा एक्सप्रेस", "ताजी अंडी आणि चिकन", "ग्राहक", "शेतकरी", "डिलिव्हरी", "10 अंकी फोन नंबर", "ओटीपी मिळवा", "लॉगिन करा"],
  };

  @override
  Widget build(BuildContext context) {
    final cur = _t[_lang]!;
    return Scaffold(
      appBar: AppBar(
        title: Text(cur[0]),
        backgroundColor: const Color(0xFF15803D),
        foregroundColor: Colors.white,
        actions: [
          DropdownButton<String>(
            value: _lang,
            dropdownColor: const Color(0xFF15803D),
            underline: const SizedBox(),
            icon: const Icon(Icons.language, color: Colors.white),
            items: const [
              DropdownMenuItem(value: "hi", child: Text("हिंदी", style: TextStyle(color: Colors.white))),
              DropdownMenuItem(value: "en", child: Text("English", style: TextStyle(color: Colors.white))),
              DropdownMenuItem(value: "mr", child: Text("मराठी", style: TextStyle(color: Colors.white))),
            ],
            onChanged: (v) => setState(() => _lang = v!),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, spreadRadius: 2),
                ],
                border: Border.all(color: const Color(0xFFFEF3C7), width: 3),
              ),
              child: const Center(
                child: Icon(Icons.egg_alt, size: 54, color: Color(0xFFF59E0B)),
              ),
            ),
            const SizedBox(height: 12),
            Text(cur[1], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF15803D))),
            const SizedBox(height: 20),
            Row(
              children: [
                _roleBox("buyer", cur[2], Icons.shopping_bag),
                const SizedBox(width: 8),
                _roleBox("seller", cur[3], Icons.storefront),
                const SizedBox(width: 8),
                _roleBox("commuter", cur[4], Icons.delivery_dining),
              ],
            ),
            const SizedBox(height: 20),
            TextField(controller: _phone, keyboardType: TextInputType.phone, decoration: InputDecoration(prefixText: "+91 ", labelText: cur[5], border: const OutlineInputBorder())),
            if (_sent) ...[
              const SizedBox(height: 12),
              TextField(controller: _otp, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "OTP (123456)", border: OutlineInputBorder())),
            ],
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF9F2089), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14)),
                onPressed: () {
                  if (!_sent) {
                    if (_phone.text.length < 10) return;
                    setState(() { _sent = true; _otp.text = "123456"; });
                  } else {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => DashScreen(role: _role, phone: _phone.text, lang: _lang)));
                  }
                },
                child: Text(_sent ? cur[7] : cur[6], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _roleBox(String r, String txt, IconData ic) {
    final s = _role == r;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _role = r),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: s ? const Color(0xFFFDF2F8) : Colors.white, border: Border.all(color: s ? const Color(0xFF9F2089) : Colors.grey.shade300, width: s ? 2 : 1), borderRadius: BorderRadius.circular(8)),
          child: Column(children: [Icon(ic, color: s ? const Color(0xFF9F2089) : Colors.grey), const SizedBox(height: 4), Text(txt, style: TextStyle(fontWeight: s ? FontWeight.bold : FontWeight.normal))]),
        ),
      ),
    );
  }
}
class DashScreen extends StatefulWidget {
  final String role, phone, lang;
  const DashScreen({super.key, required this.role, required this.phone, required this.lang});
  @override
  State<DashScreen> createState() => _DashScreenState();
}

class _DashScreenState extends State<DashScreen> {
  final List<Map<String, dynamic>> _cartItems = [];
  String _selectedCategory = "अंडे";
  String _selectedEggSub = "सभी";
  String _selectedDeliveryMode = "home";
  final _buyerAddressCtl = TextEditingController();

  final List<Map<String, dynamic>> _mainCategories = [
    {"name": "अंडे", "icon": "🥚"},
    {"name": "देसी चिकन", "icon": "🐓"},
    {"name": "बॉयलर चिकन", "icon": "🐔"},
    {"name": "कड़कनाथ", "icon": "black_rooster"},
    {"name": "बतख", "icon": "🦆"},
    {"name": "बटेर", "icon": "🐦"},
    {"name": "ईमू", "icon": "🦤"},
    {"name": "अन्य", "icon": "✨"},
  ];

  final List<String> _eggSubCategories = [
    "सभी", "देसी अंडे", "कड़कनाथ अंडे", "टेबल एग्स", "बतख के अंडे", "बटेर अंडे", "ईमू अंडे"
  ];

  static Widget getItemIcon(String name, {double size = 24}) {
    final n = name.toLowerCase();
    if (n.contains("कड़कनाथ") && (n.contains("लाइव") || n.contains("ब्लैक") || n.contains("चिकन") || n.contains("पक्षी") || n == "black_rooster")) {
      return ColorFiltered(
        colorFilter: const ColorFilter.matrix(<double>[
          -1.0, 0, 0, 0, 40,
          0, -1.0, 0, 0, 40,
          0, 0, -1.0, 0, 40,
          0, 0, 0, 1.0, 0,
        ]),
        child: Text("🐓", style: TextStyle(fontSize: size)),
      );
    } else if (n.contains("कड़कनाथ") && n.contains("अंडे")) {
      return Container(
        width: size, height: size * 1.25,
        decoration: BoxDecoration(color: const Color(0xFF262626), borderRadius: BorderRadius.all(Radius.elliptical(size, size * 1.25)), border: Border.all(color: Colors.black54, width: 1.5)),
      );
    } else if (n.contains("बटेर") && (n.contains("अंडे") || n.contains("quail"))) {
      return Container(
        width: size, height: size * 1.25,
        decoration: BoxDecoration(color: const Color(0xFFE5E5E5), borderRadius: BorderRadius.all(Radius.elliptical(size, size * 1.25)), border: Border.all(color: Colors.grey.shade600, width: 1)),
        child: Stack(children: [
          Positioned(top: 4, left: 4, child: Container(width: 4, height: 4, decoration: const BoxDecoration(color: Colors.black87, shape: BoxShape.circle))),
          Positioned(bottom: 5, right: 5, child: Container(width: 5, height: 4, decoration: const BoxDecoration(color: Colors.black87, shape: BoxShape.circle))),
          Positioned(top: 10, right: 4, child: Container(width: 3, height: 3, decoration: const BoxDecoration(color: Colors.black87, shape: BoxShape.circle))),
        ]),
      );
    } else if (n.contains("ईमू") && n.contains("अंडे")) {
      return Container(
        width: size * 1.1, height: size * 1.35,
        decoration: BoxDecoration(color: const Color(0xFF0D5C58), borderRadius: BorderRadius.all(Radius.elliptical(size * 1.1, size * 1.35)), border: Border.all(color: const Color(0xFF063533), width: 1.5)),
      );
    } else if (n.contains("टेबल") || (n.contains("व्हाइट") && n.contains("अंडे"))) {
      return Container(
        width: size, height: size * 1.25,
        decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.all(Radius.elliptical(size, size * 1.25)), border: Border.all(color: Colors.grey.shade400, width: 1)),
      );
    } else if (n.contains("अंडे")) {
      return Container(
        width: size, height: size * 1.25,
        decoration: BoxDecoration(color: const Color(0xFFD97706), borderRadius: BorderRadius.all(Radius.elliptical(size, size * 1.25)), border: Border.all(color: const Color(0xFFB45309), width: 1)),
      );
    } else if (n.contains("बतख")) {
      return Text("🦆", style: TextStyle(fontSize: size));
    } else if (n.contains("बटेर")) {
      return Text("🐦", style: TextStyle(fontSize: size));
    } else if (n.contains("ईमू")) {
      return Text("🦤", style: TextStyle(fontSize: size));
    } else if (n.contains("बॉयलर")) {
      return Text("🐔", style: TextStyle(fontSize: size));
    } else if (n.contains("अन्य") || n == "✨") {
      return Text("✨", style: TextStyle(fontSize: size));
    }
    return Text("🐓", style: TextStyle(fontSize: size));
  }

  static Widget buildProductThumbnail(String name, {String? imagePath, double width = 68, double height = 68}) {
    if (imagePath != null && imagePath.trim().isNotEmpty) {
      if (imagePath.startsWith("http")) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(imagePath, width: width, height: height, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _fallbackThumb(name, width, height)),
        );
      } else {
        final f = File(imagePath);
        if (f.existsSync()) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(f, width: width, height: height, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _fallbackThumb(name, width, height)),
          );
        }
      }
    }
    return _fallbackThumb(name, width, height);
  }

  static Widget _fallbackThumb(String name, double width, double height) {
    return Container(
      width: width, height: height,
      decoration: BoxDecoration(color: const Color(0xFFFFFBEB), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFFEF3C7))),
      child: Center(child: getItemIcon(name, size: width * 0.45)),
    );
  }

  final List<Map<String, dynamic>> _allProducts = [
    {"cat": "अंडे", "sub": "देसी अंडे", "item": "शुद्ध देसी अंडे", "unitType": "Crate", "price": 190.0, "unit": "₹190/Crate", "farm": "कृष्णा पोल्ट्री फार्म", "farmAddress": "गेट नं. 4, पारस रोड, अकोला", "dist": "2.1 किमी", "grade": "खेत से ताज़ा", "farmerPhone": "9876543210", "image": "https://images.unsplash.com/photo-1516467508483-a7212febe31a?auto=format&fit=crop&w=400&q=80"},
    {"cat": "अंडे", "sub": "कड़कनाथ अंडे", "item": "कड़कनाथ ओरिजिनल अंडे", "unitType": "Crate", "price": 240.0, "unit": "₹240/Crate", "farm": "आनंद पोल्ट्री फार्म", "farmAddress": "शिव मंदिर के पीछे, हाईवे नाका", "dist": "3.5 किमी", "grade": "High Protein A+", "farmerPhone": "9876543211", "image": "https://images.unsplash.com/photo-1582722872445-44dc5f7e3c8f?auto=format&fit=crop&w=400&q=80"},
    {"cat": "अंडे", "sub": "टेबल एग्स", "item": "व्हाइट टेबल एग्स (ब्रायलर)", "unitType": "Crate", "price": 155.0, "unit": "₹155/Crate", "farm": "पाटिल पोल्ट्री हब", "dist": "5.0 किमी", "farmAddress": "पाटिल वाड़ी, बायपास रोड", "grade": "Commercial Fresh", "farmerPhone": "9876543212", "image": "https://images.unsplash.com/photo-1506976785307-8732e854ad03?auto=format&fit=crop&w=400&q=80"},
    {"cat": "अंडे", "sub": "बतख के अंडे", "item": "ऑर्गेनिक बतख अंडे", "unitType": "Crate", "price": 210.0, "unit": "₹210/Crate", "farm": "रिवरसाइड डक फार्म", "farmAddress": "नहर पुलिया के पास", "dist": "7.0 किमी", "grade": "Large Size", "farmerPhone": "9876543213", "image": "https://images.unsplash.com/photo-1498654896293-37aacf113fd9?auto=format&fit=crop&w=400&q=80"},
    {"cat": "अंडे", "sub": "बटेर अंडे", "item": "बटेर (Quail) औषधीय अंडे", "unitType": "Crate", "price": 120.0, "unit": "₹120/Crate", "farm": "ग्रीन वैली पोल्ट्री", "farmAddress": "एमआईडीसी गेट क्र. 2", "dist": "4.0 किमी", "grade": "चितकबरे स्पॉट Nutrient Rich", "farmerPhone": "9876543214", "image": "https://images.unsplash.com/photo-1598965675045-45c5e72c7d05?auto=format&fit=crop&w=400&q=80"},
    {"cat": "अंडे", "sub": "ईमू अंडे", "item": "ईमू जंबो औषधीय अंडे", "unitType": "Piece", "price": 450.0, "unit": "₹450/Piece", "farm": "महावीर ईमू फार्म", "dist": "12.0 किमी", "farmAddress": "महावीर नगर, वाशिम रोड", "grade": "Dark Green Shell", "farmerPhone": "9876543215", "image": "https://images.unsplash.com/photo-1563245372-f21724e3856d?auto=format&fit=crop&w=400&q=80"},
    {"cat": "देसी चिकन", "sub": "देसी", "item": "देसी रंगीन चिकन (नर ♂️ Rooster)", "unitType": "Bird", "price": 310.0, "unit": "₹310/Bird", "farm": "बालाजी फार्म", "farmAddress": "बालाजी मंदिर के सामने, ग्रामीण मार्ग", "dist": "6.0 किमी", "grade": "Natural Organic", "farmerPhone": "9876543216", "image": "https://images.unsplash.com/photo-1548550023-2bdb3c5beed7?auto=format&fit=crop&w=400&q=80"},
    {"cat": "देसी चिकन", "sub": "देसी", "item": "देसी रंगीन चिकन (मादा ♀️ Hen)", "unitType": "Bird", "price": 270.0, "unit": "₹270/Bird", "farm": "बालाजी फार्म", "farmAddress": "बालाजी मंदिर के सामने, ग्रामीण मार्ग", "dist": "6.0 किमी", "grade": "Natural Organic", "farmerPhone": "9876543216", "image": "https://images.unsplash.com/photo-1612170153139-6f881ff067e0?auto=format&fit=crop&w=400&q=80"},
    {"cat": "बॉयलर चिकन", "sub": "बॉयलर", "item": "कमर्शियल व्हाइट बॉयलर", "unitType": "Bird", "price": 135.0, "unit": "₹135/Bird", "farm": "स्टार पोल्ट्री", "farmAddress": "शेड नंबर 3, बस स्टैंड बैकसाइड", "dist": "3.0 किमी", "grade": "Standard 2.2kg", "farmerPhone": "9876543217", "image": "https://images.unsplash.com/photo-1516467508483-a7212febe31a?auto=format&fit=crop&w=400&q=80"},
    {"cat": "कड़कनाथ", "sub": "कड़कनाथ", "item": "कड़कनाथ ब्लैक लाइव (नर ♂️ Rooster)", "unitType": "Bird", "price": 700.0, "unit": "₹700/Bird", "farm": "आनंद पोल्ट्री फार्म", "farmAddress": "शिव मंदिर के पीछे, हाईवे नाका", "dist": "3.5 किमी", "grade": "Pure Black Aseel", "farmerPhone": "9876543211", "image": "https://images.unsplash.com/photo-1589923188900-85dae523342b?auto=format&fit=crop&w=400&q=80"},
    {"cat": "कड़कनाथ", "sub": "कड़कनाथ", "item": "कड़कनाथ ब्लैक लाइव (मादा ♀️ Hen)", "unitType": "Bird", "price": 600.0, "unit": "₹600/Bird", "farm": "आनंद पोल्ट्री फार्म", "farmAddress": "शिव मंदिर के पीछे, हाईवे नाका", "dist": "3.5 किमी", "grade": "Pure Black Aseel", "farmerPhone": "9876543211", "image": "https://images.unsplash.com/photo-1589923188900-85dae523342b?auto=format&fit=crop&w=400&q=80"},
    {"cat": "बतख", "sub": "बतख", "item": "देसी / फार्म बतख (नर ♂️ Drake)", "unitType": "Bird", "price": 350.0, "unit": "₹350/Bird", "farm": "रिवरसाइड डक फार्म", "farmAddress": "नहर पुलिया के पास", "dist": "7.0 किमी", "grade": "Farm Raised Live", "farmerPhone": "9876543213", "image": "https://images.unsplash.com/photo-1555861496-0666c8981751?auto=format&fit=crop&w=400&q=80"},
    {"cat": "बतख", "sub": "बतख", "item": "देसी / फार्म बतख (मादा ♀️ Duck)", "unitType": "Bird", "price": 310.0, "unit": "₹310/Bird", "farm": "रिवरसाइड डक फार्म", "farmAddress": "नहर पुलिया के पास", "dist": "7.0 किमी", "grade": "Farm Raised Live", "farmerPhone": "9876543213", "image": "https://images.unsplash.com/photo-1555861496-0666c8981751?auto=format&fit=crop&w=400&q=80"},
    {"cat": "बटेर", "sub": "बटेर", "item": "जापानी बटेर (नर ♂️ Male Quail)", "unitType": "Bird", "price": 70.0, "unit": "₹70/Bird", "farm": "ग्रीन वैली पोल्ट्री", "dist": "4.0 किमी", "farmAddress": "एमआईडीसी गेट क्र. 2", "grade": "Healthy Weight", "farmerPhone": "9876543214", "image": "https://images.unsplash.com/photo-1598965675045-45c5e72c7d05?auto=format&fit=crop&w=400&q=80"},
    {"cat": "बटेर", "sub": "बटेर", "item": "जापानी बटेर (मादा ♀️ Female Quail)", "unitType": "Bird", "price": 60.0, "unit": "₹60/Bird", "farm": "ग्रीन वैली पोल्ट्री", "dist": "4.0 किमी", "farmAddress": "एमआईडीसी गेट क्र. 2", "grade": "Egg Layer Quality", "farmerPhone": "9876543214", "image": "https://images.unsplash.com/photo-1598965675045-45c5e72c7d05?auto=format&fit=crop&w=400&q=80"},
    {"cat": "ईमू", "sub": "ईमू", "item": "ईमू लाइव वयस्क (नर ♂️ Male Emu)", "unitType": "Bird", "price": 3800.0, "unit": "₹3800/Bird", "farm": "महावीर ईमू फार्म", "dist": "12.0 किमी", "farmAddress": "महावीर नगर, वाशिम रोड", "grade": "Pure Breed 35kg+", "farmerPhone": "9876543215", "image": "https://images.unsplash.com/photo-1563245372-f21724e3856d?auto=format&fit=crop&w=400&q=80"},
    {"cat": "ईमू", "sub": "ईमू", "item": "ईमू लाइव वयस्क (मादा ♀️ Female Emu)", "unitType": "Bird", "price": 3500.0, "unit": "₹3500/Bird", "farm": "महावीर ईमू फार्म", "dist": "12.0 किमी", "farmAddress": "महावीर नगर, वाशिम रोड", "grade": "Pure Breed Breeding Female", "farmerPhone": "9876543215", "image": "https://images.unsplash.com/photo-1563245372-f21724e3856d?auto=format&fit=crop&w=400&q=80"},
    {"cat": "अन्य", "sub": "अन्य", "item": "वनराजा / ग्रामप्रिया लाइव देसी", "unitType": "Bird", "price": 320.0, "unit": "₹320/Bird", "farm": "किसान स्पेशल फार्म", "dist": "5.0 किमी", "farmAddress": "ग्रामीण शेड नंबर 2", "grade": "देसी फ्री-रेंज", "farmerPhone": "9876543216", "image": "https://images.unsplash.com/photo-1548550023-2bdb3c5beed7?auto=format&fit=crop&w=400&q=80"},
  ];

  late List<Map<String, String>> _sellerListings;

  @override
  void initState() {
    super.initState();
    _sellerListings = [
      {"item": "देसी पोल्ट्री अंडे", "type": "अंडे", "qty": "20 Crates", "price": "₹190/Crate", "farm": "मेरा फार्म (+91 ${widget.phone})", "farmAddress": "पारस रेलवे क्रॉसिंग के पास, फार्म शेड #1", "grade": "Grade A+ ताज़ा", "image": "https://images.unsplash.com/photo-1516467508483-a7212febe31a?auto=format&fit=crop&w=400&q=80"},
      {"item": "कड़कनाथ ओरिजिनल अंडे", "type": "अंडे", "qty": "10 Crates", "price": "₹240/Crate", "farm": "मेरा फार्म (+91 ${widget.phone})", "farmAddress": "पारस रेलवे क्रॉसिंग के पास, फार्म शेड #1", "grade": "प्रीमियम", "image": "https://images.unsplash.com/photo-1582722872445-44dc5f7e3c8f?auto=format&fit=crop&w=400&q=80"},
      {"item": "कड़कनाथ ब्लैक लाइव (नर ♂️ Rooster)", "type": "पक्षी/बर्ड्स", "qty": "15 Birds", "price": "₹700/Bird", "farm": "मेरा फार्म (+91 ${widget.phone})", "farmAddress": "पारस रेलवे क्रॉसिंग के पास, फार्म शेड #1", "grade": "प्योर ब्लैक", "image": "https://images.unsplash.com/photo-1589923188900-85dae523342b?auto=format&fit=crop&w=400&q=80"},
      {"item": "देसी बतख लाइव (मादा ♀️ Duck)", "type": "पक्षी/बर्ड्स", "qty": "40 Birds", "price": "₹310/Bird", "farm": "मेरा फार्म (+91 ${widget.phone})", "farmAddress": "पारस रेलवे क्रॉसिंग के पास, फार्म शेड #1", "grade": "हेल्दी लाइव", "image": "https://images.unsplash.com/photo-1555861496-0666c8981751?auto=format&fit=crop&w=400&q=80"},
    ];
  }
    void _showProductDetails(Map<String, dynamic> product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: buildProductThumbnail(product["item"] as String, imagePath: product["image"] as String?, width: 140, height: 140),
            ),
            const SizedBox(height: 16),
            Text(product["item"] as String, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("दर: ${product['unit']}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF15803D))),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("📍 फार्म: ${product['farm']} (${product['dist']})", style: const TextStyle(fontWeight: FontWeight.w600)),
                  Text("🏠 पिकअप पता: ${product['farmAddress']}", style: const TextStyle(fontSize: 12, color: Colors.blueGrey)),
                  Text("✨ गुणवत्ता/ग्रेड: ${product['grade']}", style: const TextStyle(fontSize: 12, color: Color(0xFF9F2089), fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF9F2089), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
              onPressed: () {
                Navigator.pop(ctx);
                _addToCartWithQty(product);
              },
              child: const Text("मात्रा चुनें और खरीदें", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }

  void _modal(String title, List<Widget> body, String btnText, VoidCallback onAct) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => StatefulBuilder(
        builder: (ctx, setMState) => Padding(
          padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF15803D))),
              const Divider(),
              ...body,
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF9F2089), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
                onPressed: () {
                  Navigator.pop(ctx);
                  onAct();
                },
                child: Text(btnText, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addToCartWithQty(Map<String, dynamic> product) {
    int qty = 1;
    final unit = product["unitType"] == "Crate" ? "क्रेट / ट्रे" : (product["unitType"] == "Bird" ? "पंछी / नग" : "पीस");

    showDialog(
      context: context,
      builder: (dCtx) => StatefulBuilder(
        builder: (context, setDState) => AlertDialog(
          title: Text(product["item"] as String, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("फार्म पता: ${product['farmAddress']}", style: const TextStyle(fontSize: 12, color: Colors.blueGrey)),
              const SizedBox(height: 8),
              Text("रेट: ${product['unit']}", style: const TextStyle(color: Color(0xFF15803D), fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Text("ज़रूरी मात्रा ($unit):", style: const TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline, size: 30, color: Colors.red),
                    onPressed: () {
                      if (qty > 1) setDState(() => qty--);
                    },
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400), borderRadius: BorderRadius.circular(8)),
                    child: Text("$qty $unit", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline, size: 30, color: Color(0xFF15803D)),
                    onPressed: () => setDState(() => qty++),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text("कुल मूल्य: ₹${((product['price'] as double) * qty).toStringAsFixed(0)}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF9F2089))),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dCtx), child: const Text("रद्द करें")),
            OutlinedButton(
              onPressed: () {
                setState(() {
                  _cartItems.add({
                    "item": product["item"],
                    "farm": product["farm"],
                    "farmAddress": product["farmAddress"],
                    "farmerPhone": product["farmerPhone"] ?? "9876543210",
                    "dist": product["dist"],
                    "unitPrice": product["price"],
                    "unitType": product["unitType"],
                    "qty": qty,
                    "total": (product["price"] as double) * qty,
                  });
                });
                Navigator.pop(dCtx);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$qty $unit कार्ट में जोड़ा गया!"), duration: const Duration(seconds: 1)));
              },
              child: const Text("कार्ट में जोड़ें"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF9F2089), foregroundColor: Colors.white),
              onPressed: () {
                setState(() {
                  _cartItems.clear();
                  _cartItems.add({
                    "item": product["item"],
                    "farm": product["farm"],
                    "farmAddress": product["farmAddress"],
                    "farmerPhone": product["farmerPhone"] ?? "9876543210",
                    "dist": product["dist"],
                    "unitPrice": product["price"],
                    "unitType": product["unitType"],
                    "qty": qty,
                    "total": (product["price"] as double) * qty,
                  });
                });
                Navigator.pop(dCtx);
                _showCheckout();
              },
              child: const Text("अभी खरीदें"),
            ),
          ],
        ),
      ),
    );
  }
    void _showCheckout() {
    if (_cartItems.isEmpty) return;

    double subtotal = 0;
    int totalQuantityUnits = 0;
    for (var itm in _cartItems) {
      subtotal += (itm["total"] as double);
      totalQuantityUnits += (itm["qty"] as int);
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setMState) {
          double deliveryFee = 0.0;
          if (_selectedDeliveryMode == "bus_stop") {
            deliveryFee = max(30.0, totalQuantityUnits * 15.0);
          } else if (_selectedDeliveryMode == "home") {
            deliveryFee = max(60.0, totalQuantityUnits * 30.0);
          }
          double total = subtotal + deliveryFee;

          return Padding(
            padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text("ऑर्डर चेकआउट (Escrow Order)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF15803D))),
                  const Divider(),
                  Text("कुल सामग्री: ${_cartItems.length} प्रकार (कुल $totalQuantityUnits नग/क्रेट)", style: const TextStyle(fontWeight: FontWeight.bold)),
                  ..._cartItems.map((ci) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text("• ${ci['item']}: ${ci['qty']} ${ci['unitType']} = ₹${ci['total']}", style: const TextStyle(fontSize: 13)),
                  )),
                  const SizedBox(height: 10),
                  Text("📍 स्रोत फार्म: ${_cartItems.first['farm']}\nपता: ${_cartItems.first['farmAddress']}", style: const TextStyle(fontSize: 12, color: Colors.blueGrey)),
                  const SizedBox(height: 12),
                  const Text("डिलीवरी का तरीका चुनें:", style: TextStyle(fontWeight: FontWeight.bold)),
                  RadioListTile<String>(
                    dense: true,
                    title: const Text("फार्म से स्वयं पिकअप (Self Pickup)"),
                    subtitle: const Text("शुल्क: ₹0 (खुद जाकर दिए गए फार्म पते से लें)"),
                    value: "self",
                    groupValue: _selectedDeliveryMode,
                    onChanged: (v) => setMState(() => _selectedDeliveryMode = v!),
                  ),
                  RadioListTile<String>(
                    dense: true,
                    title: const Text("बस स्टॉप / मुख्य सड़क (Bus Stop)"),
                    subtitle: Text("शुल्क: ₹${max(30.0, totalQuantityUnits * 15.0).toStringAsFixed(0)} (कम्यूटर कमीशन प्रति नग)"),
                    value: "bus_stop",
                    groupValue: _selectedDeliveryMode,
                    onChanged: (v) => setMState(() => _selectedDeliveryMode = v!),
                  ),
                  RadioListTile<String>(
                    dense: true,
                    title: const Text("घर / दुकान पर सीधी डिलीवरी (Home)"),
                    subtitle: Text("शुल्क: ₹${max(60.0, totalQuantityUnits * 30.0).toStringAsFixed(0)} (कम्यूटर कमीशन ₹30/नग)"),
                    value: "home",
                    groupValue: _selectedDeliveryMode,
                    onChanged: (v) => setMState(() => _selectedDeliveryMode = v!),
                  ),
                  if (_selectedDeliveryMode != "self") ...[
                    const SizedBox(height: 8),
                    TextField(
                      controller: _buyerAddressCtl,
                      decoration: InputDecoration(
                        labelText: _selectedDeliveryMode == "bus_stop" ? "नजदीकी बस स्टॉप / लैंडमार्क" : "घर/दुकान का पूरा पता",
                        border: const OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                  ],
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("सामग्री मूल्य:", style: TextStyle(color: Colors.grey)),
                      Text("₹${subtotal.toStringAsFixed(0)}", style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("कम्यूटर डिलीवरी कमीशन:", style: TextStyle(color: Colors.grey)),
                      Text("₹${deliveryFee.toStringAsFixed(0)}", style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF9F2089))),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("कुल एस्क्रो राशि:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF15803D))),
                      Text("₹${total.toStringAsFixed(0)}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF15803D))),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF9F2089), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
                    onPressed: () {
                      Navigator.pop(ctx);
                      final orderId = "AND-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}";
                      final otp = (1000 + Random().nextInt(9000)).toString();
                      final productSummary = _cartItems.map((e) => "${e['item']} (${e['qty']} ${e['unitType']})").join(", ");
                      final firstFarm = _cartItems.first["farm"] as String;
                      final firstFarmAddress = _cartItems.first["farmAddress"] as String;
                      final farmerPhone = _cartItems.first["farmerPhone"] as String;
                      final dist = _cartItems.first["dist"] as String;
                      final dropAddress = _selectedDeliveryMode == "self" ? "स्वयं पिकअप (फार्म से)" : (_buyerAddressCtl.text.trim().isEmpty ? "ग्राहक स्थान" : _buyerAddressCtl.text.trim());

                      setState(() {
                        for (var cartItem in _cartItems) {
                          for (var sellerLot in _sellerListings) {
                            if (sellerLot["item"] == cartItem["item"]) {
                              int curStock = int.tryParse(sellerLot["qty"]!.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
                              int boughtQty = cartItem["qty"] as int;
                              int newStock = max(0, curStock - boughtQty);
                              String unitName = sellerLot["qty"]!.contains("Crate") ? "Crates" : "Birds";
                              sellerLot["qty"] = "$newStock $unitName";
                            }
                          }
                        }

                        AppState.escrowHold += total;
                        AppState.orders.insert(0, {
                          "id": orderId,
                          "otp": otp,
                          "buyerPhone": widget.phone,
                          "farmerPhone": farmerPhone,
                          "product": productSummary,
                          "farm": firstFarm,
                          "farmAddress": firstFarmAddress,
                          "dist": dist,
                          "dropAddress": dropAddress,
                          "mode": _selectedDeliveryMode,
                          "amount": subtotal,
                          "deliveryFee": deliveryFee,
                          "status": "pending_seller",
                        });
                        _cartItems.clear();
                        _buyerAddressCtl.clear();
                      });

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("ऑर्डर $orderId बुक हो गया! आपका डिलीवरी OTP: $otp है।"), duration: const Duration(seconds: 4)));
                    },
                    child: const Text("एस्क्रो से ऑर्डर बुक करें", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
    }
    void _addBatchDialog() {
    String selectedType = "अंडे";
    String selectedGender = "नर ♂️ (Rooster)";
    String selectedItem = "देसी पोल्ट्री अंडे";
    String? localPhotoPath;
    bool isProcessingGps = false;
    final customNameCtl = TextEditingController();
    final qtyCtl = TextEditingController(text: "15");
    final rateCtl = TextEditingController(text: "190");
    final addressCtl = TextEditingController(text: "पारस रेलवे क्रॉसिंग के पास, फार्म शेड #1");
    final picker = ImagePicker();

    final Map<String, List<String>> itemOptions = {
      "अंडे": ["देसी पोल्ट्री अंडे", "कड़कनाथ ओरिजिनल अंडे", "व्हाइट टेबल एग्स", "ऑर्गेनिक बतख अंडे", "बटेर औषधीय अंडे", "ईमू जंबो औषधीय अंडे", "अन्य अंडे (Other Eggs)"],
      "पक्षी/बर्ड्स": ["देसी रंगीन चिकन", "कमर्शियल बॉयलर", "कड़कनाथ ब्लैक लाइव", "देसी / फार्म बतख", "जापानी बटेर (Quail)", "ईमू वयस्क पक्षी", "अन्य नस्ल (Other Breed)"],
    };

    // लाइव GPS लोकेशन फेच करने का फंक्शन
    Future<Position?> getCurrentGps() async {
      try {
        LocationPermission perm = await Geolocator.checkPermission();
        if (perm == LocationPermission.denied) {
          perm = await Geolocator.requestPermission();
          if (perm == LocationPermission.denied) return null;
        }
        if (perm == LocationPermission.deniedForever) return null;
        return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high, timeLimit: const Duration(seconds: 7));
      } catch (_) {
        return null;
      }
    }

    // फोटो पर लाइव GPS + टाइम वॉटरमार्क छापने का फंक्शन
    Future<String> burnGpsWatermark(String rawPath, Position? pos) async {
      final bytes = await File(rawPath).readAsBytes();
      img.Image? original = img.decodeImage(bytes);
      if (original == null) return rawPath;

      // इमेज को मानक आकार (800w) में रिसाइज़ करना
      if (original.width > 900) {
        original = img.copyResize(original, width: 800);
      }

      final now = DateTime.now();
      final dateStr = DateFormat("dd-MMM-yyyy hh:mm a").format(now);
      final lat = pos != null ? pos.latitude.toStringAsFixed(4) : "20.7002";
      final lng = pos != null ? pos.longitude.toStringAsFixed(4) : "77.0082";
      final gpsLine = "GPS: $lat N, $lng E | $dateStr";
      const farmLine = "VERIFIED FARM LOT | ANDA EXPRESS";

      // नीचे डार्क ओवरले बार जोड़ना
      final barH = 50;
      final startY = original.height - barH;
      img.fillRect(original, x1: 0, y1: startY, x2: original.width, y2: original.height, color: img.ColorRgba8(0, 0, 0, 200));

      // वॉटरमार्क टेक्स्ट लिखना
      img.drawString(original, gpsLine, font: img.arial14, x: 15, y: startY + 8, color: img.ColorRgba8(254, 240, 138, 255));
      img.drawString(original, farmLine, font: img.arial14, x: 15, y: startY + 28, color: img.ColorRgba8(255, 255, 255, 255));

      final stampedPath = rawPath.replaceAll(".jpg", "_gps.jpg");
      final stampedFile = File(stampedPath);
      await stampedFile.writeAsBytes(img.encodeJpg(original, quality: 82));
      return stampedFile.path;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => StatefulBuilder(
        builder: (ctx, setBState) {
          final isEgg = selectedType == "अंडे";
          final isOther = selectedItem.contains("अन्य");
          final unitLabel = isEgg ? "Crate (ट्रे)" : "Birds (नग)";
          final rateLabel = isEgg ? "रेट प्रति Crate (₹)" : "रेट प्रति Bird (₹)";

          Future<void> pickPhoto(ImageSource src) async {
            try {
              final picked = await picker.pickImage(source: src, imageQuality: 85);
              if (picked != null) {
                setBState(() => isProcessingGps = true);
                final pos = await getCurrentGps();
                final stamped = await burnGpsWatermark(picked.path, pos);
                setBState(() {
                  localPhotoPath = stamped;
                  isProcessingGps = false;
                });
              }
            } catch (e) {
              setBState(() => isProcessingGps = false);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("फोटो कैप्चर में असमर्थ।")));
            }
          }

          return Padding(
            padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text("नई खेप लिस्ट करें (Add Lot)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF15803D))),
                  const Divider(),
                  const Text("1. प्रकार चुनें (Type):", style: TextStyle(fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<String>(
                          title: const Text("अंडे"),
                          value: "अंडे",
                          groupValue: selectedType,
                          onChanged: (v) {
                            setBState(() {
                              selectedType = v!;
                              selectedItem = itemOptions[selectedType]!.first;
                              rateCtl.text = "190";
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<String>(
                          title: const Text("पक्षी/बर्ड्स"),
                          value: "पक्षी/बर्ड्स",
                          groupValue: selectedType,
                          onChanged: (v) {
                            setBState(() {
                              selectedType = v!;
                              selectedItem = itemOptions[selectedType]!.first;
                              rateCtl.text = "290";
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  if (!isEgg) ...[
                    const SizedBox(height: 6),
                    const Text("2. लिंग चुनें (Gender):", style: TextStyle(fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<String>(
                            dense: true,
                            title: const Text("नर ♂️ (Rooster/Drake)"),
                            value: "नर ♂️",
                            groupValue: selectedGender,
                            onChanged: (v) => setBState(() => selectedGender = v!),
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<String>(
                            dense: true,
                            title: const Text("मादा ♀️ (Hen/Duck)"),
                            value: "मादा ♀️",
                            groupValue: selectedGender,
                            onChanged: (v) => setBState(() => selectedGender = v!),
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 8),
                  Text(isEgg ? "2. अंडे की नस्ल:" : "3. पक्षी की नस्ल:", style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400), borderRadius: BorderRadius.circular(6)),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      underline: const SizedBox(),
                      value: selectedItem,
                      items: itemOptions[selectedType]!.map((it) => DropdownMenuItem(value: it, child: Text(it))).toList(),
                      onChanged: (v) => setBState(() => selectedItem = v!),
                    ),
                  ),
                  if (isOther) ...[
                    const SizedBox(height: 10),
                    TextField(
                      controller: customNameCtl,
                      decoration: InputDecoration(
                        labelText: isEgg ? "अंडे/नस्ल का नाम लिखें (उदा. वनराजा अंडे)" : "पक्षी/नस्ल का नाम लिखें (उदा. वनराजा, ग्रामप्रिया)",
                        border: const OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  // जीपीएस वाटरमार्क कैमरा बटन
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (_) => SafeArea(
                          child: Wrap(
                            children: [
                              ListTile(
                                leading: const Icon(Icons.camera_alt, color: Color(0xFF15803D)),
                                title: const Text("कैमरा से लाइव GPS फोटो खींचें 📷"),
                                subtitle: const Text("ऑटोमैटिक दिनांक व लोकेशन स्टैम्प"),
                                onTap: () {
                                  Navigator.pop(context);
                                  pickPhoto(ImageSource.camera);
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.photo_library, color: Color(0xFF9F2089)),
                                title: const Text("गैलरी से फोटो चुनें 🖼️"),
                                onTap: () {
                                  Navigator.pop(context);
                                  pickPhoto(ImageSource.gallery);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: localPhotoPath != null ? const Color(0xFFECFDF5) : Colors.grey.shade50,
                        border: Border.all(color: localPhotoPath != null ? const Color(0xFF15803D) : Colors.grey.shade400, width: 1.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          if (isProcessingGps)
                            const SizedBox(width: 48, height: 48, child: Center(child: CircularProgressIndicator(color: Color(0xFF15803D))))
                          else if (localPhotoPath != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.file(File(localPhotoPath!), width: 54, height: 54, fit: BoxFit.cover),
                            )
                          else
                            const Icon(Icons.add_a_photo, size: 36, color: Color(0xFF15803D)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isProcessingGps
                                      ? "GPS स्टैम्प लगाया जा रहा है..."
                                      : (localPhotoPath != null ? "GPS वाटरमार्क फोटो तैयार ✅" : "लाइव GPS फोटो खींचें 📷"),
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                                Text(
                                  localPhotoPath != null ? "लाइव लोकेशन व दिनांक वॉटरमार्क शामिल है" : "टैप करें - ऑटोमैटिक टाइम व GPS मुहर लगेगी",
                                  style: const TextStyle(fontSize: 11, color: Colors.blueGrey),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: qtyCtl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: "मात्रा ($unitLabel)", border: const OutlineInputBorder()),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: rateCtl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: rateLabel, border: const OutlineInputBorder()),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: addressCtl,
                    decoration: const InputDecoration(labelText: "फार्म का पूरा पता (पिकअप लोकेशन)", border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF9F2089), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
                    onPressed: () {
                      Navigator.pop(ctx);
                      final finalUnit = isEgg ? "Crates" : "Birds";
                      final finalRate = isEgg ? "₹${rateCtl.text.trim()}/Crate" : "₹${rateCtl.text.trim()}/Bird";

                      String baseName = isOther && customNameCtl.text.trim().isNotEmpty ? customNameCtl.text.trim() : selectedItem;
                      final finalTitle = isEgg ? baseName : "$baseName ($selectedGender)";

                      setState(() {
                        _sellerListings.insert(0, {
                          "item": finalTitle,
                          "type": selectedType,
                          "qty": "${qtyCtl.text.trim()} $finalUnit",
                          "price": finalRate,
                          "farm": "मेरा फार्म (+91 ${widget.phone})",
                          "farmAddress": addressCtl.text.trim(),
                          "grade": isEgg ? "ताज़ा" : "स्वस्थ लाइव",
                          "image": localPhotoPath ?? "",
                        });
                      });
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("नई खेप GPS वॉटरमार्क के साथ लाइव हो गई!")));
                    },
                    child: const Text("खेप तुरंत लाइव करें", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _editBatchDialog(int index) {
    final lot = _sellerListings[index];
    final isEgg = lot["type"] == "अंडे" || lot["item"]!.contains("अंडे");
    final qtyCtl = TextEditingController(text: lot["qty"]!.replaceAll(RegExp(r'[^0-9]'), ''));
    final rateCtl = TextEditingController(text: lot["price"]!.replaceAll(RegExp(r'[^0-9]'), ''));
    final addressCtl = TextEditingController(text: lot["farmAddress"] ?? "फार्म पता उपलब्ध");

    _modal("लॉट अपडेट करें (${lot['item']})", [
      Text("उत्पाद: ${lot['item']} (${isEgg ? 'अंडे' : 'पक्षी'})", style: const TextStyle(fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      TextField(controller: qtyCtl, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: "नई मात्रा (${isEgg ? 'Crates' : 'Birds'})", border: const OutlineInputBorder())),
      const SizedBox(height: 10),
      TextField(controller: rateCtl, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: "नया रेट (${isEgg ? '₹/Crate' : '₹/Bird'})", border: const OutlineInputBorder())),
      const SizedBox(height: 10),
      TextField(controller: addressCtl, decoration: const InputDecoration(labelText: "फार्म का पता", border: const OutlineInputBorder())),
    ], "बदलाव सेव करें", () {
      final unitStr = isEgg ? "Crates" : "Birds";
      final rateStr = isEgg ? "₹${rateCtl.text.trim()}/Crate" : "₹${rateCtl.text.trim()}/Bird";

      setState(() {
        _sellerListings[index]["qty"] = "${qtyCtl.text.trim()} $unitStr";
        _sellerListings[index]["price"] = rateStr;
        _sellerListings[index]["farmAddress"] = addressCtl.text.trim();
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("लॉट की जानकारी अपडेट हो गई!")));
    });
  }
    @override
  Widget build(BuildContext context) {
    String heading = widget.role == "seller" ? "किसान डैशबोर्ड" : (widget.role == "commuter" ? "कम्यूटर डिलीवरी" : "ग्राहक बाज़ार (Anda Express)");
    return PopScope(
      canPop: true,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
          title: Text(heading),
          backgroundColor: const Color(0xFF15803D),
          foregroundColor: Colors.white,
          actions: [
            if (widget.role == "buyer")
              IconButton(icon: Badge(label: Text("${_cartItems.length}"), isLabelVisible: _cartItems.isNotEmpty, child: const Icon(Icons.shopping_cart)), onPressed: _showCheckout),
            const SizedBox(width: 8),
          ],
        ),
        body: widget.role == "seller" ? _buildSeller() : (widget.role == "commuter" ? _buildCommuter() : _buildBuyer()),
      ),
    );
  }

  Widget _buildBuyer() {
    final filtered = _allProducts.where((p) {
      if (p["cat"] != _selectedCategory) return false;
      if (_selectedCategory == "अंडे" && _selectedEggSub != "सभी") {
        return p["sub"] == _selectedEggSub;
      }
      return true;
    }).toList();

    final myOrders = AppState.orders.where((o) => o["buyerPhone"] == widget.phone).toList();

    return Column(
      children: [
        if (myOrders.isNotEmpty)
          Container(
            constraints: const BoxConstraints(maxHeight: 180),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: const Color(0xFFECFDF5),
            child: ListView(
              shrinkWrap: true,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.local_shipping, size: 16, color: Color(0xFF15803D)),
                        SizedBox(width: 6),
                        Text("मेरे सक्रिय ऑर्डर (Live Orders):", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF15803D))),
                      ],
                    ),
                    Text("कुल: ${myOrders.length}", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF15803D))),
                  ],
                ),
                const SizedBox(height: 4),
                ...myOrders.map((ord) {
                  String stText = ord["status"] == "pending_seller" ? "किसान की पुष्टि का इंतजार" : (ord["status"] == "ready_for_pickup" ? "पिकअप के लिए तैयार" : (ord["status"] == "in_transit" ? "रास्ते में है 🚚" : "डिलीवर हो गया ✅"));
                  return Card(
                    margin: const EdgeInsets.only(bottom: 6),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(child: Text("${ord['product']} - ₹${ord['amount'] + ord['deliveryFee']}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(color: const Color(0xFFFEF3C7), borderRadius: BorderRadius.circular(6), border: Border.all(color: const Color(0xFFF59E0B))),
                                child: Text("OTP: ${ord['otp']}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFFB45309))),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text("स्थिति: $stText", style: const TextStyle(fontSize: 11, color: Colors.blueGrey)),
                          if (ord["mode"] == "self") ...[
                            Text("📍 फार्म पता: ${ord['farmAddress']}", style: const TextStyle(fontSize: 11, color: Color(0xFF15803D), fontWeight: FontWeight.w500)),
                            Text("📞 किसान संपर्क: +91 ${ord['farmerPhone'] ?? '9876543210'}", style: const TextStyle(fontSize: 11, color: Color(0xFF9F2089), fontWeight: FontWeight.bold)),
                          ] else ...[
                            Text("📍 डिलीवरी मोड: ${ord['mode'] == 'bus_stop' ? 'बस स्टॉप पिकअप' : 'होम डिलीवरी'}", style: const TextStyle(fontSize: 11, color: Color(0xFF15803D), fontWeight: FontWeight.w500)),
                            Text("🚚 डिलीवरी पार्टनर: कम्यूटर द्वारा रास्ते में लाया जाएगा", style: const TextStyle(fontSize: 11, color: Colors.blueGrey)),
                          ],
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        Container(
          color: Colors.grey.shade100,
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: SizedBox(
            height: 75,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _mainCategories.length,
              itemBuilder: (context, i) {
                final cat = _mainCategories[i];
                final isSel = _selectedCategory == cat["name"];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = cat["name"] as String;
                      _selectedEggSub = "सभी";
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: isSel ? const Color(0xFF15803D) : Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: isSel ? const Color(0xFF15803D) : Colors.grey.shade300, width: 2),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2)),
                            ],
                          ),
                          child: Center(
                            child: getItemIcon(cat["name"] == "कड़कनाथ" ? "कड़कनाथ ब्लैक लाइव" : (cat["name"] as String), size: 22),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          cat["name"] as String,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
                            color: isSel ? const Color(0xFF15803D) : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        if (_selectedCategory == "अंडे")
          Container(
            height: 45,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              itemCount: _eggSubCategories.length,
              itemBuilder: (context, i) {
                final sub = _eggSubCategories[i];
                final isSubSel = _selectedEggSub == sub;
                return GestureDetector(
                  onTap: () => setState(() => _selectedEggSub = sub),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: isSubSel ? const Color(0xFFFEF3C7) : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: isSubSel ? const Color(0xFFF59E0B) : Colors.transparent),
                    ),
                    child: Center(
                      child: Text(
                        sub,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSubSel ? FontWeight.bold : FontWeight.normal,
                          color: isSubSel ? const Color(0xFFB45309) : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        Expanded(
          child: filtered.isEmpty
              ? const Center(child: Text("इस कैटेगरी में अभी कोई माल उपलब्ध नहीं है।"))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: filtered.length,
                  itemBuilder: (context, i) {
                    final item = filtered[i];
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: InkWell(
                        onTap: () => _showProductDetails(item),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildProductThumbnail(item["item"] as String, imagePath: item["image"] as String?, width: 70, height: 70),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item["item"] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                    const SizedBox(height: 2),
                                    Text("दर: ${item['unit']}", style: const TextStyle(color: Color(0xFF15803D), fontWeight: FontWeight.bold, fontSize: 13)),
                                    Text("${item['farm']} (${item['dist']})", style: const TextStyle(fontSize: 11, color: Colors.blueGrey)),
                                    Text("पता: ${item['farmAddress']}", style: const TextStyle(fontSize: 10, color: Colors.grey)),
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF9F2089),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  minimumSize: const Size(55, 28),
                                ),
                                onPressed: () => _addToCartWithQty(item),
                                child: const Text("मात्रा", style: TextStyle(fontSize: 11)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
    Widget _buildSeller() {
    final pendingOrders = AppState.orders.where((o) => o["status"] == "pending_seller").toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          color: const Color(0xFF15803D),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("वॉलेट बैलेंस", style: TextStyle(color: Colors.white70)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(12)),
                    child: Text("एस्क्रो होल्ड: ₹${AppState.escrowHold.toStringAsFixed(0)}", style: const TextStyle(color: Color(0xFFFEF08A), fontSize: 11)),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text("₹${AppState.sellerWallet.toStringAsFixed(2)}", style: const TextStyle(color: Color(0xFFFEF08A), fontSize: 24, fontWeight: FontWeight.bold)),
              Text("फोन: +91 ${widget.phone}", style: const TextStyle(color: Colors.white70)),
            ]),
          ),
        ),
        if (pendingOrders.isNotEmpty) ...[
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.notifications_active, color: Color(0xFFB45309), size: 20),
              const SizedBox(width: 6),
              Text("नए ऑर्डर (${pendingOrders.length})", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFFB45309))),
            ],
          ),
          const SizedBox(height: 8),
          ...pendingOrders.map((ord) {
            String modeStr = ord["mode"] == "self" ? "फार्म पिकअप (Self)" : (ord["mode"] == "bus_stop" ? "बस स्टॉप डिलीवरी" : "होम डिलीवरी");
            return Card(
              color: const Color(0xFFFFFBEB),
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Color(0xFFFDE68A))),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("ऑर्डर #${ord['id']}", style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text("₹${ord['amount']}", style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF15803D), fontSize: 16)),
                      ],
                    ),
                    Text("माल: ${ord['product']}"),
                    Text("मोड: $modeStr", style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFFB45309))),
                    Text("पिकअप फार्म पता: ${ord['farmAddress']}", style: const TextStyle(fontSize: 12, color: Colors.blueGrey)),
                    Text("ड्रॉप लोकेशन: ${ord['dropAddress']}", style: const TextStyle(fontSize: 12, color: Colors.black87, fontWeight: FontWeight.w500)),
                    Text("खरीदार फोन: +91 ${ord['buyerPhone']}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF15803D), foregroundColor: Colors.white),
                            onPressed: () {
                              setState(() {
                                ord["status"] = "ready_for_pickup";
                              });
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("ऑर्डर स्वीकार किया!")));
                            },
                            child: const Text("ऑर्डर स्वीकार करें"),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          }),
        ],
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("सक्रिय खेप लिस्टिंग:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9F2089),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              icon: const Icon(Icons.add_circle_outline, size: 18),
              label: const Text("नई खेप जोड़ें", style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: _addBatchDialog,
            ),
          ],
        ),
        const SizedBox(height: 10),
        ..._sellerListings.asMap().entries.map((entry) {
          final idx = entry.key;
          final lot = entry.value;
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              leading: buildProductThumbnail(lot["item"]!, imagePath: lot["image"], width: 50, height: 50),
              title: Text(lot["item"]!, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("उपलब्ध: ${lot['qty']} • ${lot['price']}\nफार्म पता: ${lot['farmAddress'] ?? lot['farm']}"),
              isThreeLine: true,
              trailing: IconButton(
                icon: const Icon(Icons.edit, color: Color(0xFF15803D)),
                tooltip: "अपडेट करें",
                onPressed: () => _editBatchDialog(idx),
              ),
              onTap: () => _editBatchDialog(idx),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildCommuter() {
    final liveTrips = AppState.orders.where((o) => (o["status"] == "ready_for_pickup" || o["status"] == "in_transit") && o["mode"] != "self").toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          color: const Color(0xFF0F172A),
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("कम्यूटर एक्सप्रेस पार्टनर", style: TextStyle(color: Colors.white70)),
              Text("सक्रिय डिलीवरी कार्य", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text("पिकअप करें और गंतव्य पर ग्राहक का OTP डालकर एस्क्रो रिलीज़ करें", style: TextStyle(color: Colors.white60, fontSize: 12)),
            ]),
          ),
        ),
        const SizedBox(height: 16),
        const Text("उपलब्ध पिकअप कार्य:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        if (liveTrips.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: Text("फिलहाल कोई सक्रिय पिकअप नहीं है।\n(किसान के ऑर्डर स्वीकार करने पर यहाँ दिखेगा)", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey))),
          )
        else
          ...liveTrips.map((ord) {
            final isInTransit = ord["status"] == "in_transit";
            String modeStr = ord["mode"] == "bus_stop" ? "बस स्टॉप पिकअप" : "सीधी होम डिलीवरी";
            return Card(
              elevation: 3,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("कमीशन: ₹${ord['deliveryFee']}", style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF15803D), fontSize: 16)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(color: isInTransit ? Colors.blue.shade100 : Colors.amber.shade100, borderRadius: BorderRadius.circular(6)),
                          child: Text(isInTransit ? "रास्ते में" : "पिकअप के लिए तैयार", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isInTransit ? Colors.blue.shade900 : Colors.amber.shade900)),
                        )
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text("📦 उत्पाद: ${ord['product']}", style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text("📍 फार्म नाम: ${ord['farm']} (${ord['dist']})"),
                    Text("🏠 पिकअप फार्म पता: ${ord['farmAddress']}", style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF15803D))),
                    const SizedBox(height: 4),
                    Text("🎯 डिलीवरी मोड: $modeStr", style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF9F2089))),
                    Text("📍 ड्रॉप लोकेशन: ${ord['dropAddress']}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                    Text("📞 ग्राहक फोन: +91 ${ord['buyerPhone']}"),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isInTransit ? const Color(0xFF15803D) : const Color(0xFF9F2089),
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          if (!isInTransit) {
                            setState(() {
                              ord["status"] = "in_transit";
                            });
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("माल पिकअप कर लिया गया!")));
                          } else {
                            final otpCtl = TextEditingController();
                            showDialog(
                              context: context,
                              builder: (oCtx) => AlertDialog(
                                title: const Text("ग्राहक OTP दर्ज करें"),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text("डिलीवरी पूरी करने और एस्क्रो भुगतान के लिए ग्राहक से 4 अंकों का OTP लें:"),
                                    const SizedBox(height: 10),
                                    TextField(controller: otpCtl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "4-Digit OTP", border: OutlineInputBorder())),
                                  ],
                                ),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(oCtx), child: const Text("रद्द करें")),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF15803D), foregroundColor: Colors.white),
                                    onPressed: () {
                                      if (otpCtl.text.trim() == ord["otp"].toString()) {
                                        Navigator.pop(oCtx);
                                        setState(() {
                                          ord["status"] = "delivered";
                                          AppState.sellerWallet += (ord["amount"] as double);
                                          AppState.escrowHold -= (((ord["amount"] as double)) + ((ord["deliveryFee"] as double)));
                                        });
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("OTP सत्यापित! डिलीवरी सफल और किसान को एस्क्रो रिलीज़ हो गया।")));
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("गलत OTP! कृपया ग्राहक से सही OTP पूछें।")));
                                      }
                                    },
                                    child: const Text("सत्यापित करें"),
                                  )
                                ],
                              ),
                            );
                          }
                        },
                        child: Text(isInTransit ? "OTP सत्यापन व डिलीवरी पूरी करें" : "पिकअप स्वीकार करें"),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
      ],
    );
  }
}
