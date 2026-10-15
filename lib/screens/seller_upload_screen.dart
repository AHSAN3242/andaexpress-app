import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Supported Farm Categories
enum ProductCategory { eggs, chicken }

/// Egg Sub-types in AndaExpress
enum EggSubType { desi, layer, organic, kadaknath }

/// Chicken Sub-types in AndaExpress
enum ChickenSubType { liveBroiler, desiCountry, kadaknathBreed }

class SellerProductUploadScreen extends StatefulWidget {
  final String sellerId;
  final Function(Map<String, dynamic> productPayload)? onProductUploaded;

  const SellerProductUploadScreen({
    super.key,
    required this.sellerId,
    this.onProductUploaded,
  });

  @override
  State<SellerProductUploadScreen> createState() => _SellerProductUploadScreenState();
}

class _SellerProductUploadScreenState extends State<SellerProductUploadScreen> {
  // Anti-fraud server-generated 4-digit Daily Unique Batch Code
  late final String _batchCode;

  ProductCategory _category = ProductCategory.eggs;
  String _subType = 'desi'; // 'desi' | 'layer' | 'organic' | 'kadaknath'

  final TextEditingController _quantityController = TextEditingController(text: '30');
  final TextEditingController _priceController = TextEditingController(text: '360');

  DateTime _layDate = DateTime.now();
  late DateTime _expiryDate;

  // Live Camera Only - No Gallery Allowed
  bool _isPhotoCaptured = false;
  bool _isCameraActive = false;
  String? _watermarkTimestamp;
  String? _watermarkGpsCoordinates;

  // Farmer Academy Mandatory Compliance Checkbox
  bool _hasAgreedToAcademy = false;
  bool _isUploading = false;

  static const Color primaryGreen = Color(0xFF1B5E20);
  static const Color sellerAmber = Color(0xFFD97706);
  static const Color softAmberBg = Color(0xFFFFFBEB);
  static const Color darkBg = Color(0xFF1E293B);

