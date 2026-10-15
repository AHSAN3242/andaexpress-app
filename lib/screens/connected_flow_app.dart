import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../config/pricing_config.dart';
import 'customer_feed_screen.dart';
import 'checkout_screen.dart';
import 'dispute_screen.dart';
import 'seller_upload_screen.dart';
import 'add_listing_screen.dart';
import 'commuter_trip_screen.dart';
import 'seller_wallet_screen.dart';
import 'city_hub_screen.dart';
import 'login_screen.dart';
import 'admin_control_panel.dart';
import 'profile_screen.dart';
import 'order_invoice_screen.dart';

/// Top-level Navigation Screens in AndaExpress Flutter Client
enum MobileScreenTab {
  customerHome,
  checkout,
  dispute,
  sellerUpload,
  commuterTrip,
  sellerWallet,
  cityHub,
  login,
  adminPanel,
  profile,
  orderInvoice,
}

/// 4-Party Role in AndaExpress Real-Time Ecosystem
enum ActiveRoleParty {
  farmer,   // 🧑‍🌾 Farmer / Producer
  commuter, // 🚌 Daily Commuter Dispatcher
  buyer,    // 🛒 Buyer / Consumer
  cityHub,  // 🏪 City Hub Shop Owner
}

/// Synchronized Shared Lifecycle State across all 4 Parties
class SharedParcelLifecycleState {
  String orderId;
  String buyerName;
  String buyerPhone;
  String eggSummary;
  String cargoCategory; // 'eggs', 'live_poultry', 'quails'
  int quantity;
  bool isDistinctBuyer;
  double discountPercent;
  int trays;
  double parcelAmount;
  double commuterFee;
  double hubFee;
  double platformFee; // Platform fee calculated based on bulk micro-tiers
  String platformFeeTier;
  String paymentPolicy; // 'advanceToken50' or 'fullCod100'
  String legSealNumber; // Tamper-evident leg seal tag for live poultry
  String scaleWatermark; // Certified scale proof
  String handshakeOtp; // 4-digit zero-cost in-app OTP
  bool isPaymentConfirmed; // Confirmed by Farmer UPI
  bool isOtpUnlocked;
  String status; // 'payment_pending', 'in_transit', 'arrived_stand', 'dropped_at_hub', 'delivered'
  String currentCustody; // 'farmer', 'commuter', 'hub_shop', 'buyer'
  String destinationAddress;
  String hubShopName;

  SharedParcelLifecycleState({
    required this.orderId,
    required this.buyerName,
    required this.buyerPhone,
    required this.eggSummary,
    this.cargoCategory = 'eggs',
    this.quantity = 12,
    this.isDistinctBuyer = false,
    this.discountPercent = 10.0,
    this.trays = 12,
    this.parcelAmount = 4320.0,
    this.commuterFee = 324.0, // 12 trays * ₹30 = ₹360 - 10% discount = ₹324.0
    this.hubFee = PricingConfig.cityHubDropFee,
    this.platformFee = 360.0, // 12 trays @ ₹30.00/tray (Tier 1: ₹1/egg)
    this.platformFeeTier = 'Tier 1: 1-30 Trays (₹1.00/अंडा = ₹30/ट्रे)',
    this.paymentPolicy = 'advanceToken50', // 50% Advance Token vs 100% COD
    this.legSealNumber = 'SEAL-MH-30-7492',
    this.scaleWatermark = 'LAT: 20.7002° N | LON: 77.0082° E • Verified Scale',
    this.handshakeOtp = '4821',
    this.isPaymentConfirmed = false,
    this.isOtpUnlocked = false,
    this.status = 'payment_pending',
    this.currentCustody = 'farmer',
    this.destinationAddress = 'अकोला बस स्टैंड गेट 1 (2-Min Handshake)',
    this.hubShopName = 'श्रीनाथ डेयरी व सिटी हब (अकोला बस स्टैंड गेट 2)',
  });
}

class AndaExpressConnectedFlowApp extends StatefulWidget {
  const AndaExpressConnectedFlowApp({super.key});

