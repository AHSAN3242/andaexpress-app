import 'package:flutter/material.dart';

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
  int _cart = 0;
  String _selectedCategory = "अंडे";
  String _selectedEggSub = "सभी";

  final List<Map<String, dynamic>> _mainCategories = [
    {"name": "अंडे", "icon": "🥚"},
    {"name": "देसी चिकन", "icon": "🐓"},
    {"name": "बॉयलर चिकन", "icon": "🐔"},
    {"name": "कड़कनाथ", "icon": "🖤"},
    {"name": "बतख", "icon": "🦆"},
    {"name": "बटेर", "icon": "🐦"},
    {"name": "ईमू", "icon": "🦤"},
  ];

  final List<String> _eggSubCategories = [
    "सभी",
    "देसी अंडे",
    "कड़कनाथ अंडे",
    "टेबल एग्स",
    "बतख के अंडे",
    "बटेर अंडे",
    "ईमू अंडे"
  ];

  final List<Map<String, String>> _allProducts = [
    {"cat": "अंडे", "sub": "देसी अंडे", "item": "शुद्ध देसी अंडे", "qty": "30 Crates", "price": "₹190/Crate", "farm": "कृष्णा फार्म (2.1 किमी)", "grade": "खेत से ताज़ा"},
    {"cat": "अंडे", "sub": "कड़कनाथ अंडे", "item": "कड़कनाथ ओरिजिनल अंडे", "qty": "20 Crates", "price": "₹240/Crate", "farm": "आनंद पोल्ट्री (3.5 किमी)", "grade": "High Protein A+"},
    {"cat": "अंडे", "sub": "टेबल एग्स", "item": "व्हाइट टेबल एग्स (ब्रायलर)", "qty": "100 Crates", "price": "₹155/Crate", "farm": "पाटिल पोल्ट्री हब (5 किमी)", "grade": "Commercial Fresh"},
    {"cat": "अंडे", "sub": "बतख के अंडे", "item": "ऑर्गेनिक बतख (Duck) अंडे", "qty": "15 Crates", "price": "₹210/Crate", "farm": "रिवरसाइड डक फार्म (7 किमी)", "grade": "Large Size"},
    {"cat": "अंडे", "sub": "बटेर अंडे", "item": "बटेर (Quail) औषधीय अंडे", "qty": "40 Crates", "price": "₹120/Crate", "farm": "ग्रीन वैली पोल्ट्री (4 किमी)", "grade": "Nutrient Rich"},
    {"cat": "अंडे", "sub": "ईमू अंडे", "item": "ईमू (Emu) जंबो अंडे", "qty": "8 Pieces", "price": "₹450/Piece", "farm": "महावीर ईमू फार्म (12 किमी)", "grade": "Giant Green Shell"},
    {"cat": "देसी चिकन", "sub": "देसी", "item": "देसी फ्री-रेंज रंगीन चिकन", "qty": "50 Birds", "price": "₹290/किग्रा", "farm": "बालाजी फार्म (6 किमी)", "grade": "100% Natural Organic"},
    {"cat": "बॉयलर चिकन", "sub": "बॉयलर", "item": "कमर्शियल व्हाइट बॉयलर", "qty": "200 Birds", "price": "₹135/किग्रा", "farm": "स्टार पोल्ट्री (3 किमी)", "grade": "Standard 2.2kg avg"},
    {"cat": "कड़कनाथ", "sub": "कड़कनाथ", "item": "कड़कनाथ प्योर ब्लैक लाइव", "qty": "35 Birds", "price": "₹650/किग्रा", "farm": "आनंद पोल्ट्री (3.5 किमी)", "grade": "Pure Aseel Bloodline"},
    {"cat": "बतख", "sub": "बतख", "item": "व्हाइट पेकिन बतख लाइव", "qty": "30 Birds", "price": "₹320/किग्रा", "farm": "रिवरसाइड फार्म (7 किमी)", "grade": "Farm Raised"},
    {"cat": "बटेर", "sub": "बटेर", "item": "जापानी बटेर (Quail)", "qty": "120 Birds", "price": "₹65/Bird", "farm": "ग्रीन वैली (4 किमी)", "grade": "Healthy Weight"},
    {"cat": "ईमू", "sub": "ईमू", "item": "वयस्क ईमू जोड़ी", "qty": "4 Pairs", "price": "₹8,500/Pair", "farm": "महावीर फार्म (12 किमी)", "grade": "Breeding Quality"},
  ];

  // किसान की सक्रिय खेप (Seller Listings)
  late List<Map<String, String>> _sellerListings;

  @override
  void initState() {
    super.initState();
    _sellerListings = [
      {"item": "देसी पोल्ट्री अंडे", "qty": "20 Crates", "price": "₹190/Crate", "farm": "मेरा फार्म (+91 ${widget.phone})", "grade": "Grade A+ ताज़ा"},
      {"item": "कड़कनाथ अंडे", "qty": "10 Crates", "price": "₹240/Crate", "farm": "मेरा फार्म (+91 ${widget.phone})", "grade": "प्रीमियम"},
    ];
  }

  final List<Map<String, dynamic>> _trips = [
    {"from": "पाटिल फार्म (रमेश)", "to": "सिटी हब गेट 2", "dist": "12.4 किमी", "earn": "₹480", "crates": "40 Crates", "done": false},
    {"from": "ग्रीन वैली (दिनेश)", "to": "होलसेल मार्केट", "dist": "7.8 किमी", "earn": "₹320", "crates": "25 Crates", "done": false},
  ];

  void _modal(String title, List<Widget> body, String btnText, VoidCallback onAct) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => Padding(
        padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
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
                Navigator.pop(context);
                onAct();
              },
              child: Text(btnText, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ),
          ],
        ),
      ),
    );
  }

  void _addBatchDialog() {
    final itemCtl = TextEditingController(text: "देसी पोल्ट्री अंडे");
    final qtyCtl = TextEditingController(text: "15");
    final rateCtl = TextEditingController(text: "190");
    _modal("नई खेप लिस्ट करें (Add Lot)", [
      TextField(controller: itemCtl, decoration: const InputDecoration(labelText: "उत्पाद का नाम (उदा. देसी अंडे, कड़कनाथ)", border: OutlineInputBorder())),
      const SizedBox(height: 10),
      TextField(controller: qtyCtl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "मात्रा (Crates या Birds)", border: OutlineInputBorder())),
      const SizedBox(height: 10),
      TextField(controller: rateCtl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "रेट प्रति Crate/किग्रा (₹)", border: OutlineInputBorder())),
    ], "खेप तुरंत लाइव करें", () {
      setState(() {
        _sellerListings.insert(0, {
          "item": itemCtl.text.trim(),
          "qty": "${qtyCtl.text.trim()} Crates",
          "price": "₹${rateCtl.text.trim()}/Crate",
          "farm": "मेरा फार्म (+91 ${widget.phone})",
          "grade": "खेत से ताज़ा",
        });
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("नई खेप सफलतापूर्वक जुड़ गई!")));
    });
  }

  void _editBatchDialog(int index) {
    final lot = _sellerListings[index];
    final qtyCtl = TextEditingController(text: lot["qty"]!.replaceAll(RegExp(r'[^0-9]'), ''));
    final rateCtl = TextEditingController(text: lot["price"]!.replaceAll(RegExp(r'[^0-9]'), ''));

    _modal("लॉट अपडेट करें (${lot['item']})", [
      Text("उत्पाद: ${lot['item']}", style: const TextStyle(fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),
      TextField(controller: qtyCtl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "नई मात्रा (उपलब्ध Crates)", border: OutlineInputBorder())),
      const SizedBox(height: 10),
      TextField(controller: rateCtl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "नया रेट प्रति Crate (₹)", border: OutlineInputBorder())),
    ], "बदलाव सेव करें", () {
      setState(() {
        _sellerListings[index]["qty"] = "${qtyCtl.text.trim()} Crates";
        _sellerListings[index]["price"] = "₹${rateCtl.text.trim()}/Crate";
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("लॉट की जानकारी अपडेट हो गई!")));
    });
  }

  void _showCheckout() {
    _modal("ऑर्डर चेकआउट (Order Summary)", [
      Text("कुल आइटम: $_cart लॉट", style: const TextStyle(fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      const Text("डिलीवरी: सीधा आपके पते पर (एक्सप्रेस कम्यूटर)"),
      const Text("भुगतान: कैश ऑन डिलीवरी (COD) / UPI"),
      const Divider(),
      const Text("अनुमानित कुल राशि: ₹1,900.00", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF15803D))),
    ], "ऑर्डर कन्फर्म करें", () {
      setState(() => _cart = 0);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("ऑर्डर सफलतापूर्वक बुक हो गया!")));
    });
  }

  @override
  Widget build(BuildContext context) {
    String heading = widget.role == "seller" ? "सेलर डैशबोर्ड" : (widget.role == "commuter" ? "कम्यूटर डिलीवरी" : "ग्राहक बाज़ार (Anda Express)");
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
              IconButton(icon: Badge(label: Text("$_cart"), isLabelVisible: _cart > 0, child: const Icon(Icons.shopping_cart)), onPressed: _showCheckout),
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

    return Column(
      children: [
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
                            child: Text(cat["icon"] as String, style: const TextStyle(fontSize: 22)),
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
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xFFFFFBEB),
                          child: Text(
                            item["cat"] == "अंडे" ? "🥚" : (item["cat"] == "देसी चिकन" ? "🐓" : (item["cat"] == "बॉयलर चिकन" ? "🐔" : (item["cat"] == "कड़कनाथ" ? "🖤" : (item["cat"] == "बतख" ? "🦆" : "🐦")))),
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                        title: Text(item["item"]!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        subtitle: Text("${item['farm']}\nउपलब्ध: ${item['qty']} • ${item['grade']}", style: const TextStyle(fontSize: 12)),
                        isThreeLine: true,
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(item["price"]!, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF15803D), fontSize: 14)),
                            const SizedBox(height: 4),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF9F2089),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                minimumSize: const Size(50, 26),
                              ),
                              onPressed: () {
                                setState(() => _cart++);
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${item['item']} कार्ट में जोड़ा गया!"), duration: const Duration(seconds: 1)));
                              },
                              child: const Text("खरीदें", style: TextStyle(fontSize: 11)),
                            )
                          ],
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
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          color: const Color(0xFF15803D),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text("वॉलेट बैलेंस", style: TextStyle(color: Colors.white70)),
              const Text("₹18,450.00", style: TextStyle(color: Color(0xFFFEF08A), fontSize: 24, fontWeight: FontWeight.bold)),
              Text("फोन: +91 ${widget.phone}", style: const TextStyle(color: Colors.white70)),
            ]),
          ),
        ),
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
              leading: CircleAvatar(
                backgroundColor: const Color(0xFFFFFBEB),
                child: Text(lot["item"]!.contains("अंडे") ? "🥚" : "🐓", style: const TextStyle(fontSize: 20)),
              ),
              title: Text(lot["item"]!, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("${lot['qty']} • ${lot['price']}\n${lot['farm']}"),
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
    return ListView(
      padding: const EdgeInsets.all(16),
      children: _trips.map((t) => Card(
        child: ListTile(
          title: Text("कमीशन: ${t['earn']} (${t['crates']})", style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF15803D))),
          subtitle: Text("पिकअप: ${t['from']}\nड्रॉप: ${t['to']}\nदूरी: ${t['dist']}"),
          isThreeLine: true,
          trailing: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: t['done'] ? Colors.grey : const Color(0xFF9F2089), foregroundColor: Colors.white),
            onPressed: () {
              setState(() => t['done'] = true);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("ट्रिप स्वीकार कर ली गई")));
            },
            child: Text(t['done'] ? "स्वीकृत" : "स्वीकार करें", style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
      )).toList(),
    );
  }
}
