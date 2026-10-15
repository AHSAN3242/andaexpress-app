import 'package:flutter/material.dart';

/// Strict Dispute Screen for AndaExpress
/// Buyers MUST upload a live camera photo of the "Water Float Test"
/// (egg submerged in a transparent bowl of water) to file a refund claim.
class DisputeScreen extends StatefulWidget {
  final String initialOrderId;
  final VoidCallback onDisputeSubmitted;

  const DisputeScreen({
    super.key,
    this.initialOrderId = 'ord_sample_901',
    required this.onDisputeSubmitted,
  });

  @override
  State<DisputeScreen> createState() => _DisputeScreenState();
}

class _DisputeScreenState extends State<DisputeScreen> {
  late TextEditingController _orderIdController;
  String _selectedReason = 'अंडा पानी में तैर रहा है (Egg floated horizontally to surface)';
  String? _floatTestPhotoUrl;
  bool _isCapturingLive = false;
  bool _isSubmitting = false;

  final List<String> _disputeReasons = [
    'अंडा पानी में तैर रहा है (Egg floated horizontally to surface)',
    'अंडा पानी में लंबवत खड़ा है (Egg stood upright: expired air pocket)',
    'बैच कोड मेल नहीं खा रहा (Batch code mismatch with tray)',
    'पार्सल में अंडे टूटे हुए प्राप्त हुए (Broken eggs received)',
  ];

  @override
  void initState() {
    super.initState();
    _orderIdController = TextEditingController(text: widget.initialOrderId);
  }

  @override
  void dispose() {
    _orderIdController.dispose();
    super.dispose();
  }

  void _simulateLiveCameraCapture() {
    setState(() => _isCapturingLive = true);
    // Simulate live camera snapshot with auto NTP & GPS watermarking
    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) {
        setState(() {
          _isCapturingLive = false;
          _floatTestPhotoUrl = 'https://images.unsplash.com/photo-1582722872445-44dc5f7e3c8f?w=600';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('विवाद एवं रिफंड (Float-Test Dispute)'),
        backgroundColor: const Color(0xFFDC2626), // Strict red
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Policy Notice Banner
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                border: Border.all(color: const Color(0xFFFCA5A5)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Icon(Icons.warning_amber_rounded, color: Color(0xFFDC2626)),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'सख्त एंटी-फ्रॉड नीति: रिफंड पाने के लिए पारदर्शी कटोरे में पानी भरकर अंडे का लाइव फ्लोट टेस्ट फोटो अनिवार्य है। गैलरी अपलोड पूरी तरह बंद है।',
                      style: TextStyle(color: Color(0xFF991B1B), fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Order ID
            const Text('ऑर्डर आईडी (Order ID)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 6),
            TextField(
              controller: _orderIdController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
            ),

            const SizedBox(height: 16),

            // Reason Selector
            const Text('विवाद का कारण (Dispute Reason)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: _selectedReason,
                  items: _disputeReasons.map((reason) {
                    return DropdownMenuItem(value: reason, child: Text(reason, style: const TextStyle(fontSize: 12)));
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedReason = val);
                  },
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Live Camera Photo Upload Section
            const Text(
              'वाटर फ्लोट टेस्ट का लाइव फोटो (Float-Test Proof)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 8),

            Container(
              width: double.infinity,
              height: 220,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: _floatTestPhotoUrl != null ? const Color(0xFF16A34A) : Colors.grey.shade400,
                  width: _floatTestPhotoUrl != null ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: _floatTestPhotoUrl != null
                  ? Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(_floatTestPhotoUrl!, width: double.infinity, height: double.infinity, fit: BoxFit.cover),
                        ),
                        Positioned(
                          bottom: 8,
                          left: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            color: Colors.black.withOpacity(0.7),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text('✓ LIVE CAMERA PROOF • WATER FLOAT TEST', style: TextStyle(color: Colors.greenAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                                Text('NTP: 2026-09-30 01:45:00 UTC • GPS: 28.4595° N, 77.0266° E', style: TextStyle(color: Colors.white, fontSize: 9)),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 16,
                            child: IconButton(
                              icon: const Icon(Icons.refresh, size: 16, color: Colors.black87),
                              onPressed: _simulateLiveCameraCapture,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.camera_alt, size: 40, color: Color(0xFFDC2626)),
                          const SizedBox(height: 8),
                          const Text('गैलरी बंद है • केवल लाइव कैमरा फोटो', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 12),
                          ElevatedButton.icon(
                            onPressed: _isCapturingLive ? null : _simulateLiveCameraCapture,
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFDC2626), foregroundColor: Colors.white),
                            icon: const Icon(Icons.camera),
                            label: Text(_isCapturingLive ? 'कैप्चरिंग...' : 'लाइव फ्लोट टेस्ट फोटो खींचें'),
                          ),
                        ],
                      ),
                    ),
            ),

            const SizedBox(height: 24),

            // Submit Dispute Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: (_floatTestPhotoUrl == null || _isSubmitting)
                    ? null
                    : () {
                        setState(() => _isSubmitting = true);
                        Future.delayed(const Duration(seconds: 1), () {
                          if (mounted) {
                            setState(() => _isSubmitting = false);
                            widget.onDisputeSubmitted();
                          }
                        });
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDC2626),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  disabledBackgroundColor: Colors.grey.shade300,
                ),
                child: _isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'विवाद सबमिट करें (Submit Refund Claim)',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
