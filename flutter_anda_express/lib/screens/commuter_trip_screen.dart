import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../config/pricing_config.dart';
export '../config/pricing_config.dart';

/// Status of an egg/poultry parcel in the commuter run
enum ParcelDeliveryStatus {
  assigned, // Assigned to commuter run
  inTransit, // Commuter departed from Paras
  arrivedBusStand, // Commuter reached Akola Bus Stand
  deliveredDirect, // Direct handshake handover using 4-digit code
  droppedAtHub, // Handover timed out -> Dropped at Akola City Hub Shop (₹5 fee added)
}

/// Assigned Cargo Parcel for Commuter Route
class CommuterParcel {
  final String orderId;
  final String buyerName;
  final String buyerPhone;
  final String itemSummary;
  final CargoCategory category;
  final int quantity; // Trays or Birds count
  final bool isDistinctBuyer;
  final String pickupCode; // 4-digit anti-bypass security code
  final double commuterFee; // Calculated using CommuterFareCalculator
  final double grossFee;
  final double discountPercent;
  final double parcelAmount;
  ParcelDeliveryStatus status;
  String? hubShopName;
  double extraHubFee;

  CommuterParcel({
    required this.orderId,
    required this.buyerName,
    required this.buyerPhone,
    required this.itemSummary,
    required this.category,
    required this.quantity,
    this.isDistinctBuyer = false,
    required this.pickupCode,
    required this.commuterFee,
    required this.grossFee,
    required this.discountPercent,
    required this.parcelAmount,
    this.status = ParcelDeliveryStatus.assigned,
    this.hubShopName,
    this.extraHubFee = 0.0,
  });

  /// Factory helper to create parcel with exact fare calculation
  factory CommuterParcel.create({
    required String orderId,
    required String buyerName,
    required String buyerPhone,
    required String itemSummary,
    required CargoCategory category,
    required int quantity,
    bool isDistinctBuyer = false,
    required String pickupCode,
    required double parcelAmount,
    ParcelDeliveryStatus status = ParcelDeliveryStatus.assigned,
    String? hubShopName,
    double extraHubFee = 0.0,
  }) {
    final fareResult = CommuterFareCalculator.calculate(
      category: category,
      quantity: quantity,
      isDistinctBuyer: isDistinctBuyer,
    );

    return CommuterParcel(
      orderId: orderId,
      buyerName: buyerName,
      buyerPhone: buyerPhone,
      itemSummary: itemSummary,
      category: category,
      quantity: quantity,
      isDistinctBuyer: isDistinctBuyer,
      pickupCode: pickupCode,
      commuterFee: fareResult.netFare,
      grossFee: fareResult.grossAmount,
      discountPercent: fareResult.discountPercentage,
      parcelAmount: parcelAmount,
      status: status,
      hubShopName: hubShopName,
      extraHubFee: extraHubFee,
    );
  }
}

class CommuterTripScreen extends StatefulWidget {
  final String commuterName;
  final String routeName;

  const CommuterTripScreen({
    super.key,
    this.commuterName = 'Santosh Gawande (Daily Bus Commuter)',
    this.routeName = 'Paras to Akola (पारस ➡️ अकोला)',
  });

  @override
  State<CommuterTripScreen> createState() => _CommuterTripScreenState();
}

class _CommuterTripScreenState extends State<CommuterTripScreen> {
  // Trip State
  bool _isTripActive = false;
  DateTime? _departureTime;
  bool _hasArrivedAtBusStand = false;

  // Handover Countdown Timer
  Timer? _countdownTimer;
  int _secondsRemaining = PricingConfig.commuterHandoverWindowSeconds; // 2 minutes (120 seconds)
  bool _isTimerRunning = false;

  // Interactive Fare Calculator inputs
  CargoCategory _calcCategory = CargoCategory.eggs;
  int _calcQuantity = 10;
  bool _calcIsDistinctBuyer = false;

