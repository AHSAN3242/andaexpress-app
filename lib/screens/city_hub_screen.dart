import 'package:flutter/material.dart';

/// City Hub Custody Status
enum HubParcelStatus {
  inCustody, // Parcel safely stored at shop
  delivered, // Buyer entered OTP and picked up eggs
  returned,  // Unclaimed / returned
}

/// Parcel in City Hub Custody
class HubCustodyParcel {
  final String orderId;
  final String buyerName;
  final String buyerPhone;
  final String eggSummary;
  final int trays;
  final double parcelAmount;
  final double commuterFee;
  final double hubFee; // ₹5 shop fee
  final String expectedOtp;
  final DateTime droppedAt;
  HubParcelStatus status;
  bool isPaidToFarmer;

  HubCustodyParcel({
    required this.orderId,
    required this.buyerName,
    required this.buyerPhone,
    required this.eggSummary,
    required this.trays,
    required this.parcelAmount,
    required this.commuterFee,
    this.hubFee = 5.0,
    required this.expectedOtp,
    required this.droppedAt,
    this.status = HubParcelStatus.inCustody,
    this.isPaidToFarmer = true,
  });
}

/// City Hub Shop Custody & Handover Screen
/// Shrinath Dairy & City Hub (Akola Bus Stand Gate 2)
class CityHubScreen extends StatefulWidget {
  final String hubName;
  final String hubAddress;
  final String ownerName;
  final List<HubCustodyParcel>? initialParcels;
  final Function(String orderId)? onParcelDelivered;

  const CityHubScreen({
    super.key,
    this.hubName = 'श्रीनाथ डेयरी व सिटी हब (Shrinath Dairy & City Hub)',
    this.hubAddress = 'अकोला बस स्टैंड गेट नं. 2, मुख्य सड़क, अकोला (Akola)',
    this.ownerName = 'सुरेश भाई पटेल (हब संचालक)',
    this.initialParcels,
    this.onParcelDelivered,
  });

  @override
  State<CityHubScreen> createState() => _CityHubScreenState();
}

class _CityHubScreenState extends State<CityHubScreen> {
  static const Color primaryBlue = Color(0xFF1E3A8A);
  static const Color primaryGreen = Color(0xFF1B5E20);
  static const Color hubAmber = Color(0xFFD97706);

  late List<HubCustodyParcel> _hubParcels;
  final Map<String, TextEditingController> _otpControllers = {};

