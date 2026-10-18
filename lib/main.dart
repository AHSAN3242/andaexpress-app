import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(
    title: "AndaExpress",
    debugShowCheckedModeBanner: false,
    home: CompleteLoginFlowScreen(),
  ));
}

class CompleteLoginFlowScreen extends StatefulWidget {
  const CompleteLoginFlowScreen({super.key});
  @override
  State<CompleteLoginFlowScreen> createState() => _CompleteLoginFlowScreenState();
}

class _CompleteLoginFlowScreenState extends State<CompleteLoginFlowScreen> {
  String _role = "seller";
  final TextEditingController _phoneCtl = TextEditingController();
  final TextEditingController _otpCtl = TextEditingController();
  bool _otpSent = false;

  void _handleAuth() {
    if (!_otpSent) {
      if (_phoneCtl.text.trim().length < 10) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("कृपया 10 अंकों का नंबर दर्ज करें")),
        );
        return;
      }
      setState(() {
        _otpSent = true;
        _otpCtl.text = "123456";
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (ctx) => RoleDashboardScreen(role: _role, phone: _phoneCtl.text.trim()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AndaExpress (अंडा एक्सप्रेस)"),
        backgroundColor: const Color(0xFFD97706),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),
            const Icon(Icons.egg_alt, size: 70, color: Color(0xFFD97706)),
            const SizedBox(height: 8),
            const Text(
              "खेत से सीधे ताज़ा अंडे और चिकन",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            const Text("अपनी प्रोफाइल चुनें:", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              children: [
                _roleBtn("buyer", "खरीदार\n(Buyer)", Icons.shopping_bag),
                const SizedBox(width: 8),
                _roleBtn("seller", "किसान\n(Seller)", Icons.storefront),
                const SizedBox(width: 8),
                _roleBtn("commuter", "डिलीवरी\n(Commuter)", Icons.delivery_dining),
              ],
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _phoneCtl,
              keyboardType: TextInputType.phone,
              enabled: !_otpSent,
              decoration: const InputDecoration(
                prefixText: "+91 ",
                labelText: "10 अंकों का मोबाइल नंबर",
                border: OutlineInputBorder(),
              ),
            ),
            if (_otpSent) ...[
              const SizedBox(height: 14),
              TextField(
                controller: _otpCtl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "6 अंकों का OTP",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD97706),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: _handleAuth,
              child: Text(
                _otpSent ? "लॉगिन करें और आगे बढ़ें" : "ओटीपी प्राप्त करें",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _roleBtn(String role, String label, IconData icon) {
    final sel = _role == role;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _role = role),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: sel ? const Color(0xFFFEF3C7) : Colors.white,
            border: Border.all(color: sel ? const Color(0xFFD97706) : Colors.grey.shade300, width: sel ? 2 : 1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Icon(icon, color: sel ? const Color(0xFFD97706) : Colors.grey),
              const SizedBox(height: 4),
              Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 11, fontWeight: sel ? FontWeight.bold : FontWeight.normal)),
            ],
          ),
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
  late TabController _tabCtl;
  int _cart = 0;

  final List<Map<String, String>> _listings = [
    {"item": "देसी ताज़ा अंडे", "qty": "20 Crates", "price": "₹190/Crate", "farm": "पाटिल फार्म (प्लॉट 14)", "grade": "Grade A+"},
    {"item": "ब्रायलर फार्म फ्रेश", "qty": "50 Crates", "price": "₹155/Crate", "farm": "पाटिल फार्म (प्लॉट 14)", "grade": "Standard Table"},
  ];

  final List<Map<String, String>> _demands = [
    {"buyer": "शाही बेकर्स", "loc": "सेंट्रल मार्केट (दूरी 6 किमी)", "req": "व्हाइट अंडे 100 Crates", "rate": "₹152/Crate"},
    {"buyer": "होटल ग्रीन पार्क", "loc": "हाइवे जंक्शन (दूरी 3.5 किमी)", "req": "देसी चिकन 80 Kg", "rate": "₹140/Kg"},
  ];

  final List<Map<String, String>> _products = [
    {"name": "कड़कनाथ शुद्ध देसी अंडे", "farm": "आनंद पोल्ट्री फार्म", "price": "₹220/Crate", "loc": "पारस रोड (2.5 किमी)", "stock": "35 Crates", "desc": "100% शुद्धता और ताज़गी की गारंटी"},
    {"name": "फार्म फ्रेश टेबल एग्स", "farm": "बालाजी एग्रो पोल्ट्री", "price": "₹150/Crate", "loc": "MIDC के पास (5 किमी)", "stock": "120 Crates", "desc": "साफ़ और ग्रेडेड ताज़ा अंडे"},
    {"name": "देसी चिकन (लाइव ब्रायलर)", "farm": "किसान मित्र फार्म", "price": "₹135/Kg", "loc": "बायपास रोड (8 किमी)", "stock": "250 पंछी", "desc": "नेचुरल फीड पर तैयार"},
  ];

  final List<Map<String, dynamic>> _trips = [
    {"id": "TRIP-802", "from": "पाटिल पोल्ट्री फार्म (रमेश पाटिल)", "to": "सेंट्रल सिटी हब, डिपो गेट 2", "dist": "12.4 किमी", "earn": "₹480", "crates": "40 Crates", "done": false},
    {"id": "TRIP-805", "from": "ग्रीन वैली फार्म (दिनेश गायकवाड़)", "to": "होलसेल एग मार्केट", "dist": "7.8 किमी", "earn": "₹320", "crates": "25 Crates", "done": false},
  ];

  @override
  void initState() {
    super.initState();
    _tabCtl = TabController(length: 2, vsync: this);
  }

  void _showDetail(String title, List<Widget> details, String btnText, VoidCallback onAction) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(height: 20),
            ...details,
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD97706), foregroundColor: Colors.white),
              onPressed: () {
                Navigator.pop(ctx);
                onAction();
              },
              child: Text(btnText),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.role == "seller") return _buildSeller();
    if (widget.role == "commuter") return _buildCommuter();
    return _buildBuyer();
  }

  Widget _buildSeller() {
    return Scaffold(
      appBar: AppBar(
        title: const Text("सेलर डैशबोर्ड"),
        backgroundColor: const Color(0xFFD97706),
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabCtl,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [Tab(text: "मेरी खेप (Stock)"), Tab(text: "खरीदार मांग (Demands)")],
        ),
      ),
      body: TabBarView(
        controller: _tabCtl,
        children: [
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: const Color(0xFFD97706), borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("वॉलेट बैलेंस", style: TextStyle(color: Colors.white70)),
                    const Text("₹18,450.00", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                    Text("फार्म फोन: +91 ${widget.phone}", style: const TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text("सक्रिय खेप (टैप करके विवरण देखें):", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ..._listings.map((l) => Card(
                child: ListTile(
                  title: Text(l["item"]!, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("${l["qty"]} • ${l["price"]}\n${l["farm"]}"),
                  isThreeLine: true,
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                  onTap: () => _showDetail(
                    l["item"]!,
                    [
                      Text("फार्म: ${l["farm"]}"),
                      Text("उपलब्ध: ${l["qty"]}"),
                      Text("रेट: ${l["price"]}"),
                      Text("ग्रेड: ${l["grade"]}"),
                    ],
                    "रेट या मात्रा अपडेट करें",
                    () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("अपडेट सुरक्षित किया गया"))),
                  ),
                ),
              )),
            ],
          ),
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ..._demands.map((d) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(d["buyer"]!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Text(d["rate"]!, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Text("स्थान: ${d["loc"]}"),
                      Text("मांग: ${d["req"]}"),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD97706), foregroundColor: Colors.white),
                        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${d["buyer"]} को ऑफर भेजा गया"))),
                        child: const Text("सप्लाई ऑफर भेजें"),
                      ),
                    ],
                  ),
                ),
              )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBuyer() {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ग्राहक बाज़ार (Buyer)"),
        backgroundColor: const Color(0xFFD97706),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Badge(label: Text("$_cart"), isLabelVisible: _cart > 0, child: const Icon(Icons.shopping_cart)),
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("कार्ट में $_cart आइटम हैं"))),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text("उपलब्ध फार्म स्टॉक (टैप करके विवरण देखें):", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ..._products.map((p) => Card(
            child: ListTile(
              title: Text(p["name"]!, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("${p["farm"]} • ${p["price"]}"),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD97706), foregroundColor: Colors.white),
                onPressed: () => _showDetail(
                  p["name"]!,
                  [
                    Text("फार्म: ${p["farm"]}"),
                    Text("स्थान: ${p["loc"]}"),
                    Text("उपलब्ध स्टॉक: ${p["stock"]}"),
                    Text("रेट: ${p["price"]}"),
                    Text("विवरण: ${p["desc"]}"),
                  ],
                  "अभी ऑर्डर करें",
                  () {
                    setState(() => _cart++);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("कार्ट में जोड़ा गया")));
                  },
                ),
                child: const Text("विवरण"),
              ),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildCommuter() {
    return Scaffold(
      appBar: AppBar(
        title: const Text("कम्यूटर डिलीवरी"),
        backgroundColor: const Color(0xFFD97706),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ..._trips.map((t) => Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("कमीशन: ${t["earn"]}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 16)),
                      Chip(label: Text(t["crates"])),
                    ],
                  ),
                  const Divider(),
                  Text("पिकअप: ${t["from"]}"),
                  Text("ड्रॉप: ${t["to"]}"),
                  Text("दूरी: ${t["dist"]}"),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: t["done"] ? Colors.grey : const Color(0xFFD97706),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => _showDetail(
                      "ट्रिप ${t["id"]}",
                      [
                        Text("पिकअप: ${t["from"]}"),
                        Text("ड्रॉप: ${t["to"]}"),
                        Text("दूरी: ${t["dist"]}"),
                        Text("कमीशन: ${t["earn"]}"),
                      ],
                      t["done"] ? "पहले से स्वीकृत है" : "ट्रिप स्वीकार करें",
                      () {
                        if (!t["done"]) {
                          setState(() => t["done"] = true);
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("ट्रिप स्वीकार कर ली गई")));
                        }
                      },
                    ),
                    child: Text(t["done"] ? "स्वीकृत" : "रूट विवरण देखें"),
                  ),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }
}