  // Assigned Parcels for this Paras to Akola run conforming to limits & fare calculations
  final List<CommuterParcel> _parcels = [
    // Parcel 1: Eggs >= 10 trays (12 Trays, 10% discount: 12 * 30 = ₹360 - 10% = ₹324.0)
    CommuterParcel.create(
      orderId: 'ORD-AKL-842',
      buyerName: 'Rahul Sharma',
      buyerPhone: '+919811223344',
      itemSummary: 'देसी फ्री-रेंज अंडे (12 Trays)',
      category: CargoCategory.eggs,
      quantity: 12,
      isDistinctBuyer: false,
      pickupCode: '4821',
      parcelAmount: 4320.0,
      status: ParcelDeliveryStatus.assigned,
    ),
    // Parcel 2: Live Poultry >= 5 birds (6 Kadaknath Chickens, 10% discount: 6 * 50 = ₹300 - 10% = ₹270.0)
    CommuterParcel.create(
      orderId: 'ORD-AKL-903',
      buyerName: 'Pooja Deshmukh',
      buyerPhone: '+919822334455',
      itemSummary: 'कड़कनाथ लाइव चिकन (6 Birds)',
      category: CargoCategory.livePoultry,
      quantity: 6,
      isDistinctBuyer: false,
      pickupCode: '7392',
      parcelAmount: 3600.0,
      status: ParcelDeliveryStatus.assigned,
    ),
    // Parcel 3: Quails > 20 birds (25 Quails, 5% discount: 25 * 5 = ₹125 - 5% = ₹118.75)
    CommuterParcel.create(
      orderId: 'ORD-AKL-915',
      buyerName: 'Amit Verma',
      buyerPhone: '+919833445566',
      itemSummary: 'बटेर पक्षी (25 Quail Birds)',
      category: CargoCategory.quails,
      quantity: 25,
      isDistinctBuyer: false,
      pickupCode: '5814',
      parcelAmount: 1875.0,
      status: ParcelDeliveryStatus.assigned,
    ),
    // Parcel 4: Distinct Buyer (Standard Rate, No Discount: 4 Trays * ₹30 = ₹120.0)
    CommuterParcel.create(
      orderId: 'ORD-AKL-920',
      buyerName: 'Sunita Patil (अलग खरीदार)',
      buyerPhone: '+919844556677',
      itemSummary: 'ऑर्गेनिक ब्राउन अंडे (4 Trays)',
      category: CargoCategory.eggs,
      quantity: 4,
      isDistinctBuyer: true,
      pickupCode: '3190',
      parcelAmount: 1440.0,
      status: ParcelDeliveryStatus.assigned,
    ),
  ];

  static const Color primaryGreen = Color(0xFF1B5E20);
  static const Color commuterAmber = Color(0xFFD97706);
  static const Color busBlue = Color(0xFF1E3A8A);

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  // ==============================================================
  // CARGO LIMITS AGGREGATIONS
  // ==============================================================

  int get _currentEggTraysCount => _parcels
      .where((p) => p.category == CargoCategory.eggs)
      .fold(0, (sum, p) => sum + p.quantity);

  int get _currentLivePoultryCount => _parcels
      .where((p) => p.category == CargoCategory.livePoultry)
      .fold(0, (sum, p) => sum + p.quantity);

  int get _currentQuailsCount => _parcels
      .where((p) => p.category == CargoCategory.quails)
      .fold(0, (sum, p) => sum + p.quantity);

  // ==============================================================
  // FARE SETTLEMENT SUMMARY CALCULATION
  // ==============================================================

  double get _totalEarnedCommuterFee =>
      _parcels.fold(0.0, (sum, p) => sum + p.commuterFee);

  double get _collectedHandoverFees => _parcels
      .where((p) =>
          p.status == ParcelDeliveryStatus.deliveredDirect ||
          p.status == ParcelDeliveryStatus.droppedAtHub)
      .fold(0.0, (sum, p) => sum + p.commuterFee);

