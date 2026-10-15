import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../config/pricing_config.dart';

/// Commuter Dispute Entity for Admin Resolution Desk
class CommuterDisputeItem {
  final String disputeId;
  final String orderId;
  final String commuterName;
  final String commuterPhone;
  final String farmerName;
  final String farmerUid;
  final double fareAmount;
  final double hoursElapsed;
  final String itemSummary;
  final String route;
  final String handshakeOtp;
  String status; // 'pending_escrow_deduction' or 'escrow_settled'
  String? settledAt;
  String? txnId;

  CommuterDisputeItem({
    required this.disputeId,
    required this.orderId,
    required this.commuterName,
    required this.commuterPhone,
    required this.farmerName,
    required this.farmerUid,
    required this.fareAmount,
    required this.hoursElapsed,
    required this.itemSummary,
    required this.route,
    required this.handshakeOtp,
    this.status = 'pending_escrow_deduction',
    this.settledAt,
    this.txnId,
  });
}

/// Anti-Fraud Shipment Entity for Live Poultry Specimen Audit
class AntiFraudShipmentItem {
  final String tagNumber;
  final String batchId;
  final String orderId;
  final String breed;
  final int birdsCount;
  final String scaleWeightPerBird;
  final String totalWeight;
  final String gpsWatermark;
  final String legSealNumber;
  final String photoProofUrl;
  final String scalePhotoUrl;
  String status; // 'verified', 'audit_cleared', 'flagged'
  final String remarks;

  AntiFraudShipmentItem({
    required this.tagNumber,
    required this.batchId,
    required this.orderId,
    required this.breed,
    required this.birdsCount,
    required this.scaleWeightPerBird,
    required this.totalWeight,
    required this.gpsWatermark,
    required this.legSealNumber,
    required this.photoProofUrl,
    required this.scalePhotoUrl,
    this.status = 'verified',
    required this.remarks,
  });
}

/// Web Admin Control Panel for AndaExpress
/// Modules:
/// A. Commuter Fare & Dispute Resolution Desk (12h Auto-Escrow)
/// B. Dynamic Pricing & Slab Controller
/// C. Anti-Fraud Audit Log (Scale weights, Leg-seals, GPS watermarks)
class AdminControlPanelScreen extends StatefulWidget {
  final Function(double newEggFare, double newPoultryFare, double newQuailFare)? onPricingUpdated;
  final Function(String disputeId, double amount)? onEscrowDeducted;

  const AdminControlPanelScreen({
    super.key,
    this.onPricingUpdated,
    this.onEscrowDeducted,
  });

  @override
  State<AdminControlPanelScreen> createState() => _AdminControlPanelScreenState();
}