  @override
  State<AndaExpressConnectedFlowApp> createState() => _AndaExpressConnectedFlowAppState();
}

class _AndaExpressConnectedFlowAppState extends State<AndaExpressConnectedFlowApp> {
  MobileScreenTab _currentTab = MobileScreenTab.customerHome;
  ActiveRoleParty _activeParty = ActiveRoleParty.buyer;
  final List<MobileScreenTab> _history = [];

  static const Color primaryGreen = Color(0xFF1B5E20);
  static const Color commuterBlue = Color(0xFF1E3A8A);
  static const Color hubPurple = Color(0xFF581C87);

  // User Profile & KYC Onboarding State
  UserProfileData _userProfile = UserProfileData();

  // Synchronized 4-Party Real-Time Order Lifecycle State
  final SharedParcelLifecycleState _sharedOrder = SharedParcelLifecycleState(
    orderId: 'ORD-AKL-842',
    buyerName: 'Rahul Sharma (राहुल शर्मा)',
    buyerPhone: '+91 98112 23344',
    eggSummary: 'देसी फ्री-रेंज अंडे (12 Trays)',
    cargoCategory: 'eggs',
    quantity: 12,
    isDistinctBuyer: false,
    discountPercent: PricingConfig.eggBulkDiscountPercent,
    trays: 12,
    parcelAmount: 4320.0,
    commuterFee: 324.0, // 12 trays @ ₹30 - 10% discount = ₹324.00
    hubFee: PricingConfig.cityHubDropFee,
    handshakeOtp: '4821',
    isPaymentConfirmed: false,
    isOtpUnlocked: false,
    status: 'payment_pending',
    currentCustody: 'farmer',
    destinationAddress: 'अकोला बस स्टैंड गेट 1 (2-Min Handshake)',
    hubShopName: 'श्रीनाथ डेयरी व सिटी हब (अकोला बस स्टैंड गेट 2)',
  );

  // Cart State shared across app
  final List<Map<String, dynamic>> _cartItems = [
    {
      'id': 'prod_desi_egg_30',
      'title': 'देसी फ्री-रेंज अंडे (Desi Free-Range Eggs 30s)',
      'price': 340,
      'quantity': 1,
      'batch_code': '#EGG-842',
    },
    {
      'id': 'prod_kadaknath_egg_12',
      'title': 'कड़कनाथ ब्लैक अंडे (Pure Kadaknath Eggs 12s)',
      'price': 480,
      'quantity': 1,
      'batch_code': '#KAD-119',
    },
  ];

  void _navigateTo(MobileScreenTab tab) {
    if (_currentTab != tab) {
      setState(() {
        _history.add(_currentTab);
        _currentTab = tab;
        // Sync party role based on selected tab
        if (tab == MobileScreenTab.sellerUpload || tab == MobileScreenTab.sellerWallet) {
          _activeParty = ActiveRoleParty.farmer;
        } else if (tab == MobileScreenTab.commuterTrip) {
          _activeParty = ActiveRoleParty.commuter;
        } else if (tab == MobileScreenTab.cityHub) {
          _activeParty = ActiveRoleParty.cityHub;
        } else if (tab == MobileScreenTab.customerHome || tab == MobileScreenTab.checkout) {
          _activeParty = ActiveRoleParty.buyer;
        }
      });
    }
  }

  void _selectPartyRole(ActiveRoleParty party) {
    setState(() {
      _activeParty = party;
      switch (party) {
        case ActiveRoleParty.farmer:
          _currentTab = MobileScreenTab.sellerUpload;
          break;
        case ActiveRoleParty.commuter:
          _currentTab = MobileScreenTab.commuterTrip;
          break;
        case ActiveRoleParty.buyer:
          _currentTab = MobileScreenTab.customerHome;
          break;
        case ActiveRoleParty.cityHub:
          _currentTab = MobileScreenTab.cityHub;
          break;
      }
    });
  }

