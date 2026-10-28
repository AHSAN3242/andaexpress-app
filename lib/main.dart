import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

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
  bool _agreeAllRules = false;

  final Map<String, List<String>> _t = {
    "hi": ["अंडा एक्सप्रेस", "खेत से ताज़ा अंडे और चिकन", "खरीदार", "किसान", "डिलीवरी", "10 अंकों का फोन नंबर", "ओटीपी प्राप्त करें", "लॉगिन करें"],
    "en": ["Anda Express", "Farm Fresh Eggs & Chicken", "Buyer", "Seller", "Commuter", "10-digit Phone", "Get OTP", "Login"],
    "mr": ["अंडा एक्सप्रेस", "ताजी अंडी आणि चिकन", "ग्राहक", "शेतकरी", "डिलिव्हरी", "10 अंकी फोन नंबर", "ओटीपी मिळवा", "लॉगिन करा"],
  };

  Widget _buildUnifiedGuidelines() {
    String roleRespTitle = "ग्राहक की जिम्मेदारी";
    List<String> rolePoints = [
      "1. सही पता व समय पर हाजिरी: सही डिलीवरी लैंडमार्क दर्ज करें और 15-मिनट WhatsApp अलर्ट मिलते ही लोकेशन पर उपस्थित रहें।",
      "2. अकारण वापसी निषेध: यदि माल किसान द्वारा लिस्टिंग अनुसार सही है, तो मन बदलने या अकारण डिलीवरी अस्वीकार नहीं की जा सकती।",
      "3. सूचना पर रिप्लाई: ऑर्डर बुकिंग के बाद उपलब्ध कन्फर्मेशन विंडो में WhatsApp/कॉल पर उत्तर देना अनिवार्य है।",
      "4. अनुपस्थिति पर दोनों तरफ का किराया: कम्यूटर के 10 मिनट इंतज़ार के बाद न पहुँचने पर माल वापस गाँव भेज दिया जाएगा और दोनों तरफ का कुल किराया आपके अग्रिम भुगतान से काटा जाएगा।",
    ];

    if (_role == "seller") {
      roleRespTitle = "किसान की जिम्मेदारी";
      rolePoints = [
        "1. अनिवार्य लिंग व वजन: हर पक्षी का लिंग (नर/मादा), अलग टैग नंबर और कांटे पर वजन के साथ फोटो अपलोड करना अनिवार्य है।",
        "2. अंडों पर उत्पादन तारीख: प्रत्येक अंडे/क्रेट पर उत्पादन तिथि स्टैम्प व औसत वजन दर्ज करें (±10-15g मार्जिन मान्य)।",
        "3. प्रामाणिक माल की सुपुर्दगी: जो फोटो और विवरण ऐप पर दिखाया है, कम्यूटर को हूबहू वही माल सौंपना होगा।",
        "4. गलत माल पर दोनों तरफ का भाड़ा वसूली: यदि दिखाया हुआ माल नहीं दिया जाता या टैग मेल नहीं खाता, तो दोनों तरफ का पूरा भाड़ा किसान के वॉलेट से काटा जाएगा।",
      ];
    } else if (_role == "commuter") {
      roleRespTitle = "कम्यूटर की जिम्मेदारी";
      rolePoints = [
        "1. फार्म पर टैग व वजन मिलान: फार्म पर हर पक्षी का टैग नंबर व वजन स्क्रीन से जांचकर ही पिकअप स्वीकार करें।",
        "2. 15-Min WhatsApp अलर्ट: बस स्टैंड पहुँचने से 15 मिनट पूर्व ग्राहक को ऐप से WhatsApp चेतावनी ज़रूर भेजें।",
        "3. वापसी बस हैंडओवर: ग्राहक के न आने पर 10 मिनट बाद लोकल बस कंडक्टर को माल सौंपकर बस नंबर व फ़ोटो ऐप में दर्ज करें; आपकी डिलीवरी फ़ीस सुरक्षित रहेगी।",
      ];
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "सभी तरह के गैर व्यवहार और धोखाधड़ी से बचने के लिए हर नियम का पालन करना अनिवार्य है",
          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF15803D), fontSize: 13, height: 1.3),
        ),
        const SizedBox(height: 10),
        Text("📋 $roleRespTitle:", style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF166534), fontSize: 13)),
        const SizedBox(height: 4),
        ...rolePoints.map((pt) => Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(pt, style: const TextStyle(fontSize: 12, color: Color(0xFF14532D))),
        )),
        const Divider(color: Color(0xFFBBF7D0), height: 16),
        const Text("⚖️ लीगल प्रक्रिया (कानूनी नीति व न्यायालय मुक्ति):", style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF166534), fontSize: 13)),
        const SizedBox(height: 4),
        const Text(
          "1. मध्यस्थता मात्र: 'अंडा एक्सप्रेस' केवल किसान, ग्राहक और कम्यूटर को आपस में जोड़ने वाला एक स्वतंत्र डिजिटल माध्यम है।\n"
          "2. धोखाधड़ी व विवाद: किसी भी पक्ष द्वारा गलत जानकारी, टूटने-फूटने, नुकसान या धोखाधड़ी के लिए ऐप अथवा इसके संचालक उत्तरदायी नहीं होंगे।\n"
          "3. न्यायालय/पुलिस विवाद से मुक्ति: किसी भी विवाद में ऐप व इसके स्वामियों को पक्षकार नहीं बनाया जाएगा; सभी पक्ष अपने विवाद आपसी स्तर पर सुलझाएंगे।\n"
          "4. एस्क्रो व टोकन सीमा: एस्क्रो केवल OTP आधारित फंड सुरक्षा व किराया कटौती प्रबंधन करता है, यह माल की भौतिक गारंटी नहीं लेता।",
          style: TextStyle(fontSize: 11, color: Color(0xFF14532D), height: 1.3),
        ),
      ],
    );
  }

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
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFFFFBEB),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, spreadRadius: 2),
                ],
                border: Border.all(color: const Color(0xFFFEF3C7), width: 3),
              ),
              child: const Center(
                child: Icon(Icons.egg_alt, size: 48, color: Color(0xFFF59E0B)),
              ),
            ),
            const SizedBox(height: 10),
            Text(cur[1], style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF15803D))),
            const SizedBox(height: 16),
            Row(
              children: [
                _roleBox("buyer", cur[2], Icons.shopping_bag),
                const SizedBox(width: 8),
                _roleBox("seller", cur[3], Icons.storefront),
                const SizedBox(width: 8),
                _roleBox("commuter", cur[4], Icons.delivery_dining),
              ],
            ),
            const SizedBox(height: 16),
            TextField(controller: _phone, keyboardType: TextInputType.phone, decoration: InputDecoration(prefixText: "+91 ", labelText: cur[5], border: const OutlineInputBorder())),
            if (_sent) ...[
              const SizedBox(height: 10),
              TextField(controller: _otp, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "OTP (123456)", border: OutlineInputBorder())),
            ],
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF86EFAC), width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildUnifiedGuidelines(),
                  const Divider(color: Color(0xFFBBF7D0), height: 18),
                  InkWell(
                    onTap: () => setState(() => _agreeAllRules = !_agreeAllRules),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: _agreeAllRules,
                          activeColor: const Color(0xFF15803D),
                          checkColor: Colors.white,
                          side: const BorderSide(color: Color(0xFF15803D), width: 2),
                          onChanged: (v) => setState(() => _agreeAllRules = v ?? false),
                        ),
                        const Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Text(
                              "मैंने प्लेटफ़ॉर्म के सभी नियम, अनिवार्य लिस्टिंग शर्तें, हर्जाना नीति व लीगल प्रक्रिया को पढ़ लिया है और मैं शत-प्रतिशत सहमत हूँ।",
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF14532D)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _agreeAllRules ? const Color(0xFF9F2089) : Colors.grey.shade400,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: _agreeAllRules
                    ? () {
                        if (!_sent) {
                          if (_phone.text.length < 10) return;
                          setState(() { _sent = true; _otp.text = "123456"; });
                        } else {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => DashScreen(role: _role, phone: _phone.text, lang: _lang)));
                        }
                      }
                    : null,
                child: Text(_sent ? cur[7] : cur[6], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            if (!_agreeAllRules)
              const Padding(
                padding: EdgeInsets.only(top: 6),
                child: Text("⚠️ आगे बढ़ने के लिए हरे नियम बॉक्स पर टिक करके सहमति दें।", style: TextStyle(fontSize: 11, color: Colors.red)),
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
  String _selectedDeliveryMode = "self";
  String _paymentMode = "prepaid";
  final _buyerAddressCtl = TextEditingController();

  static Future<void> launchWhatsApp(String phone, String message) async {
    final cleanPhone = phone.replaceAll(RegExp(r'[^0-9]'), '');
    final finalNumber = cleanPhone.length == 10 ? "91$cleanPhone" : cleanPhone;
    final encodedMsg = Uri.encodeComponent(message);
    final url = Uri.parse("https://wa.me/$finalNumber?text=$encodedMsg");
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    } catch (_) {}
  }

  static Future<void> makePhoneCall(String phone) async {
    final cleanPhone = phone.replaceAll(RegExp(r'[^0-9]'), '');
    final url = Uri.parse("tel:$cleanPhone");
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      }
    } catch (_) {}
  }

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
        decoration: BoxDecoration(color: const Color(0xFF0D5C58), borderRadius: BorderRadius.all(Radius.elliptical(size, size * 1.35)), border: Border.all(color: const Color(0xFF063533), width: 1.5)),
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

  static Widget buildProductThumbnail(String name, {String? imagePath, String? gpsStamp, double? width, double height = 75, bool isDetailView = false, String? tagOrWeightInfo}) {
    Widget imageWidget;
    if (imagePath != null && imagePath.trim().isNotEmpty) {
      if (imagePath.startsWith("http")) {
        imageWidget = Image.network(imagePath, width: width, height: height, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _fallbackThumb(name, width ?? 75, height));
      } else {
        final f = File(imagePath);
        if (f.existsSync()) {
          imageWidget = Image.file(f, width: width, height: height, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _fallbackThumb(name, width ?? 75, height));
        } else {
          imageWidget = _fallbackThumb(name, width ?? 75, height);
        }
      }
    } else {
      imageWidget = _fallbackThumb(name, width ?? 75, height);
    }

    final stamp = (gpsStamp != null && gpsStamp.isNotEmpty) ? gpsStamp : "20.7002° N, 77.0082° E";
    final nowTime = DateFormat('dd-MMM-yyyy • hh:mm a').format(DateTime.now());

    return ClipRRect(
      borderRadius: BorderRadius.circular(isDetailView ? 14 : 10),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          imageWidget,
          Container(
            width: width ?? double.infinity,
            padding: EdgeInsets.symmetric(horizontal: isDetailView ? 10 : 4, vertical: isDetailView ? 6 : 2),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black.withOpacity(0.92), Colors.black.withOpacity(0.6), Colors.transparent],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (tagOrWeightInfo != null && tagOrWeightInfo.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(bottom: 2),
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                    decoration: BoxDecoration(color: const Color(0xFFDC2626), borderRadius: BorderRadius.circular(4)),
                    child: Text(tagOrWeightInfo, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                Row(
                  children: [
                    Icon(Icons.location_on, color: const Color(0xFFFACC15), size: isDetailView ? 14 : 10),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Text(
                        "GPS: $stamp",
                        style: TextStyle(color: const Color(0xFFFACC15), fontSize: isDetailView ? 11 : 8, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                if (isDetailView) ...[
                  const SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("🕒 $nowTime", style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w500)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(color: const Color(0xFF15803D), borderRadius: BorderRadius.circular(4)),
                        child: const Text("FARM & SCALE VERIFIED", style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _fallbackThumb(String name, double width, double height) {
    return Container(
      width: width, height: height,
      decoration: BoxDecoration(color: const Color(0xFFFFFBEB), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFFFEF3C7))),
      child: Center(child: getItemIcon(name, size: 36)),
    );
  }
    final List<Map<String, dynamic>> _allProducts = [
    {"cat": "अंडे", "sub": "देसी अंडे", "item": "शुद्ध देसी अंडे (तारीख मुद्रित)", "unitType": "Crate", "piecesPerCrate": 30, "price": 190.0, "weight": "50-55g/अंडा (±15g मार्जिन)", "prodDate": "28-Oct-2026", "bestBefore": "उत्पादन से 30 दिन", "farm": "कृष्णा पोल्ट्री फार्म", "farmAddress": "गेट नं. 4, पारस रोड, अकोला", "dist": "2.1 किमी", "grade": "ताज़ा • तारीख मुहर सहित", "farmerPhone": "9876543210", "gallery": ["https://images.unsplash.com/photo-1516467508483-a7212febe31a?auto=format&fit=crop&w=800&q=80", "https://images.unsplash.com/photo-1582722872445-44dc5f7e3c8f?auto=format&fit=crop&w=800&q=80"], "gps": "20.7011° N, 77.0094° E"},
    {"cat": "अंडे", "sub": "कड़कनाथ अंडे", "item": "कड़कनाथ ओरिजिनल अंडे (तारीख मुद्रित)", "unitType": "Crate", "piecesPerCrate": 20, "price": 240.0, "weight": "45-50g/अंडा (±10g मार्जिन)", "prodDate": "28-Oct-2026", "bestBefore": "उत्पादन से 30 दिन", "farm": "आनंद पोल्ट्री फार्म", "farmAddress": "शिव मंदिर के पीछे, हाईवे नाका", "dist": "3.5 किमी", "grade": "High Protein A+", "farmerPhone": "9876543211", "gallery": ["https://images.unsplash.com/photo-1582722872445-44dc5f7e3c8f?auto=format&fit=crop&w=800&q=80"], "gps": "20.6985° N, 77.0120° E"},
    {"cat": "अंडे", "sub": "टेबल एग्स", "item": "व्हाइट टेबल एग्स (ब्रायलर)", "unitType": "Crate", "piecesPerCrate": 30, "price": 155.0, "weight": "55-60g/अंडा (±10g मार्जिन)", "prodDate": "28-Oct-2026", "bestBefore": "उत्पादन से 30 दिन", "farm": "पाटिल पोल्ट्री हब", "dist": "5.0 किमी", "farmAddress": "पाटिल वाड़ी, बायपास रोड", "grade": "Commercial Fresh", "farmerPhone": "9876543212", "gallery": ["https://images.unsplash.com/photo-1506976785307-8732e854ad03?auto=format&fit=crop&w=800&q=80"], "gps": "20.7050° N, 77.0180° E"},
    {"cat": "अंडे", "sub": "बतख के अंडे", "item": "ऑर्गेनिक बतख अंडे (तारीख मुद्रित)", "unitType": "Crate", "piecesPerCrate": 30, "price": 210.0, "weight": "65-70g/अंडा (±15g मार्जिन)", "prodDate": "28-Oct-2026", "bestBefore": "उत्पादन से 30 दिन", "farm": "रिवरसाइड डक फार्म", "farmAddress": "नहर पुलिया के पास, अकोला", "dist": "7.0 किमी", "grade": "Large Organic Size", "farmerPhone": "9876543213", "gallery": ["https://images.unsplash.com/photo-1498654896293-37aacf113fd9?auto=format&fit=crop&w=800&q=80"], "gps": "20.7100° N, 77.0250° E"},
    {"cat": "अंडे", "sub": "बटेर अंडे", "item": "बटेर (Quail) औषधीय अंडे", "unitType": "Crate", "piecesPerCrate": 24, "price": 120.0, "weight": "12-15g/अंडा (±5g मार्जिन)", "prodDate": "28-Oct-2026", "bestBefore": "उत्पादन से 30 दिन", "farm": "ग्रीन वैली पोल्ट्री", "farmAddress": "एमआईडीसी गेट क्र. 2", "dist": "4.0 किमी", "grade": "चितकबरे स्पॉट Nutrient Rich", "farmerPhone": "9876543214", "gallery": ["https://images.unsplash.com/photo-1598965675045-45c5e72c7d05?auto=format&fit=crop&w=800&q=80"], "gps": "20.6950° N, 77.0040° E"},
    {"cat": "अंडे", "sub": "ईमू अंडे", "item": "ईमू जंबो औषधीय अंडे", "unitType": "Piece", "piecesPerCrate": 1, "price": 450.0, "weight": "550-600g/अंडा (±50g मार्जिन)", "prodDate": "28-Oct-2026", "bestBefore": "उत्पादन से 45 दिन", "farm": "महावीर ईमू फार्म", "dist": "12.0 किमी", "farmAddress": "महावीर नगर, वाशिम रोड", "grade": "Dark Green Shell", "farmerPhone": "9876543215", "gallery": ["https://images.unsplash.com/photo-1563245372-f21724e3856d?auto=format&fit=crop&w=800&q=80"], "gps": "20.6800° N, 77.0300° E"},
    {"cat": "देसी चिकन", "sub": "देसी", "item": "देसी रंगीन चिकन (नर ♂️)", "unitType": "Bird", "piecesPerCrate": 1, "price": 310.0, "weight": "1.8kg (±200g प्राकृतिक मार्जिन)", "tagPrefix": "D", "farm": "बालाजी फार्म", "farmAddress": "बालाजी मंदिर के सामने, ग्रामीण मार्ग", "dist": "6.0 किमी", "grade": "Natural Organic", "farmerPhone": "9876543216", "gallery": [
      "https://images.unsplash.com/photo-1548550023-2bdb3c5beed7?auto=format&fit=crop&w=800&q=80",
      "https://images.unsplash.com/photo-1612170153139-6f881ff067e0?auto=format&fit=crop&w=800&q=80",
      "https://images.unsplash.com/photo-1548550023-2bdb3c5beed7?auto=format&fit=crop&w=800&q=80"
    ], "gps": "20.7020° N, 77.0110° E"},
    {"cat": "बॉयलर चिकन", "sub": "बॉयलर", "item": "कमर्शियल व्हाइट बॉयलर (लाइव)", "unitType": "Bird", "piecesPerCrate": 1, "price": 135.0, "weight": "2.2kg (±200g प्राकृतिक मार्जिन)", "tagPrefix": "B", "farm": "स्टार पोल्ट्री", "farmAddress": "शेड नंबर 3, बस स्टैंड बैकसाइड", "dist": "3.0 किमी", "grade": "Standard Fresh Live", "farmerPhone": "9876543217", "gallery": [
      "https://images.unsplash.com/photo-1516467508483-a7212febe31a?auto=format&fit=crop&w=800&q=80"
    ], "gps": "20.6990° N, 77.0090° E"},
    {"cat": "कड़कनाथ", "sub": "कड़कनाथ", "item": "कड़कनाथ ब्लैक लाइव (नर ♂️)", "unitType": "Bird", "piecesPerCrate": 1, "price": 700.0, "weight": "1.5kg (±200g प्राकृतिक मार्जिन)", "tagPrefix": "K", "farm": "आनंद पोल्ट्री फार्म", "farmAddress": "शिव मंदिर के पीछे, हाईवे नाका", "dist": "3.5 किमी", "grade": "Pure Black Aseel", "farmerPhone": "9876543211", "gallery": [
      "https://images.unsplash.com/photo-1589923188900-85dae523342b?auto=format&fit=crop&w=800&q=80"
    ], "gps": "20.6985° N, 77.0120° E"},
    {"cat": "बतख", "sub": "बतख", "item": "देसी / फार्म बतख (नर ♂️ Drake)", "unitType": "Bird", "piecesPerCrate": 1, "price": 350.0, "weight": "2.0kg (±200g प्राकृतिक मार्जिन)", "tagPrefix": "DK", "farm": "रिवरसाイド डक फार्म", "farmAddress": "नहर पुलिया के पास, अकोला", "dist": "7.0 किमी", "grade": "Healthy Live Duck", "farmerPhone": "9876543213", "gallery": [
      "https://images.unsplash.com/photo-1555861496-0666c8981751?auto=format&fit=crop&w=800&q=80"
    ], "gps": "20.7100° N, 77.0250° E"},
    {"cat": "बटेर", "sub": "बटेर", "item": "जापानी बटेर लाइव (नर ♂️)", "unitType": "Bird", "piecesPerCrate": 1, "price": 70.0, "weight": "220g (±30g प्राकृतिक मार्जिन)", "tagPrefix": "Q", "farm": "ग्रीन वैली पोल्ट्री", "dist": "4.0 किमी", "farmAddress": "एमआईडीसी गेट क्र. 2", "grade": "Healthy Weight", "farmerPhone": "9876543214", "gallery": [
      "https://images.unsplash.com/photo-1598965675045-45c5e72c7d05?auto=format&fit=crop&w=800&q=80"
    ], "gps": "20.6950° N, 77.0040° E"},
    {"cat": "ईमू", "sub": "ईमू", "item": "ईमू लाइव वयस्क पक्षी", "unitType": "Bird", "piecesPerCrate": 1, "price": 3800.0, "weight": "35kg (±2kg मार्जिन)", "tagPrefix": "EM", "farm": "महावीर ईमू फार्म", "dist": "12.0 किमी", "farmAddress": "महावीर नगर, वाशिम रोड", "grade": "Pure Breed 35kg+", "farmerPhone": "9876543215", "gallery": [
      "https://images.unsplash.com/photo-1563245372-f21724e3856d?auto=format&fit=crop&w=800&q=80"
    ], "gps": "20.6800° N, 77.0300° E"},
    {"cat": "अन्य", "sub": "अन्य", "item": "वनराजा / ग्रामप्रिया लाइव देसी", "unitType": "Bird", "piecesPerCrate": 1, "price": 320.0, "weight": "1.9kg (±200g मार्जिन)", "tagPrefix": "V", "farm": "किसान स्पेशल फार्म", "dist": "5.0 किमी", "farmAddress": "ग्रामीण शेड नंबर 2", "grade": "देसी फ्री-रेंज", "farmerPhone": "9876543216", "gallery": [
      "https://images.unsplash.com/photo-1548550023-2bdb3c5beed7?auto=format&fit=crop&w=800&q=80"
    ], "gps": "20.7020° N, 77.0110° E"},
  ];

  late List<Map<String, dynamic>> _sellerListings;

  @override
  void initState() {
    super.initState();
    _sellerListings = [
      {"item": "देसी पोल्ट्री अंडे (तारीख मुद्रित)", "type": "अंडे", "qty": "20 Crates", "price": 190.0, "pieces": 30, "weight": "50-55g/अंडा (±15g मार्जिन)", "prodDate": "28-Oct-2026", "bestBefore": "उत्पादन से 30 दिन", "farm": "मेरा फार्म (+91 ${widget.phone})", "farmAddress": "पारस रेलवे क्रॉसिंग के पास, फार्म शेड #1", "grade": "Grade A+ ताज़ा", "farmerPhone": widget.phone, "image": "https://images.unsplash.com/photo-1516467508483-a7212febe31a?auto=format&fit=crop&w=800&q=80", "gps": "20.7002° N, 77.0082° E"},
      {"item": "कड़कनाथ ओरिजिनल अंडे (तारीख मुद्रित)", "type": "अंडे", "qty": "10 Crates", "price": 240.0, "pieces": 20, "weight": "45-50g/अंडा (±10g मार्जिन)", "prodDate": "28-Oct-2026", "bestBefore": "उत्पादन से 30 दिन", "farm": "मेरा फार्म (+91 ${widget.phone})", "farmAddress": "पारस रेलवे क्रॉसिंग के पास, फार्म शेड #1", "grade": "प्रीमियम", "farmerPhone": widget.phone, "image": "https://images.unsplash.com/photo-1582722872445-44dc5f7e3c8f?auto=format&fit=crop&w=800&q=80", "gps": "20.7002° N, 77.0082° E"},
      {"item": "कड़कनाथ ब्लैक लाइव (नर ♂️)", "type": "पक्षी/बर्ड्स", "qty": "15 Birds", "price": 700.0, "pieces": 1, "weight": "1.5kg (±200g प्राकृतिक मार्जिन)", "farm": "मेरा फार्म (+91 ${widget.phone})", "farmAddress": "पारस रेलवे क्रॉसिंग के पास, फार्म शेड #1", "grade": "प्योर ब्लैक", "farmerPhone": widget.phone, "image": "https://images.unsplash.com/photo-1589923188900-85dae523342b?auto=format&fit=crop&w=800&q=80", "gps": "20.7002° N, 77.0082° E"},
    ];
  }
    void _showProductDetails(Map<String, dynamic> product) {
    final isEgg = product["unitType"] == "Crate" || (product["item"] as String).contains("अंडे");
    final pcs = (product["piecesPerCrate"] as int?) ?? 30;
    final price = (product["price"] as double?) ?? 0.0;
    final perPiece = isEgg && pcs > 0 ? (price / pcs).toStringAsFixed(2) : null;
    final weight = product["weight"] ?? (isEgg ? "50-55g/अंडा (±15g मार्जिन)" : "1.8kg (±200g मार्जिन)");
    final prodDate = product["prodDate"] ?? DateFormat('dd-MMM-yyyy').format(DateTime.now());
    final bestBefore = product["bestBefore"] ?? "उत्पादन से 30 दिन";
    final List<String> gallery = (product["gallery"] as List<String>?) ?? [product["image"] ?? ""];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.only(top: 12, left: 16, right: 16, bottom: 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(width: 45, height: 5, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10))),
              ),
              const SizedBox(height: 14),
              SizedBox(
                height: 250,
                child: PageView.builder(
                  itemCount: max(1, gallery.length),
                  itemBuilder: (pCtx, pageIdx) {
                    final img = gallery.isNotEmpty ? gallery[pageIdx] : "";
                    String tagOverlay;
                    if (isEgg) {
                      tagOverlay = pageIdx == 0 ? "📦 कंबाइन लॉट (क्रेट्स) • मुद्रित तिथि: $prodDate" : "तारीख व वजन मुहर • अंडा #${pageIdx}";
                    } else {
                      tagOverlay = pageIdx == 0
                          ? "📸 पूरे लॉट का संयुक्त (कंबाइन) फोटो"
                          : "पक्षी #${pageIdx} • टैग #${product['tagPrefix'] ?? 'B'}-${100 + pageIdx} • कांटे पर वजन: $weight";
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: buildProductThumbnail(
                        product["item"] as String,
                        imagePath: img,
                        gpsStamp: product["gps"] as String?,
                        width: double.infinity,
                        height: 250,
                        isDetailView: true,
                        tagOrWeightInfo: tagOverlay,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 6),
              if (gallery.length > 1)
                const Center(
                  child: Text("👈 कंबाइन व अलग-अलग पक्षियों के कांटे पर वजन देखने के लिए स्वाइप करें 👉", style: TextStyle(fontSize: 11, color: Colors.blueGrey, fontWeight: FontWeight.bold)),
                ),
              const SizedBox(height: 12),
              Text(product["item"] as String, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              if (isEgg) ...[
                Text("दर: ₹${price.toStringAsFixed(0)} / Crate", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF15803D))),
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: const Color(0xFFFEF3C7), borderRadius: BorderRadius.circular(6)),
                  child: Text("📦 1 क्रेट = $pcs अंडे (मात्र ₹$perPiece प्रति अंडा)", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFB45309))),
                ),
              ] else ...[
                Text("दर: ₹${price.toStringAsFixed(0)} / Bird", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF15803D))),
              ],
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: const Color(0xFFF0FDF4), borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFFBBF7D0))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("⚖️ वजन व ताज़गी गारंटी (पारदर्शिता विवरण):", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF15803D), fontSize: 13)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.scale, size: 16, color: Color(0xFF15803D)),
                        const SizedBox(width: 6),
                        Expanded(child: Text("औसत वजन: $weight", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
                      ],
                    ),
                    if (isEgg) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today, size: 16, color: Color(0xFF15803D)),
                          const SizedBox(width: 6),
                          Text("उत्पादन तिथि: $prodDate", style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.timer, size: 16, color: Color(0xFFB45309)),
                          const SizedBox(width: 6),
                          Text("Best Before: $bestBefore", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFB45309))),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.verified, color: Color(0xFF15803D), size: 18),
                        const SizedBox(width: 6),
                        Expanded(child: Text("सत्यापित GPS: ${product['gps'] ?? '20.7002° N, 77.0082° E'}", style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF15803D), fontSize: 13))),
                      ],
                    ),
                    const Divider(height: 16),
                    Text("📍 फार्म नाम: ${product['farm']} (${product['dist']})", style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                    const SizedBox(height: 3),
                    Text("🏠 पिकअप पता: ${product['farmAddress']}", style: const TextStyle(fontSize: 12, color: Colors.blueGrey)),
                    const SizedBox(height: 3),
                    Text("✨ ताज़गी व ग्रेड: ${product['grade']}", style: const TextStyle(fontSize: 12, color: Color(0xFF9F2089), fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF9F2089), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                onPressed: () {
                  Navigator.pop(ctx);
                  _addToCartWithQty(product);
                },
                child: const Text("मात्रा चुनें और खरीदें", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
    }
    void _addToCartWithQty(Map<String, dynamic> product) {
    int qty = 1;
    final isEgg = product["unitType"] == "Crate" || (product["item"] as String).contains("अंडे");
    final pcs = (product["piecesPerCrate"] as int?) ?? 30;
    final unit = isEgg ? "क्रेट / ट्रे" : "पंछी / नग";
    final price = (product["price"] as double?) ?? 0.0;
    final perPiece = isEgg && pcs > 0 ? (price / pcs).toStringAsFixed(2) : null;
    final prefix = (product["tagPrefix"] ?? "D").toString();
    final fPhone = (product["farmerPhone"] ?? "9876543210").toString();

    showDialog(
      context: context,
      builder: (dCtx) => StatefulBuilder(
        builder: (context, setDState) {
          List<String> birdTags = [];
          if (!isEgg) {
            for (int k = 1; k <= qty; k++) {
              birdTags.add("#$prefix-${100 + k}");
            }
          }

          return AlertDialog(
            title: Text(product["item"] as String, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("फार्म: ${product['farm']}", style: const TextStyle(fontSize: 12, color: Colors.blueGrey)),
                const SizedBox(height: 8),
                Text("रेट: ₹${price.toStringAsFixed(0)} / $unit", style: const TextStyle(color: Color(0xFF15803D), fontWeight: FontWeight.bold)),
                if (isEgg) ...[
                  const SizedBox(height: 4),
                  Text("1 क्रेट = $pcs अंडे (₹$perPiece/अंडा)", style: const TextStyle(color: Color(0xFFB45309), fontSize: 12, fontWeight: FontWeight.bold)),
                ],
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
                if (!isEgg) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.blue.shade200)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("आवंटित अलग-अलग टैग नंबर ($qty पक्षी):", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.blue)),
                        const SizedBox(height: 4),
                        Text(birdTags.join(", "), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black87)),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                Text("कुल मूल्य: ₹${(price * qty).toStringAsFixed(0)}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF9F2089))),
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
                      "farmerPhone": fPhone,
                      "dist": product["dist"],
                      "unitPrice": price,
                      "unitType": product["unitType"],
                      "piecesPerCrate": pcs,
                      "qty": qty,
                      "weight": product["weight"],
                      "allocatedTags": birdTags.join(", "),
                      "total": price * qty,
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
                      "farmerPhone": fPhone,
                      "dist": product["dist"],
                      "unitPrice": price,
                      "unitType": product["unitType"],
                      "piecesPerCrate": pcs,
                      "qty": qty,
                      "weight": product["weight"],
                      "allocatedTags": birdTags.join(", "),
                      "total": price * qty,
                    });
                  });
                  Navigator.pop(dCtx);
                  _showCheckout();
                },
                child: const Text("अभी खरीदें"),
              ),
            ],
          );
        },
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
          double totalOrderAmount = subtotal + deliveryFee;

          double tokenAmount = (subtotal * 0.50) + deliveryFee;
          double remainingOnDelivery = subtotal * 0.50;
          double payNowAmount = _paymentMode == "prepaid" ? totalOrderAmount : tokenAmount;

          return Padding(
            padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text("सुरक्षित ऑर्डर चेकआउट (Confirmed Escrow)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF15803D))),
                  const Divider(),
                  Text("कुल सामग्री: ${_cartItems.length} प्रकार (कुल $totalQuantityUnits नग/क्रेट)", style: const TextStyle(fontWeight: FontWeight.bold)),
                  ..._cartItems.map((ci) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("• ${ci['item']}: ${ci['qty']} ${ci['unitType']} = ₹${ci['total']}", style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                        if (ci['allocatedTags'] != null && ci['allocatedTags'].toString().isNotEmpty)
                          Text("   🏷️ अलग-अलग टैग: ${ci['allocatedTags']}", style: const TextStyle(fontSize: 11, color: Colors.blue, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  )),
                  const SizedBox(height: 10),
                  Text("📍 स्रोत फार्म: ${_cartItems.first['farm']}\nपता: ${_cartItems.first['farmAddress']}", style: const TextStyle(fontSize: 12, color: Colors.blueGrey)),
                  const SizedBox(height: 12),
                  const Text("डिलीवरी का तरीका चुनें:", style: TextStyle(fontWeight: FontWeight.bold)),
                  RadioListTile<String>(
                    dense: true,
                    title: const Text("फार्म से स्वयं पिकअप (Self Pickup)"),
                    subtitle: const Text("शुल्क: ₹0 (खुद जाकर फार्म से लें • किसान का नंबर दिखेगा)"),
                    value: "self",
                    groupValue: _selectedDeliveryMode,
                    onChanged: (v) => setMState(() => _selectedDeliveryMode = v!),
                  ),
                  RadioListTile<String>(
                    dense: true,
                    title: const Text("बस स्टॉप / मुख्य सड़क (Bus Stop)"),
                    subtitle: Text("शुल्क: ₹${max(30.0, totalQuantityUnits * 15.0).toStringAsFixed(0)} (कम्यूटर कमीशन)"),
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
                        labelText: _selectedDeliveryMode == "bus_stop" ? "नजदीकी बस स्टॉप / लैंडमार्क (अनिवार्य *)" : "घर/दुकान का पूरा पता (अनिवार्य *)",
                        hintText: _selectedDeliveryMode == "bus_stop" ? "उदा. अकोला बस स्टैंड, टी प्वाइंट" : "मकान नं, गली, लैंडमार्क",
                        helperText: "कम्यूटर के पहुँचने के लिए सही लैंडमार्क या पता आवश्यक है",
                        border: const OutlineInputBorder(),
                        isDense: true,
                        prefixIcon: const Icon(Icons.location_on, color: Colors.red),
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  const Text("भुगतान विकल्प (Payment Security):", style: TextStyle(fontWeight: FontWeight.bold)),
                  RadioListTile<String>(
                    dense: true,
                    title: const Text("100% ऑनलाइन एस्क्रो (अनुशंसित - 100% Safe)"),
                    subtitle: const Text("संपूर्ण भुगतान सुरक्षित एस्क्रो में जमा रहेगा"),
                    value: "prepaid",
                    groupValue: _paymentMode,
                    onChanged: (v) => setMState(() => _paymentMode = v!),
                  ),
                  RadioListTile<String>(
                    dense: true,
                    title: const Text("50% अग्रिम सुरक्षा टोकन (Partial Advance)"),
                    subtitle: Text("अग्रिम: ₹${tokenAmount.toStringAsFixed(0)} ऑनलाइन • बाकी ₹${remainingOnDelivery.toStringAsFixed(0)} डिलीवरी पर"),
                    value: "token",
                    groupValue: _paymentMode,
                    onChanged: (v) => setMState(() => _paymentMode = v!),
                  ),
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
                      const Text("कम्यूटर डिलीवरी फ़ीस:", style: TextStyle(color: Colors.grey)),
                      Text("₹${deliveryFee.toStringAsFixed(0)}", style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF9F2089))),
                    ],
                  ),
                  if (_paymentMode == "token") ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("डिलीवरी पर देय शेष राशि:", style: TextStyle(color: Colors.blueGrey)),
                        Text("₹${remainingOnDelivery.toStringAsFixed(0)}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey)),
                      ],
                    ),
                  ],
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_paymentMode == "prepaid" ? "कुल ऑनलाइन एस्क्रो:" : "अभी देय 50% टोकन:", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF15803D))),
                      Text("₹${payNowAmount.toStringAsFixed(0)}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF15803D))),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF9F2089), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
                    onPressed: () {
                      if (_selectedDeliveryMode != "self" && _buyerAddressCtl.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("⚠️ डिलीवरी के लिए बस स्टॉप लैंडमार्क या पूरा पता दर्ज करना अनिवार्य है!"),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 3),
                        ));
                        return;
                      }

                      Navigator.pop(ctx);
                      final orderId = "AND-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}";
                      final otp = (1000 + Random().nextInt(9000)).toString();
                      final productSummary = _cartItems.map((e) => "${e['item']} (${e['qty']} ${e['unitType']})").join(", ");
                      final firstFarm = _cartItems.first["farm"] as String;
                      final firstFarmAddress = _cartItems.first["farmAddress"] as String;
                      final farmerPhone = _cartItems.first["farmerPhone"] as String;
                      final dist = _cartItems.first["dist"] as String;
                      final allTags = _cartItems.map((e) => e["allocatedTags"] ?? "").where((t) => t.toString().isNotEmpty).join(" | ");
                      final allWeights = _cartItems.map((e) => e["weight"] ?? "").join(", ");
                      final dropAddress = _selectedDeliveryMode == "self" ? "स्वयं पिकअप (फार्म से)" : _buyerAddressCtl.text.trim();

                      setState(() {
                        for (var cartItem in _cartItems) {
                          for (var sellerLot in _sellerListings) {
                            if (sellerLot["item"] == cartItem["item"]) {
                              int curStock = int.tryParse(sellerLot["qty"].toString().replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
                              int boughtQty = cartItem["qty"] as int;
                              int newStock = max(0, curStock - boughtQty);
                              String unitName = sellerLot["qty"].toString().contains("Crate") ? "Crates" : "Birds";
                              sellerLot["qty"] = "$newStock $unitName";
                            }
                          }
                        }

                        AppState.escrowHold += payNowAmount;
                        AppState.orders.insert(0, {
                          "id": orderId,
                          "otp": otp,
                          "buyerPhone": widget.phone,
                          "farmerPhone": farmerPhone,
                          "product": productSummary,
                          "farm": firstFarm,
                          "farmAddress": firstFarmAddress,
                          "dist": dist,
                          "tags": allTags,
                          "weights": allWeights,
                          "dropAddress": dropAddress,
                          "mode": _selectedDeliveryMode,
                          "amount": subtotal,
                          "deliveryFee": deliveryFee,
                          "paymentMode": _paymentMode,
                          "paidAdvance": payNowAmount,
                          "balanceOnDelivery": _paymentMode == "token" ? remainingOnDelivery : 0.0,
                          "status": "pending_seller",
                          "returnBus": null,
                        });
                        _cartItems.clear();
                        _buyerAddressCtl.clear();
                      });

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("ऑर्डर $orderId बुक हो गया! आपका डिलीवरी OTP: $otp है।"),
                        duration: const Duration(seconds: 4),
                      ));
                    },
                    child: Text(_paymentMode == "prepaid" ? "एस्क्रो से पूरा भुगतान करें" : "50% टोकन देकर पक्का ऑर्डर करें", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
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
    String? selectedGender; // पहले से कोई चयनित नहीं रहेगा (अनिवार्य चयन)
    String selectedItem = "देसी पोल्ट्री अंडे";
    List<String> uploadedPhotos = [];
    String liveGpsCoord = "20.7002° N, 77.0082° E";
    bool isProcessingGps = false;
    final customNameCtl = TextEditingController();
    final tagPrefixCtl = TextEditingController();
    final qtyCtl = TextEditingController();
    final rateCtl = TextEditingController();
    final piecesCtl = TextEditingController(text: "30");
    final addressCtl = TextEditingController(text: "पारस रेलवे क्रॉसिंग के पास, फार्म शेड #1");
    
    final todayDate = DateFormat('dd-MMM-yyyy').format(DateTime.now());
    final prodDateCtl = TextEditingController(text: todayDate);
    final eggWeightCtl = TextEditingController();
    final birdWeightCtl = TextEditingController();
    final picker = ImagePicker();

    final Map<String, List<String>> itemOptions = {
      "अंडे": ["देसी पोल्ट्री अंडे", "कड़कनाथ ओरिजिनल अंडे", "व्हाइट टेबल एग्स", "ऑर्गेनिक बतख अंडे", "बटेर औषधीय अंडे", "ईमू जंबो औषधीय अंडे", "अन्य अंडे (Other Eggs)"],
      "पक्षी/बर्ड्स": ["देसी रंगीन चिकन", "कमर्शियल बॉयलर", "कड़कनाथ ब्लैक लाइव", "देसी / फार्म बतख", "जापानी बटेर (Quail)", "ईमू वयस्क पक्षी", "अन्य नस्ल (Other Breed)"],
    };

    Future<String> fetchCurrentGps() async {
      try {
        LocationPermission perm = await Geolocator.checkPermission();
        if (perm == LocationPermission.denied) {
          perm = await Geolocator.requestPermission();
        }
        if (perm == LocationPermission.whileInUse || perm == LocationPermission.always) {
          final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.medium, timeLimit: const Duration(seconds: 5));
          return "${pos.latitude.toStringAsFixed(4)}° N, ${pos.longitude.toStringAsFixed(4)}° E";
        }
      } catch (_) {}
      return "20.7002° N, 77.0082° E";
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
          final rateLabel = isEgg ? "रेट प्रति Crate (₹) *" : "रेट प्रति Bird (₹) *";

          Future<void> pickSinglePhoto(ImageSource src) async {
            try {
              final picked = await picker.pickImage(source: src, imageQuality: 80);
              if (picked != null) {
                setBState(() => isProcessingGps = true);
                final coord = await fetchCurrentGps();
                setBState(() {
                  uploadedPhotos.add(picked.path);
                  liveGpsCoord = coord;
                  isProcessingGps = false;
                });
              }
            } catch (e) {
              setBState(() => isProcessingGps = false);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("कैमरा या गैलरी खोलने में असमर्थ।")));
            }
          }

          Future<void> pickMultipleGalleryPhotos() async {
            try {
              final pickedList = await picker.pickMultiImage(imageQuality: 80);
              if (pickedList.isNotEmpty) {
                setBState(() => isProcessingGps = true);
                final coord = await fetchCurrentGps();
                setBState(() {
                  for (var item in pickedList) {
                    if (uploadedPhotos.length < 7) {
                      uploadedPhotos.add(item.path);
                    }
                  }
                  liveGpsCoord = coord;
                  isProcessingGps = false;
                });
              }
            } catch (e) {
              setBState(() => isProcessingGps = false);
            }
          }

          return Padding(
            padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text("नई खेप लिस्ट करें (सभी फील्ड अनिवार्य *)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF15803D))),
                  const Divider(),
                  const Text("1. प्रकार चुनें (Type) *:", style: TextStyle(fontWeight: FontWeight.bold)),
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
                              selectedGender = null;
                              selectedItem = itemOptions[selectedType]!.first;
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
                              selectedGender = null;
                              selectedItem = itemOptions[selectedType]!.first;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  if (!isEgg) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: const [
                        Text("2. लिंग चुनें (Gender) *:", style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(width: 6),
                        Text("(चयन अनिवार्य)", style: TextStyle(color: Colors.red, fontSize: 11, fontWeight: FontWeight.bold)),
                      ],
                    ),
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
                    const SizedBox(height: 8),
                    TextField(
                      controller: tagPrefixCtl,
                      decoration: const InputDecoration(
                        labelText: "टैग कोड * (उदा. D, K, B - पक्षियों को D-101 मिलेगा)",
                        border: OutlineInputBorder(),
                        isDense: true,
                        prefixIcon: Icon(Icons.tag, color: Colors.blue),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: birdWeightCtl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "पक्षी का औसत वजन (किग्रा / kg) *",
                        hintText: "उदा. 1.8",
                        helperText: "प्राकृतिक मार्जिन: ±200 ग्राम तक स्वीकार्य",
                        border: OutlineInputBorder(),
                        isDense: true,
                        prefixIcon: Icon(Icons.scale, color: Color(0xFF15803D)),
                      ),
                    ),
                  ] else ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: prodDateCtl,
                            decoration: const InputDecoration(labelText: "उत्पादन तिथि *", border: OutlineInputBorder(), isDense: true),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: eggWeightCtl,
                            decoration: const InputDecoration(
                              labelText: "अंडे का वजन (ग्राम) *",
                              hintText: "उदा. 50-55g",
                              helperText: "मार्जिन: ±10-20g",
                              border: OutlineInputBorder(),
                              isDense: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text("⏳ Best Before: उत्पादन से 30 दिन तक ताज़ा", style: TextStyle(fontSize: 11, color: Color(0xFF15803D), fontWeight: FontWeight.bold)),
                  ],
                  const SizedBox(height: 10),
                  Text(isEgg ? "2. अंडे की नस्ल *:" : "3. पक्षी की नस्ल *:", style: const TextStyle(fontWeight: FontWeight.bold)),
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
                        labelText: isEgg ? "अंडे/नस्ल का नाम लिखें *" : "पक्षी/नस्ल का नाम लिखें *",
                        border: const OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: uploadedPhotos.isNotEmpty ? const Color(0xFFECFDF5) : Colors.grey.shade50,
                      border: Border.all(color: uploadedPhotos.isNotEmpty ? const Color(0xFF15803D) : Colors.grey.shade400, width: 1.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "📸 फोटो अपलोड (${uploadedPhotos.length}/7) *:",
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF15803D)),
                            ),
                            Text(
                              uploadedPhotos.isEmpty ? "कम से कम 1 फोटो अनिवार्य" : "GPS: $liveGpsCoord",
                              style: TextStyle(fontSize: 10, color: uploadedPhotos.isEmpty ? Colors.red : Colors.blueGrey, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "पहला फोटो पूरे लॉट का संयुक्त (कंबाइन) और बाकी कांटे पर वजन व टैग के साथ लें।",
                          style: TextStyle(fontSize: 11, color: Colors.black87),
                        ),
                        const SizedBox(height: 10),
                        if (uploadedPhotos.isNotEmpty) ...[
                          SizedBox(
                            height: 75,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: uploadedPhotos.length,
                              itemBuilder: (context, pIdx) {
                                return Stack(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(right: 8),
                                      child: buildProductThumbnail(
                                        selectedItem,
                                        imagePath: uploadedPhotos[pIdx],
                                        gpsStamp: liveGpsCoord,
                                        width: 75,
                                        height: 75,
                                        tagOrWeightInfo: pIdx == 0 ? "कंबाइन" : "#${pIdx}",
                                      ),
                                    ),
                                    Positioned(
                                      top: 2,
                                      right: 10,
                                      child: GestureDetector(
                                        onTap: () => setBState(() => uploadedPhotos.removeAt(pIdx)),
                                        child: Container(
                                          decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                                          padding: const EdgeInsets.all(2),
                                          child: const Icon(Icons.close, size: 14, color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                        if (uploadedPhotos.length < 7)
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFF15803D), side: const BorderSide(color: Color(0xFF15803D))),
                                  icon: const Icon(Icons.camera_alt, size: 16),
                                  label: Text(uploadedPhotos.isEmpty ? "1. कंबाइन फोटो 📷" : "कांटे का फोटो 📷"),
                                  onPressed: () => pickSinglePhoto(ImageSource.camera),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: OutlinedButton.icon(
                                  style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFF9F2089), side: const BorderSide(color: Color(0xFF9F2089))),
                                  icon: const Icon(Icons.photo_library, size: 16),
                                  label: const Text("गैलरी से चुनें 🖼️"),
                                  onPressed: pickMultipleGalleryPhotos,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: qtyCtl,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(labelText: "मात्रा ($unitLabel) *", border: const OutlineInputBorder()),
                        ),
                      ),
                      if (isEgg) ...[
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: piecesCtl,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: "1 क्रेट में अंडे *", hintText: "उदा. 30", border: OutlineInputBorder()),
                          ),
                        ),
                      ],
                    ],
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
                    decoration: const InputDecoration(labelText: "फार्म का पूरा पता (पिकअप स्थान) *", border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF9F2089), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
                    onPressed: () {
                      // 1. लिंग चयन अनिवार्य जांच (केवल पक्षियों के लिए)
                      if (!isEgg && (selectedGender == null || selectedGender!.isEmpty)) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("⚠️ कृपया पक्षी का लिंग (नर ♂️ या मादा ♀️) अवश्य चुनें!"),
                          backgroundColor: Colors.red,
                        ));
                        return;
                      }

                      // 2. फोटो अनिवार्य जांच
                      if (uploadedPhotos.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("⚠️ कम से कम 1 फोटो (लॉट या कांटे का) अपलोड करना अनिवार्य है!"),
                          backgroundColor: Colors.red,
                        ));
                        return;
                      }

                       // 3. मात्रा और दर अनिवार्य जांच
                      final parsedQty = int.tryParse(qtyCtl.text.trim()) ?? 0;
                      final parsedPrice = double.tryParse(rateCtl.text.trim()) ?? 0.0;
                      if (parsedQty <= 0) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("⚠️ कृपया वैध मात्रा (कम से कम 1) दर्ज करें!"),
                          backgroundColor: Colors.red,
                        ));
                        return;
                      }
                      if (parsedPrice <= 0.0) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("⚠️ कृपया वैध दर (रेट) दर्ज करें!"),
                          backgroundColor: Colors.red,
                        ));
                        return;
                      }

                      // 4. पक्षी टैग और वजन अनिवार्य जांच
                      if (!isEgg) {
                        if (tagPrefixCtl.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text("⚠️ कृपया पक्षी टैग कोड (उदा. D, K, B) दर्ज करें!"),
                            backgroundColor: Colors.red,
                          ));
                          return;
                        }
                        if (birdWeightCtl.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text("⚠️ कृपया पक्षी का औसत वजन दर्ज करें!"),
                            backgroundColor: Colors.red,
                          ));
                          return;
                        }
                      } else {
                        if (eggWeightCtl.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text("⚠️ कृपया अंडे का औसत वजन दर्ज करें!"),
                            backgroundColor: Colors.red,
                          ));
                          return;
                        }
                      }

                      // 5. फार्म पता अनिवार्य जांच
                      if (addressCtl.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("⚠️ कृपया फार्म का पूरा पिकअप पता दर्ज करें!"),
                          backgroundColor: Colors.red,
                        ));
                        return;
                      }

                      Navigator.pop(ctx);
                      final finalUnit = isEgg ? "Crates" : "Birds";
                      final eggCount = isEgg ? (int.tryParse(piecesCtl.text.trim()) ?? 30) : 1;

                      String baseName = isOther && customNameCtl.text.trim().isNotEmpty ? customNameCtl.text.trim() : selectedItem;
                      final finalTitle = isEgg ? "$baseName (तारीख: ${prodDateCtl.text.trim()})" : "$baseName ($selectedGender)";
                      final weightDesc = isEgg ? "${eggWeightCtl.text.trim()}g/अंडा (±15g मार्जिन)" : "${birdWeightCtl.text.trim()}kg (±200g मार्जिन)";
                      final prefix = tagPrefixCtl.text.trim().isEmpty ? "D" : tagPrefixCtl.text.trim();

                      setState(() {
                        _sellerListings.insert(0, {
                          "item": finalTitle,
                          "type": selectedType,
                          "qty": "$parsedQty $finalUnit",
                          "price": parsedPrice,
                          "pieces": eggCount,
                          "weight": weightDesc,
                          "tagPrefix": prefix,
                          "prodDate": isEgg ? prodDateCtl.text.trim() : null,
                          "bestBefore": isEgg ? "उत्पादन से 30 दिन" : null,
                          "farm": "मेरा फार्म (+91 ${widget.phone})",
                          "farmAddress": addressCtl.text.trim(),
                          "farmerPhone": widget.phone,
                          "grade": isEgg ? "तारीख मुद्रित • 30 Days Fresh" : "प्रत्येक पक्षी टैग युक्त",
                          "image": uploadedPhotos.first,
                          "gallery": uploadedPhotos,
                          "gps": liveGpsCoord,
                        });

                        _allProducts.insert(0, {
                          "cat": selectedType == "अंडे" ? "अंडे" : (selectedItem.contains("अन्य") ? "अन्य" : selectedItem.split(" ").first),
                          "sub": isEgg ? "देसी अंडे" : (selectedItem.contains("अन्य") ? "अन्य" : selectedItem.split(" ").first),
                          "item": finalTitle,
                          "unitType": isEgg ? "Crate" : "Bird",
                          "piecesPerCrate": eggCount,
                          "weight": weightDesc,
                          "tagPrefix": prefix,
                          "prodDate": isEgg ? prodDateCtl.text.trim() : null,
                          "bestBefore": isEgg ? "उत्पादन से 30 दिन" : null,
                          "price": parsedPrice,
                          "farm": "मेरा फार्म (+91 ${widget.phone})",
                          "farmAddress": addressCtl.text.trim(),
                          "farmerPhone": widget.phone,
                          "dist": "0.8 किमी",
                          "grade": isEgg ? "खेत से ताज़ा • 30 दिन उपयोग" : "स्वस्थ लाइव • टैग्ड",
                          "gallery": uploadedPhotos,
                          "gps": liveGpsCoord,
                        });
                      });
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("खेप 100% अनिवार्य विवरण व सत्यापन के साथ जुड़ गई!")));
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
    final isEgg = lot["type"] == "अंडे" || lot["item"].toString().contains("अंडे");
    final qtyCtl = TextEditingController(text: lot["qty"].toString().replaceAll(RegExp(r'[^0-9]'), ''));
    final rateCtl = TextEditingController(text: lot["price"].toString().replaceAll(RegExp(r'[^0-9]'), ''));
    final pcsCtl = TextEditingController(text: (lot["pieces"] ?? 30).toString());
    final addressCtl = TextEditingController(text: (lot["farmAddress"] ?? "फार्म पता उपलब्ध").toString());

    _modal("लॉट अपडेट करें (${lot['item']})", [
      Text("उत्पाद: ${lot['item']} (${isEgg ? 'अंडे' : 'पक्षी'})", style: const TextStyle(fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      TextField(controller: qtyCtl, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: "नई मात्रा (${isEgg ? 'Crates' : 'Birds'})", border: const OutlineInputBorder())),
      if (isEgg) ...[
        const SizedBox(height: 10),
        TextField(controller: pcsCtl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "1 क्रेट में अंडों की संख्या", border: OutlineInputBorder())),
      ],
      const SizedBox(height: 10),
      TextField(controller: rateCtl, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: "नया रेट (${isEgg ? '₹/Crate' : '₹/Bird'})", border: const OutlineInputBorder())),
      const SizedBox(height: 10),
      TextField(controller: addressCtl, decoration: const InputDecoration(labelText: "फार्म का पता", border: const OutlineInputBorder())),
    ], "बदलाव सेव करें", () {
      final unitStr = isEgg ? "Crates" : "Birds";
      final parsedRate = double.tryParse(rateCtl.text.trim()) ?? 190.0;
      final parsedPcs = int.tryParse(pcsCtl.text.trim()) ?? 30;

      setState(() {
        _sellerListings[index]["qty"] = "${qtyCtl.text.trim()} $unitStr";
        _sellerListings[index]["price"] = parsedRate;
        _sellerListings[index]["pieces"] = parsedPcs;
        _sellerListings[index]["farmAddress"] = addressCtl.text.trim();
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("लॉट की जानकारी अपडेट हो गई!")));
    });
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
            constraints: const BoxConstraints(maxHeight: 240),
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
                  final st = ord["status"] as String;
                  final isSelfPickup = ord["mode"] == "self";
                  
                  String stText = "किसान द्वारा तैयारी जारी";
                  if (st == "packed_ready") {
                    stText = isSelfPickup ? "माल पैक है • फार्म पर जाकर स्वयं पिकअप करें" : "किसान द्वारा पैक हो गया • कम्यूटर को सौंपा जा रहा है";
                  }
                  if (st == "in_transit") stText = "कम्यूटर रास्ते में है 🚚";
                  if (st == "delivered") stText = "डिलीवर हो गया ✅";
                  if (st == "returned_bus") stText = "अनुपस्थिति पर बस से गाँव वापस रवाना (किराया काटा गया) 🚌";
                  if (st == "rejected_by_buyer") stText = "गलत माल होने पर रिजेक्ट • किसान से दोनों तरफ का भाड़ा काटा गया ⚠️";

                  final fPhone = ord["farmerPhone"] ?? "9876543210";

                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
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
                          if (ord['tags'] != null && ord['tags'].toString().isNotEmpty) ...[
                            const SizedBox(height: 3),
                            Text("🏷️ आपके पक्षियों के टैग: ${ord['tags']}", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.blue)),
                          ],
                          const SizedBox(height: 3),
                          Text("स्थिति: $stText", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: (st == "returned_bus" || st == "rejected_by_buyer") ? Colors.red : const Color(0xFF15803D))),
                          if (st == "returned_bus") ...[
                            const SizedBox(height: 3),
                            Text("🚌 वापसी बस विवरण: ${ord['returnBus'] ?? ''}", style: const TextStyle(fontSize: 11, color: Colors.red, fontWeight: FontWeight.bold)),
                          ],
                          const SizedBox(height: 3),
                          Text("📍 फार्म: ${ord['farm']} • ${ord['farmAddress']}", style: const TextStyle(fontSize: 10, color: Colors.blueGrey)),
                          
                          if (isSelfPickup) ...[
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: const Color(0xFFF0FDF4), borderRadius: BorderRadius.circular(6), border: Border.all(color: const Color(0xFFBBF7D0))),
                              child: Row(
                                children: [
                                  const Icon(Icons.phone, size: 14, color: Color(0xFF15803D)),
                                  const SizedBox(width: 4),
                                  Expanded(child: Text("किसान मोबाइल: +91 $fPhone", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF15803D)))),
                                  GestureDetector(
                                    onTap: () => makePhoneCall(fPhone),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(color: const Color(0xFF15803D), borderRadius: BorderRadius.circular(4)),
                                      child: const Text("कॉल 📞", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  GestureDetector(
                                    onTap: () => launchWhatsApp(fPhone, "नमस्ते! मैं आपके फार्म पर ऑर्डर #${ord['id']} पिकअप करने आ रहा हूँ। कृपया फार्म पर उपस्थित रहें।"),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(color: const Color(0xFF25D366), borderRadius: BorderRadius.circular(4)),
                                      child: const Text("चैट 💬", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          const SizedBox(height: 4),
                          Text("🎯 डिलीवरी: ${ord['dropAddress']}", style: const TextStyle(fontSize: 10, color: Colors.black87, fontWeight: FontWeight.w500)),
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
                    final isEgg = item["unitType"] == "Crate" || (item["item"] as String).contains("अंडे");
                    final pcs = (item["piecesPerCrate"] as int?) ?? 30;
                    final price = (item["price"] as double?) ?? 0.0;
                    final perEgg = isEgg && pcs > 0 ? (price / pcs).toStringAsFixed(2) : null;
                    final thumbImg = (item["gallery"] as List<String>?)?.isNotEmpty == true ? (item["gallery"] as List<String>).first : (item["image"] as String?);

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
                              buildProductThumbnail(item["item"] as String, imagePath: thumbImg, gpsStamp: item["gps"] as String?, width: 85, height: 85),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item["item"] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                    const SizedBox(height: 2),
                                    Text("दर: ₹${price.toStringAsFixed(0)} / ${item['unitType']}", style: const TextStyle(color: Color(0xFF15803D), fontWeight: FontWeight.bold, fontSize: 13)),
                                    if (isEgg) ...[
                                      Text("1 क्रेट = $pcs अंडे (₹$perEgg/अंडा • तारीख मुद्रित)", style: const TextStyle(color: Color(0xFFB45309), fontSize: 11, fontWeight: FontWeight.bold)),
                                    ] else ...[
                                      Text("औसत वजन: ${item['weight'] ?? '1.8kg'}", style: const TextStyle(color: Color(0xFFB45309), fontSize: 11, fontWeight: FontWeight.bold)),
                                    ],
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
    final pendingOrders = AppState.orders.where((o) => o["status"] == "pending_seller" || o["status"] == "packed_ready").toList();

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
              Text("सक्रिय ऑर्डर (${pendingOrders.length})", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFFB45309))),
            ],
          ),
          const SizedBox(height: 8),
          ...pendingOrders.map((ord) {
            final isPacked = ord["status"] == "packed_ready";
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
                    if (ord['tags'] != null && ord['tags'].toString().isNotEmpty)
                      Text("अलग-अलग टैग्स: ${ord['tags']}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                    Text("मोड: $modeStr", style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFFB45309))),
                    Text("पिकअप फार्म पता: ${ord['farmAddress']}", style: const TextStyle(fontSize: 12, color: Colors.blueGrey)),
                    Text("ड्रॉप लोकेशन: ${ord['dropAddress']}", style: const TextStyle(fontSize: 12, color: Colors.black87, fontWeight: FontWeight.w500)),
                    Text("खरीदार फोन: +91 ${ord['buyerPhone']}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    const SizedBox(height: 10),
                    if (!isPacked) ...[
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF15803D), foregroundColor: Colors.white),
                          icon: const Icon(Icons.inventory_2, size: 18),
                          label: const Text("माल पैक हो गया (तारीख व अलग-अलग टैग सत्यापित)"),
                          onPressed: () {
                            setState(() {
                              ord["status"] = "packed_ready";
                            });
                            final buyerMsg = "हेलो! आपका अंडा एक्सप्रेस ऑर्डर #${ord['id']} पैक हो गया है। आवंटित पक्षी टैग: ${ord['tags']}। फार्म का पता: ${ord['farmAddress']}। कृपया समय पर पिकअप करें।";
                            launchWhatsApp(ord["buyerPhone"] as String, buyerMsg);
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("पैकिंग मार्क हुई और ग्राहक को WhatsApp अलर्ट भेजा गया!")));
                          },
                        ),
                      ),
                    ] else ...[
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: const Color(0xFFECFDF5), borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle, color: Color(0xFF15803D), size: 18),
                            const SizedBox(width: 8),
                            Expanded(child: Text(ord["mode"] == "self" ? "पैकिंग पूर्ण! ग्राहक स्वयं फार्म पर आकर पिकअप करेगा..." : "पैकिंग पूर्ण! कम्यूटर द्वारा पिकअप किया जा रहा है...", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF15803D)))),
                          ],
                        ),
                      ),
                    ],
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
          final isEgg = lot["type"] == "अंडे" || lot["item"].toString().contains("अंडे");
          final pcs = lot["pieces"] ?? 30;
          final price = (lot["price"] is double) ? (lot["price"] as double) : double.tryParse(lot["price"].toString().replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
          final perPiece = isEgg && pcs > 0 ? (price / pcs).toStringAsFixed(2) : null;

          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              leading: buildProductThumbnail(lot["item"].toString(), imagePath: lot["image"]?.toString(), gpsStamp: lot["gps"]?.toString(), width: 56, height: 56),
              title: Text(lot["item"].toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(
                isEgg
                    ? "उपलब्ध: ${lot['qty']} (1 क्रेट=$pcs अंडे) • ₹${price.toStringAsFixed(0)}/Crate (₹$perPiece/अंडा)\nवजन: ${lot['weight'] ?? '50-55g'}\nफार्म पता: ${lot['farmAddress'] ?? lot['farm']}"
                    : "उपलब्ध: ${lot['qty']} • ₹${price.toStringAsFixed(0)}/Bird\nवजन: ${lot['weight'] ?? '1.8kg'}\nफार्म पता: ${lot['farmAddress'] ?? lot['farm']}",
              ),
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
    final liveTrips = AppState.orders.where((o) => (o["status"] == "packed_ready" || o["status"] == "in_transit") && o["mode"] != "self").toList();

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
              Text("फार्म पर प्रत्येक पक्षी का अलग टैग व वजन देखकर ही पिकअप करें।", style: TextStyle(color: Colors.white60, fontSize: 12)),
            ]),
          ),
        ),
        const SizedBox(height: 16),
        const Text("उपलब्ध डिलीवरी कार्य:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        if (liveTrips.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: Text("फिलहाल कोई सक्रिय पिकअप नहीं है।\n(किसान के माल पैक करने पर यहाँ खुलेगा)", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey))),
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
                          decoration: BoxDecoration(color: isInTransit ? Colors.blue.shade100 : Colors.green.shade100, borderRadius: BorderRadius.circular(6)),
                          child: Text(isInTransit ? "रास्ते में" : "पिकअप के लिए तैयार", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isInTransit ? Colors.blue.shade900 : Colors.green.shade900)),
                        )
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text("📦 उत्पाद: ${ord['product']}", style: const TextStyle(fontWeight: FontWeight.bold)),
                    if (ord['tags'] != null && ord['tags'].toString().isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.blue.shade200)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("🔍 फार्म पर भौतिक मिलान करें (अलग-अलग टैग्स):", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.blue)),
                            const SizedBox(height: 2),
                            Text("टैग नंबर: ${ord['tags']}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black87)),
                            Text("औसत वजन: ${ord['weights'] ?? 'जाँचें'}", style: const TextStyle(fontSize: 11, color: Colors.blueGrey)),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 4),
                    Text("📍 फार्म नाम: ${ord['farm']} (${ord['dist']})"),
                    Text("🏠 पिकअप फार्म पता: ${ord['farmAddress']}", style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF15803D))),
                    const SizedBox(height: 4),
                    Text("🎯 डिलीवरी मोड: $modeStr", style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF9F2089))),
                    Text("📍 ड्रॉप लोकेशन: ${ord['dropAddress']}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                    Text("📞 ग्राहक फोन: +91 ${ord['buyerPhone']}"),
                    const SizedBox(height: 10),
                    if (isInTransit) ...[
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFF15803D), side: const BorderSide(color: Color(0xFF15803D))),
                        icon: const Icon(Icons.notification_important, size: 18),
                        label: const Text("15 Min WhatsApp Alert भेजें"),
                        onPressed: () {
                          final warnMsg = "⚠️ हेलो! कम्यूटर केवल 15 मिनट में बस स्टॉप पर पहुँच रहा है। कृपया तुरंत लोकेशन पर उपस्थित रहें।";
                          launchWhatsApp(ord["buyerPhone"] as String, warnMsg);
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("ग्राहक को 15-मिनट WhatsApp चेतावनी भेज दी गई!")));
                        },
                      ),
                      const SizedBox(height: 8),
                    ],
                    Row(
                      children: [
                        Expanded(
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
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("माल के सभी टैग सत्यापित कर पिकअप कर लिया गया!")));
                              } else {
                                final otpCtl = TextEditingController();
                                showDialog(
                                  context: context,
                                  builder: (oCtx) => AlertDialog(
                                    title: const Text("ग्राहक OTP दर्ज करें"),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text("डिलीवरी पूरी करने और भुगतान के लिए ग्राहक से 4 अंकों का OTP लें:"),
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
                                              AppState.escrowHold -= (ord["paidAdvance"] as double);
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
                            child: Text(isInTransit ? "OTP सत्यापन व डिलीवरी पूरी करें" : "टैग सत्यापित करें व पिकअप लें"),
                          ),
                        ),
                      ],
                    ),
                    if (isInTransit) ...[
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(foregroundColor: Colors.red, side: const BorderSide(color: Colors.red)),
                          icon: const Icon(Icons.directions_bus, size: 18),
                          label: const Text("ग्राहक अनुपस्थित 👉 वापसी बस हैंडओवर (ग्राहक हर्जाना)"),
                          onPressed: () {
                            final busCtl = TextEditingController(text: "MH-30-AB-");
                            final condCtl = TextEditingController();
                            final returnFareCtl = TextEditingController(text: "40");

                            showDialog(
                              context: context,
                              builder: (bCtx) => AlertDialog(
                                title: const Text("गाँव वापसी बस हैंडओवर (ग्राहक हर्जाना)", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.red)),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text("ग्राहक 10 मिनट में नहीं आया। दोनों तरफ का किराया ग्राहक के अग्रिम भुगतान से काटा जाएगा:", style: TextStyle(fontSize: 11)),
                                    const SizedBox(height: 10),
                                    TextField(controller: busCtl, decoration: const InputDecoration(labelText: "बस / जीप नंबर", border: OutlineInputBorder(), isDense: true)),
                                    const SizedBox(height: 8),
                                    TextField(controller: condCtl, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: "कंडक्टर फोन नंबर", border: OutlineInputBorder(), isDense: true)),
                                    const SizedBox(height: 8),
                                    TextField(controller: returnFareCtl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "वापसी बस भाड़ा (₹)", border: OutlineInputBorder(), isDense: true)),
                                  ],
                                ),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(bCtx), child: const Text("रद्द करें")),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                                    onPressed: () {
                                      Navigator.pop(bCtx);
                                      final retFare = double.tryParse(returnFareCtl.text.trim()) ?? 40.0;
                                      setState(() {
                                        ord["status"] = "returned_bus";
                                        ord["returnBus"] = "बस नं: ${busCtl.text} • कंडक्टर: ${condCtl.text} (वापसी भाड़ा: ₹$retFare)";
                                        AppState.escrowHold -= (ord["paidAdvance"] as double);
                                      });
                                      final farmerMsg = "सूचना: ग्राहक बस स्टॉप पर अनुपस्थित रहा। कम्यूटर ने आपका माल बस नं ${busCtl.text} (कंडक्टर फोन: ${condCtl.text}) में गाँव के लिए रवाना कर दिया है। दोनों तरफ का किराया ग्राहक से वसूल लिया गया है। कृपया गाँव स्टॉप से माल प्राप्त करें।";
                                      launchWhatsApp(ord["farmerPhone"] as String, farmerMsg);
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("माल बस में हैंडओवर दर्ज हुआ! दोनों तरफ का किराया कटा व किसान को सूचना भेजी गई।")));
                                    },
                                    child: const Text("हैंडओवर कन्फर्म करें"),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 6),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFFB91C1C), side: const BorderSide(color: Color(0xFFB91C1C))),
                          icon: const Icon(Icons.report_problem, size: 18),
                          label: const Text("गलत माल/टैग मिसमैच 👉 किसान से दोनों तरफ भाड़ा वसूली"),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (rCtx) => AlertDialog(
                                title: const Text("गलत माल रिजेक्शन (किसान हर्जाना)", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFFB91C1C))),
                                content: const Text(
                                  "यदि किसान ने तारीख के बिना अंडे दिए हैं, पक्षी का टैग नंबर मेल नहीं खाता या लिस्टिंग अनुसार माल नहीं है:\n\n"
                                  "• ग्राहक को पूरा रिफंड मिलेगा।\n"
                                  "• कम्यूटर की डिलीवरी फ़ीस व रिटर्न का दोनों तरफ का भाड़ा सीधे किसान के वॉलेट से काटा जाएगा।",
                                  style: TextStyle(fontSize: 12),
                                ),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(rCtx), child: const Text("रद्द करें")),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFB91C1C), foregroundColor: Colors.white),
                                    onPressed: () {
                                      Navigator.pop(rCtx);
                                      setState(() {
                                        ord["status"] = "rejected_by_buyer";
                                        final penalty = ((ord["deliveryFee"] as double) * 2);
                                        AppState.sellerWallet -= penalty;
                                        AppState.escrowHold -= (ord["paidAdvance"] as double);
                                      });
                                      final farmerPenaltyMsg = "चेतावनी: आपके द्वारा लिस्टिंग अनुसार सही माल/टैग न देने के कारण ऑर्डर #${ord['id']} रिजेक्ट हुआ है। नियम अनुसार दोनों तरफ का डिलीवरी भाड़ा आपके किसान वॉलेट से काट लिया गया है।";
                                      launchWhatsApp(ord["farmerPhone"] as String, farmerPenaltyMsg);
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("गलत माल रिजेक्ट! किसान वॉलेट से दोनों तरफ का भाड़ा काटा गया।")));
                                    },
                                    child: const Text("हैंडओवर व हर्जाना लागू करें"),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }),
      ],
    );
  }
}
