import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../config/pricing_config.dart';

/// Digital Delivery Invoice Model
class DeliveryInvoiceData {
  final String orderId;
  final String timestamp;
  final String buyerName;
  final String buyerPhone;
  final String deliveryAddress;

  final String farmerName;
  final String farmerUpiId;
  final String farmLocation;

  final String commuterName;
  final String commuterPhone;
  final String commuterVehicle;
  final String commuteRoute;

  // Items
  final String itemTitle;
  final String category; // 'eggs', 'live_poultry', 'quails'
  final int quantity;
  final double unitPrice;
  final double totalProductAmount;

  // Commuter Fare
  final double baseCommuterRate;
  final double bulkDiscountPercent;
  final double commuterFareAmount;

  // Platform Fee
  final String platformFeeTierTitle;
  final double platformFeeRate;
  final double platformFeeTotal;

  // Anti-Tamper Security Attestation
  final String legSealNumber;
  final String tagNumber;
  final String certifiedScaleWeight;
  final String gpsGeotag;
  final String verifiedHandshakeOtp;

  // Custody Status
  final String custodyStatus;
  final String settlementStatus;

  DeliveryInvoiceData({
    this.orderId = 'ORD-AKL-842',
    this.timestamp = '2026-10-14 10:45 AM IST',
    this.buyerName = 'Rahul Sharma (राहुल शर्मा)',
    this.buyerPhone = '+91 98112 23344',
    this.deliveryAddress = 'अकोला बस स्टैंड गेट 1 (2-Min Handshake Point)',
    this.farmerName = 'Chhabra Organic Poultry Farms',
    this.farmerUpiId = 'chhabra.poultry@icici',
    this.farmLocation = 'LAT: 20.7002° N | LON: 77.0082° E (Paras Belt)',
    this.commuterName = 'Santosh Gawande (संतोष गावंडे)',
    this.commuterPhone = '+91 94221 88301',
    this.commuterVehicle = 'दैनिक बस ट्रांसपोर्ट (Daily Bus Transit)',
    this.commuteRoute = 'Paras Depot ➡️ Akola Bus Stand (Gate 1)',
    this.itemTitle = 'देसी फ्री-रेंज अंडे (Desi Country Eggs)',
    this.category = 'eggs',
    this.quantity = 12,
    this.unitPrice = 360.0,
    this.totalProductAmount = 4320.0,
    this.baseCommuterRate = 30.0,
    this.bulkDiscountPercent = 10.0,
    this.commuterFareAmount = 324.0, // 12 * 30 - 10%
    this.platformFeeTierTitle = 'Tier 1: 1 to 30 Trays (₹1.00/अंडा = ₹30/ट्रे)',
    this.platformFeeRate = 1.00,
    this.platformFeeTotal = 360.0,
    this.legSealNumber = 'SEAL-MH-30-7492',
    this.tagNumber = 'AND-9102',
    this.certifiedScaleWeight = '21.60 kg Net Certified (1.80 kg/tray avg)',
    this.gpsGeotag = 'LAT: 20.7002° N | LON: 77.0082° E • Verified Geostamp',
    this.verifiedHandshakeOtp = '4821',
    this.custodyStatus = 'DELIVERED TO BUYER (कस्टडी खरीदार के पास)',
    this.settlementStatus = 'PREPAID ESCROW SETTLED ✓',
  });
}

class OrderInvoiceScreen extends StatelessWidget {
  final DeliveryInvoiceData? invoiceData;
  final VoidCallback? onBackToHome;

  const OrderInvoiceScreen({
    super.key,
    this.invoiceData,
    this.onBackToHome,
  });

  static const Color primaryGreen = Color(0xFF1B5E20);
  static const Color darkSlate = Color(0xFF0F172A);
  static const Color amberAccent = Color(0xFFD97706);
  static const Color commuterBlue = Color(0xFF1E3A8A);