  @override
  void initState() {
    super.initState();
    // Simulate server-issued daily 4-digit unique batch code
    final randomDigits = 800 + (DateTime.now().millisecond % 199);
    _batchCode = '#EGG-$randomDigits';
    _expiryDate = _layDate.add(const Duration(days: 21)); // 21-day egg shelf life
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _triggerLiveCamera() {
    setState(() {
      _isCameraActive = true;
    });

    // Simulate Camera Sensor acquisition + Google NTP server time fetch + GPS lock
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (mounted) {
        final ntpNow = DateTime.now();
        final formattedNtp = DateFormat('yyyy-MM-dd HH:mm:ss \'NTP\'').format(ntpNow);
        const lockedGps = 'LAT: 28.2492° N | LON: 77.0620° E (±2m Accuracy)';

        setState(() {
          _isCameraActive = false;
          _isPhotoCaptured = true;
          _watermarkTimestamp = formattedNtp;
          _watermarkGpsCoordinates = lockedGps;
        });
      }
    });
  }

  void _handleSubmit() {
    if (!_isPhotoCaptured) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('लाइव कैमरा से फोटो खींचना अनिवार्य है (गैलरी अनुमति नहीं है)'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!_hasAgreedToAcademy) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('कृपया फार्मर अकादमी नियम और डेट स्टैम्पिंग चेकबॉक्स स्वीकार करें'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isUploading = true);

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() => _isUploading = false);
        final payload = {
          'product_id': 'prod_${DateTime.now().millisecondsSinceEpoch}',
          'seller_id': widget.sellerId,
          'category': _category.name,
          'egg_type': _subType,
          'price': double.tryParse(_priceController.text) ?? 0.0,
          'stock': int.tryParse(_quantityController.text) ?? 0,
          'lay_date': _layDate.toIso8601String(),
          'expiry_date': _expiryDate.toIso8601String(),
          'unique_batch_code': _batchCode,
          'photo_url': 'https://firebasestorage.googleapis.com/.../batch_proof.jpg',
          'network_timestamp': DateTime.now().toIso8601String(),
          'gps_lat_long': {'latitude': 28.2492, 'longitude': 77.0620},
          'academy_compliance_accepted': true,
        };

        widget.onProductUploaded?.call(payload);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('बैच $_batchCode सफलतापूर्वक प्रकाशित हुआ!'),
            backgroundColor: primaryGreen,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'नया फार्म बैच अपलोड करें',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              'Seller Batch Upload • Anti-Fraud Secured',
              style: TextStyle(fontSize: 11, color: Colors.white70),
            ),
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
                const Icon(Icons.qr_code_2, size: 14, color: Colors.black87),
                const SizedBox(width: 4),
                Text(
                  _batchCode,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Dynamic Server-Issued Batch Code Anti-Fraud Card
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: softAmberBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber.shade300),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.shield_outlined, color: Colors.amber, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'सर्वर-जेनरेटेड दैनिक यूनिक बैच कोड',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        Text(
                          'प्रत्येक ट्रे पर $_batchCode स्टैम्प अनिवार्य है। खरीदार सत्यापन के लिए कोड स्कैन करेंगे।',
                          style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    _batchCode,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFFB45309),
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Form Field 1: Category (Eggs / Chicken)
            const Text(
              '1. उत्पाद श्रेणी (Category)',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: _buildCategoryBtn(
                    title: 'अंडे (Eggs)',
                    emoji: '🥚',
                    isSelected: _category == ProductCategory.eggs,
                    onTap: () => setState(() {
                      _category = ProductCategory.eggs;
                      _subType = 'desi';
                    }),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildCategoryBtn(
                    title: 'चिकन (Chicken)',
                    emoji: '🐔',
                    isSelected: _category == ProductCategory.chicken,
                    onTap: () => setState(() {
                      _category = ProductCategory.chicken;
                      _subType = 'liveBroiler';
                    }),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Form Field 2: Sub-type (Desi / Layer / Kadaknath)
            const Text(
              '2. नस्ल / प्रकार (Sub-type)',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _subType,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down, color: primaryGreen),
                  items: _category == ProductCategory.eggs
                      ? const [
                          DropdownMenuItem(value: 'desi', child: Text('देसी अंडे (Desi Brown)')),
                          DropdownMenuItem(value: 'layer', child: Text('लेयर / टेबल अंडे (White Layer)')),
                          DropdownMenuItem(value: 'organic', child: Text('ऑर्गेनिक फ्री-रेंज (Organic Free-Range)')),
                          DropdownMenuItem(value: 'kadaknath', child: Text('कड़कनाथ काला अंडा (Kadaknath Black)')),
                        ]
                      : const [
                          DropdownMenuItem(value: 'liveBroiler', child: Text('ब्रॉयलर पोल्ट्री (Broiler Live)')),
                          DropdownMenuItem(value: 'desiCountry', child: Text('देसी मुर्गा / मुर्गी (Desi Country Fowl)')),
                          DropdownMenuItem(value: 'kadaknathBreed', child: Text('कड़कनाथ जीवित (Kadaknath Pure)')),
                        ],
                  onChanged: (val) => setState(() => _subType = val!),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Form Fields 3 & 4: Quantity & Price
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '3. मात्रा (Quantity)',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _quantityController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: '30',
                          suffixText: _category == ProductCategory.eggs ? 'ट्रे / अंडे' : 'किलो / पक्षी',
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '4. मूल्य (Price in ₹)',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      const SizedBox(height: 6),
                      TextField(
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          prefixText: '₹ ',
                          hintText: '360',
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Form Fields 5 & 6: Lay Date & Auto-Calculated Expiry Date
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '5. अंडे देने की तारीख (Lay Date)',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 16, color: primaryGreen),
                            const SizedBox(width: 8),
                            Text(
                              DateFormat('dd MMM yyyy').format(_layDate),
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '6. समाप्ति तारीख (Expiry Date)',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF2F2),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFFFCA5A5)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.event_busy, size: 16, color: Colors.red),
                            const SizedBox(width: 8),
                            Text(
                              DateFormat('dd MMM yyyy').format(_expiryDate),
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Live Camera Only - No Gallery Allowed Notice & Frame
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'लाइव कैमरा प्रूफ (केवल कैमरा - गैलरी बंद)',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                Text(
                  'Gallery Selection Disabled',
                  style: TextStyle(fontSize: 10, color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Camera Simulation Box with Watermarking Overlay
            Container(
              height: 210,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: primaryGreen, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Photo View or Active Camera Simulator
                  if (_isPhotoCaptured)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.network(
                        'https://images.unsplash.com/photo-1582722872445-44dc5f7e3c8f?auto=format&fit=crop&w=600&q=80',
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    )
                  else if (_isCameraActive)
                    const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(color: Colors.amber),
                          SizedBox(height: 12),
                          Text(
                            'Connecting Google NTP Server & Locking GPS...',
                            style: TextStyle(color: Colors.white, fontSize: 11),
                          ),
                        ],
                      ),
                    )
                  else
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.camera_alt_outlined, color: Colors.white70, size: 38),
                          const SizedBox(height: 8),
                          const Text(
                            'लाइव कैमरा से ताज़ा अंडे की फोटो खींचें',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'गैलरी से अपलोड पूरी तरह प्रतिबंधित है (Anti-Fraud)',
                            style: TextStyle(color: Colors.red.shade300, fontSize: 11),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton.icon(
                            onPressed: _triggerLiveCamera,
                            icon: const Icon(Icons.camera),
                            label: const Text('लाइव कैमरा चालू करें (Live Camera Only)'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryGreen,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Simulated Live Watermarking Overlay directly on captured photo
                  if (_isPhotoCaptured) ...[
                    // Retake Live Camera Button
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: _triggerLiveCamera,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.refresh, size: 12, color: Colors.white),
                              SizedBox(width: 4),
                              Text('Retake (Live)', style: TextStyle(color: Colors.white, fontSize: 10)),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Top Left: Unique Batch Code Watermark
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade600,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'BATCH: $_batchCode',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),

                    // Bottom: Auto-Watermarked Google NTP Time + GPS Lat/Long
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.85),
                          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(14)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.cloud_done, size: 12, color: Colors.greenAccent),
                                const SizedBox(width: 4),
                                Text(
                                  _watermarkTimestamp ?? '',
                                  style: const TextStyle(
                                    color: Colors.greenAccent,
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Row(
                              children: [
                                const Icon(Icons.location_on, size: 12, color: Colors.amberAccent),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    _watermarkGpsCoordinates ?? '',
                                    style: const TextStyle(
                                      color: Colors.amberAccent,
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'monospace',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Mandatory Farmer Academy Compliance Checkbox
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _hasAgreedToAcademy ? const Color(0xFFF0FDF4) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _hasAgreedToAcademy ? primaryGreen : Colors.grey.shade300,
                  width: _hasAgreedToAcademy ? 1.5 : 1,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: _hasAgreedToAcademy,
                    activeColor: primaryGreen,
                    onChanged: (val) => setState(() => _hasAgreedToAcademy = val ?? false),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _hasAgreedToAcademy = !_hasAgreedToAcademy),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'मैंने डेट स्टैम्पिंग और सुरक्षित पैकिंग गाइड समझ ली है',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'मैं पुष्टि करता हूँ कि अंडे 24 घंटे के भीतर निकाले गए हैं और बैच कोड ($_batchCode) कार्टन पर स्पष्ट रूप से अंकित है।',
                            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Upload / Publish Batch Action Button
            ElevatedButton(
              onPressed: _isUploading ? null : _handleSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: _isUploading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.cloud_upload_outlined),
                      const SizedBox(width: 8),
                      Text(
                        'बैच प्रकाशित करें ($_batchCode)',
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
            ),

            const SizedBox(height: 12),
            const Text(
              'AndaExpress Anti-Fraud Engine • Google NTP Synced • Gallery Selection Blocked',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryBtn({
    required String title,
    required String emoji,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? primaryGreen : Colors.transparent,
            width: 2,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: primaryGreen.withOpacity(0.1), blurRadius: 6, offset: const Offset(0, 2))]
              : [],
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? primaryGreen : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