  @override
  void initState() {
    super.initState();
    _hubParcels = widget.initialParcels ?? [
      HubCustodyParcel(
        orderId: 'ORD-AKL-842',
        buyerName: 'Rahul Sharma (राहुल शर्मा)',
        buyerPhone: '+91 98112 23344',
        eggSummary: 'देसी फ्री-रेंज अंडे (30 Trays)',
        trays: 1,
        parcelAmount: 360.0,
        commuterFee: 28.0,
        hubFee: 5.0,
        expectedOtp: '4821',
        droppedAt: DateTime.now().subtract(const Duration(minutes: 15)),
        status: HubParcelStatus.inCustody,
        isPaidToFarmer: true,
      ),
      HubCustodyParcel(
        orderId: 'ORD-AKL-903',
        buyerName: 'Pooja Deshmukh (पूजा देशमुख)',
        buyerPhone: '+91 98223 34455',
        eggSummary: 'कड़कनाथ ब्लैक अंडे (12 Pack)',
        trays: 1,
        parcelAmount: 480.0,
        commuterFee: 30.0,
        hubFee: 5.0,
        expectedOtp: '7392',
        droppedAt: DateTime.now().subtract(const Duration(minutes: 42)),
        status: HubParcelStatus.inCustody,
        isPaidToFarmer: true,
      ),
    ];

    for (var p in _hubParcels) {
      _otpControllers[p.orderId] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (var c in _otpControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _verifyOtpAndHandover(HubCustodyParcel parcel) {
    final enteredOtp = _otpControllers[parcel.orderId]?.text.trim() ?? '';
    if (enteredOtp == parcel.expectedOtp) {
      setState(() {
        parcel.status = HubParcelStatus.delivered;
      });
      widget.onParcelDelivered?.call(parcel.orderId);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '✓ OTP (${parcel.expectedOtp}) सत्यापित! पार्सल ${parcel.orderId} खरीदार को सौंपा गया। हब शुल्क ₹${parcel.hubFee} प्राप्त हुआ।',
          ),
          backgroundColor: primaryGreen,
          duration: const Duration(seconds: 4),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'अमान्य OTP! खरीदार के ऐप में अनलॉक्ड 4-अंकीय कोड (${parcel.expectedOtp}) देखें।',
          ),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final inCustodyCount = _hubParcels.where((p) => p.status == HubParcelStatus.inCustody).length;
    final totalEarnedFees = _hubParcels
        .where((p) => p.status == HubParcelStatus.delivered)
        .fold(0.0, (sum, p) => sum + p.hubFee);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('सिटी हब कस्टडी ट्रांसफर (City Hub Shop)'),
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Chip(
              backgroundColor: Colors.amber.shade300,
              label: Text(
                'कस्टडी: $inCustodyCount पार्सल',
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hub Shop Banner Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E3A8A), Color(0xFF172554)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.blue.shade900.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade400,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.storefront, color: Colors.black87, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.hubName,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            Text(
                              widget.ownerName,
                              style: TextStyle(color: Colors.blue.shade200, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.amber, size: 16),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            widget.hubAddress,
                            style: const TextStyle(color: Colors.white70, fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'हब सुरक्षा व कूलिंग शुल्क: ₹5.00 / पार्सल',
                        style: TextStyle(color: Colors.amber.shade300, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'कुल अर्जित शुल्क: ₹${totalEarnedFees.toStringAsFixed(0)}',
                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Anti-Bypass Handshake Custody Notice
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                border: Border.all(color: const Color(0xFFBFDBFE)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.verified_user, color: primaryBlue, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'कस्टडी ट्रांसफर व शून्य-लागत OTP सुरक्षा',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: primaryBlue),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'कम्यूटर द्वारा बस स्टैंड पर 2-मिनट के बाद पार्सल इस दुकान पर सुरक्षित छोड़ा गया। खरीदार जब दुकान आएंगे, तो वे अपना अनलॉक्ड 4-अंकीय OTP दिखाएंगे। OTP दर्ज करने पर ही हैंडओवर दर्ज होगा।',
                          style: TextStyle(fontSize: 10.5, color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Hub Parcels Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'दुकान में सुरक्षित अंडे पार्सल (Inventory)',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Text(
                  '${_hubParcels.length} कुल पार्सल',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // List of parcels
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _hubParcels.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final parcel = _hubParcels[index];
                final isDelivered = parcel.status == HubParcelStatus.delivered;
                final controller = _otpControllers[parcel.orderId]!;

                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isDelivered ? Colors.green.shade400 : Colors.grey.shade300,
                      width: isDelivered ? 1.5 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Parcel header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: isDelivered ? const Color(0xFFDCFCE7) : const Color(0xFFDBEAFE),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  isDelivered ? Icons.check_circle : Icons.inventory_2,
                                  color: isDelivered ? primaryGreen : primaryBlue,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    parcel.orderId,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                  ),
                                  Text(
                                    parcel.buyerName,
                                    style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: isDelivered ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              isDelivered ? '✓ हैंडओवर संपन्न' : '🏢 कस्टडी में (At Hub)',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: isDelivered ? const Color(0xFF15803D) : const Color(0xFFB45309),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // Egg summary & amounts
                      Text(
                        parcel.eggSummary,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                      ),
                      const SizedBox(height: 4),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'अंडे मूल्य: ₹${parcel.parcelAmount.toStringAsFixed(0)}',
                            style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.amber.shade50,
                              border: Border.all(color: Colors.amber.shade300),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '+ ₹${parcel.hubFee.toStringAsFixed(0)} हब हैंडलिंग शुल्क',
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.amber.shade900),
                            ),
                          ),
                        ],
                      ),

                      const Divider(height: 20),

                      if (!isDelivered) ...[
                        Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: TextField(
                                controller: controller,
                                keyboardType: TextInputType.number,
                                maxLength: 4,
                                decoration: InputDecoration(
                                  counterText: '',
                                  labelText: 'खरीदार का 4-अंकीय OTP',
                                  hintText: parcel.expectedOtp,
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              flex: 2,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryGreen,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                onPressed: () => _verifyOtpAndHandover(parcel),
                                child: const Text('हैंडओवर करें', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'खरीदार फोन: ${parcel.buyerPhone}',
                              style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                            ),
                            TextButton.icon(
                              style: TextButton.styleFrom(padding: EdgeInsets.zero, visualDensity: VisualDensity.compact),
                              icon: const Icon(Icons.pin, size: 12),
                              label: Text('Fill OTP (${parcel.expectedOtp})', style: const TextStyle(fontSize: 10)),
                              onPressed: () {
                                controller.text = parcel.expectedOtp;
                              },
                            ),
                          ],
                        ),
                      ] else ...[
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0FDF4),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: const [
                              Icon(Icons.check_circle_outline, color: primaryGreen, size: 16),
                              SizedBox(width: 6),
                              Text(
                                'डिलीवरी पूर्ण! खरीदार ने अंडे प्राप्त किए व ₹5 हब शुल्क चुकाया।',
                                style: TextStyle(color: primaryGreen, fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
