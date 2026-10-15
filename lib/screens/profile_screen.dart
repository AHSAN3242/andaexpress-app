import 'package:flutter/material.dart';

/// User Role for Onboarding & Profile Setup
enum ProfileUserRole {
  farmer,
  commuter,
  buyer,
}

/// Commuter Vehicle Options
enum CommuterVehicleType {
  bike,
  cruiserTaxi,
  autoRickshaw,
  busTransport,
}

/// Profile Data Model
class UserProfileData {
  // Common
  String name;
  String phone;
  ProfileUserRole role;

  // Farmer Specific
  String farmName;
  String farmerUpiId;
  String farmerGpsLocation;
  String fssaiNumber;

  // Commuter Specific
  String commuterUpiId;
  CommuterVehicleType vehicleType;
  String commuteRoute;
  String dailyTiming;

  // Buyer Specific
  String preferredBusStop;
  String deliveryNotes;

  UserProfileData({
    this.name = 'Chhabra Organic Farms',
    this.phone = '+91 98223 34455',
    this.role = ProfileUserRole.farmer,
    this.farmName = 'Chhabra Organic Poultry Farms',
    this.farmerUpiId = 'chhabra.poultry@icici',
    this.farmerGpsLocation = 'LAT: 20.7002° N | LON: 77.0082° E (Paras Belt)',
    this.fssaiNumber = 'FSSAI-MH-2026-88910',
    this.commuterUpiId = 'santosh.gawande@okhdfcbank',
    this.vehicleType = CommuterVehicleType.busTransport,
    this.commuteRoute = 'Paras Depot ➡️ Akola Bus Stand (Gate 1)',
    this.dailyTiming = '10:30 AM (Morning) & 06:15 PM (Evening)',
    this.preferredBusStop = 'अकोला बस स्टैंड गेट नं 1 (Akola Bus Stand Gate 1)',
    this.deliveryNotes = 'Near inquiry booth, please call 10 mins before arrival',
  });
}

class ProfileScreen extends StatefulWidget {
  final UserProfileData? initialProfile;
  final Function(UserProfileData updatedProfile)? onProfileSaved;