  void _handleBack() {
    if (_history.isNotEmpty) {
      setState(() {
        _currentTab = _history.removeLast();
      });
    } else {
      _navigateTo(MobileScreenTab.customerHome);
    }
  }

  void _handleAddToCart(String productId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('कार्ट में जोड़ा गया! चेकआउट के लिए टैप करें'),
        backgroundColor: primaryGreen,
        action: SnackBarAction(
          label: 'चेकआउट',
          textColor: Colors.amber,
          onPressed: () => _navigateTo(MobileScreenTab.checkout),
        ),
      ),
    );
  }

  // SIMULATION: Confirm Payment -> Unlocks OTP on Buyer screen
  void _simulateConfirmPayment() {
    setState(() {
      _sharedOrder.isPaymentConfirmed = true;
      _sharedOrder.isOtpUnlocked = true;
      if (_sharedOrder.status == 'payment_pending') {
        _sharedOrder.status = 'in_transit';
        _sharedOrder.currentCustody = 'commuter';
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '✓ UPI भुगतान सत्यापित! शून्य-लागत OTP (${_sharedOrder.handshakeOtp}) खरीदार स्क्रीन पर अनलॉक हुआ। कस्टडी: कम्यूटर।',
        ),
        backgroundColor: primaryGreen,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  // SIMULATION: Commuter drops at Hub -> Transfers custody to City Hub Shop
  void _simulateDropAtCityHubShop() {
    setState(() {
      _sharedOrder.status = 'dropped_at_hub';
      _sharedOrder.currentCustody = 'hub_shop';
      _sharedOrder.destinationAddress = _sharedOrder.hubShopName;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '🏢 कस्टडी ट्रांसफर! पार्सल ${_sharedOrder.orderId} श्रीनाथ डेयरी हब पर जमा हुआ (+₹5 शुल्क)। खरीदार पिकअप स्थान स्वतः अपडेट हुआ।',
        ),
        backgroundColor: Colors.blue.shade900,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  // SIMULATION: Complete OTP Delivery Handover
  void _simulateCompleteDelivery() {
    setState(() {
      _sharedOrder.status = 'delivered';
      _sharedOrder.currentCustody = 'buyer';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '🎉 डिलीवरी संपन्न! खरीदार ने OTP ${_sharedOrder.handshakeOtp} देकर अंडे प्राप्त किए। 4-पक्षीय सिंक पूर्ण।',
        ),
        backgroundColor: primaryGreen,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _showFloatTestInfoModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('🥚 पानी में फ्लोट टेस्ट का विज्ञान', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                ],
              ),
              const SizedBox(height: 10),
              const ListTile(
                leading: Icon(Icons.check_circle, color: Colors.green),
                title: Text('पूरी तरह डूबा (0-7 दिन पुराना)'),
                subtitle: Text('ताज़ा अंडा पानी के तल पर क्षैतिज रूप से बैठता है।'),
              ),
              const ListTile(
                leading: Icon(Icons.warning, color: Colors.amber),
                title: Text('खड़ा हुआ (10-18 दिन पुराना)'),
                subtitle: Text('अंडे का चौड़ा सिरा ऊपर उठता है (एयर पॉकेट बढ़ जाती है)।'),
              ),
              const ListTile(
                leading: Icon(Icons.cancel, color: Colors.red),
                title: Text('पानी पर तैरता हुआ (21+ दिन - बासी)'),
                subtitle: Text('अंडा पानी पर तैरता है। यह तुरंत 100% रिफंड के लिए योग्य है!'),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _navigateTo(MobileScreenTab.dispute);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade700, foregroundColor: Colors.white),
                  child: const Text('विवाद दर्ज करें (Open Float-Test Dispute)'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _getTitleForTab(_currentTab),
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        leading: _currentTab != MobileScreenTab.customerHome
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _handleBack,
              )
            : const Padding(
                padding: EdgeInsets.all(12),
                child: Icon(Icons.egg, color: Colors.amber),
              ),
        actions: [
          // Wallet Shortcut Button
          IconButton(
            icon: const Icon(Icons.account_balance_wallet_outlined),
            tooltip: 'विक्रेता प्रीपेड वॉलेट (Seller Wallet)',
            onPressed: () => _navigateTo(MobileScreenTab.sellerWallet),
          ),
          // City Hub Shortcut Button
          IconButton(
            icon: const Icon(Icons.storefront_outlined),
            tooltip: 'सिटी हब दुकान (City Hub Shop)',
            onPressed: () => _navigateTo(MobileScreenTab.cityHub),
          ),
          // Commuter Run Button
          IconButton(
            icon: const Icon(Icons.directions_bus),
            tooltip: 'कम्यूटर ट्रिप व डिस्पैच (Paras ➡️ Akola)',
            onPressed: () => _navigateTo(MobileScreenTab.commuterTrip),
          ),
          // Web Admin Control Panel Button
          IconButton(
            icon: const Icon(Icons.shield_outlined, color: Colors.amber),
            tooltip: 'वेब एडमिन कंट्रोल पैनल (Admin Panel)',
            onPressed: () => _navigateTo(MobileScreenTab.adminPanel),
          ),
          if (_currentTab != MobileScreenTab.checkout)
            IconButton(
              icon: Stack(
                children: [
                  const Icon(Icons.shopping_bag_outlined),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(color: Colors.amber, shape: BoxShape.circle),
                      constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                      child: Text(
                        '${_cartItems.length}',
                        style: const TextStyle(fontSize: 9, color: Colors.black, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
              onPressed: () => _navigateTo(MobileScreenTab.checkout),
            ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: Colors.black.withOpacity(0.15),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildPartyRoleChip(ActiveRoleParty.farmer, '🧑‍🌾 1. किसान (Farmer)'),
                  const SizedBox(width: 6),
                  _buildPartyRoleChip(ActiveRoleParty.commuter, '🚌 2. कम्यूटर (Commuter)'),
                  const SizedBox(width: 6),
                  _buildPartyRoleChip(ActiveRoleParty.buyer, '🛒 3. खरीदार (Buyer)'),
                  const SizedBox(width: 6),
                  _buildPartyRoleChip(ActiveRoleParty.cityHub, '🏪 4. सिटी हब (City Hub)'),
                  const SizedBox(width: 6),
                  InkWell(
                    onTap: () => _navigateTo(MobileScreenTab.adminPanel),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: _currentTab == MobileScreenTab.adminPanel ? Colors.amber : Colors.white24,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: _currentTab == MobileScreenTab.adminPanel ? Colors.white : Colors.amber.shade400),
                      ),
                      child: Text(
                        '🛡️ 5. एडमिन (Admin)',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: _currentTab == MobileScreenTab.adminPanel ? Colors.black87 : Colors.amber.shade200,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Synchronized Shared Order State Banner
          _buildSharedSyncStatusBar(),
          // Main tab content
          Expanded(child: _buildScreenForTab(_currentTab)),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTab == MobileScreenTab.customerHome
            ? 0
            : _currentTab == MobileScreenTab.checkout
                ? 1
                : _currentTab == MobileScreenTab.dispute
                    ? 2
                    : (_currentTab == MobileScreenTab.sellerUpload || _currentTab == MobileScreenTab.sellerWallet)
                        ? 3
                        : (_currentTab == MobileScreenTab.profile || _currentTab == MobileScreenTab.login)
                            ? 4
                            : 0,
        onTap: (index) {
          switch (index) {
            case 0:
              _navigateTo(MobileScreenTab.customerHome);
              break;
            case 1:
              _navigateTo(MobileScreenTab.checkout);
              break;
            case 2:
              _navigateTo(MobileScreenTab.dispute);
              break;
            case 3:
              _navigateTo(MobileScreenTab.sellerUpload);
              break;
            case 4:
              _navigateTo(MobileScreenTab.profile);
              break;
          }
        },
        selectedItemColor: _currentTab == MobileScreenTab.dispute ? const Color(0xFFDC2626) : primaryGreen,
        unselectedItemColor: Colors.grey.shade600,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home Feed'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Checkout'),
          BottomNavigationBarItem(icon: Icon(Icons.report_problem), label: 'Dispute'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory_2), label: 'Seller/Hub'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile / KYC'),
        ],
      ),
    );
  }

  Widget _buildPartyRoleChip(ActiveRoleParty party, String label) {
    final isSelected = _activeParty == party;
    return InkWell(
      onTap: () => _selectPartyRole(party),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? Colors.amber : Colors.white24,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? Colors.white : Colors.transparent),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.black87 : Colors.white,
          ),
        ),
      ),
    );
  }

  /// Live Synchronized Order Status & OTP Card
  Widget _buildSharedSyncStatusBar() {
    final isUnlocked = _sharedOrder.isOtpUnlocked;
    final isDelivered = _sharedOrder.status == 'delivered';
    final isDroppedAtHub = _sharedOrder.status == 'dropped_at_hub';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDelivered
            ? const Color(0xFFF0FDF4)
            : isDroppedAtHub
                ? const Color(0xFFEFF6FF)
                : const Color(0xFFFFFBEB),
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                isDelivered
                    ? Icons.check_circle
                    : isDroppedAtHub
                        ? Icons.storefront
                        : Icons.sync,
                size: 16,
                color: isDelivered ? primaryGreen : commuterBlue,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'ऑर्डर ${_sharedOrder.orderId} • कस्टडी: ${_sharedOrder.currentCustody.toUpperCase()}',
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
              // OTP Badge (Locked / Unlocked)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: isUnlocked ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: isUnlocked ? Colors.green : Colors.red.shade300),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isUnlocked ? Icons.lock_open : Icons.lock,
                      size: 12,
                      color: isUnlocked ? const Color(0xFF15803D) : Colors.red,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isUnlocked ? 'OTP: ${_sharedOrder.handshakeOtp}' : 'OTP Locked',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                        color: isUnlocked ? const Color(0xFF15803D) : Colors.red.shade800,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isDroppedAtHub
                    ? '📍 पिकअप: ${_sharedOrder.destinationAddress}'
                    : '📍 गंतव्य: ${_sharedOrder.destinationAddress}',
                style: TextStyle(fontSize: 10, color: Colors.grey.shade700),
              ),
              // Simulation Trigger Buttons
              if (!_sharedOrder.isPaymentConfirmed)
                InkWell(
                  onTap: _simulateConfirmPayment,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: primaryGreen,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      '⚡ Confirm Payment (Unlock OTP)',
                      style: TextStyle(fontSize: 9.5, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              else if (!isDroppedAtHub && !isDelivered)
                InkWell(
                  onTap: _simulateDropAtCityHubShop,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: commuterBlue,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '🏢 Drop at City Hub (+₹${PricingConfig.cityHubDropFee.toStringAsFixed(0)})',
                      style: const TextStyle(fontSize: 9.5, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              else if (isDroppedAtHub && !isDelivered)
                InkWell(
                  onTap: _simulateCompleteDelivery,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: primaryGreen,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      '✓ Complete Hub OTP Handover',
                      style: TextStyle(fontSize: 9.5, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              else if (isDelivered)
                InkWell(
                  onTap: () => _navigateTo(MobileScreenTab.orderInvoice),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                    decoration: BoxDecoration(
                      color: primaryGreen,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.emerald.shade300),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.receipt_long, size: 11, color: Colors.amber),
                        SizedBox(width: 4),
                        Text(
                          '🧾 डिजिटल रसीद देखें (View Invoice)',
                          style: TextStyle(fontSize: 9.5, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.inventory_2, size: 11, color: Color(0xFF1E3A8A)),
                        const SizedBox(width: 4),
                        Text(
                          'कार्गो सीमा: अंडे ${PricingConfig.maxEggTrays} ट्रे • पोल्ट्री ${PricingConfig.maxLiveBirds} पक्षी • बटेर ${PricingConfig.maxQuails} पक्षी',
                          style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                      ],
                    ),
                    Text(
                      'डिलीवरी किराया: ₹${_sharedOrder.commuterFee.toStringAsFixed(0)} (${PricingConfig.eggBulkDiscountPercent.toStringAsFixed(0)}% छूट लागू)',
                      style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: primaryGreen, fontFamily: 'monospace'),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.shield_outlined, size: 11, color: Color(0xFF92400E)),
                        const SizedBox(width: 4),
                        Text(
                          'प्लेटफ़ॉर्म शुल्क: ${_sharedOrder.platformFeeTier} • ₹${_sharedOrder.platformFee.toStringAsFixed(0)} (वॉलेट से)',
                          style: const TextStyle(fontSize: 9.0, fontWeight: FontWeight.w600, color: Color(0xFF92400E)),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade100,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.amber.shade400),
                      ),
                      child: Text(
                        _sharedOrder.paymentPolicy == 'advanceToken50' ? '50% अग्रिम टोकन' : '100% सीओडी',
                        style: const TextStyle(fontSize: 8.5, fontWeight: FontWeight.bold, color: Color(0xFF78350F)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getTitleForTab(MobileScreenTab tab) {
    switch (tab) {
      case MobileScreenTab.customerHome:
        return 'ताज़ा फार्म कैटलॉग (Customer Feed)';
      case MobileScreenTab.checkout:
        return 'डायनेमिक चेकआउट (Checkout)';
      case MobileScreenTab.dispute:
        return 'फ्लोट-टेस्ट विवाद क्लेम (Dispute)';
      case MobileScreenTab.sellerUpload:
        return 'फार्मर लिस्टिंग व डिस्पैच (Seller Batch)';
      case MobileScreenTab.commuterTrip:
        return 'कम्यूटर ट्रिप व डिस्पैच (Commuter Run)';
      case MobileScreenTab.sellerWallet:
        return 'विक्रेता प्रीपेड वॉलेट व सेफ हार्बर';
      case MobileScreenTab.cityHub:
        return 'सिटी हब दुकान व कस्टडी (Hub Shop)';
      case MobileScreenTab.login:
        return 'लॉगिन / साइन-अप (Login)';
      case MobileScreenTab.adminPanel:
        return 'वेब एडमिन कंट्रोल पैनल (Admin Control Panel)';
      case MobileScreenTab.profile:
        return 'यूज़र प्रोफाइल व KYC ऑनबोर्डिंग (Profile / KYC)';
      case MobileScreenTab.orderInvoice:
        return 'डिजिटल डिलीवरी इनवॉइस व रसीद (Tax Invoice)';
    }
  }

  Widget _buildScreenForTab(MobileScreenTab tab) {
    switch (tab) {
      case MobileScreenTab.customerHome:
        return CustomerFeedScreen(
          onAddToCart: _handleAddToCart,
          onOpenFloatTestGuide: _showFloatTestInfoModal,
        );
      case MobileScreenTab.checkout:
        return CheckoutScreen(
          cartItems: _cartItems,
          onOrderCompleted: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('ऑर्डर सफलतापूर्वक दर्ज हुआ! फार्म से पैक हो रहा है'),
                backgroundColor: primaryGreen,
              ),
            );
            _navigateTo(MobileScreenTab.customerHome);
          },
        );
      case MobileScreenTab.dispute:
        return DisputeScreen(
          initialOrderId: 'ord_sample_901',
          onDisputeSubmitted: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('फ्लोट टेस्ट प्रूफ के साथ विवाद दर्ज किया गया। एडमिन ऑडिट में है।'),
                backgroundColor: Colors.black87,
              ),
            );
            _navigateTo(MobileScreenTab.customerHome);
          },
        );
      case MobileScreenTab.sellerUpload:
        return AddListingScreen(
          sellerId: 'usr_seller_chhabra',
          onListingCreated: (payload) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('बैच ${payload['batch_id']} सफलतापूर्वक प्रकाशित हुआ!'),
                backgroundColor: primaryGreen,
              ),
            );
            _navigateTo(MobileScreenTab.customerHome);
          },
        );
      case MobileScreenTab.commuterTrip:
        return const CommuterTripScreen();
      case MobileScreenTab.sellerWallet:
        return const SellerWalletScreen();
      case MobileScreenTab.cityHub:
        return CityHubScreen(
          onParcelDelivered: (orderId) {
            setState(() {
              _sharedOrder.status = 'delivered';
              _sharedOrder.currentCustody = 'buyer';
            });
          },
        );
      case MobileScreenTab.login:
        return const LoginScreen();
      case MobileScreenTab.adminPanel:
        return AdminControlPanelScreen(
          onPricingUpdated: (newEgg, newPoultry, newQuail) {
            setState(() {
              final discount = _sharedOrder.trays >= 10 ? (PricingConfig.eggBulkDiscountPercent / 100) : 0.0;
              _sharedOrder.commuterFee = (newEgg * _sharedOrder.trays) * (1 - discount);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('एडमिन पैनल: नई दरें सिंक हुईं (अंडा: ₹$newEgg, पोल्ट्री: ₹$newPoultry, बटेर: ₹$newQuail)'),
                backgroundColor: primaryGreen,
              ),
            );
          },
          onEscrowDeducted: (disputeId, amount) {
            setState(() {
              _sharedOrder.parcelAmount = (_sharedOrder.parcelAmount - amount).clamp(0, double.infinity);
            });
          },
        );
      case MobileScreenTab.profile:
        return ProfileScreen(
          initialProfile: _userProfile,
          onProfileSaved: (updated) {
            setState(() {
              _userProfile = updated;
              _sharedOrder.destinationAddress = updated.preferredBusStop;
            });
          },
        );
      case MobileScreenTab.orderInvoice:
        return OrderInvoiceScreen(
          invoiceData: DeliveryInvoiceData(
            orderId: _sharedOrder.orderId,
            timestamp: DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.now()),
            buyerName: _userProfile.name.isNotEmpty ? _userProfile.name : _sharedOrder.buyerName,
            buyerPhone: _userProfile.phone.isNotEmpty ? _userProfile.phone : _sharedOrder.buyerPhone,
            deliveryAddress: _sharedOrder.destinationAddress,
            farmerName: _userProfile.farmName,
            farmerUpiId: _userProfile.farmerUpiId,
            farmLocation: _userProfile.farmerGpsLocation,
            commuterName: 'Santosh Gawande (संतोष गावंडे)',
            commuterPhone: '+91 94221 88301',
            commuterVehicle: 'दैनिक बस ट्रांसपोर्ट (Daily Bus Transit)',
            commuteRoute: _userProfile.commuteRoute,
            itemTitle: _sharedOrder.eggSummary,
            category: _sharedOrder.cargoCategory,
            quantity: _sharedOrder.quantity,
            unitPrice: 360.0,
            totalProductAmount: _sharedOrder.parcelAmount,
            baseCommuterRate: PricingConfig.freshEggTrayFare,
            bulkDiscountPercent: _sharedOrder.discountPercent,
            commuterFareAmount: _sharedOrder.commuterFee,
            platformFeeTierTitle: _sharedOrder.platformFeeTier,
            platformFeeRate: 1.00,
            platformFeeTotal: _sharedOrder.platformFee,
            legSealNumber: _sharedOrder.legSealNumber,
            tagNumber: 'AND-9102',
            certifiedScaleWeight: '21.60 kg Net Certified (1.80 kg/tray avg)',
            gpsGeotag: _sharedOrder.scaleWatermark,
            verifiedHandshakeOtp: _sharedOrder.handshakeOtp,
            custodyStatus: 'DELIVERED TO BUYER (कस्टडी खरीदार के पास)',
            settlementStatus: 'PREPAID ESCROW SETTLED ✓',
          ),
          onBackToHome: () => _navigateTo(MobileScreenTab.customerHome),
        );
    }
  }
}