  @override
  Widget build(BuildContext context) {
    final d = invoiceData ?? DeliveryInvoiceData();

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text('डिजिटल डिलीवरी इनवॉइस (Digital Invoice)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        backgroundColor: darkSlate,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, size: 20),
            tooltip: 'रसीद शेयर करें (Share Receipt)',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('डिजिटल डिलीवरी रसीद क्लिपबोर्ड पर कॉपी हुई! WhatsApp पर शेयर कर सकते हैं।'),
                  backgroundColor: primaryGreen,
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.print_outlined, size: 20),
            tooltip: 'प्रिंट इनवॉइस (Print PDF)',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('प्रिंटर डायलाग खुला: AndaExpress Official Tax & Trip Receipt.pdf'),
                  backgroundColor: darkSlate,
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 540),
            child: Column(
              children: [
                // Digital Invoice Card
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade300),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Header Brand Band
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF1B5E20), Color(0xFF0F172A)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.vertical(top: Radius.circular(19)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: Colors.amber,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Center(
                                    child: Text('🥚', style: TextStyle(fontSize: 22)),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      'AndaExpress',
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.black, fontSize: 18, letterSpacing: -0.5),
                                    ),
                                    Text(
                                      'डिजिटल डिलीवरी व टैक्स इनवॉइस',
                                      style: TextStyle(color: Colors.amber, fontSize: 10.5, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.emerald.shade900.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.emerald.shade400),
                              ),
                              child: Row(
                                children: const [
                                  Icon(Icons.verified, size: 14, color: Colors.greenAccent),
                                  SizedBox(width: 4),
                                  Text(
                                    '100% PAID',
                                    style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, fontFamily: 'monospace'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Order ID & Timestamp Bar
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        color: Colors.slate.shade100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Text('ऑर्डर ID: ', style: TextStyle(fontSize: 11, color: Colors.black54)),
                                Text(
                                  d.orderId,
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'monospace', color: Colors.black87),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.access_time, size: 12, color: Colors.black54),
                                const SizedBox(width: 4),
                                Text(d.timestamp, style: const TextStyle(fontSize: 10.5, color: Colors.black54)),
                              ],
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 1. Multi-Party Contact Badges
                            _buildPartyDetailsSection(d),

                            const Divider(height: 28),

                            // 2. Item Breakdown (Quantity, Unit Price, Total Product Amount)
                            const Text(
                              '1. सामग्री विवरण (Item Breakdown):',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5, color: darkSlate),
                            ),
                            const SizedBox(height: 8),

                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(d.itemTitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                      const SizedBox(height: 2),
                                      Text(
                                        'मात्रा: ${d.quantity} ${d.category == "eggs" ? "ट्रे (360 अंडे)" : "पक्षी"} • ₹${d.unitPrice.toStringAsFixed(0)} / ${d.category == "eggs" ? "ट्रे" : "पक्षी"}',
                                        style: TextStyle(fontSize: 10.5, color: Colors.grey.shade600),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '₹${d.totalProductAmount.toStringAsFixed(2)}',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, fontFamily: 'monospace'),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 14),

