import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/pricing_config.dart';
export '../config/pricing_config.dart';

/// Transaction Ledger Item in Seller Wallet
class WalletTransaction {
  final String id;
  final String orderId;
  final String title;
  final double amount; // Negative for platform fee deduction, positive for top-up
  final double balanceAfter;
  final DateTime timestamp;
  final String note;
  final bool isDeduction;

  WalletTransaction({
    required this.id,
    required this.orderId,
    required this.title,
    required this.amount,
    required this.balanceAfter,
    required this.timestamp,
    required this.note,
    this.isDeduction = true,
  });
}

class SellerWalletScreen extends StatefulWidget {
  final String sellerId;
  final String sellerName;
  final double initialBalance;

  const SellerWalletScreen({
    super.key,
    this.sellerId = 'usr_seller_chhabra',
    this.sellerName = 'Chhabra Organic Poultry Farms',
    this.initialBalance = 1250.0,
  });

  @override
  State<SellerWalletScreen> createState() => _SellerWalletScreenState();
}

class _SellerWalletScreenState extends State<SellerWalletScreen> {
  late double _currentBalance;
  int _selectedTopUpAmount = 100; // default top-up amount
  bool _isSafeHarborExpanded = false;

  // Live Micro-Tier Fee Calculator state
  bool _calcIsEggs = true;
  int _calcTrays = 12; // 12 trays
  int _calcBirds = 25; // 25 birds

  // Ledger of past transactions matching refined bulk micro-tiers
  late List<WalletTransaction> _transactions;

  static const Color primaryGreen = Color(0xFF1B5E20);
  static const Color walletAmber = Color(0xFFD97706);
  static const Color poultryRed = Color(0xFFB91C1C);
  static const Color lightBg = Color(0xFFF8FAFC);

  @override
  void initState() {
    super.initState();
    _currentBalance = widget.initialBalance;

    final now = DateTime.now();
    _transactions = [
      WalletTransaction(
        id: 'TXN-904',
        orderId: 'ORD-AKL-842',
        title: 'अंडे प्लेटफ़ॉर्म शुल्क (Tier 1: 12 Trays)',
        amount: -360.0, // 12 trays * ₹30/tray = ₹360
        balanceAfter: 1250.0,
        timestamp: now.subtract(const Duration(hours: 1)),
        note: 'Tier 1: 12 Trays @ ₹1.00/अंडा (₹30.00/ट्रे) • Delivered Handover',
      ),
      WalletTransaction(
        id: 'TXN-903',
        orderId: 'ORD-BULK-712',
        title: 'अंडे प्लेटफ़ॉर्म शुल्क (Tier 2: 40 Trays)',
        amount: -600.0, // 40 trays * ₹15/tray = ₹600
        balanceAfter: 1610.0,
        timestamp: now.subtract(const Duration(hours: 8)),
        note: 'Tier 2: 40 Trays @ ₹0.50/अंडा (₹15.00/ट्रे) • Delivered to Bakery',
      ),
      WalletTransaction(
        id: 'TXN-902',
        orderId: 'RECHARGE-UPI',
        title: 'UPI प्रीपेड वॉलेट टॉप-अप (PhonePe)',
        amount: 1000.0,
        balanceAfter: 2210.0,
        timestamp: now.subtract(const Duration(days: 1)),
        note: 'Instant Top-up via ICICI VPA Gateway (andaexpress@icici)',
        isDeduction: false,
      ),
      WalletTransaction(
        id: 'TXN-901',
        orderId: 'ORD-LIV-518',
        title: 'लाइव पोल्ट्री शुल्क (Bulk Tier 1: 25 Birds)',
        amount: -125.0, // 25 birds * ₹5/bird = ₹125
        balanceAfter: 1210.0,
        timestamp: now.subtract(const Duration(days: 2)),
        note: 'Bulk Tier 1: 25 Birds @ ₹5.00/पक्षी • Leg-Seal #MH-30-7492 verified',
      ),
      WalletTransaction(
        id: 'TXN-900',
        orderId: 'ORD-EGG-601',
        title: 'अंडे प्लेटफ़ॉर्म शुल्क (Tier 3: 60 Trays Bulk)',
        amount: -270.0, // 60 trays * ₹4.50/tray = ₹270
        balanceAfter: 1335.0,
        timestamp: now.subtract(const Duration(days: 3)),
        note: 'Tier 3 Bulk: 60 Trays (>1500 eggs) @ ₹0.15/अंडा (₹4.50/ट्रे)',
      ),
    ];
  }

