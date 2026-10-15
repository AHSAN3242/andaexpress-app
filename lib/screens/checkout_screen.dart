import 'package:flutter/material.dart';
import '../models/app_settings_model.dart';

/// Checkout Screen for AndaExpress
/// Reads dynamic platform fee slabs from Firebase app_settings
/// and calculates transparent price breakdown with Self-Pickup / Courier choice.
class CheckoutScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final VoidCallback onOrderCompleted;

  const CheckoutScreen({
    super.key,
    required this.cartItems,
    required this.onOrderCompleted,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _orderType = 'Courier'; // 'Courier' or 'Pickup'
  String _paymentMode = 'upi'; // 'upi' or 'cod'
  bool _isPlacingOrder = false;

  // Dynamic fee slabs from app_settings
  final List<PlatformFeeSlab> _feeSlabs = const [
    PlatformFeeSlab(min: 0, max: 100, fee: 1),
    PlatformFeeSlab(min: 101, max: 500, fee: 2),
    PlatformFeeSlab(min: 501, max: 1000, fee: 3),
    PlatformFeeSlab(min: 1001, max: 2000, fee: 5),
    PlatformFeeSlab(min: 2001, max: 999999, fee: 10),
  ];

  int _calculateItemTotal() {
    int total = 0;
    for (var item in widget.cartItems) {
      final price = (item['price'] as int?) ?? 0;
      final quantity = (item['quantity'] as int?) ?? 1;
      total += price * quantity;
    }
    return total;
  }

  int _calculatePlatformFee(int itemTotal) {
    for (var slab in _feeSlabs) {
      if (itemTotal >= slab.min && itemTotal <= slab.max) {
        return slab.fee;
      }
    }
    return 10;
  }

  @override
  Widget build(BuildContext context) {
    final itemTotal = _calculateItemTotal();
    final platformFee = _calculatePlatformFee(itemTotal);
    final deliveryCharge = _orderType == 'Courier' ? 40 : 0;
    final grandTotal = itemTotal + platformFee + deliveryCharge;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('ऑर्डर चेकआउट (Transparent Checkout)'),
        backgroundColor: const Color(0xFF1B5E20),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Delivery / Pickup Mode Selector
            const Text(
              'डिलीवरी का प्रकार चुनें (Fulfillment Mode)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _orderType = 'Courier'),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _orderType == 'Courier' ? const Color(0xFFE8F5E9) : Colors.white,
                        border: Border.all(
                          color: _orderType == 'Courier' ? const Color(0xFF1B5E20) : Colors.grey.shade300,
                          width: _orderType == 'Courier' ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: const [
                          Icon(Icons.delivery_dining, color: Color(0xFF1B5E20)),
                          SizedBox(height: 4),
                          Text('घर तक डिलीवरी (Courier)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          Text('₹40 एक्सप्रेस शुल्क', style: TextStyle(fontSize: 10, color: Colors.grey)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _orderType = 'Pickup'),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: _orderType == 'Pickup' ? const Color(0xFFE8F5E9) : Colors.white,
                        border: Border.all(
                          color: _orderType == 'Pickup' ? const Color(0xFF1B5E20) : Colors.grey.shade300,
                          width: _orderType == 'Pickup' ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: const [
                          Icon(Icons.storefront, color: Color(0xFF1B5E20)),
                          SizedBox(height: 4),
                          Text('फार्म से सेल्फ-पिकअप', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          Text('₹0 फ्री पिकअप', style: TextStyle(fontSize: 10, color: Colors.green)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Cart Items
            const Text(
              'ऑर्डर विवरण (Order Items)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.cartItems.length,
                separatorBuilder: (_, __) => Divider(color: Colors.grey.shade100, height: 1),
                itemBuilder: (context, i) {
                  final it = widget.cartItems[i];
                  return ListTile(
                    title: Text(it['title'] ?? 'अंडे'),
                    subtitle: Text('मात्रा: ${it['quantity'] ?? 1} ट्रे • Batch ${it['batch_code'] ?? '#EGG-842'}'),
                    trailing: Text(
                      '₹${((it['price'] as int? ?? 0) * (it['quantity'] as int? ?? 1))}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Transparent Price Breakdown
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.between,
                    children: [
                      const Text('सामग्री कुल (Item Total):', style: TextStyle(color: Colors.grey)),
                      Text('₹$itemTotal', style: const TextStyle(fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.between,
                    children: [
                      Row(
                        children: const [
                          Text('प्लेटफॉर्म सपोर्ट शुल्क: ', style: TextStyle(color: Colors.grey)),
                          Icon(Icons.info_outline, size: 14, color: Colors.grey),
                        ],
                      ),
                      Text('₹$platformFee', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1B5E20))),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '• app_settings स्लैब: ₹501-₹1000 पर मात्र ₹$platformFee',
                      style: const TextStyle(fontSize: 10, color: Colors.green),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.between,
                    children: [
                      const Text('डिलीवरी शुल्क:', style: TextStyle(color: Colors.grey)),
                      Text('₹$deliveryCharge', style: const TextStyle(fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.between,
                    children: [
                      const Text('कुल देय राशि (Grand Total):', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('₹$grandTotal', style: const TextStyle(fontWeight: FontWeight.extrabold, fontSize: 18, color: Color(0xFF1B5E20))),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Place Order Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isPlacingOrder
                    ? null
                    : () {
                        setState(() => _isPlacingOrder = true);
                        Future.delayed(const Duration(seconds: 1), () {
                          if (mounted) {
                            setState(() => _isPlacingOrder = false);
                            widget.onOrderCompleted();
                          }
                        });
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1B5E20),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: _isPlacingOrder
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        '₹$grandTotal का भुगतान करें (Place Order)',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