class _AdminControlPanelScreenState extends State<AdminControlPanelScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Farmer Prepaid Balance Pool
  double _farmerWalletBalance = 1250.0;

  // Dynamic Pricing State (linked to pricing_config)
  double _eggBaseFare = PricingConfig.freshEggTrayFare; // 30.0
  double _liveBirdFare = PricingConfig.liveBirdFare; // 50.0
  double _quailFare = PricingConfig.quailFare; // 5.0
  double _tier1EggRate = PricingConfig.eggTier1PerEgg; // 1.00
  double _tier2EggRate = PricingConfig.eggTier2PerEgg; // 0.50
  double _tier3EggRate = PricingConfig.eggTier3PerEgg; // 0.15

  // Module A: Commuter Delivery Disputes (Unpaid past 12 hours)
  late List<CommuterDisputeItem> _disputes;

  // Module C: Anti-Fraud Live Poultry Shipments
  late List<AntiFraudShipmentItem> _shipments;

  // Escrow Audit Ledger
  final List<Map<String, dynamic>> _escrowLedger = [];

  static const Color primaryGreen = Color(0xFF1B5E20);
  static const Color amberAccent = Color(0xFFD97706);
  static const Color darkSlate = Color(0xFF0F172A);
  static const Color cardBg = Colors.white;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    _disputes = [
      CommuterDisputeItem(
        disputeId: 'DISP-COMM-842',
        orderId: 'ORD-AKL-842',
        commuterName: 'Santosh Gawande (संतोष गावंडे)',
        commuterPhone: '+91 94221 88301',
        farmerName: 'Chhabra Organic Poultry Farms',
        farmerUid: 'usr_seller_chhabra',
        fareAmount: 324.0, // 12 trays @ ₹30 - 10% discount
        hoursElapsed: 14.5, // > 12 hours statutory window
        itemSummary: 'देसी फ्री-रेंज अंडे (12 Trays • 360 eggs)',
        route: 'Paras Depot ➡️ Akola Bus Stand (Gate 1)',
        handshakeOtp: '4821',
        status: 'pending_escrow_deduction',
      ),
      CommuterDisputeItem(
        disputeId: 'DISP-COMM-903',
        orderId: 'ORD-AKL-903',
        commuterName: 'Ganesh Rathod (गणेश राठौड़)',
        commuterPhone: '+91 98220 11922',
        farmerName: 'Punjab Pure Desi Fowls',
        farmerUid: 'usr_seller_punjab',
        fareAmount: 270.0, // 6 live birds @ ₹50 - 10% discount
        hoursElapsed: 16.2, // > 12 hours statutory window
        itemSummary: 'कड़कनाथ लाइव चिकन (6 Birds • Tag #AND-9102)',
        route: 'Paras Depot ➡️ Akola Stand (Gate 2)',
        handshakeOtp: '7392',
        status: 'pending_escrow_deduction',
      ),
      CommuterDisputeItem(
        disputeId: 'DISP-COMM-709',
        orderId: 'ORD-AKL-709',
        commuterName: 'Kailash Tayade (कैलाश तायडे)',
        commuterPhone: '+91 97654 33211',
        farmerName: 'Chhabra Organic Poultry Farms',
        farmerUid: 'usr_seller_chhabra',
        fareAmount: 118.75, // 25 quails @ ₹5 - 5% discount
        hoursElapsed: 13.0, // > 12 hours statutory window
        itemSummary: 'बटेर पक्षी (25 Quail Birds • Tag #AND-7320)',
        route: 'Paras Depot ➡️ Akola City Hub',
        handshakeOtp: '5814',
        status: 'pending_escrow_deduction',
      ),
    ];

    _shipments = [
      AntiFraudShipmentItem(
        tagNumber: 'AND-9102',
        batchId: '#BATCH-AKL-9102',
        orderId: 'ORD-AKL-903',
        breed: 'शुद्ध कड़कनाथ (Pure Kadaknath)',
        birdsCount: 6,
        scaleWeightPerBird: '1.65 kg / bird (Certified DigiScale #DS-42)',
        totalWeight: '9.90 kg Net Weight',
        gpsWatermark: 'LAT: 20.7002° N | LON: 77.0082° E • Paras Depot',
        legSealNumber: 'SEAL-MH-30-7492',
        photoProofUrl: 'https://images.unsplash.com/photo-1548550023-2bdb3c5beed7?auto=format&fit=crop&w=600&q=80',
        scalePhotoUrl: 'https://images.unsplash.com/photo-1582722872445-44dc5f7e3c8f?auto=format&fit=crop&w=600&q=80',
        status: 'verified',
        remarks: 'Numbered tamper-evident leg seals intact. Certified scale watermark confirms 1.65kg avg.',
      ),
      AntiFraudShipmentItem(
        tagNumber: 'AND-8419',
        batchId: '#BATCH-AKL-8419',
        orderId: 'ORD-LIV-8419',
        breed: 'देसी फ्री-रेंज असील (Aseel Country Fowl)',
        birdsCount: 12,
        scaleWeightPerBird: '2.10 kg / bird (Certified DigiScale #DS-18)',
        totalWeight: '25.20 kg Net Weight',
        gpsWatermark: 'LAT: 20.7015° N | LON: 77.0094° E • Paras Farm',
        legSealNumber: 'SEAL-MH-30-8419',
        photoProofUrl: 'https://images.unsplash.com/photo-1516467508483-a7212febe31a?auto=format&fit=crop&w=600&q=80',
        scalePhotoUrl: 'https://images.unsplash.com/photo-1582722872445-44dc5f7e3c8f?auto=format&fit=crop&w=600&q=80',
        status: 'verified',
        remarks: 'High-res scale photo matches digital ledger display. Anti-tamper seal validated.',
      ),
      AntiFraudShipmentItem(
        tagNumber: 'AND-7320',
        batchId: '#BATCH-AKL-7320',
        orderId: 'ORD-LIV-7320',
        breed: 'लाइव फार्म ब्रॉयलर (Commercial Live Broiler)',
        birdsCount: 25,
        scaleWeightPerBird: '1.80 kg / bird (Certified DigiScale #DS-09)',
        totalWeight: '45.00 kg Net Weight',
        gpsWatermark: 'LAT: 20.6998° N | LON: 77.0071° E • Paras Highway',
        legSealNumber: 'SEAL-MH-30-7320',
        photoProofUrl: 'https://images.unsplash.com/photo-1548550023-2bdb3c5beed7?auto=format&fit=crop&w=600&q=80',
        scalePhotoUrl: 'https://images.unsplash.com/photo-1582722872445-44dc5f7e3c8f?auto=format&fit=crop&w=600&q=80',
        status: 'audit_cleared',
        remarks: 'Commercial bulk dispatch. Leg seal chain validated at Akola Bus Stand checkpoint.',
      ),
    ];
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Action: Authorize Wallet Escrow Deduction
  void _authorizeWalletEscrowDeduction(CommuterDisputeItem dispute) {
    if (dispute.status == 'escrow_settled') return;

    setState(() {
      _farmerWalletBalance = (_farmerWalletBalance - dispute.fareAmount).clamp(0.0, double.infinity);
      final nowStr = DateFormat('hh:mm a, dd MMM').format(DateTime.now());
      final txnId = 'ESCROW-TXN-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

      dispute.status = 'escrow_settled';
      dispute.settledAt = nowStr;
      dispute.txnId = txnId;

      _escrowLedger.insert(0, {
        'txnId': txnId,
        'orderId': dispute.orderId,
        'disputeId': dispute.disputeId,
        'amount': dispute.fareAmount,
        'commuter': dispute.commuterName,
        'farmer': dispute.farmerName,
        'timestamp': nowStr,
      });
    });

    widget.onEscrowDeducted?.call(dispute.disputeId, dispute.fareAmount);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'एस्क्रो अधिकृत! ₹${dispute.fareAmount.toStringAsFixed(2)} किसान के वॉलेट से काटकर कम्यूटर ${dispute.commuterName} को क्रेडिट किए गए।',
        ),
        backgroundColor: primaryGreen,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  /// Action: Save Live Pricing & Slab Updates
  void _savePricingUpdates() {
    widget.onPricingUpdated?.call(_eggBaseFare, _liveBirdFare, _quailFare);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('डायनेमिक दरें व स्लैब सफलतापूर्वक सिंक हुए! मोबाइल दृश्य तुरंत अपडेट हो गए।'),
        backgroundColor: primaryGreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pendingCount = _disputes.where((d) => d.status == 'pending_escrow_deduction').length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: darkSlate,
        foregroundColor: Colors.white,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('वेब एडमिन कंट्रोल पैनल (Web Admin Control Panel)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            Text('Dispute Desk • Dynamic Pricing • Anti-Fraud Audit', style: TextStyle(fontSize: 10.5, color: Colors.amber)),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: primaryGreen.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.emerald.shade400),
            ),
            child: Row(
              children: [
                const Icon(Icons.account_balance_wallet, size: 14, color: Colors.amber),
                const SizedBox(width: 4),
                Text(
                  'वॉलेट: ₹${_farmerWalletBalance.toStringAsFixed(0)}',
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.amber,
          labelColor: Colors.amber,
          unselectedLabelColor: Colors.white70,
          labelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          tabs: [
            Tab(
              icon: const Icon(Icons.gavel, size: 16),
              text: 'A. विवाद डेस्क ${pendingCount > 0 ? "($pendingCount)" : ""}',
            ),
            const Tab(
              icon: Icon(Icons.tune, size: 16),
              text: 'B. दर व स्लैब कंट्रोलर',
            ),
            const Tab(
              icon: Icon(Icons.verified_user, size: 16),
              text: 'C. एंटी-फ्रॉड ऑडिट',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCommuterDisputeDeskTab(),
          _buildDynamicPricingControllerTab(),
          _buildAntiFraudAuditLogTab(),
        ],
      ),
    );
  }

  // =========================================================================
  // MODULE A: COMMUTER FARE & DISPUTE RESOLUTION DESK
  // =========================================================================
  Widget _buildCommuterDisputeDeskTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF3C7),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.shade400),
            ),
            child: const Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: Color(0xFF92400E), size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'कम्यूटर विवाद निवारण डेस्क: 12 घंटे की कानूनी सेटलमेंट विंडो समाप्त होने के बाद भी जिन कम्यूटरों का किराया बकाया है, एडमिन किसान के प्रीपेड वॉलेट से ऑटो-डिडक्शन अधिकृत कर सकता है।',
                    style: TextStyle(fontSize: 11, color: Color(0xFF78350F), height: 1.3),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _disputes.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final dispute = _disputes[index];
              final isPending = dispute.status == 'pending_escrow_deduction';

              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: isPending ? Colors.amber.shade400 : Colors.grey.shade300),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 4, offset: const Offset(0, 2)),
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
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(6)),
                              child: Text(dispute.disputeId, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
                            ),
                            const SizedBox(width: 6),
                            Text('Order: ${dispute.orderId}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: isPending ? Colors.red.shade50 : Colors.green.shade50,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: isPending ? Colors.red.shade300 : Colors.green.shade300),
                          ),
                          child: Text(
                            isPending ? '${dispute.hoursElapsed}h बीत गए (>12h उल्लंघन)' : 'एस्क्रो सेटल हुआ ✓',
                            style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.bold,
                              color: isPending ? Colors.red.shade900 : Colors.green.shade900,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Text(dispute.itemSummary, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Colors.black87)),
                    const SizedBox(height: 4),

                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('🚌 कम्यूटर: ${dispute.commuterName}', style: const TextStyle(fontSize: 10.5, color: Colors.blueGrey)),
                              Text(dispute.commuterPhone, style: const TextStyle(fontSize: 10.5, fontFamily: 'monospace')),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('🧑‍🌾 किसान: ${dispute.farmerName}', style: const TextStyle(fontSize: 10.5, color: Colors.blueGrey)),
                              Text('हैंडशेक OTP: #${dispute.handshakeOtp}', style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: primaryGreen)),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('बकाया कम्यूटर डिलीवरी किराया:', style: TextStyle(fontSize: 10, color: Colors.grey)),
                            Text('₹${dispute.fareAmount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: primaryGreen, fontFamily: 'monospace')),
                          ],
                        ),

                        if (isPending)
                          ElevatedButton.icon(
                            onPressed: () => _authorizeWalletEscrowDeduction(dispute),
                            icon: const Icon(Icons.shield, size: 14),
                            label: const Text('Authorize Wallet Escrow Deduction'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: amberAccent,
                              foregroundColor: Colors.white,
                              textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          )
                        else
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(8)),
                            child: Row(
                              children: [
                                const Icon(Icons.check_circle, color: primaryGreen, size: 14),
                                const SizedBox(width: 4),
                                Text('कम्यूटर क्रेडिटेड (${dispute.settledAt})', style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: primaryGreen)),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // MODULE B: DYNAMIC PRICING & SLAB CONTROLLER
  // =========================================================================
  Widget _buildDynamicPricingControllerTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.grey.shade300)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.directions_bus, color: Color(0xFF1E3A8A), size: 18),
                    SizedBox(width: 6),
                    Text('1. कम्यूटर डिलीवरी बेस किराया दरें (Paras ➡️ Akola)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5)),
                  ],
                ),
                const SizedBox(height: 10),

                // Egg Tray Base Fare (₹30)
                _buildPricingStepper(
                  title: '🥚 ताज़ा अंडे (Egg Tray Base Fare)',
                  formula: 'मानक ₹30 • >=10 ट्रे पर 10% छूट लागू',
                  value: _eggBaseFare,
                  unit: '/ tray',
                  onChanged: (val) => setState(() => _eggBaseFare = val),
                ),

                const Divider(height: 16),

                // Live Bird Base Fare (₹50)
                _buildPricingStepper(
                  title: '🐔 लाइव पोल्ट्री (Live Bird Base Fare)',
                  formula: 'मानक ₹50 • >=5 पक्षी पर 10% छूट लागू',
                  value: _liveBirdFare,
                  unit: '/ bird',
                  onChanged: (val) => setState(() => _liveBirdFare = val),
                ),

                const Divider(height: 16),

                // Quail Base Fare (₹5)
                _buildPricingStepper(
                  title: '🐦 बटेर पक्षी (Quail Base Fare)',
                  formula: 'मानक ₹5 • >20 पक्षी पर 5% छूट लागू',
                  value: _quailFare,
                  unit: '/ bird',
                  step: 0.5,
                  onChanged: (val) => setState(() => _quailFare = val),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Bulk Platform Fee Micro-Tiers
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.grey.shade300)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.layers, color: primaryGreen, size: 18),
                    SizedBox(width: 6),
                    Text('2. बल्क प्लेटफ़ॉर्म सुविधा शुल्क टियर (Eggs Micro-Tiers)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5)),
                  ],
                ),
                const SizedBox(height: 10),

                // Tier 1: 1-30 trays (₹1.00/egg)
                _buildTierCard(
                  title: 'Tier 1 (1 से 30 ट्रे / 1 - 900 अंडे)',
                  perEgg: _tier1EggRate,
                  perTray: _tier1EggRate * 30,
                  onRateChanged: (val) => setState(() => _tier1EggRate = val),
                ),

                const SizedBox(height: 8),

                // Tier 2: 31-50 trays (₹0.50/egg)
                _buildTierCard(
                  title: 'Tier 2 (31 से 50 ट्रे / 930 - 1500 अंडे)',
                  perEgg: _tier2EggRate,
                  perTray: _tier2EggRate * 30,
                  onRateChanged: (val) => setState(() => _tier2EggRate = val),
                ),

                const SizedBox(height: 8),

                // Tier 3: >50 trays (₹0.15/egg)
                _buildTierCard(
                  title: 'Bulk Tier 3 (> 50 ट्रे / 1500+ अंडे, Unlimited)',
                  perEgg: _tier3EggRate,
                  perTray: _tier3EggRate * 30,
                  onRateChanged: (val) => setState(() => _tier3EggRate = val),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _savePricingUpdates,
              icon: const Icon(Icons.sync),
              label: const Text('दरें सेव व मोबाइल ऐप में सिंक करें (Apply & Sync Live)'),
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
    );
  }

  Widget _buildPricingStepper({
    required String title,
    required String formula,
    required double value,
    required String unit,
    double step = 1.0,
    required Function(double) onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold)),
              Text(formula, style: const TextStyle(fontSize: 9.5, color: Colors.grey)),
            ],
          ),
        ),
        Row(
          children: [
            IconButton.filledTonal(
              icon: const Icon(Icons.remove, size: 14),
              onPressed: value > step ? () => onChanged(value - step) : null,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text('₹${value.toStringAsFixed(step < 1 ? 2 : 0)} $unit', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'monospace')),
            ),
            IconButton.filledTonal(
              icon: const Icon(Icons.add, size: 14),
              onPressed: () => onChanged(value + step),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTierCard({
    required String title,
    required double perEgg,
    required double perTray,
    required Function(double) onRateChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.grey.shade200)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                Text('प्रति ट्रे: ₹${perTray.toStringAsFixed(2)}', style: const TextStyle(fontSize: 9.5, color: Colors.blueGrey)),
              ],
            ),
          ),
          Row(
            children: [
              const Text('₹', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(
                width: 65,
                child: TextFormField(
                  initialValue: perEgg.toStringAsFixed(2),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.all(6), border: OutlineInputBorder()),
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, fontFamily: 'monospace'),
                  onChanged: (val) {
                    final parsed = double.tryParse(val);
                    if (parsed != null && parsed > 0) onRateChanged(parsed);
                  },
                ),
              ),
              const SizedBox(width: 4),
              const Text('/अंडा', style: TextStyle(fontSize: 10, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // MODULE C: ANTI-FRAUD AUDIT LOG
  // =========================================================================
  Widget _buildAntiFraudAuditLogTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade300)),
            child: const Row(
              children: [
                Icon(Icons.shield, color: Colors.redAccent, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'एंटी-फ्रॉड ऑडिट लॉग: लाइव पोल्ट्री शिपमेंट पर नंबर युक्त लेग-सील, प्रमाणित तराजू फोटो वाटरमार्क और जीपीएस टाइमस्टैम्प द्वारा पक्षियों की अदला-बदली रोकी जाती है।',
                    style: TextStyle(fontSize: 11, color: Colors.black87),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _shipments.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final ship = _shipments[index];
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade300),
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
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(color: Colors.amber.shade50, borderRadius: BorderRadius.circular(6)),
                              child: Text('Tag #${ship.tagNumber}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF92400E))),
                            ),
                            const SizedBox(width: 6),
                            Text(ship.batchId, style: const TextStyle(fontSize: 10.5, color: Colors.grey)),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: ship.status == 'verified' ? Colors.green.shade50 : Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            ship.status == 'verified' ? '✓ Verified OK' : 'Cleared',
                            style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: ship.status == 'verified' ? primaryGreen : Colors.blue.shade900),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),
                    Text('${ship.breed} • ${ship.birdsCount} पक्षी', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),

                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(8)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('⚖️ प्रमाणित तराजू वजन: ${ship.scaleWeightPerBird}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: primaryGreen)),
                              Text(ship.totalWeight, style: const TextStyle(fontSize: 10, color: Colors.blueGrey)),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text('🏷️ लेग-सील टैग: ${ship.legSealNumber}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.red)),
                          const SizedBox(height: 2),
                          Text('📍 GPS: ${ship.gpsWatermark}', style: const TextStyle(fontSize: 9.5, color: Colors.grey)),
                        ],
                      ),
                    ),

                    const SizedBox(height: 6),
                    Text(ship.remarks, style: const TextStyle(fontSize: 9.5, color: Colors.blueGrey)),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