  const ProfileScreen({
    super.key,
    this.initialProfile,
    this.onProfileSaved,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late ProfileUserRole _selectedRole;

  // Controllers
  late TextEditingController _nameController;
  late TextEditingController _phoneController;

  // Farmer controllers
  late TextEditingController _farmNameController;
  late TextEditingController _farmerUpiController;
  late TextEditingController _farmerGpsController;
  late TextEditingController _fssaiController;

  // Commuter controllers
  late TextEditingController _commuterUpiController;
  late CommuterVehicleType _selectedVehicle;
  late String _selectedRoute;
  late TextEditingController _dailyTimingController;

  // Buyer controllers
  late String _selectedBusStop;
  late TextEditingController _deliveryNotesController;

  bool _isAutoDetectingGps = false;
  bool _isSaved = false;

  static const Color primaryGreen = Color(0xFF1B5E20);
  static const Color commuterBlue = Color(0xFF1E3A8A);
  static const Color amberAccent = Color(0xFFD97706);

  final List<String> _routes = [
    'Paras Depot ➡️ Akola Bus Stand (Gate 1)',
    'Paras Depot ➡️ Akola Stand (Gate 2)',
    'Paras Highway ➡️ Akola City Hub (Nimwadi)',
    'Akola Bus Stand ➡️ Paras Return Run',
  ];

  final List<String> _busStops = [
    'अकोला बस स्टैंड गेट नं 1 (Akola Bus Stand Gate 1)',
    'अकोला बस स्टैंड गेट नं 2 (श्रीनाथ डेयरी हब)',
    'निमवाड़ी स्टैंड चौक (Nimwadi Stand Square)',
    'कौशल्य नगर कॉर्नर (Kaushalya Nagar)',
  ];

  @override
  void initState() {
    super.initState();
    final p = widget.initialProfile ?? UserProfileData();
    _selectedRole = p.role;
    _nameController = TextEditingController(text: p.name);
    _phoneController = TextEditingController(text: p.phone);

    _farmNameController = TextEditingController(text: p.farmName);
    _farmerUpiController = TextEditingController(text: p.farmerUpiId);
    _farmerGpsController = TextEditingController(text: p.farmerGpsLocation);
    _fssaiController = TextEditingController(text: p.fssaiNumber);

    _commuterUpiController = TextEditingController(text: p.commuterUpiId);
    _selectedVehicle = p.vehicleType;
    _selectedRoute = p.commuteRoute;
    _dailyTimingController = TextEditingController(text: p.dailyTiming);

    _selectedBusStop = p.preferredBusStop;
    _deliveryNotesController = TextEditingController(text: p.deliveryNotes);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _farmNameController.dispose();
    _farmerUpiController.dispose();
    _farmerGpsController.dispose();
    _fssaiController.dispose();
    _commuterUpiController.dispose();
    _dailyTimingController.dispose();
    _deliveryNotesController.dispose();
    super.dispose();
  }

  void _autoDetectGpsPin() {
    setState(() => _isAutoDetectingGps = true);
    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) {
        setState(() {
          _isAutoDetectingGps = false;
          _farmerGpsController.text =
              'LAT: 20.7002° N | LON: 77.0082° E (Certified GPS Lock: Paras Farm Belt)';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✓ सटीक GPS पिन सफलतापूर्वक लॉक हुआ! (Paras Outskirts)'),
            backgroundColor: primaryGreen,
          ),
        );
      }
    });
  }

  void _saveProfile() {
    final updated = UserProfileData(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      role: _selectedRole,
      farmName: _farmNameController.text.trim(),
      farmerUpiId: _farmerUpiController.text.trim(),
      farmerGpsLocation: _farmerGpsController.text.trim(),
      fssaiNumber: _fssaiController.text.trim(),
      commuterUpiId: _commuterUpiController.text.trim(),
      vehicleType: _selectedVehicle,
      commuteRoute: _selectedRoute,
      dailyTiming: _dailyTimingController.text.trim(),
      preferredBusStop: _selectedBusStop,
      deliveryNotes: _deliveryNotesController.text.trim(),
    );

    widget.onProfileSaved?.call(updated);

    setState(() => _isSaved = true);
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _isSaved = false);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'प्रोफाइल व KYC सफलतापूर्वक अपडेट हुआ! (${_selectedRole == ProfileUserRole.farmer ? "किसान UPI: ${_farmerUpiController.text}" : _selectedRole == ProfileUserRole.commuter ? "कम्यूटर वाहन: ${_getVehicleLabel(_selectedVehicle)}" : "पसंदीदा स्टॉप: $_selectedBusStop"})',
        ),
        backgroundColor: primaryGreen,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  String _getVehicleLabel(CommuterVehicleType v) {
    switch (v) {
      case CommuterVehicleType.bike:
        return 'टू-व्हीलर / बाइक (Two-Wheeler / Bike)';
      case CommuterVehicleType.cruiserTaxi:
        return 'शेयरिंग टैक्सी / क्रूज़र (Sharing Taxi / Cruiser)';
      case CommuterVehicleType.autoRickshaw:
        return 'ऑटो रिक्शा (Auto Rickshaw)';
      case CommuterVehicleType.busTransport:
        return 'प्राइवेट ट्रांसपोर्ट / बस (Private Bus / Transport)';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.slate.shade700),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: amberAccent.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: amberAccent),
                    ),
                    child: const Center(
                      child: Text('🪪', style: TextStyle(fontSize: 26)),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'यूज़र प्रोफाइल व KYC ऑनबोर्डिंग',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        SizedBox(height: 3),
                        Text(
                          'भूमिका अनुसार UPI VPA, वाहन और बस स्टैंड स्टॉप सेटअप',
                          style: TextStyle(fontSize: 11, color: Colors.amber),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Role Selector Segment
            const Text(
              'आपकी भूमिका चुनें (Select Onboarding Role):',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87),
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                _buildRoleButton(ProfileUserRole.farmer, '🧑‍🌾 किसान (Farmer)', primaryGreen),
                const SizedBox(width: 8),
                _buildRoleButton(ProfileUserRole.commuter, '🚌 कम्यूटर (Commuter)', commuterBlue),
                const SizedBox(width: 8),
                _buildRoleButton(ProfileUserRole.buyer, '🛒 खरीदार (Buyer)', const Color(0xFF0D9488)),
              ],
            ),

            const SizedBox(height: 18),

            // Common User Details Card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'प्राथमिक संपर्क विवरण (Primary Contact)',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black87),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'पूरा नाम (Full Name / Organization)',
                      prefixIcon: const Icon(Icons.person_outline, size: 20),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'मोबाइल नंबर (Phone Number)',
                      prefixIcon: const Icon(Icons.phone_outlined, size: 20),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ==========================================
            // A. FARMER SPECIFIC SETUP
            // ==========================================
            if (_selectedRole == ProfileUserRole.farmer) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: primaryGreen.withOpacity(0.4), width: 1.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.agriculture, color: primaryGreen, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'A. किसान प्रोफाइल व सीधे UPI भुगतान सेटअप',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: primaryGreen),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Direct UPI ID / VPA field
                    TextField(
                      controller: _farmerUpiController,
                      decoration: InputDecoration(
                        labelText: 'सीधा UPI VPA आईडी (Direct Farmer UPI ID)*',
                        hintText: 'उदा. chhabra.poultry@icici या kisan@upi',
                        helperText: 'चेकआउट QR कोड में यह UPI आईडी डायनेमिक रूप से उपयोग होगी (100% शून्य कमीशन)',
                        helperStyle: const TextStyle(color: primaryGreen, fontSize: 10.5),
                        prefixIcon: const Icon(Icons.qr_code, color: primaryGreen, size: 20),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Farm Name
                    TextField(
                      controller: _farmNameController,
                      decoration: InputDecoration(
                        labelText: 'फार्म का नाम (Registered Farm Name)',
                        hintText: 'उदा. Chhabra Organic Poultry Farms',
                        prefixIcon: const Icon(Icons.storefront_outlined, size: 20),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Auto-detect GPS Pin
                    TextField(
                      controller: _farmerGpsController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'खेत का GPS पिन (Auto-detect GPS Pin)',
                        prefixIcon: const Icon(Icons.my_location, color: Colors.blue, size: 20),
                        suffixIcon: _isAutoDetectingGps
                            ? const Padding(
                                padding: EdgeInsets.all(12),
                                child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
                              )
                            : TextButton.icon(
                                onPressed: _autoDetectGpsPin,
                                icon: const Icon(Icons.gps_fixed, size: 16, color: primaryGreen),
                                label: const Text('ऑटो पिन', style: TextStyle(color: primaryGreen, fontSize: 11, fontWeight: FontWeight.bold)),
                              ),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // FSSAI / Certification
                    TextField(
                      controller: _fssaiController,
                      decoration: InputDecoration(
                        labelText: 'FSSAI / स्थानीय ग्राम पंचायत लाइसेंस संख्या',
                        hintText: 'FSSAI-MH-2026-88910',
                        prefixIcon: const Icon(Icons.verified_outlined, size: 20),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // ==========================================
            // B. COMMUTER PROFILE & TRANSPORT SETUP
            // ==========================================
            if (_selectedRole == ProfileUserRole.commuter) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: commuterBlue.withOpacity(0.4), width: 1.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.directions_bus, color: commuterBlue, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'B. कम्यूटर प्रोफाइल व परिवहन सेटअप',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: commuterBlue),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Commuter UPI ID
                    TextField(
                      controller: _commuterUpiController,
                      decoration: InputDecoration(
                        labelText: 'कम्यूटर UPI ID (किराया भुगतान सेटलमेंट हेतु)*',
                        hintText: 'उदा. santosh.gawande@okhdfcbank',
                        helperText: 'प्रत्येक सफल 2-मिनट हैंडशेक के बाद ₹30/ट्रे किराया सीधे इस UPI में क्रेडिट होगा',
                        helperStyle: const TextStyle(color: commuterBlue, fontSize: 10.5),
                        prefixIcon: const Icon(Icons.account_balance_wallet_outlined, color: commuterBlue, size: 20),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Commuter Vehicle Selection: [ Two-Wheeler / Bike | Sharing Taxi / Cruiser | Auto Rickshaw | Private Transport / Bus ]
                    const Text(
                      'परिवहन का साधन (Select Vehicle Type):*',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11.5, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<CommuterVehicleType>(
                          isExpanded: true,
                          value: _selectedVehicle,
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedVehicle = val);
                          },
                          items: CommuterVehicleType.values.map((v) {
                            return DropdownMenuItem(
                              value: v,
                              child: Text(_getVehicleLabel(v), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                            );
                          }).toList(),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Daily Commute Route selection (e.g. Paras <-> Akola)
                    const Text(
                      'दैनिक आवागमन मार्ग (Daily Commute Route):*',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11.5, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: _selectedRoute,
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedRoute = val);
                          },
                          items: _routes.map((r) {
                            return DropdownMenuItem(
                              value: r,
                              child: Text(r, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                            );
                          }).toList(),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Daily Timing
                    TextField(
                      controller: _dailyTimingController,
                      decoration: InputDecoration(
                        labelText: 'नियमित प्रस्थान समय (Daily Departure Timings)',
                        prefixIcon: const Icon(Icons.access_time, size: 20),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // ==========================================
            // C. BUYER PROFILE
            // ==========================================
            if (_selectedRole == ProfileUserRole.buyer) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF0D9488).withOpacity(0.4), width: 1.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.shopping_bag_outlined, color: Color(0xFF0D9488), size: 20),
                        SizedBox(width: 8),
                        Text(
                          'C. खरीदार प्रोफाइल व बस स्टॉप प्राथमिकता',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0D9488)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Delivery bus stop preference
                    const Text(
                      'पसंदीदा डिलीवरी बस स्टॉप (Preferred Delivery Bus Stop):*',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11.5, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: _selectedBusStop,
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedBusStop = val);
                          },
                          items: _busStops.map((s) {
                            return DropdownMenuItem(
                              value: s,
                              child: Text(s, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                            );
                          }).toList(),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Delivery notes
                    TextField(
                      controller: _deliveryNotesController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: 'हैंडओवर निर्देश व लैंडमार्क (Handover Notes)',
                        hintText: 'उदा. पूछताछ बूथ के पास, आगमन से 10 मिनट पहले कॉल करें',
                        prefixIcon: const Icon(Icons.notes, size: 20),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 20),

            // Save / Update Profile Action Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedRole == ProfileUserRole.farmer
                      ? primaryGreen
                      : _selectedRole == ProfileUserRole.commuter
                          ? commuterBlue
                          : const Color(0xFF0D9488),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                ),
                icon: Icon(_isSaved ? Icons.check_circle : Icons.save, size: 20),
                label: Text(
                  _isSaved ? 'प्रोफाइल सहेज ली गई (Saved) ✓' : 'प्रोफाइल व KYC सहेजें (Save Profile & KYC)',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleButton(ProfileUserRole role, String label, Color color) {
    final isSelected = _selectedRole == role;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedRole = role),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected ? color : Colors.white,
            border: Border.all(color: isSelected ? color : Colors.grey.shade300, width: isSelected ? 2 : 1),
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected
                ? [BoxShadow(color: color.withOpacity(0.2), blurRadius: 4, offset: const Offset(0, 2))]
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
