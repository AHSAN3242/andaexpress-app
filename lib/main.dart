import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(
    title: "AndaExpress",
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
  String _lang = "hi", _role = "seller";
  final _phone = TextEditingController(), _otp = TextEditingController();
  bool _sent = false;

  final Map<String, List<String>> _t = {
    "hi": ["अंडा एक्सप्रेस", "खेत से ताज़ा अंडे और चिकन", "खरीदार", "किसान", "डिलीवरी", "10 अंकों का फोन नंबर", "ओटीपी प्राप्त करें", "लॉगिन करें"],
    "en": ["AndaExpress", "Farm Fresh Eggs & Chicken", "Buyer", "Seller", "Commuter", "10-digit Phone", "Get OTP", "Login"],
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
            const Icon(Icons.egg_alt, size: 64, color: Color(0xFF9F2089)),
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
          child: Column(children: [Icon(ic, color: s ? const Color(0xFF9F2089) : Colors.grey), Text(txt, style: TextStyle(fontWeight: s ? FontWeight.bold : FontWeight.normal))]),
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
  List<Map<String, String>> _cartItems = [];

  final List<Map<String, String>> _listings = [
    {"item": "देसी ताज़ा अंडे", "qty": "20 Crates", "price": "₹190/Crate", "farm": "पाटिल फार्म (प्लॉट 14)", "grade": "Grade A+ ताज़ा"},
    {"item": "ब्रायलर फार्म फ्रेश", "qty": "50 Crates", "price": "₹155/Crate", "farm": "पाटिल फार्म (प्लॉट 14)", "grade": "Standard Table"},
  ];

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
            ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF9F2089), foregroundColor: Colors.white), onPressed: () { Navigator.pop(context); onAct(); }, child: Text(btnText, style: const TextStyle(fontWeight: FontWeight.bold))),
          ],
        ),
      ),
    );
  }

  void _addBatchDialog() {
    final itemCtl = TextEditingController(text: "देसी पोल्ट्री अंडे");
    final qtyCtl = TextEditingController(text: "15");
    final rateCtl = TextEditingController(text: "185");
    _modal("नई खेप लिस्ट करें (Add Lot)", [
      TextField(controller: itemCtl, decoration: const InputDecoration(labelText: "उत्पाद का प्रकार", border: OutlineInputBorder())),
      const SizedBox(height: 10),
      TextField(controller: qtyCtl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "मात्रा (Crates की संख्या)", border: OutlineInputBorder())),
      const SizedBox(height: 10),
      TextField(controller: rateCtl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "रेट प्रति Crate (₹)", border: OutlineInputBorder())),
    ], "खेप तुरंत लाइव करें", () {
      setState(() {
        _listings.insert(0, {
          "item": itemCtl.text.trim(),
          "qty": "${qtyCtl.text.trim()} Crates",
          "price": "₹${rateCtl.text.trim()}/Crate",
          "farm": "मेरा फार्म (+91 ${widget.phone})",
          "grade": "Grade A+ ताज़ा",
        });
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("नई खेप सफलतापूर्वक जुड़ गई!")));
    });
  }

  void _showCheckout() {
    _modal("ऑर्डर चेकआउट (Order Bill)", [
      Text("कुल चुने गए आइटम: $_cart लॉट", style: const TextStyle(fontWeight: FontWeight.bold)),
      const SizedBox(height: 8),
      const Text("डिलीवरी: सीधा आपके पते पर (एक्सप्रेस कम्यूटर)"),
      const Text("भुगतान का तरीका: कैश ऑन डिलीवरी (COD) / UPI"),
      const Divider(),
      const Text("अनुमानित कुल राशि: ₹1,900.00", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF15803D))),
    ], "ऑर्डर कन्फर्म करें", () {
      setState(() { _cart = 0; _cartItems.clear(); });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("ऑर्डर सफलतापूर्वक बुक हो गया!")));
    });
  }

  @override
  Widget build(BuildContext context) {
    String heading = widget.role == "seller" ? "सेलर डैशबोर्ड" : (widget.role == "commuter" ? "कम्यूटर डिलीवरी" : "ग्राहक बाज़ार");
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
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("सक्रिय खेप:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF9F2089), foregroundColor: Colors.white),
              icon: const Icon(Icons.add, size: 16),
              label: const Text("नई खेप"),
              onPressed: _addBatchDialog,
            )
          ],
        ),
        const SizedBox(height: 8),
        ..._listings.map((l) => _cardTile(l["item"]!, "${l['qty']} • ${l['price']}\n${l['farm']}", () {
          _modal(l["item"]!, [Text("फार्म: ${l['farm']}"), Text("मात्रा: ${l['qty']}"), Text("रेट: ${l['price']}"), Text("ग्रेड: ${l['grade']}")], "रेट या स्टॉक अपडेट करें", () {});
        })),
      ],
    );
  }

  Widget _buildBuyer() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text("फार्म उत्पाद (विवरण हेतु टैप करें):", style: TextStyle(fontWeight: FontWeight.bold)),
        _cardTile("कड़कनाथ शुद्ध अंडे", "आनंद पोल्ट्री • ₹220/Crate\nपारस रोड (2.5 किमी)", () {
          _modal("कड़कनाथ अंडे", [const Text("फार्म: आनंद पोल्ट्री फार्म"), const Text("स्थान: पारस रोड (2.5 किमी)"), const Text("स्टॉक: 35 Crates उपलब्ध"), const Text("गारंटी: 100% Float-Test ताज़ा")], "कार्ट में जोड़ें और बिल देखें", () {
            setState(() => _cart++);
            _showCheckout();
          });
        }),
        _cardTile("फार्म फ्रेश टेबल एग्स", "बालाजी पोल्ट्री • ₹150/Crate\nMIDC एरिया (5 किमी)", () {
          _modal("टेबल एग्स", [const Text("फार्म: बालाजी पोल्ट्री"), const Text("स्टॉक: 120 Crates"), const Text("रेट: ₹150/Crate")], "कार्ट में जोड़ें और बिल देखें", () {
            setState(() => _cart++);
            _showCheckout();
          });
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
              _modal("ट्रिप विवरण", [Text("पिकअप: ${t['from']}"), Text("ड्रॉप: ${t['to']}"), Text("दूरी: ${t['dist']}"), Text("कमीशन: ${t['earn']}")], t['done'] ? "स्वीकृत" : "ट्रिप स्वीकार करें", () {
                if (!t['done']) {
                  setState(() => t['done'] = true);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("ट्रिप स्वीकार कर ली गई")));
                }
              });
            },
            child: Text(t['done'] ? "स्वीकृत" : "विवरण", style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
      )).toList(),
    );
  }

  Widget _cardTile(String t, String sub, VoidCallback onTap) {
    return Card(child: ListTile(title: Text(t, style: const TextStyle(fontWeight: FontWeight.bold)), subtitle: Text(sub), trailing: const Icon(Icons.arrow_forward_ios, size: 14), onTap: onTap));
  }
}