  Future<void> _initiateUpiPayment(int amount) async {
    final upiUrl = 'upi://pay?pa=andaexpress@icici&pn=AndaExpressPlatform&am=$amount.00&cu=INR&tn=SellerPrepaidWalletRecharge';
    final uri = Uri.parse(upiUrl);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      _showUpiQrDialog(amount);
    }
  }

  void _showUpiQrDialog(int amount) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.qr_code_2, color: primaryGreen),
            SizedBox(width: 8),
            Text('UPI वॉलेट रिचार्ज'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('रिचार्ज राशि: ₹$amount.00', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 6),
            const Text('UPI ID: andaexpress@icici (VPA)', style: TextStyle(fontSize: 11, color: Colors.grey)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Column(
                children: [
                  Icon(Icons.qr_code, size: 120, color: Colors.black87),
                  SizedBox(height: 4),
                  Text('GPay • PhonePe • Paytm • BHIM', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'सत्यापन के बाद राशि सीधे विक्रेता प्रीपेड वॉलेट में क्रेडिट हो जाएगी।',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('रद्द करें')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: primaryGreen, foregroundColor: Colors.white),
            onPressed: () {
              Navigator.pop(ctx);
              _processSuccessfulRecharge(amount);
            },
            child: const Text('भुगतान सत्यापित करें (Simulate Pay)'),
          ),
        ],
      ),
    );
  }

  void _processSuccessfulRecharge(int amount) {
    setState(() {
      _currentBalance += amount;
      final newTxn = WalletTransaction(
        id: 'TXN-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
        orderId: 'RECHARGE-UPI',
        title: 'UPI प्रीपेड वॉलेट टॉप-अप',
        amount: amount.toDouble(),
        balanceAfter: _currentBalance,
        timestamp: DateTime.now(),
        note: 'Instant Top-up via ICICI VPA Gateway',
        isDeduction: false,
      );
      _transactions.insert(0, newTxn);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('वॉलेट में ₹$amount सफलतापूर्वक जोड़े गए! नया बैलेंस: ₹${_currentBalance.toStringAsFixed(2)}'),
        backgroundColor: primaryGreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final eggFeeResult = PlatformFeeEngine.calculateEggFee(_calcTrays);
    final poultryFeeResult = PlatformFeeEngine.calculateLivePoultryFee(_calcBirds);

    return Scaffold(
      backgroundColor: lightBg,
      appBar: AppBar(
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('विक्रेता प्रीपेड वॉलेट व शुल्क इंजन', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            Text('Bulk Micro-Tiers • Platform Fee Architecture', style: TextStyle(fontSize: 11, color: Colors.white70)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ========================================================
            // 1. CURRENT BALANCE & PREPAID WALLET CARD
            // ========================================================
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: primaryGreen.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.account_balance_wallet, color: Colors.amber, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'उपलब्ध प्रीपेड बैलेंस (Prepaid Balance)',
                            style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: _currentBalance >= PricingConfig.minSellerWalletDeposit ? Colors.emerald.shade900 : Colors.red.shade900,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _currentBalance >= PricingConfig.minSellerWalletDeposit ? 'सक्रिय (Active)' : 'लो बैलेंस (<₹${PricingConfig.minSellerWalletDeposit.toStringAsFixed(0)})',
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Large Balance Display
                  Text(
                    '₹${_currentBalance.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Dynamic Deduction Policy Notice
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.shield_outlined, color: Colors.amber, size: 16),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'डायनेमिक डिडक्शन: निर्धारित बल्क माइक्रो-टियर शुल्क केवल तभी कटेगा जब ऑर्डर की स्थिति "delivered" या "dropped_at_hub" होगी।',
                            style: TextStyle(color: Colors.white, fontSize: 10.5, height: 1.3),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // ========================================================
            // 2. REFINED BULK MICRO-TIER FEE ENGINE CARD
            // ========================================================
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
                      Icon(Icons.tune, color: primaryGreen, size: 18),
                      SizedBox(width: 6),
                      Text('प्लेटफ़ॉर्म शुल्क आर्किटेक्चर (Bulk Micro-Tiers)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Category 1: Fresh Eggs Tier Structure
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFBEB),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.amber.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Text('🥚', style: TextStyle(fontSize: 16)),
                            SizedBox(width: 6),
                            Text('ताज़ा अंडे शुल्क संरचना (Single Buyer Volume):', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11.5, color: Color(0xFF92400E))),
                          ],
                        ),
                        const SizedBox(height: 6),
                        _buildTierRow('1 से 30 ट्रे (1 - 900 अंडे)', 'Flat ₹1.00 / अंडा', '₹30.00 / ट्रे', Colors.brown.shade800),
                        _buildTierRow('31 से 50 ट्रे (930 - 1,500 अंडे)', 'Flat ₹0.50 (50p) / अंडा', '₹15.00 / ट्रे', Colors.orange.shade900),
                        _buildTierRow('> 50 ट्रे (1,500+ अंडे, Unlimited)', 'Flat ₹0.15 (15p) / अंडा', '₹4.50 / ट्रे', primaryGreen),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Category 2: Live Poultry Bulk Tier Structure
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Text('🐔', style: TextStyle(fontSize: 16)),
                            SizedBox(width: 6),
                            Text('लाइव पोल्ट्री बल्क शुल्क संरचना (Live Poultry):', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11.5, color: Color(0xFF991B1B))),
                          ],
                        ),
                        const SizedBox(height: 6),
                        _buildTierRow('1 से 15 पक्षी (Retail)', 'Standard Retail Slabs', '₹10 / ₹20 / ₹40', Colors.red.shade900),
                        _buildTierRow('16 से 50 पक्षी (Bulk Tier 1)', 'Flat ₹5.00 प्रति पक्षी', '₹5.00 / bird', Colors.red.shade800),
                        _buildTierRow('51 से 100 पक्षी (Bulk Tier 2)', 'Flat ₹3.00 प्रति पक्षी', '₹3.00 / bird', Colors.deepOrange.shade800),
                        _buildTierRow('101 से 500 पक्षी (Commercial)', 'Flat ₹1.00 प्रति पक्षी', '₹1.00 / bird', Colors.amber.shade900),
                        _buildTierRow('> 500 पक्षी (Mega Hatchery)', 'Flat ₹0.50 (50p) प्रति पक्षी', '₹0.50 / bird', primaryGreen),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Interactive Live Fee Calculator
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('लाइव शुल्क कैलकुलेटर टेस्ट:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                            Row(
                              children: [
                                ChoiceChip(
                                  label: const Text('🥚 अंडे', style: TextStyle(fontSize: 10)),
                                  selected: _calcIsEggs,
                                  onSelected: (val) => setState(() => _calcIsEggs = true),
                                  visualDensity: VisualDensity.compact,
                                ),
                                const SizedBox(width: 4),
                                ChoiceChip(
                                  label: const Text('🐔 पोल्ट्री', style: TextStyle(fontSize: 10)),
                                  selected: !_calcIsEggs,
                                  onSelected: (val) => setState(() => _calcIsEggs = false),
                                  visualDensity: VisualDensity.compact,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        if (_calcIsEggs) ...[
                          Row(
                            children: [
                              Text('मात्रा: $_calcTrays ट्रे (${_calcTrays * 30} अंडे)', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                              Expanded(
                                child: Slider(
                                  value: _calcTrays.toDouble(),
                                  min: 1,
                                  max: 100,
                                  divisions: 99,
                                  activeColor: primaryGreen,
                                  onChanged: (val) => setState(() => _calcTrays = val.round()),
                                ),
                              ),
                            ],
                          ),
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
                                    Text(eggFeeResult.tierTitle, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: primaryGreen)),
                                    Text('दर: ${eggFeeResult.unitRateExplanation}', style: const TextStyle(fontSize: 9.5, color: Colors.grey)),
                                  ],
                                ),
                                Text(
                                  'कुल: ₹${eggFeeResult.totalFee.toStringAsFixed(2)}',
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: primaryGreen, fontFamily: 'monospace'),
                                ),
                              ],
                            ),
                          ),
                        ] else ...[
                          Row(
                            children: [
                              Text('मात्रा: $_calcBirds पक्षी', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                              Expanded(
                                child: Slider(
                                  value: _calcBirds.toDouble(),
                                  min: 1,
                                  max: 600,
                                  divisions: 120,
                                  activeColor: poultryRed,
                                  onChanged: (val) => setState(() => _calcBirds = val.round()),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red.shade200),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(poultryFeeResult.tierTitle, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: poultryRed)),
                                    Text('दर: ${poultryFeeResult.unitRateExplanation}', style: const TextStyle(fontSize: 9.5, color: Colors.grey)),
                                  ],
                                ),
                                Text(
                                  'कुल: ₹${poultryFeeResult.totalFee.toStringAsFixed(2)}',
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: poultryRed, fontFamily: 'monospace'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // ========================================================
            // 3. SIMPLE UPI TOP-UP / RECHARGE SECTION
            // ========================================================
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6, offset: const Offset(0, 2)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.flash_on, color: walletAmber, size: 18),
                          SizedBox(width: 6),
                          Text('त्वरित UPI रिचार्ज (Quick Wallet Top-up)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Text('0% Platform Fee', style: TextStyle(fontSize: 10, color: Colors.grey, fontFamily: 'monospace')),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Quick Recharge Chips: +₹50, +₹100, +₹500
                  Row(
                    children: [50, 100, 500].map((amt) {
                      final isSelected = _selectedTopUpAmount == amt;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedTopUpAmount = amt),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected ? primaryGreen : Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: isSelected ? primaryGreen : Colors.grey.shade300, width: isSelected ? 1.5 : 1),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '+₹$amt',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.white : Colors.black87,
                                fontFamily: 'monospace',
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 12),

                  // Interactive UPI Pay Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _initiateUpiPayment(_selectedTopUpAmount),
                      icon: const Icon(Icons.payment, size: 16),
                      label: Text('UPI से ₹$_selectedTopUpAmount रिचार्ज करें (Instant Top-up)'),
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

            const SizedBox(height: 16),

            // ========================================================
            // 4. INTERMEDIARY PLATFORM PROTECTION (IT ACT 2000, SEC 79)
            // ========================================================
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.amber.shade400, width: 1.2),
              ),
              child: Column(
                children: [
                  ListTile(
                    onTap: () => setState(() => _isSafeHarborExpanded = !_isSafeHarborExpanded),
                    leading: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(color: Colors.amber.shade100, borderRadius: BorderRadius.circular(8)),
                      child: const Icon(Icons.gavel, color: Color(0xFF92400E), size: 18),
                    ),
                    title: const Text(
                      'Platform Terms & Safe Harbor Disclosure',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF92400E)),
                    ),
                    subtitle: const Text(
                      'सूचना प्रौद्योगिकी अधिनियम 2000 (धारा 79) सेफ हार्बर सुरक्षा',
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                    trailing: Icon(
                      _isSafeHarborExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      color: const Color(0xFF92400E),
                    ),
                  ),

                  if (_isSafeHarborExpanded)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Divider(height: 1),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(color: Colors.amber.shade50, borderRadius: BorderRadius.circular(10)),
                            child: const Text(
                              'AndaExpress operates solely as a digital facilitator connecting poultry farmers, daily commuters, and buyers. The platform charges standardized volume micro-tier facilitation fees per successful order and does not produce, store, or own the poultry products.',
                              style: TextStyle(fontSize: 11, color: Color(0xFF78350F), height: 1.35),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '• अग्रिम टोकन बनाम सीओडी: किसान प्रत्येक बैच पर "Require 50% Advance Token" या "Allow 100% Cash/UPI on Delivery (COD)" चुन सकते हैं। कम्यूटर का प्री-पिकअप कॉल गेट अनिवार्य है।',
                            style: TextStyle(fontSize: 10.5, color: Colors.black87),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            '• एंटी-टैम्परिंग सुरक्षा: लाइव पोल्ट्री पक्षियों पर नंबर युक्त लेग-सील व प्रमाणित तराजू फोटो वाटरमार्क द्वारा प्रामाणिकता सुनिश्चित की जाती है।',
                            style: TextStyle(fontSize: 10.5, color: Colors.black87),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '• एस्क्रो व सेटलमेंट सुरक्षा: सुरक्षित किसान सेटलमेंट विंडो ${PricingConfig.farmerSettlementWindowHours} घंटे है। न्यूनतम वॉलेट डिपॉजिट राशि ₹${PricingConfig.minSellerWalletDeposit.toStringAsFixed(0)} अनिवार्य है।',
                            style: const TextStyle(fontSize: 10.5, color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // ========================================================
            // 5. TRANSACTION LEDGER
            // ========================================================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'लेनदेन इतिहास (Transaction Ledger)',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                Text(
                  '${_transactions.length} Transactions',
                  style: const TextStyle(fontSize: 11, color: Colors.grey, fontFamily: 'monospace'),
                ),
              ],
            ),
            const SizedBox(height: 8),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _transactions.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final txn = _transactions[index];
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: txn.isDeduction ? Colors.red.shade50 : Colors.green.shade50,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          txn.isDeduction ? Icons.arrow_downward : Icons.arrow_upward,
                          color: txn.isDeduction ? Colors.red : primaryGreen,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(txn.title, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold)),
                            Text(
                              '${txn.orderId} • ${DateFormat('dd MMM, hh:mm a').format(txn.timestamp)}',
                              style: const TextStyle(fontSize: 10, color: Colors.grey, fontFamily: 'monospace'),
                            ),
                            Text(txn.note, style: TextStyle(fontSize: 9.5, color: Colors.grey.shade600)),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            txn.isDeduction ? '-₹${txn.amount.abs().toStringAsFixed(2)}' : '+₹${txn.amount.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'monospace',
                              color: txn.isDeduction ? Colors.red.shade800 : primaryGreen,
                            ),
                          ),
                          Text(
                            'शेष: ₹${txn.balanceAfter.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 9.5, color: Colors.grey, fontFamily: 'monospace'),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTierRow(String title, String perUnit, String perTray, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('• $title', style: const TextStyle(fontSize: 10.5, color: Colors.black87)),
          Row(
            children: [
              Text(perUnit, style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: color)),
              const SizedBox(width: 4),
              Text('($perTray)', style: const TextStyle(fontSize: 9.5, color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}