                            // 3. Commuter Transit Fare Breakdown
                            const Text(
                              '2. कम्यूटर डिलीवरी किराया विवरण (Commuter Fare Breakdown):',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5, color: darkSlate),
                            ),
                            const SizedBox(height: 8),

                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.blue.shade200),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'बेस डिलीवरी किराया (${d.quantity} ${d.category == "eggs" ? "ट्रे" : "पक्षी"} @ ₹${d.baseCommuterRate.toStringAsFixed(0)}):',
                                        style: const TextStyle(fontSize: 11, color: Colors.black87),
                                      ),
                                      Text(
                                        '₹${(d.quantity * d.baseCommuterRate).toStringAsFixed(2)}',
                                        style: const TextStyle(fontSize: 11, fontFamily: 'monospace', fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                  if (d.bulkDiscountPercent > 0) ...[
                                    const SizedBox(height: 4),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'बल्क वॉल्यूम छूट (${d.bulkDiscountPercent.toStringAsFixed(0)}% छूट लागू):',
                                          style: const TextStyle(fontSize: 11, color: primaryGreen, fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          '-₹${((d.quantity * d.baseCommuterRate) * (d.bulkDiscountPercent / 100)).toStringAsFixed(2)}',
                                          style: const TextStyle(fontSize: 11, fontFamily: 'monospace', color: primaryGreen, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                  const Divider(height: 14),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'कम्यूटर को देय कुल किराया (Net Commuter Transit Fare):',
                                        style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: commuterBlue),
                                      ),
                                      Text(
                                        '₹${d.commuterFareAmount.toStringAsFixed(2)}',
                                        style: const TextStyle(fontSize: 13, fontFamily: 'monospace', fontWeight: FontWeight.bold, color: commuterBlue),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 14),

                            // 4. Platform Fee Deducted from Seller Wallet (Tier breakdown)
                            const Text(
                              '3. प्लेटफ़ॉर्म सुविधा शुल्क (Seller Wallet Platform Fee):',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5, color: darkSlate),
                            ),
                            const SizedBox(height: 8),

                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.amber.shade50.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.amber.shade300),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        d.platformFeeTierTitle,
                                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF78350F)),
                                      ),
                                      Text(
                                        '₹${d.platformFeeTotal.toStringAsFixed(2)}',
                                        style: const TextStyle(fontSize: 11.5, fontFamily: 'monospace', fontWeight: FontWeight.bold, color: Color(0xFF78350F)),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    '• विक्रेता के प्रीपेड वॉलेट एस्क्रो से स्वतः काटा गया (शून्य नकद बोझ)',
                                    style: TextStyle(fontSize: 10, color: Colors.amber.shade900),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 16),

                            // 5. Anti-Tamper Security Proof (Leg Seal & Certified DigiScale)
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0F172A),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: const [
                                      Icon(Icons.shield_outlined, color: Colors.amber, size: 16),
                                      SizedBox(width: 6),
                                      Text(
                                        'एंटी-टैम्परिंग व प्रामाणिकता सुरक्षा (Anti-Tamper Proof)',
                                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 11),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  _buildSecurityRow(Icons.tag, 'टैम्पर-प्रूफ लेग सील टैग:', d.legSealNumber, Colors.amberAccent),
                                  const SizedBox(height: 6),
                                  _buildSecurityRow(Icons.qr_code_scanner, 'नमूना टैग नंबर:', '#${d.tagNumber}', Colors.cyanAccent),
                                  const SizedBox(height: 6),
                                  _buildSecurityRow(Icons.scale, 'सर्टिफाइड स्केल वजन:', d.certifiedScaleWeight, Colors.greenAccent),
                                  const SizedBox(height: 6),
                                  _buildSecurityRow(Icons.lock_open, 'हैंडओवर OTP कोड:', '#${d.verifiedHandshakeOtp} (सत्यापित)', Colors.greenAccent),
                                  const SizedBox(height: 6),
                                  _buildSecurityRow(Icons.pin_drop, 'GPS वाटरमार्क:', d.gpsGeotag, Colors.white70),
                                ],
                              ),
                            ),

                            const SizedBox(height: 18),

                            // Net Grand Total
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.emerald.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.emerald.shade300),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        'कुल भुगतान राशि (Grand Total Paid):',
                                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black87),
                                      ),
                                      Text(
                                        'उत्पाद राशि + कम्यूटर किराया',
                                        style: TextStyle(fontSize: 9.5, color: primaryGreen),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '₹${(d.totalProductAmount + d.commuterFareAmount).toStringAsFixed(2)}',
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.black, fontFamily: 'monospace', color: primaryGreen),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onBackToHome,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: darkSlate),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: const Icon(Icons.arrow_back, size: 18, color: darkSlate),
                        label: const Text('होम पर लौटें (Return Home)', style: TextStyle(color: darkSlate, fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('डिजिटल इनवॉइस PDF डाउनलोड हो रहा है... (AndaExpress-Invoice.pdf)'),
                              backgroundColor: primaryGreen,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryGreen,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 2,
                        ),
                        icon: const Icon(Icons.download, size: 18),
                        label: const Text('PDF डाउनलोड करें (Download)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPartyDetailsSection(DeliveryInvoiceData d) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('🧑‍🌾 किसान / विक्रेता:', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 2),
                    Text(d.farmerName, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    Text('UPI: ${d.farmerUpiId}', style: const TextStyle(fontSize: 9.5, color: primaryGreen, fontFamily: 'monospace')),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('🛒 खरीदार (Buyer):', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 2),
                    Text(d.buyerName, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    Text(d.buyerPhone, style: const TextStyle(fontSize: 9.5, color: Colors.black54)),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.blue.shade50.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.blue.shade100),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('🚌 कम्यूटर डिलीवरी पार्टनर:', style: TextStyle(fontSize: 10, color: commuterBlue, fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text('${d.commuterName} (${d.commuterPhone}) • ${d.commuterVehicle}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              Text('रूट: ${d.commuteRoute}', style: const TextStyle(fontSize: 9.5, color: Colors.black87)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSecurityRow(IconData icon, String label, String value, Color valueColor) {
    return Row(
      children: [
        Icon(icon, size: 12, color: Colors.white70),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.white70)),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            value,
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, fontFamily: 'monospace', color: valueColor),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