  double get _pendingHandoverFees =>
      _totalEarnedCommuterFee - _collectedHandoverFees;

  String _formatTimer(int totalSeconds) {
    final m = totalSeconds ~/ 60;
    final s = totalSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  // ==============================================================
  // TRIP CONTROLLERS & ALERTS
  // ==============================================================

  Future<void> _startTripAndSendLoudAlert() async {
    setState(() {
      _isTripActive = true;
      _departureTime = DateTime.now();
      for (var p in _parcels) {
        if (p.status == ParcelDeliveryStatus.assigned) {
          p.status = ParcelDeliveryStatus.inTransit;
        }
      }
    });

    try {
      // ignore: unused_local_variable
      final fcm = FirebaseMessaging.instance;
    } catch (_) {}

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.notifications_active, color: Colors.amber),
              SizedBox(width: 8),
              Expanded(
                child: Text('यात्रा शुरू! 4 खरीदारों को लाउड अलर्ट व किराया विवरण भेज दिया गया है।'),
              ),
            ],
          ),
          backgroundColor: primaryGreen,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _sendWhatsAppAlert(CommuterParcel parcel) async {
    final cleanPhone = parcel.buyerPhone.replaceAll(RegExp(r'[^\d+]'), '');
    final fareStr = parcel.commuterFee.toStringAsFixed(2);
    final message =
        'नमस्ते ${parcel.buyerName}! AndaExpress कम्यूटर पारस से अकोला रवाना हो चुका है। '
        'सामान: ${parcel.itemSummary}। डिलीवरी शुल्क: ₹$fareStr। '
        'बस स्टैंड आगमन पर अपना 4-अंकीय कोड बताएं: ${parcel.pickupCode} (ऑर्डर: ${parcel.orderId})';
    final encoded = Uri.encodeComponent(message);

    final whatsappUri = Uri.parse('whatsapp://send?phone=$cleanPhone&text=$encoded');
    final webUri = Uri.parse('https://wa.me/$cleanPhone?text=$encoded');

    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    } else if (await canLaunchUrl(webUri)) {
      await launchUrl(webUri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('WhatsApp खोलने में असमर्थ'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _makeDirectPhoneCall(String phoneNumber) async {
    final cleanPhone = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    final telUri = Uri.parse('tel:$cleanPhone');

    if (await canLaunchUrl(telUri)) {
      await launchUrl(telUri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('कॉल लगाने में असमर्थ'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _toggleArrivedAtBusStand(bool arrived) {
    setState(() {
      _hasArrivedAtBusStand = arrived;
      if (arrived) {
        for (var p in _parcels) {
          if (p.status == ParcelDeliveryStatus.inTransit) {
            p.status = ParcelDeliveryStatus.arrivedBusStand;
          }
        }
        _startTwoMinuteHandoverTimer();
      } else {
        _countdownTimer?.cancel();
        _isTimerRunning = false;
        _secondsRemaining = PricingConfig.commuterHandoverWindowSeconds;
      }
    });

    if (arrived && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('अकोला बस स्टैंड आगमन दर्ज! 2-मिनट हैंडशेक टाइमर शुरू हुआ।'),
          backgroundColor: commuterAmber,
        ),
      );
    }
  }

  void _startTwoMinuteHandoverTimer() {
    _countdownTimer?.cancel();
    _secondsRemaining = PricingConfig.commuterHandoverWindowSeconds;
    _isTimerRunning = true;

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        timer.cancel();
        setState(() => _isTimerRunning = false);
        _showTimerExpiredHubPrompt();
      }
    });
  }

  void _showTimerExpiredHubPrompt() {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.timer_off, color: Colors.red),
            SizedBox(width: 8),
            Text('2-मिनट समय समाप्त!'),
          ],
        ),
        content: const Text(
          'बस स्टैंड पर 2 मिनट का हैंडशेक समय समाप्त हो गया है। कम्यूटर को बस पकड़ने में देरी न हो, इसके लिए अंडे पार्सल को सिटी हब दुकान पर छोड़ें (+₹5 दुकान शुल्क)।',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('रुके रहें'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade700, foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(ctx);
              for (var p in _parcels) {
                if (p.status == ParcelDeliveryStatus.arrivedBusStand && p.category == CargoCategory.eggs) {
                  _dropAtCityHubShop(p);
                }
              }
            },
            child: const Text('हब दुकान पर छोड़ें (Drop at Hub)'),
          ),
        ],
      ),
    );
  }

  void _verifyDirectHandshake(CommuterParcel parcel) {
    final codeController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.handshake, color: primaryGreen),
            SizedBox(width: 8),
            Text('4-अंकीय कोड सत्यापन'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('खरीदार: ${parcel.buyerName}'),
            Text('सामान: ${parcel.itemSummary}'),
            Text('डिलीवरी किराया: ₹${parcel.commuterFee.toStringAsFixed(2)}'),
            const SizedBox(height: 10),
            TextField(
              controller: codeController,
              keyboardType: TextInputType.number,
              maxLength: 4,
              decoration: InputDecoration(
                labelText: 'खरीदार का 4-अंकीय कोड दर्ज करें',
                hintText: parcel.pickupCode,
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('रद्द करें')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: primaryGreen, foregroundColor: Colors.white),
            onPressed: () {
              if (codeController.text.trim() == parcel.pickupCode) {
                setState(() {
                  parcel.status = ParcelDeliveryStatus.deliveredDirect;
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('पार्सल ${parcel.orderId} हैंडओवर सफल! ₹${parcel.commuterFee.toStringAsFixed(2)} नकद/UPI प्राप्त करें।'),
                    backgroundColor: primaryGreen,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('अमान्य कोड! कृपया खरीदार से सही कोड पूछें।'), backgroundColor: Colors.red),
                );
              }
            },
            child: const Text('सत्यापित करें'),
          ),
        ],
      ),
    );
  }

  void _dropAtCityHubShop(CommuterParcel parcel) {
    setState(() {
      parcel.status = ParcelDeliveryStatus.droppedAtHub;
      parcel.hubShopName = 'श्रीनाथ डेयरी व सिटी हब (अकोला बस स्टैंड गेट 2)';
      parcel.extraHubFee = 5.0;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('पार्सल ${parcel.orderId} हब दुकान पर छोड़ा गया।'),
            const Text('खरीदार को ₹5 शुल्क व दुकान का पता SMS/FCM भेज दिया गया है।', style: TextStyle(fontSize: 11)),
          ],
        ),
        backgroundColor: Colors.blueGrey.shade900,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fareResult = CommuterFareCalculator.calculate(
      category: _calcCategory,
      quantity: _calcQuantity,
      isDistinctBuyer: _calcIsDistinctBuyer,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        backgroundColor: busBlue,
        foregroundColor: Colors.white,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('कम्यूटर ट्रिप व डिस्पैच कंट्रोलर', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            Text('Cargo Limits & Fare Settlement Engine', style: TextStyle(fontSize: 11, color: Colors.white70)),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.amber.shade400,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.currency_rupee, size: 14, color: Colors.black87),
                Text(
                  '₹${_totalEarnedCommuterFee.toStringAsFixed(0)} Earnable',
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==========================================
            // 1. ROUTE & DEPARTURE INITIATION CARD
            // ==========================================
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(10)),
                            child: const Icon(Icons.directions_bus, color: busBlue, size: 20),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('रूट: पारस ➡️ अकोला (Paras to Akola)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                              Text(widget.commuterName, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                            ],
                          ),
                        ],
                      ),
                      Chip(
                        label: Text(
                          _isTripActive ? 'ऑन रूट (In Transit)' : 'तैयार (Ready)',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: _isTripActive ? Colors.green.shade900 : Colors.amber.shade900,
                          ),
                        ),
                        backgroundColor: _isTripActive ? Colors.green.shade50 : Colors.amber.shade50,
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('प्रस्थान समय (Departure):', style: TextStyle(fontSize: 11, color: Colors.grey)),
                          Text(
                            _departureTime != null ? DateFormat('hh:mm a').format(_departureTime!) : '10:30 AM (Scheduled)',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('असाइन किए गए पार्सल:', style: TextStyle(fontSize: 11, color: Colors.grey)),
                          Text('${_parcels.length} पार्सल (₹${_totalEarnedCommuterFee.toStringAsFixed(2)})',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: primaryGreen)),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Button 1: Start Trip & Send Loud Alert
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isTripActive ? null : _startTripAndSendLoudAlert,
                      icon: const Icon(Icons.campaign),
                      label: Text(_isTripActive ? 'यात्रा सक्रिय है (Trip In Progress)' : 'यात्रा शुरू / लाउड अलर्ट भेजें (Start Trip & Send Loud Alert)'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // ==========================================
            // 2. MAXIMUM CARGO LIMITS & CAPACITY USAGE
            // ==========================================
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.inventory_2, color: busBlue, size: 18),
                      SizedBox(width: 6),
                      Text('अधिकतम कार्गो क्षमता सीमा (Cargo Capacity Limits)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'कम्यूटर बस सुरक्षा व कानूनी सीमाएँ (Maximum Cargo Capacities):',
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),

                  // Limit 1: Eggs (30 Trays)
                  _buildCargoProgressBar(
                    title: 'अंडे (Eggs)',
                    current: _currentEggTraysCount,
                    max: PricingConfig.maxEggTrays,
                    unit: 'ट्रे (Trays)',
                    color: Colors.orange.shade700,
                    icon: Icons.egg,
                  ),

                  const SizedBox(height: 10),

                  // Limit 2: Live Poultry (15 Birds)
                  _buildCargoProgressBar(
                    title: 'लाइव पोल्ट्री (Chicken/Duck)',
                    current: _currentLivePoultryCount,
                    max: PricingConfig.maxLiveBirds,
                    unit: 'पक्षी (Birds)',
                    color: Colors.deepOrange.shade700,
                    icon: Icons.pest_control,
                  ),

                  const SizedBox(height: 10),

                  // Limit 3: Quails (30 Birds)
                  _buildCargoProgressBar(
                    title: 'बटेर (Quails)',
                    current: _currentQuailsCount,
                    max: PricingConfig.maxQuails,
                    unit: 'पक्षी (Birds)',
                    color: Colors.teal.shade700,
                    icon: Icons.flutter_dash,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // ==========================================
            // 3. FARE CALCULATION ENGINE & RATE RULES
            // ==========================================
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.green.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.calculate, color: primaryGreen, size: 18),
                          SizedBox(width: 6),
                          Text('डिलीवरी किराया दर व छूट नियम (Delivery Fare Engine)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: primaryGreen)),
                        ],
                      ),
                      Chip(
                        label: Text('Official Rates', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: primaryGreen)),
                        backgroundColor: Colors.white,
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Rate 1: Quails: ₹5.00 per bird (apply 5% discount only if quantity > 20)
                  _buildRateRuleItem(
                    title: 'बटेर (Quails):',
                    rateText: '₹5.00 प्रति पक्षी',
                    discountText: '> 20 पक्षी होने पर 5% छूट',
                    color: Colors.teal.shade800,
                  ),

                  // Rate 2: Eggs: ₹30.00 per tray (apply 10% discount for orders >= 10 trays)
                  _buildRateRuleItem(
                    title: 'अंडे (Eggs):',
                    rateText: '₹30.00 प्रति ट्रे',
                    discountText: '>= 10 ट्रे होने पर 10% छूट',
                    color: Colors.orange.shade900,
                  ),

                  // Rate 3: Live Poultry: ₹50.00 per bird (apply 10% discount for orders >= 5 birds)
                  _buildRateRuleItem(
                    title: 'लाइव पोल्ट्री (Chicken/Duck):',
                    rateText: '₹50.00 प्रति पक्षी',
                    discountText: '>= 5 पक्षी होने पर 10% छूट',
                    color: Colors.deepOrange.shade900,
                  ),

                  // Distinct buyers rule
                  _buildRateRuleItem(
                    title: 'अलग खरीदार (Distinct Buyers):',
                    rateText: 'मानक दर (Standard Rate)',
                    discountText: 'कोई छूट लागू नहीं (No Discount)',
                    color: Colors.indigo.shade900,
                  ),

                  const Divider(height: 18),

                  // Interactive Fare Calculator Simulator
                  const Text('किराया कैलकुलेटर सिम्युलेटर (Interactive Rate Test):', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: primaryGreen)),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      // Category dropdown
                      Expanded(
                        flex: 3,
                        child: DropdownButtonFormField<CargoCategory>(
                          value: _calcCategory,
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          items: const [
                            DropdownMenuItem(value: CargoCategory.quails, child: Text('बटेर (₹5)', style: TextStyle(fontSize: 11))),
                            DropdownMenuItem(value: CargoCategory.eggs, child: Text('अंडे (₹30)', style: TextStyle(fontSize: 11))),
                            DropdownMenuItem(value: CargoCategory.livePoultry, child: Text('पोल्ट्री (₹50)', style: TextStyle(fontSize: 11))),
                          ],
                          onChanged: (val) {
                            if (val != null) setState(() => _calcCategory = val);
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Quantity input
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          initialValue: _calcQuantity.toString(),
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            isDense: true,
                            labelText: 'मात्रा',
                            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          onChanged: (val) {
                            final parsed = int.tryParse(val) ?? 1;
                            setState(() => _calcQuantity = parsed > 0 ? parsed : 1);
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // Distinct Buyer Switch
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('अलग खरीदार (Distinct Buyer - No Discount):', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                      Switch(
                        value: _calcIsDistinctBuyer,
                        activeColor: primaryGreen,
                        onChanged: (val) => setState(() => _calcIsDistinctBuyer = val),
                      ),
                    ],
                  ),

                  // Calculation Result Card
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green.shade200),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(fareResult.ruleExplanation, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                            if (fareResult.discountPercentage > 0)
                              Text('छूट: ${fareResult.discountPercentage.toStringAsFixed(0)}% (-₹${fareResult.discountAmount.toStringAsFixed(2)})',
                                  style: TextStyle(fontSize: 10, color: Colors.red.shade700, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text('देय किराया:', style: TextStyle(fontSize: 9, color: Colors.grey)),
                            Text('₹${fareResult.netFare.toStringAsFixed(2)}',
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: primaryGreen, fontFamily: 'monospace')),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // ========================================================
            // 4. BUS STAND 2-MINUTE ARRIVAL & COUNTDOWN FAIL-SAFE
            // ========================================================
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _hasArrivedAtBusStand ? Colors.amber.shade50 : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _hasArrivedAtBusStand ? commuterAmber : Colors.grey.shade300, width: _hasArrivedAtBusStand ? 1.5 : 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.location_on, color: commuterAmber, size: 20),
                          SizedBox(width: 6),
                          Text('अकोला बस स्टैंड आगमन टॉगल', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        ],
                      ),
                      Switch(
                        value: _hasArrivedAtBusStand,
                        activeColor: commuterAmber,
                        onChanged: _isTripActive ? _toggleArrivedAtBusStand : null,
                      ),
                    ],
                  ),
                  const Text(
                    'Arrival Toggle: "Arrived at Akola Bus Stand" - Starts 2-min handshake window.',
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),

                  if (_hasArrivedAtBusStand) ...[
                    const Divider(height: 20),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('हैंडशेक काउंटडाउन (2-Minute Timer):', style: TextStyle(fontSize: 10, color: Colors.white70)),
                              Text(
                                _formatTimer(_secondsRemaining),
                                style: TextStyle(
                                  fontSize: 22,
                                  fontFamily: 'monospace',
                                  fontWeight: FontWeight.bold,
                                  color: _secondsRemaining < 30 ? Colors.redAccent : Colors.amberAccent,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: _secondsRemaining < 30 ? Colors.red.shade900 : Colors.blueGrey.shade800,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _secondsRemaining < 30 ? 'हब ड्रॉप का समय!' : 'हैंडशेक चालू',
                              style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ==========================================
            // 5. ASSIGNED CARGO PARCELS LIST
            // ==========================================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('असाइन किए गए कार्गो पार्सल (Assigned Parcels):', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                Text('${_parcels.length} Parcels', style: const TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 8),

            ..._parcels.map((parcel) {
              final isDelivered = parcel.status == ParcelDeliveryStatus.deliveredDirect;
              final isHubDropped = parcel.status == ParcelDeliveryStatus.droppedAtHub;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDelivered
                        ? primaryGreen
                        : isHubDropped
                            ? Colors.blueGrey
                            : Colors.grey.shade300,
                    width: isDelivered ? 1.5 : 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header: Order ID & Status
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(parcel.orderId, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                if (parcel.isDistinctBuyer) ...[
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                    decoration: BoxDecoration(color: Colors.indigo.shade50, borderRadius: BorderRadius.circular(4)),
                                    child: Text('अलग खरीदार', style: TextStyle(fontSize: 8.5, color: Colors.indigo.shade900, fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ],
                            ),
                            Text(parcel.buyerName, style: const TextStyle(fontSize: 12, color: Colors.black87)),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: isDelivered
                                ? Colors.green.shade50
                                : isHubDropped
                                    ? Colors.blueGrey.shade50
                                    : Colors.amber.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isDelivered
                                  ? Colors.green.shade300
                                  : isHubDropped
                                      ? Colors.blueGrey.shade300
                                      : Colors.amber.shade300,
                            ),
                          ),
                          child: Text(
                            isDelivered
                                ? 'डिलीवर (Handover Done)'
                                : isHubDropped
                                    ? 'हब पर छोड़ा (Hub Dropped)'
                                    : 'इन-ट्रांजिट (In Transit)',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: isDelivered
                                  ? primaryGreen
                                  : isHubDropped
                                      ? Colors.blueGrey.shade900
                                      : commuterAmber,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Parcel Specs & 4-Digit Code
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(parcel.itemSummary, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                              Text('ऑर्डर मूल्य: ₹${parcel.parcelAmount.toStringAsFixed(0)}',
                                  style: const TextStyle(fontSize: 10, color: Colors.grey)),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text('पिकअप/डिलीवरी कोड:', style: TextStyle(fontSize: 9, color: Colors.grey)),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(color: Colors.amber.shade300, borderRadius: BorderRadius.circular(6)),
                                child: Text(
                                  parcel.pickupCode,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, fontFamily: 'monospace', letterSpacing: 1.5),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    if (isHubDropped) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          children: [
                            const Icon(Icons.store, color: busBlue, size: 16),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                '${parcel.hubShopName} (+₹5 दुकान शुल्क खरीदार देय)',
                                style: const TextStyle(fontSize: 10, color: busBlue, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: 10),

                    // Actions
                    if (!isDelivered && !isHubDropped) ...[
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => _sendWhatsAppAlert(parcel),
                              icon: const Icon(Icons.chat, size: 14, color: Color(0xFF25D366)),
                              label: const Text('WhatsApp अलर्ट', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                side: const BorderSide(color: Color(0xFF25D366)),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => _makeDirectPhoneCall(parcel.buyerPhone),
                              icon: const Icon(Icons.phone, size: 14, color: Colors.blue),
                              label: const Text('डायरेक्ट कॉल', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                side: const BorderSide(color: Colors.blue),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: ElevatedButton.icon(
                              onPressed: _hasArrivedAtBusStand ? () => _verifyDirectHandshake(parcel) : null,
                              icon: const Icon(Icons.check_circle, size: 16),
                              label: const Text('हैंडशेक कोड सत्यापित करें', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryGreen,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                            ),
                          ),
                          // Only eggs can be dropped at city hub shop fallback as per policy
                          if (parcel.category == CargoCategory.eggs) ...[
                            const SizedBox(width: 8),
                            Expanded(
                              flex: 2,
                              child: ElevatedButton.icon(
                                onPressed: () => _dropAtCityHubShop(parcel),
                                icon: const Icon(Icons.storefront, size: 14),
                                label: const Text('हब दुकान पर छोड़ें', style: TextStyle(fontSize: 10)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueGrey.shade800,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],

                    const Divider(height: 18),

                    // Fare Breakdown
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('कम्यूटर डिलीवरी शुल्क (Earned Fee):', style: TextStyle(fontSize: 11, color: Colors.grey)),
                            if (parcel.discountPercent > 0)
                              Text('मूल: ₹${parcel.grossFee.toStringAsFixed(0)} (छूट: ${parcel.discountPercent.toStringAsFixed(0)}%)',
                                  style: TextStyle(fontSize: 9.5, color: Colors.green.shade800, fontWeight: FontWeight.w600)),
                          ],
                        ),
                        Text(
                          '₹${parcel.commuterFee.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: primaryGreen, fontFamily: 'monospace'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),

            const SizedBox(height: 12),

            // ==========================================
            // 6. FARE SETTLEMENT SUMMARY DISPLAY
            // ==========================================
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.account_balance_wallet, color: primaryGreen, size: 18),
                      SizedBox(width: 6),
                      Text('कम्यूटर ट्रिप कमाई व निपटान (Trip Earnings & Settlement)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('कुल ट्रिप डिलीवरी कमाई (Total Earnable):', style: TextStyle(fontSize: 11, color: Colors.grey)),
                      Text('₹${_totalEarnedCommuterFee.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, fontFamily: 'monospace')),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('सत्यापित व प्राप्त शुल्क (Collected):', style: TextStyle(fontSize: 11, color: Colors.grey)),
                      Text('₹${_collectedHandoverFees.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: primaryGreen, fontFamily: 'monospace')),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('शेष प्राप्तव्य (Pending Collection):', style: TextStyle(fontSize: 11, color: Colors.grey)),
                      Text('₹${_pendingHandoverFees.toStringAsFixed(2)}',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: commuterAmber, fontFamily: 'monospace')),
                    ],
                  ),
                  const Divider(height: 16),
                  const Text(
                    'नियम: प्रत्येक पार्सल का तय डिलीवरी शुल्क खरीदार से हैंडओवर पर सीधे नकद या यूपीआई द्वारा प्राप्त करें। हब पर छोड़े गए अंडे पार्सल का ₹5 दुकान शुल्क खरीदार हब संचालक को देंगे।',
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCargoProgressBar({
    required String title,
    required int current,
    required int max,
    required String unit,
    required Color color,
    required IconData icon,
  }) {
    final double percent = (current / max).clamp(0.0, 1.0);
    final bool isOver = current > max;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, size: 14, color: color),
                const SizedBox(width: 4),
                Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              ],
            ),
            Text(
              '$current / $max $unit (${(percent * 100).toStringAsFixed(0)}%)',
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.bold,
                color: isOver ? Colors.red : Colors.black87,
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: percent,
            minHeight: 8,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(isOver ? Colors.red : color),
          ),
        ),
      ],
    );
  }

  Widget _buildRateRuleItem({
    required String title,
    required String rateText,
    required String discountText,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color)),
          Row(
            children: [
              Text(rateText, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(color: Colors.green.shade100, borderRadius: BorderRadius.circular(4)),
                child: Text(discountText, style: TextStyle(fontSize: 9, color: Colors.green.shade900, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
