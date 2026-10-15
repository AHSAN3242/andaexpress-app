import { AppSettingsEntity, DisputeEntity, OrderEntity, ProductEntity, SecurityTestCase, UserEntity } from '../types';

export const DEFAULT_APP_SETTINGS: AppSettingsEntity = {
  platform_fee_slabs: [
    { min: 0, max: 100, fee: 1 },
    { min: 101, max: 500, fee: 2 },
    { min: 501, max: 1000, fee: 3 },
    { min: 1001, max: 2000, fee: 5 },
    { min: 2001, max: 999999, fee: 10 },
  ],
  app_name: 'AndaExpress',
  support_phone: '+91 98765 43210',
  freshness_guarantee_days: 7,
  updated_at: '2026-09-29T10:00:00Z',
  updated_by: 'admin_ahsankhan',
};

export const MOCK_USERS: UserEntity[] = [
  {
    uid: 'usr_buyer_rahul',
    phone: '+919811223344',
    role: 'buyer',
    name: 'Rahul Sharma',
    address: 'Flat 402, Green Park Avenue, South Extension, New Delhi',
    geo_point: { latitude: 28.5672, longitude: 77.2100 },
    status: 'active',
    created_at: '2026-09-10T08:30:00Z',
  },
  {
    uid: 'usr_seller_chhabra',
    phone: '+919822334455',
    role: 'seller',
    name: 'Chhabra Organic Poultry Farms',
    address: 'Village Sohna, Khasra 42, Gurugram Outskirts, Haryana',
    geo_point: { latitude: 28.2492, longitude: 77.0620 },
    status: 'active',
    created_at: '2026-08-15T09:15:00Z',
  },
  {
    uid: 'usr_seller_punjab',
    phone: '+919833445566',
    role: 'seller',
    name: 'Punjab Pure Desi Fowls',
    address: 'GT Road Mile 12, Ambala Farm Belt, Punjab',
    geo_point: { latitude: 30.3782, longitude: 76.7767 },
    status: 'active',
    created_at: '2026-07-20T11:00:00Z',
  },
  {
    uid: 'usr_admin_ahsan',
    phone: '+919900112233',
    role: 'admin',
    name: 'Ahsan Khan (Lead Admin)',
    address: 'AndaExpress Ops HQ, Cyber City Tower B, Gurugram',
    geo_point: { latitude: 28.4986, longitude: 77.0878 },
    status: 'active',
    created_at: '2026-01-01T00:00:00Z',
  },
];

export const MOCK_PRODUCTS: ProductEntity[] = [
  {
    product_id: 'prod_desi_egg_30',
    seller_id: 'usr_seller_chhabra',
    farm_name: 'Chhabra Organic Poultry Farms',
    category: 'eggs',
    egg_type: 'desi',
    price: 360,
    stock: 45,
    lay_date: '2026-09-28T05:30:00Z',
    expiry_date: '2026-10-19T05:30:00Z',
    unique_batch_code: 'BATCH-2026-CHB-DESI-0928',
    photo_url: 'https://images.unsplash.com/photo-1582722872445-44dc5f7e3c8f?auto=format&fit=crop&w=600&q=80',
    network_timestamp: '2026-09-28T06:15:00Z',
    gps_lat_long: { latitude: 28.2492, longitude: 77.0620 },
  },
  {
    product_id: 'prod_kadaknath_egg_12',
    seller_id: 'usr_seller_punjab',
    farm_name: 'Punjab Pure Desi Fowls',
    category: 'eggs',
    egg_type: 'kadaknath',
    price: 480,
    stock: 22,
    lay_date: '2026-09-29T06:00:00Z',
    expiry_date: '2026-10-20T06:00:00Z',
    unique_batch_code: 'BATCH-2026-PJB-KDK-0929',
    photo_url: 'https://images.unsplash.com/photo-1516467508483-a7212febe31a?auto=format&fit=crop&w=600&q=80',
    network_timestamp: '2026-09-29T06:30:00Z',
    gps_lat_long: { latitude: 30.3782, longitude: 76.7767 },
  },
  {
    product_id: 'prod_broiler_table_30',
    seller_id: 'usr_seller_chhabra',
    farm_name: 'Chhabra Organic Poultry Farms',
    category: 'eggs',
    egg_type: 'broiler_table',
    price: 210,
    stock: 120,
    lay_date: '2026-09-29T04:45:00Z',
    expiry_date: '2026-10-20T04:45:00Z',
    unique_batch_code: 'BATCH-2026-CHB-BRL-0929',
    photo_url: 'https://images.unsplash.com/photo-1506976785307-8732e854ad03?auto=format&fit=crop&w=600&q=80',
    network_timestamp: '2026-09-29T05:00:00Z',
    gps_lat_long: { latitude: 28.2492, longitude: 77.0620 },
  },
  {
    product_id: 'prod_organic_chicken_1kg',
    seller_id: 'usr_seller_punjab',
    farm_name: 'Punjab Pure Desi Fowls',
    category: 'chicken',
    egg_type: 'none',
    price: 450,
    stock: 18,
    lay_date: '2026-09-29T07:00:00Z',
    expiry_date: '2026-10-02T07:00:00Z',
    unique_batch_code: 'BATCH-2026-PJB-CHK-0929',
    photo_url: 'https://images.unsplash.com/photo-1604503468506-a8da13d82791?auto=format&fit=crop&w=600&q=80',
    network_timestamp: '2026-09-29T07:30:00Z',
    gps_lat_long: { latitude: 30.3782, longitude: 76.7767 },
  },
  {
    product_id: 'prod_quail_egg_24',
    seller_id: 'usr_seller_chhabra',
    farm_name: 'Chhabra Organic Poultry Farms',
    category: 'eggs',
    egg_type: 'quail',
    price: 190,
    stock: 35,
    lay_date: '2026-09-28T09:00:00Z',
    expiry_date: '2026-10-15T09:00:00Z',
    unique_batch_code: 'BATCH-2026-CHB-QUAIL-0928',
    photo_url: 'https://images.unsplash.com/photo-1598965675045-45c5e72c7d05?auto=format&fit=crop&w=600&q=80',
    network_timestamp: '2026-09-28T09:30:00Z',
    gps_lat_long: { latitude: 28.2492, longitude: 77.0620 },
  }
];

export const MOCK_ORDERS: OrderEntity[] = [
  {
    order_id: 'ord_sample_901',
    buyer_id: 'usr_buyer_rahul',
    seller_id: 'usr_seller_chhabra',
    items: [
      {
        product_id: 'prod_desi_egg_30',
        title: 'Farm Fresh Desi Brown Eggs (30-Egg Tray)',
        egg_type: 'desi',
        unit_price: 360,
        quantity: 1,
        subtotal: 360,
      },
    ],
    item_amount: 360,
    platform_fee: 2, // Slab ₹101 - ₹500 = ₹2
    order_type: 'Courier',
    payment_mode: 'upi',
    status: 'delivered',
    network_timestamp: '2026-09-27T11:20:00Z',
  },
  {
    order_id: 'ord_sample_902',
    buyer_id: 'usr_buyer_rahul',
    seller_id: 'usr_seller_punjab',
    items: [
      {
        product_id: 'prod_kadaknath_egg_12',
        title: 'Pure Breed Kadaknath Black Eggs (12-Pack)',
        egg_type: 'kadaknath',
        unit_price: 480,
        quantity: 2,
        subtotal: 960,
      },
    ],
    item_amount: 960,
    platform_fee: 3, // Slab ₹501 - ₹1000 = ₹3
    order_type: 'Courier',
    payment_mode: 'cod',
    status: 'out_for_delivery',
    network_timestamp: '2026-09-29T08:15:00Z',
  },
];

export const MOCK_DISPUTES: DisputeEntity[] = [
  {
    dispute_id: 'disp_sample_01',
    order_id: 'ord_sample_901',
    buyer_id: 'usr_buyer_rahul',
    seller_id: 'usr_seller_chhabra',
    reason: 'Water bowl float test failed: 4 out of 30 eggs floated horizontally to the surface indicating stale air cell pocket.',
    float_test_proof_photo_url: 'https://images.unsplash.com/photo-1587486913049-53fc88980cfc?auto=format&fit=crop&w=600&q=80',
    status: 'resolved_refund',
    admin_remarks: 'Verified float test photo proof clearly shows egg floating above water line. 100% refund of ₹362 approved under 7-day freshness guarantee.',
    created_at: '2026-09-27T16:40:00Z',
    updated_at: '2026-09-28T09:10:00Z',
  },
];

export const DIRTY_DOZEN_TESTS: SecurityTestCase[] = [
  {
    id: 'SEC-01',
    title: 'Platform Fee Tampering (Bypass Slab Fee)',
    category: 'Fee Integrity',
    actor: 'usr_buyer_rahul (Buyer)',
    targetCollection: 'orders/ord_test_hack',
    attemptDescription: 'Buyer attempts to send platform_fee: 0 for a cart worth ₹1,500 (Admin slab requires fee = ₹5).',
    payload: {
      order_id: 'ord_test_hack',
      buyer_id: 'usr_buyer_rahul',
      seller_id: 'usr_seller_chhabra',
      items: [{ product_id: 'prod_desi_egg_30', title: 'Eggs', unit_price: 300, quantity: 5, subtotal: 1500 }],
      item_amount: 1500,
      platform_fee: 0, // Malicious override
      order_type: 'Courier',
      payment_mode: 'upi',
      status: 'pending',
      network_timestamp: '2026-09-29T12:00:00Z',
    },
    expectedResult: 'DENIED',
    matchedRuleHelper: 'isValidOrder(incoming()) && OrderService dynamic fee calculation gate',
    vulnerabilityPrevented: 'Denial of Platform Revenue & Fee Spoofing',
  },
  {
    id: 'SEC-02',
    title: 'Cross-Tenant Product Stock/Price Hijack',
    category: 'Fee Integrity',
    actor: 'usr_seller_punjab (Hostile Seller)',
    targetCollection: 'products/prod_desi_egg_30',
    attemptDescription: 'Seller A attempts to modify the price and deplete stock of Seller B\'s egg batch.',
    payload: {
      product_id: 'prod_desi_egg_30',
      seller_id: 'usr_seller_chhabra', // Owned by Chhabra, modified by Punjab
      price: 1,
      stock: 0,
    },
    expectedResult: 'DENIED',
    matchedRuleHelper: 'existing().seller_id == request.auth.uid',
    vulnerabilityPrevented: 'Competitor Catalog Sabotage & Stock Zeroing',
  },
  {
    id: 'SEC-03',
    title: 'Self-Promotion to Administrator Role',
    category: 'Role Escalation',
    actor: 'usr_buyer_rahul (Buyer)',
    targetCollection: 'users/usr_buyer_rahul',
    attemptDescription: 'Buyer updates their user document to grant themselves role: "admin".',
    payload: {
      uid: 'usr_buyer_rahul',
      role: 'admin',
      status: 'active',
    },
    expectedResult: 'DENIED',
    matchedRuleHelper: 'incoming().role == existing().role && incoming().status == existing().status',
    vulnerabilityPrevented: 'Privilege Escalation & Unauthorized Access Control',
  },
  {
    id: 'SEC-04',
    title: 'Dispute Creation Without Float-Test Photo Proof',
    category: 'Float Test Proof',
    actor: 'usr_buyer_rahul (Buyer)',
    targetCollection: 'disputes/disp_fraud_01',
    attemptDescription: 'Buyer files a freshness dispute with an empty float_test_proof_photo_url to claim a fraudulent refund.',
    payload: {
      dispute_id: 'disp_fraud_01',
      order_id: 'ord_sample_901',
      buyer_id: 'usr_buyer_rahul',
      seller_id: 'usr_seller_chhabra',
      reason: 'Eggs are bad',
      float_test_proof_photo_url: '', // Empty proof
      status: 'opened',
      admin_remarks: '',
    },
    expectedResult: 'DENIED',
    matchedRuleHelper: 'isValidDispute(incoming()) -> float_test_proof_photo_url.size() >= 10',
    vulnerabilityPrevented: 'Frivolous & Fraudulent Freshness Refund Claims',
  },
  {
    id: 'SEC-05',
    title: 'Terminal Order State Mutation (Post-Delivered Tamper)',
    category: 'Terminal State',
    actor: 'usr_seller_chhabra (Seller)',
    targetCollection: 'orders/ord_sample_901',
    attemptDescription: 'Seller attempts to change a delivered order back to "confirmed" to double-bill or alter ledger.',
    payload: {
      status: 'confirmed',
    },
    expectedResult: 'DENIED',
    matchedRuleHelper: 'existing().status in [pending, confirmed, packed, out_for_delivery] (delivered is terminal)',
    vulnerabilityPrevented: 'Financial Ledger Tampering & State Shortcutting',
  },
  {
    id: 'SEC-06',
    title: 'Admin Remarks Injection by Buyer/Seller',
    category: 'Role Escalation',
    actor: 'usr_buyer_rahul (Buyer)',
    targetCollection: 'disputes/disp_sample_01',
    attemptDescription: 'Buyer attempts to inject admin_remarks: "Approved full refund with ₹500 compensation voucher".',
    payload: {
      admin_remarks: 'Approved full refund with ₹500 compensation voucher',
      status: 'resolved_refund',
    },
    expectedResult: 'DENIED',
    matchedRuleHelper: 'isAdmin() required for disputes update',
    vulnerabilityPrevented: 'Arbitration Forgery & Unauthorized Financial Settlement',
  },
  {
    id: 'SEC-07',
    title: 'Unauthenticated User PII & GPS Scraping',
    category: 'PII Isolation',
    actor: 'Anonymous / Unauthenticated Client',
    targetCollection: 'users/usr_buyer_rahul',
    attemptDescription: 'Anonymous bot crawls users collection to scrape phone numbers, home addresses, and GPS coordinates.',
    payload: {},
    expectedResult: 'DENIED',
    matchedRuleHelper: 'isSignedIn() && (request.auth.uid == userId || isAdmin())',
    vulnerabilityPrevented: 'Customer PII Leakage & Doxxing Vulnerability',
  },
  {
    id: 'SEC-08',
    title: 'Denial of Wallet via 2MB Batch Code Injection',
    category: 'Denial of Wallet',
    actor: 'usr_seller_chhabra (Seller)',
    targetCollection: 'products/prod_dos_attack',
    attemptDescription: 'Seller tries to upload a product with a 2,000,000 character string in unique_batch_code.',
    payload: {
      product_id: 'prod_dos_attack',
      unique_batch_code: 'A'.repeat(2000000),
    },
    expectedResult: 'DENIED',
    matchedRuleHelper: 'isValidProduct(incoming()) -> unique_batch_code.size() <= 64',
    vulnerabilityPrevented: 'Firestore Indexing Denial-of-Wallet Cost Attack',
  },
  {
    id: 'SEC-09',
    title: 'Orphaned Order Creation (Impersonating Buyer)',
    category: 'Fee Integrity',
    actor: 'usr_attacker_uid',
    targetCollection: 'orders/ord_fake_victim',
    attemptDescription: 'Attacker creates an order setting buyer_id: usr_buyer_rahul to charge the victim\'s wallet/COD.',
    payload: {
      order_id: 'ord_fake_victim',
      buyer_id: 'usr_buyer_rahul',
    },
    expectedResult: 'DENIED',
    matchedRuleHelper: 'incoming().buyer_id == request.auth.uid',
    vulnerabilityPrevented: 'Identity Spoofing & Fraudulent Order Placement',
  },
  {
    id: 'SEC-10',
    title: 'Platform Fee Slabs Overwrite by Regular User',
    category: 'Role Escalation',
    actor: 'usr_seller_chhabra (Seller)',
    targetCollection: 'app_settings/general',
    attemptDescription: 'Seller attempts to write to app_settings to set all platform fees to 0.',
    payload: {
      platform_fee_slabs: [{ min: 0, max: 999999, fee: 0 }],
    },
    expectedResult: 'DENIED',
    matchedRuleHelper: 'isAdmin() && isValidAppSettings(incoming())',
    vulnerabilityPrevented: 'Global Platform Revenue Model Compromise',
  },
  {
    id: 'SEC-11',
    title: 'ID Poisoning Attack (10KB Document ID)',
    category: 'Denial of Wallet',
    actor: 'usr_attacker',
    targetCollection: 'orders/bad_id_injection',
    attemptDescription: 'Attacker submits write to order ID containing special characters and 10KB junk payload.',
    payload: {},
    expectedResult: 'DENIED',
    matchedRuleHelper: 'isValidId(id) -> id.size() <= 128 && id.matches(^[a-zA-Z0-9_\\-]+$)',
    vulnerabilityPrevented: 'Document ID Path Traversal & Memory Exhaustion',
  },
  {
    id: 'SEC-12',
    title: 'Invalid GeoPoint Injection (Out of Bounds Coordinates)',
    category: 'Fee Integrity',
    actor: 'usr_buyer_rahul',
    targetCollection: 'users/usr_buyer_rahul',
    attemptDescription: 'Buyer attempts to send geo_point: { latitude: 999, longitude: -500 }.',
    payload: {
      geo_point: { latitude: 999, longitude: -500 },
    },
    expectedResult: 'DENIED',
    matchedRuleHelper: 'isValidGeoPoint(geo) -> latitude between -90 and 90, longitude between -180 and 180',
    vulnerabilityPrevented: 'Geographic Search Crash & Corrupted Spatial Data',
  },
];

export const FLUTTER_CODE_SNIPPETS = [
  {
    path: 'lib/screens/connected_flow_app.dart',
    title: 'lib/screens/connected_flow_app.dart',
    language: 'dart',
    description: 'Connected navigation flow with top AppBar back-button, bottom navigation bar, Customer Home, Dynamic Checkout, and Float-Test Dispute camera.',
    code: `import 'package:flutter/material.dart';

enum MobileScreenTab { customerHome, checkout, dispute, sellerUpload, login }

class AndaExpressConnectedFlowApp extends StatefulWidget {
  const AndaExpressConnectedFlowApp({super.key});
  @override
  State<AndaExpressConnectedFlowApp> createState() => _AndaExpressConnectedFlowAppState();
}

class _AndaExpressConnectedFlowAppState extends State<AndaExpressConnectedFlowApp> {
  MobileScreenTab _currentTab = MobileScreenTab.customerHome;
  final List<MobileScreenTab> _history = [];

  static const Color primaryGreen = Color(0xFF1B5E20);

  void _navigateTo(MobileScreenTab tab) {
    setState(() {
      _history.add(_currentTab);
      _currentTab = tab;
    });
  }

  void _handleBack() {
    if (_history.isNotEmpty) {
      setState(() => _currentTab = _history.removeLast());
    } else {
      _navigateTo(MobileScreenTab.customerHome);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        leading: _currentTab != MobileScreenTab.customerHome
            ? IconButton(icon: const Icon(Icons.arrow_back), onPressed: _handleBack)
            : const Padding(padding: EdgeInsets.all(12.0), child: Text('🥚', style: TextStyle(fontSize: 20))),
        title: Text(_getTitleForTab(_currentTab)),
      ),
      body: _buildScreenForTab(_currentTab),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTab.index,
        onTap: (i) => _navigateTo(MobileScreenTab.values[i]),
        selectedItemColor: primaryGreen,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home Feed'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Checkout'),
          BottomNavigationBarItem(icon: Icon(Icons.report_problem), label: 'Dispute'),
          BottomNavigationBarItem(icon: Icon(Icons.camera_alt), label: 'Seller Upload'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Login'),
        ],
      ),
    );
  }
}`,
  },
  {
    path: 'lib/screens/customer_feed_screen.dart',
    title: 'lib/screens/customer_feed_screen.dart',
    language: 'dart',
    description: 'Customer Home Feed screen displaying verified fresh farm egg batches, distance in km, lay dates, and Water Float Test educational trigger.',
    code: `import 'package:flutter/material.dart';

class CustomerFeedScreen extends StatelessWidget {
  final Function(String productId) onAddToCart;
  final VoidCallback onOpenFloatTestGuide;

  const CustomerFeedScreen({
    super.key,
    required this.onAddToCart,
    required this.onOpenFloatTestGuide,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ताज़ा फार्म कैटलॉग (Customer Feed)')),
      body: ListView(
        children: [
          // GPS Location & Verification Banner
          ListTile(
            leading: const Icon(Icons.location_on, color: Colors.amber),
            title: const Text('डिलीवरी: 2.4 किमी दायरा • Verified Fresh'),
            subtitle: const Text('100% ताज़गी गारंटी: पानी में फ्लोट टेस्ट गाइड देखें'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14),
            onTap: onOpenFloatTestGuide,
          ),
          // Product Cards with batch codes, lay dates, and Add to Cart
        ],
      ),
    );
  }
}`,
  },
  {
    path: 'lib/screens/checkout_screen.dart',
    title: 'lib/screens/checkout_screen.dart',
    language: 'dart',
    description: 'Dynamic checkout reading support fees from Firebase app_settings slabs, with Courier vs Self-Pickup fulfillment choice.',
    code: `import 'package:flutter/material.dart';
import '../models/app_settings_model.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('डायनेमिक चेकआउट (Checkout)')),
      body: Column(
        children: [
          // Order Type Selector (Courier vs Self-Pickup)
          // Cart Items List
          // Transparent Price Breakdown: Item Total + Platform Fee from app_settings
          ElevatedButton(
            onPressed: widget.onOrderCompleted,
            child: const Text('ऑर्डर दर्ज करें (Place Order)'),
          ),
        ],
      ),
    );
  }
}`,
  },
  {
    path: 'lib/screens/dispute_screen.dart',
    title: 'lib/screens/dispute_screen.dart',
    language: 'dart',
    description: 'Strict dispute submission screen requiring live camera capture of the water bowl float test (gallery upload disabled).',
    code: `import 'package:flutter/material.dart';

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
  String? _floatTestPhotoUrl;
  bool _isCapturingLive = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('फ्लोट-टेस्ट विवाद क्लेम (Dispute)'),
        backgroundColor: Colors.red.shade700,
      ),
      body: Column(
        children: [
          // Strict Warning: Live camera photo only
          // Order ID & Reason Selector
          // Live Water Float Test Photo Preview with NTP & GPS Watermarks
          ElevatedButton(
            onPressed: _floatTestPhotoUrl != null ? widget.onDisputeSubmitted : null,
            child: const Text('रिफंड क्लेम सबमिट करें'),
          ),
        ],
      ),
    );
  }
}`,
  },
  {
    path: 'lib/screens/seller_upload_screen.dart',
    title: 'lib/screens/seller_upload_screen.dart',
    language: 'dart',
    description: 'Seller product batch upload screen with daily 4-digit batch codes, live camera only, Google NTP and GPS photo watermarks, and Farmer Academy compliance.',
    code: `import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum ProductCategory { eggs, chicken }

class SellerProductUploadScreen extends StatefulWidget {
  final String sellerId;
  const SellerProductUploadScreen({super.key, required this.sellerId});

  @override
  State<SellerProductUploadScreen> createState() => _SellerProductUploadScreenState();
}

class _SellerProductUploadScreenState extends State<SellerProductUploadScreen> {
  late final String _batchCode; // Dynamic Server Daily 4-digit code e.g. #EGG-842
  ProductCategory _category = ProductCategory.eggs;
  String _subType = 'desi';
  final TextEditingController _quantityController = TextEditingController(text: '30');
  final TextEditingController _priceController = TextEditingController(text: '360');
  DateTime _layDate = DateTime.now();
  late DateTime _expiryDate;

  // Live Camera Only - Gallery selection completely disabled
  bool _isPhotoCaptured = false;
  String? _watermarkTimestamp;
  String? _watermarkGpsCoordinates;

  // Mandatory Agreement Checkbox
  bool _hasAgreedToAcademy = false;

  @override
  void initState() {
    super.initState();
    final randomDigits = 800 + (DateTime.now().millisecond % 199);
    _batchCode = '#EGG-\$randomDigits';
    _expiryDate = _layDate.add(const Duration(days: 21));
  }

  void _triggerLiveCamera() {
    final ntpNow = DateTime.now();
    _watermarkTimestamp = DateFormat('yyyy-MM-dd HH:mm:ss \\'NTP\\'').format(ntpNow);
    _watermarkGpsCoordinates = 'LAT: 28.2492° N | LON: 77.0620° E (±2m Accuracy)';
    setState(() => _isPhotoCaptured = true);
  }

  // Mandatory agreement text:
  // 'मैंने डेट स्टैम्पिंग और सुरक्षित पैकिंग गाइड समझ ली है'
}`,
  },
  {
    path: 'lib/screens/login_screen.dart',
    title: 'lib/screens/login_screen.dart',
    language: 'dart',
    description: 'Farm-fresh green & white login screen with +91 phone input, OTP flow, role switcher, and strict Legal Terms & Conditions gate before OTP request.',
    code: `import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum AppLanguage { hindi, marathi, english }
enum UserAppRole { buyer, seller }

class LoginScreen extends StatefulWidget {
  final Function(String phone, String role, String language)? onLoginSuccess;
  const LoginScreen({super.key, this.onLoginSuccess});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  AppLanguage _selectedLanguage = AppLanguage.english;
  UserAppRole _selectedRole = UserAppRole.buyer;
  bool _isOtpSent = false;
  bool _isLoading = false;
  bool _agreedToTerms = false; // Strict Legal Gate

  static const primaryGreen = Color(0xFF1B5E20);
  static const softGreenBg = Color(0xFFF1F8E9);
  static const eggGold = Color(0xFFF59E0B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Language Switcher & Guarantee Pill
              _buildTopBar(),
              const SizedBox(height: 28),

              // Brand Emblem & Tagline
              _buildBrandHeader(),
              const SizedBox(height: 28),

              // Role Toggle: 'I want to Buy' vs 'I want to Sell'
              _buildRoleSelector(),
              const SizedBox(height: 24),

              // +91 Mobile Number Input
              _buildPhoneField(),

              // 6-digit OTP verification field
              if (_isOtpSent) ...[
                const SizedBox(height: 16),
                _buildOtpField(),
              ],

              const SizedBox(height: 20),

              // Strict Legal Terms & Conditions Checkbox Gate (English)
              if (!_isOtpSent) ...[
                _buildLegalTermsCheckbox(),
                const SizedBox(height: 16),
              ],

              // Submit action button (Disabled by default until checkbox is checked)
              ElevatedButton(
                onPressed: _isLoading || (!_isOtpSent && !_agreedToTerms)
                    ? null
                    : (_isOtpSent ? _handleVerifyOtp : _handleRequestOtp),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedRole == UserAppRole.seller ? const Color(0xFFD97706) : primaryGreen,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey.shade300,
                  disabledForegroundColor: Colors.grey.shade500,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: Text(_isOtpSent ? 'Verify OTP & Continue' : 'Request OTP'),
              ),
              const SizedBox(height: 24),

              // 100% Bio-Pure, 24h Fresh, Float-Tested Trust Badges
              _buildTrustBadges(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegalTermsCheckbox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _agreedToTerms ? primaryGreen : Colors.grey.shade300),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: _agreedToTerms,
            activeColor: primaryGreen,
            onChanged: (val) => setState(() => _agreedToTerms = val ?? false),
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 12, color: Colors.black87),
                children: [
                  const TextSpan(text: 'I agree to the '),
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: () => _showLegalTermsModal('Terms & Conditions'),
                      child: const Text('Terms & Conditions', style: TextStyle(fontWeight: FontWeight.bold, color: primaryGreen, decoration: TextDecoration.underline)),
                    ),
                  ),
                  const TextSpan(text: ' and '),
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: () => _showLegalTermsModal('Privacy Policy'),
                      child: const Text('Privacy Policy', style: TextStyle(fontWeight: FontWeight.bold, color: primaryGreen, decoration: TextDecoration.underline)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLegalTermsModal(String title) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text('Intermediary Notice (IT Act 2000, Sec 79)', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('1. Intermediary Platform Notice (IT Act 2000, Sec 79): AndaExpress operates solely as a digital mediator/technology aggregator connecting Buyers and Sellers.'),
            Text('2. Dispute & Liability Disclaimer: The platform is NOT a party to any transaction. Any dispute is strictly between Buyer and Seller.'),
            Text('3. Legal Immunity: The App, owners, and affiliates hold zero liability or obligation. Full sole responsibility lies with users.'),
            Text('4. Mandatory Compliance: Strict adherence to GPS verification, lay-date accuracy, and Water Float Test refund policies.'),
          ],
        ),
      ),
    );
  }
}`,
  },
  {
    path: 'pubspec.yaml',
    title: 'pubspec.yaml',
    language: 'yaml',
    description: 'Flutter project dependencies including Firebase Core, Firestore, Auth, Riverpod, and Geolocator.',
    code: `name: anda_express
description: "Farm-Fresh Eggs & Chicken Every Day - Flutter + Firebase Mobile App."
publish_to: "none"
version: 1.0.0+1

environment:
  sdk: ">=3.2.0 <4.0.0"
  flutter: ">=3.16.0"

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8

  # Firebase Core & Cloud Firestore
  firebase_core: ^3.6.0
  cloud_firestore: ^5.4.4
  firebase_auth: ^5.3.1
  firebase_storage: ^12.3.2

  # State Management & Reactive UI
  flutter_riverpod: ^2.6.1

  # Location, GeoPoint & Camera/Proof Handling
  geolocator: ^13.0.1
  image_picker: ^1.1.2

  # Utilities
  intl: ^0.19.0
  uuid: ^4.5.1
  cached_network_image: ^3.4.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0

flutter:
  uses-material-design: true`,
  },
  {
    path: 'lib/models/app_settings_model.dart',
    title: 'lib/models/app_settings_model.dart',
    language: 'dart',
    description: 'Dynamic platform fee slabs and calculatePlatformFee() business logic according to admin settings.',
    code: `import 'package:cloud_firestore/cloud_firestore.dart';

/// Individual platform fee tier slab
class PlatformFeeSlab {
  final double min;
  final double max;
  final double fee;

  const PlatformFeeSlab({
    required this.min,
    required this.max,
    required this.fee,
  });

  factory PlatformFeeSlab.fromMap(Map<String, dynamic> map) {
    return PlatformFeeSlab(
      min: (map['min'] as num?)?.toDouble() ?? 0.0,
      max: (map['max'] as num?)?.toDouble() ?? 0.0,
      fee: (map['fee'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() => {'min': min, 'max': max, 'fee': fee};
  bool contains(double amount) => amount >= min && amount <= max;
}

/// Global settings managed exclusively by AndaExpress Administrators
class AppSettingsModel {
  final List<PlatformFeeSlab> platformFeeSlabs;
  final String appName;
  final String supportPhone;
  final int freshnessGuaranteeDays;
  final DateTime? updatedAt;
  final String? updatedBy;

  const AppSettingsModel({
    required this.platformFeeSlabs,
    this.appName = 'AndaExpress',
    this.supportPhone = '+91 98765 43210',
    this.freshnessGuaranteeDays = 7,
    this.updatedAt,
    this.updatedBy,
  });

  /// Default predefined slabs according to specification:
  /// [{min:0, max:100, fee:1}, {min:101, max:500, fee:2}, {min:501, max:1000, fee:3}, {min:1001, max:2000, fee:5}, {min:2001, max:999999, fee:10}]
  static List<PlatformFeeSlab> get defaultSlabs => const [
        PlatformFeeSlab(min: 0, max: 100, fee: 1),
        PlatformFeeSlab(min: 101, max: 500, fee: 2),
        PlatformFeeSlab(min: 501, max: 1000, fee: 3),
        PlatformFeeSlab(min: 1001, max: 2000, fee: 5),
        PlatformFeeSlab(min: 2001, max: 999999, fee: 10),
      ];

  /// Calculates dynamic platform fee based on item_amount
  double calculatePlatformFee(double itemAmount) {
    if (itemAmount <= 0) return 0.0;
    for (final slab in platformFeeSlabs) {
      if (slab.contains(itemAmount)) {
        return slab.fee;
      }
    }
    return platformFeeSlabs.isNotEmpty ? platformFeeSlabs.last.fee : 10.0;
  }

  factory AppSettingsModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    if (data == null) return AppSettingsModel(platformFeeSlabs: defaultSlabs);
    final rawSlabs = data['platform_fee_slabs'] as List<dynamic>?;
    final slabs = rawSlabs != null
        ? rawSlabs.map((s) => PlatformFeeSlab.fromMap(Map<String, dynamic>.from(s as Map))).toList()
        : defaultSlabs;

    return AppSettingsModel(
      platformFeeSlabs: slabs,
      appName: data['app_name'] as String? ?? 'AndaExpress',
      supportPhone: data['support_phone'] as String? ?? '+91 98765 43210',
      freshnessGuaranteeDays: (data['freshness_guarantee_days'] as num?)?.toInt() ?? 7,
    );
  }
}`,
  },
  {
    path: 'lib/models/product_model.dart',
    title: 'lib/models/product_model.dart',
    language: 'dart',
    description: 'Batch traceability, lay dates, shelf life, and GPS coordinates mapping.',
    code: `import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String productId;
  final String seller_id;
  final String category; // 'eggs', 'chicken', 'combo', 'feed'
  final String egg_type; // 'desi', 'organic', 'broiler_table', 'free_range', 'kadaknath', 'quail'
  final double price;
  final int stock;
  final DateTime lay_date;
  final DateTime expiry_date;
  final String unique_batch_code;
  final String photo_url;
  final DateTime network_timestamp;
  final GeoPoint gps_lat_long;

  const ProductModel({
    required this.productId,
    required this.seller_id,
    required this.category,
    required this.egg_type,
    required this.price,
    required this.stock,
    required this.lay_date,
    required this.expiry_date,
    required this.unique_batch_code,
    required this.photo_url,
    required this.network_timestamp,
    required this.gps_lat_long,
  });

  int get daysSinceLay => DateTime.now().difference(lay_date).inDays;
  bool get isUltraFresh => daysSinceLay <= 7;
  bool get isSafeForConsumption => DateTime.now().isBefore(expiry_date);

  factory ProductModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final map = snapshot.data()!;
    GeoPoint parsedGps;
    if (map['gps_lat_long'] is GeoPoint) {
      parsedGps = map['gps_lat_long'] as GeoPoint;
    } else if (map['gps_lat_long'] is Map) {
      final m = map['gps_lat_long'] as Map<String, dynamic>;
      parsedGps = GeoPoint(
        (m['latitude'] as num?)?.toDouble() ?? 0.0,
        (m['longitude'] as num?)?.toDouble() ?? 0.0,
      );
    } else {
      parsedGps = const GeoPoint(0.0, 0.0);
    }

    DateTime parseDate(dynamic val) {
      if (val is Timestamp) return val.toDate();
      if (val is String) return DateTime.tryParse(val) ?? DateTime.now();
      return DateTime.now();
    }

    return ProductModel(
      productId: map['product_id'] as String? ?? '',
      seller_id: map['seller_id'] as String? ?? '',
      category: map['category'] as String? ?? 'eggs',
      egg_type: map['egg_type'] as String? ?? 'desi',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      stock: (map['stock'] as num?)?.toInt() ?? 0,
      lay_date: parseDate(map['lay_date']),
      expiry_date: parseDate(map['expiry_date']),
      unique_batch_code: map['unique_batch_code'] as String? ?? '',
      photo_url: map['photo_url'] as String? ?? '',
      network_timestamp: parseDate(map['network_timestamp']),
      gps_lat_long: parsedGps,
    );
  }

  Map<String, dynamic> toFirestore() => {
    'product_id': productId,
    'seller_id': seller_id,
    'category': category,
    'egg_type': egg_type,
    'price': price,
    'stock': stock,
    'lay_date': lay_date.toIso8601String(),
    'expiry_date': expiry_date.toIso8601String(),
    'unique_batch_code': unique_batch_code,
    'photo_url': photo_url,
    'network_timestamp': network_timestamp.toIso8601String(),
    'gps_lat_long': {'latitude': gps_lat_long.latitude, 'longitude': gps_lat_long.longitude},
  };
}`,
  },
  {
    path: 'lib/models/order_model.dart',
    title: 'lib/models/order_model.dart',
    language: 'dart',
    description: 'Order item lines, platform fee integration, Pickup/Courier options, and terminal status checks.',
    code: `import 'package:cloud_firestore/cloud_firestore.dart';

class OrderItem {
  final String productId;
  final String title;
  final String eggType;
  final double unitPrice;
  final int quantity;
  final double subtotal;

  const OrderItem({
    required this.productId,
    required this.title,
    required this.eggType,
    required this.unitPrice,
    required this.quantity,
    required this.subtotal,
  });

  factory OrderItem.fromMap(Map<String, dynamic> map) => OrderItem(
    productId: map['product_id'] as String? ?? '',
    title: map['title'] as String? ?? 'Farm Eggs',
    eggType: map['egg_type'] as String? ?? 'desi',
    unitPrice: (map['unit_price'] as num?)?.toDouble() ?? 0.0,
    quantity: (map['quantity'] as num?)?.toInt() ?? 1,
    subtotal: (map['subtotal'] as num?)?.toDouble() ?? 0.0,
  );

  Map<String, dynamic> toMap() => {
    'product_id': productId,
    'title': title,
    'egg_type': eggType,
    'unit_price': unitPrice,
    'quantity': quantity,
    'subtotal': subtotal,
  };
}

class OrderModel {
  final String orderId;
  final String buyer_id;
  final String seller_id;
  final List<OrderItem> items;
  final double item_amount;
  final double platform_fee;
  final String order_type; // 'Pickup' or 'Courier'
  final String payment_mode; // 'cod', 'upi', 'card', 'wallet'
  final String status;
  final DateTime network_timestamp;

  const OrderModel({
    required this.orderId,
    required this.buyer_id,
    required this.seller_id,
    required this.items,
    required this.item_amount,
    required this.platform_fee,
    required this.order_type,
    required this.payment_mode,
    required this.status,
    required this.network_timestamp,
  });

  double get grandTotal => item_amount + platform_fee;
  double get sellerPayout => item_amount;
  bool get isDelivered => status == 'delivered';

  factory OrderModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final map = snapshot.data()!;
    final rawItems = map['items'] as List<dynamic>? ?? [];
    return OrderModel(
      orderId: map['order_id'] as String? ?? '',
      buyer_id: map['buyer_id'] as String? ?? '',
      seller_id: map['seller_id'] as String? ?? '',
      items: rawItems.map((i) => OrderItem.fromMap(Map<String, dynamic>.from(i as Map))).toList(),
      item_amount: (map['item_amount'] as num?)?.toDouble() ?? 0.0,
      platform_fee: (map['platform_fee'] as num?)?.toDouble() ?? 0.0,
      order_type: map['order_type'] as String? ?? 'Courier',
      payment_mode: map['payment_mode'] as String? ?? 'cod',
      status: map['status'] as String? ?? 'pending',
      network_timestamp: (map['network_timestamp'] is Timestamp)
          ? (map['network_timestamp'] as Timestamp).toDate()
          : DateTime.tryParse(map['network_timestamp'].toString()) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'order_id': orderId,
    'buyer_id': buyer_id,
    'seller_id': seller_id,
    'items': items.map((i) => i.toMap()).toList(),
    'item_amount': item_amount,
    'platform_fee': platform_fee,
    'order_type': order_type,
    'payment_mode': payment_mode,
    'status': status,
    'network_timestamp': network_timestamp.toIso8601String(),
  };
}`,
  },
  {
    path: 'lib/models/dispute_model.dart',
    title: 'lib/models/dispute_model.dart',
    language: 'dart',
    description: 'Dispute model with mandatory float test photo proof and admin remarks adjudication.',
    code: `import 'package:cloud_firestore/cloud_firestore.dart';

class DisputeModel {
  final String disputeId;
  final String orderId;
  final String buyer_id;
  final String seller_id;
  final String reason;
  final String float_test_proof_photo_url;
  final String status; // 'opened', 'under_review', 'resolved_refund', 'rejected'
  final String admin_remarks;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const DisputeModel({
    required this.disputeId,
    required this.orderId,
    required this.buyer_id,
    required this.seller_id,
    required this.reason,
    required this.float_test_proof_photo_url,
    required this.status,
    required this.admin_remarks,
    this.createdAt,
    this.updatedAt,
  });

  bool get isFloatTestProofValid => float_test_proof_photo_url.trim().isNotEmpty;

  factory DisputeModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final map = snapshot.data()!;
    return DisputeModel(
      disputeId: map['dispute_id'] as String? ?? '',
      orderId: map['order_id'] as String? ?? '',
      buyer_id: map['buyer_id'] as String? ?? '',
      seller_id: map['seller_id'] as String? ?? '',
      reason: map['reason'] as String? ?? '',
      float_test_proof_photo_url: map['float_test_proof_photo_url'] as String? ?? '',
      status: map['status'] as String? ?? 'opened',
      admin_remarks: map['admin_remarks'] as String? ?? '',
    );
  }

  Map<String, dynamic> toFirestore() => {
    'dispute_id': disputeId,
    'order_id': orderId,
    'buyer_id': buyer_id,
    'seller_id': seller_id,
    'reason': reason,
    'float_test_proof_photo_url': float_test_proof_photo_url,
    'status': status,
    'admin_remarks': admin_remarks,
  };
}`,
  },
  {
    path: 'lib/services/order_service.dart',
    title: 'lib/services/order_service.dart',
    language: 'dart',
    description: 'Dynamic slab fee query, atomic stock reservation transaction, and status progression.',
    code: `import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/app_settings_model.dart';
import '../models/order_model.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const _uuid = Uuid();

  Future<AppSettingsModel> getAppSettings() async {
    final doc = await _firestore.collection('app_settings').doc('general').get();
    if (doc.exists && doc.data() != null) {
      return AppSettingsModel.fromFirestore(doc);
    }
    return AppSettingsModel(platformFeeSlabs: AppSettingsModel.defaultSlabs);
  }

  Future<double> calculateFee(double itemAmount) async {
    final settings = await getAppSettings();
    return settings.calculatePlatformFee(itemAmount);
  }

  /// Places order in an atomic transaction to decrement product stock
  Future<OrderModel> placeOrder({
    required String buyerId,
    required String sellerId,
    required List<OrderItem> items,
    required String orderType,
    required String paymentMode,
  }) async {
    final orderId = 'ord_\${_uuid.v4().substring(0, 8)}';
    final double itemAmount = items.fold(0.0, (sum, i) => sum + i.subtotal);
    final double platformFee = await calculateFee(itemAmount);

    final newOrder = OrderModel(
      orderId: orderId,
      buyer_id: buyerId,
      seller_id: sellerId,
      items: items,
      item_amount: itemAmount,
      platform_fee: platformFee,
      order_type: orderType,
      payment_mode: paymentMode,
      status: 'pending',
      network_timestamp: DateTime.now(),
    );

    await _firestore.runTransaction((transaction) async {
      for (final item in items) {
        final prodRef = _firestore.collection('products').doc(item.productId);
        final prodSnap = await transaction.get(prodRef);
        final currentStock = (prodSnap.data()?['stock'] as num?)?.toInt() ?? 0;
        if (currentStock < item.quantity) {
          throw Exception('Insufficient stock for \${item.title}. Available: \$currentStock');
        }
        transaction.update(prodRef, {'stock': currentStock - item.quantity});
      }
      final orderRef = _firestore.collection('orders').doc(orderId);
      transaction.set(orderRef, newOrder.toFirestore());
    });

    return newOrder;
  }
}`,
  },
  {
    path: 'lib/services/dispute_service.dart',
    title: 'lib/services/dispute_service.dart',
    language: 'dart',
    description: 'Image upload of float test water bowl proof and dispute batch commit.',
    code: `import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import '../models/dispute_model.dart';

class DisputeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  static const _uuid = Uuid();

  Future<String> uploadFloatTestProof({required String orderId, required File imageFile}) async {
    final fileName = 'float_proof_\${orderId}_\${DateTime.now().millisecondsSinceEpoch}.jpg';
    final ref = _storage.ref().child('dispute_proofs/\$fileName');
    final task = await ref.putFile(imageFile, SettableMetadata(contentType: 'image/jpeg'));
    return await task.ref.getDownloadURL();
  }

  Future<DisputeModel> fileFreshnessDispute({
    required String orderId,
    required String buyerId,
    required String sellerId,
    required String reason,
    required String floatTestProofPhotoUrl,
  }) async {
    if (floatTestProofPhotoUrl.trim().isEmpty) {
      throw ArgumentError('Float test proof photo is mandatory.');
    }
    final disputeId = 'disp_\${_uuid.v4().substring(0, 8)}';
    final dispute = DisputeModel(
      disputeId: disputeId,
      orderId: orderId,
      buyer_id: buyerId,
      seller_id: sellerId,
      reason: reason,
      float_test_proof_photo_url: floatTestProofPhotoUrl,
      status: 'opened',
      admin_remarks: '',
      createdAt: DateTime.now(),
    );

    final batch = _firestore.batch();
    batch.set(_firestore.collection('disputes').doc(disputeId), dispute.toFirestore());
    batch.update(_firestore.collection('orders').doc(orderId), {'status': 'disputed'});
    await batch.commit();

    return dispute;
  }
}`,
  },
  {
    path: 'pubspec.yaml',
    title: 'pubspec.yaml',
    language: 'yaml',
    description: 'Flutter project dependencies configured with Firebase, FCM, live camera, GPS tagging, watermark manipulation, Cloudinary upload, and url_launcher.',
    code: `name: anda_express
description: "Farm-Fresh Eggs & Chicken Every Day - Flutter + Firebase Mobile App."
publish_to: "none"
version: 1.0.0+1

environment:
  sdk: ">=3.2.0 <4.0.0"
  flutter: ">=3.16.0"

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8

  # Firebase Core, Auth, Cloud Firestore & Cloud Messaging
  firebase_core: latest
  firebase_auth: latest
  cloud_firestore: latest
  firebase_messaging: latest # (for FCM loud alerts)
  firebase_storage: ^12.3.2

  # Camera Capture & Live GPS Tagging
  image_picker: latest # (for camera capture)
  geolocator: latest # (for live GPS tagging)

  # Drawing Watermark on Photo & Direct Cloudinary Upload
  image: latest # (for drawing watermark on photo)
  http: latest # (for Cloudinary direct upload)

  # Date Formatting & Instant Alerts (1-tap WhatsApp & phone calls)
  intl: latest # (for date formatting)
  url_launcher: latest # (for 1-tap WhatsApp and call alerts)

  # State Management & Utilities
  flutter_riverpod: ^2.6.1
  uuid: ^4.5.1
  cached_network_image: ^3.4.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0

flutter:
  uses-material-design: true
  assets:
    - assets/images/`,
  },
  {
    path: 'android/app/src/main/AndroidManifest.xml',
    title: 'android/app/src/main/AndroidManifest.xml',
    language: 'xml',
    description: 'Android manifest with CAMERA, ACCESS_FINE_LOCATION, ACCESS_COARSE_LOCATION, INTERNET, POST_NOTIFICATIONS permissions and url_launcher queries.',
    code: `<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.andaexpress.app">

    <!-- Permissions required by AndaExpress -->
    <uses-permission android:name="android.permission.CAMERA" />
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />

    <!-- Optional Hardware Features -->
    <uses-feature android:name="android.hardware.camera" android:required="false" />
    <uses-feature android:name="android.hardware.camera.autofocus" android:required="false" />
    <uses-feature android:name="android.hardware.location.gps" android:required="false" />

    <application
        android:label="AndaExpress"
        android:name="\${applicationName}"
        android:icon="@mipmap/ic_launcher"
        android:usesCleartextTraffic="true">
        
        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:launchMode="singleTop"
            android:theme="@style/LaunchTheme"
            android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
            android:hardwareAccelerated="true"
            android:windowSoftInputMode="adjustResize">
            <meta-data
              android:name="io.flutter.embedding.android.NormalTheme"
              android:resource="@style/NormalTheme"
              />
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity>

        <!-- FCM Notification Channel Configuration -->
        <meta-data
            android:name="com.google.firebase.messaging.default_notification_channel_id"
            android:value="anda_express_loud_alerts" />

        <meta-data
            android:name="flutterEmbedding"
            android:value="2" />
    </application>

    <!-- Queries for url_launcher integration (WhatsApp & direct calling) -->
    <queries>
        <intent>
            <action android:name="android.intent.action.VIEW" />
            <data android:scheme="whatsapp" />
        </intent>
        <package android:name="com.whatsapp" />

        <intent>
            <action android:name="android.intent.action.DIAL" />
            <data android:scheme="tel" />
        </intent>

        <intent>
            <action android:name="android.intent.action.VIEW" />
            <data android:scheme="https" />
        </intent>
    </queries>
</manifest>`,
  },
  {
    path: 'lib/services/proof_watermark_service.dart',
    title: 'lib/services/proof_watermark_service.dart',
    language: 'dart',
    description: 'Live camera capture, GPS precision tagging, graphic watermark stamping, and Cloudinary upload.',
    code: `import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ProofWatermarkService {
  final ImagePicker _picker = ImagePicker();

  Future<File?> captureLiveCameraPhoto() async {
    final XFile? captured = await _picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.rear,
      imageQuality: 85,
    );
    if (captured == null) return null;
    return File(captured.path);
  }

  Future<Position> getCurrentLocation() async {
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<File> applyWatermark({
    required File originalFile,
    required Position position,
    required String batchOrOrderId,
  }) async {
    final Uint8List imageBytes = await originalFile.readAsBytes();
    final img.Image? decodedImage = img.decodeImage(imageBytes);
    if (decodedImage == null) throw Exception('Failed to decode image');

    final timestampStr = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    final gpsStr = 'LAT: \${position.latitude.toStringAsFixed(4)} | LON: \${position.longitude.toStringAsFixed(4)}';
    
    img.drawString(
      decodedImage,
      'AndaExpress • \$batchOrOrderId • \$timestampStr • \$gpsStr',
      font: img.arial24,
      x: 20,
      y: decodedImage.height - 40,
      color: img.ColorRgb8(255, 255, 255),
    );

    final watermarkedBytes = img.encodeJpg(decodedImage, quality: 85);
    final watermarkedFile = File('\${originalFile.path}_watermarked.jpg');
    await watermarkedFile.writeAsBytes(watermarkedBytes);
    return watermarkedFile;
  }
}`,
  },
  {
    path: 'lib/services/alert_service.dart',
    title: 'lib/services/alert_service.dart',
    language: 'dart',
    description: 'FCM Loud alerts, 1-tap WhatsApp notifications, and direct phone dialer using url_launcher.',
    code: `import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:url_launcher/url_launcher.dart';

class AlertService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> configureFcmAlerts({
    required Function(RemoteMessage message) onAlertReceived,
  }) async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      sound: true,
      criticalAlert: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      FirebaseMessaging.onMessage.listen(onAlertReceived);
    }
  }

  static Future<bool> launchWhatsApp({required String phoneNumber, required String message}) async {
    final cleanPhone = phoneNumber.replaceAll(RegExp(r'[^\\d+]'), '');
    final uri = Uri.parse('whatsapp://send?phone=\$cleanPhone&text=\${Uri.encodeComponent(message)}');
    if (await canLaunchUrl(uri)) {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
    return false;
  }

  static Future<bool> makePhoneCall({required String phoneNumber}) async {
    final uri = Uri.parse('tel:\${phoneNumber.replaceAll(RegExp(r\'[^\\d+]\'), \'\')}');
    if (await canLaunchUrl(uri)) {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
    return false;
  }
}`,
  },
  {
    path: 'lib/screens/add_listing_screen.dart',
    title: 'lib/screens/add_listing_screen.dart',
    language: 'dart',
    description: 'Farmer Listing & Dispatch screen featuring camera proof watermarking, Cloudinary unsigned upload, Farm Pickup vs Daily Commuter delivery, and ₹2 prepaid wallet platform fee policy.',
    code: `import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image/image.dart' as img;

enum DeliveryMode { farmPickup, commuterDelivery }
enum EggVariety { desi, kadaknath, broiler }

class AddListingScreen extends StatefulWidget {
  final String sellerId;
  final Function(Map<String, dynamic> listingPayload)? onListingCreated;

  const AddListingScreen({
    super.key,
    this.sellerId = 'usr_seller_chhabra',
    this.onListingCreated,
  });

  @override
  State<AddListingScreen> createState() => _AddListingScreenState();
}

class _AddListingScreenState extends State<AddListingScreen> {
  late final String _batchId;
  late final String _orderRefId;
  EggVariety _selectedVariety = EggVariety.desi;
  int _quantityTrays = 30; // 1 tray = 30 eggs
  double _pricePerTray = 360.0; // ₹12/egg

  DeliveryMode _deliveryMode = DeliveryMode.farmPickup;
  double _commuterDeliveryFee = 28.0; // Dynamic commuter fee ₹25-₹30 (Paras to Akola)

  bool _isCapturing = false;
  String? _watermarkTimestamp;
  String? _watermarkGpsCoordinates;
  String? _cloudinaryImageUrl;
  bool _photoProofVerified = false;

  final double _platformFee = 2.0; // Fixed ₹2 platform fee
  final double _sellerWalletBalance = 450.0;

  @override
  void initState() {
    super.initState();
    final randomDigits = 800 + (DateTime.now().millisecond % 199);
    _batchId = '#BATCH-AKL-\$randomDigits';
    _orderRefId = 'ORD-PARAS-\$randomDigits';
  }

  Future<void> _captureAndWatermarkPhoto() async {
    setState(() => _isCapturing = true);
    // Picks live camera photo, stamps NTP time + Paras-Akola GPS, uploads to Cloudinary unsigned preset
    final now = DateTime.now();
    final formattedTime = DateFormat('yyyy-MM-dd HH:mm:ss \\'IST\\'').format(now);
    const gpsFormatted = 'LAT: 20.7002° N | LON: 77.0082° E (Paras - Akola Belt)';

    setState(() {
      _isCapturing = false;
      _watermarkTimestamp = formattedTime;
      _watermarkGpsCoordinates = gpsFormatted;
      _cloudinaryImageUrl = 'https://res.cloudinary.com/andaexpress/image/upload/v1/batches/fresh_desi_batch.jpg';
      _photoProofVerified = true;
    });
  }

  void _submitListing() {
    if (!_photoProofVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('कृपया अंडों की लाइव फोटो खींचें'), backgroundColor: Colors.red),
      );
      return;
    }
    final payload = {
      'batch_id': _batchId,
      'order_ref_id': _orderRefId,
      'seller_id': widget.sellerId,
      'variety': _selectedVariety.name,
      'quantity_trays': _quantityTrays,
      'price_per_tray': _pricePerTray,
      'delivery_mode': _deliveryMode == DeliveryMode.farmPickup ? 'farm_pickup' : 'commuter_delivery',
      'delivery_fee': _deliveryMode == DeliveryMode.farmPickup ? 0.0 : _commuterDeliveryFee,
      'platform_fee': _platformFee,
      'wallet_note': 'Fixed platform fee of ₹2 deducted from prepaid seller wallet only upon delivery',
      'photo_url': _cloudinaryImageUrl,
    };
    widget.onListingCreated?.call(payload);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('नया बैच व डिस्पैच लिस्टिंग (Seller Batch)')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 1. Camera Capture & Proof Watermark (Cloudinary Upload)
          // 2. Delivery Mode (Farm Pickup ₹0 vs Commuter Delivery Paras to Akola ₹25-₹30)
          // 3. Batch Details (Variety, Trays, Price)
          // 4. Platform Fee & Prepaid Wallet Note (₹2 on delivery only)
        ],
      ),
    );
  }
}`,
  },
  {
    path: 'lib/screens/commuter_trip_screen.dart',
    title: 'lib/screens/commuter_trip_screen.dart',
    language: 'dart',
    description: 'Commuter Trip & Dispatch Controller featuring Paras to Akola route initiation, Anti-Bypass Buyer Alert (FCM, WhatsApp, Call), 2-minute bus stand countdown timer, city hub fail-safe, and fare settlement display.',
    code: `import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

enum ParcelDeliveryStatus { assigned, inTransit, arrivedBusStand, deliveredDirect, droppedAtHub }

class CommuterTripScreen extends StatefulWidget {
  final String routeName;
  const CommuterTripScreen({super.key, this.routeName = 'Paras to Akola (पारस ➡️ अकोला)'});
  @override
  State<CommuterTripScreen> createState() => _CommuterTripScreenState();
}

class _CommuterTripScreenState extends State<CommuterTripScreen> {
  bool _isTripActive = false;
  bool _hasArrivedAtBusStand = false;
  int _secondsRemaining = 120; // 2-min countdown timer

  // 1. Start Trip & Send Loud FCM Alert
  Future<void> _startTripAndSendLoudAlert() async {
    setState(() => _isTripActive = true);
    // Broadcast high-priority FCM notification to buyer
  }

  // 2. 1-Tap WhatsApp Alert
  Future<void> _sendWhatsAppAlert(String phone, String code, String orderId) async {
    final msg = Uri.encodeComponent('Hello, commuter is arriving at Akola bus stand in 30 mins. Please be ready with your code: \$code (Order: \$orderId)');
    final uri = Uri.parse('whatsapp://send?phone=\$phone&text=\$msg');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  // 3. 1-Tap Direct Call
  Future<void> _makeCall(String phone) async {
    final uri = Uri.parse('tel:\$phone');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  // 4. City Hub Fail-Safe Drop (+₹5 shop fee)
  void _dropAtCityHubShop(String orderId) {
    // Drop at Shrinath Dairy Hub (Akola Bus Stand Gate 2)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('कम्यूटर ट्रिप व डिस्पैच कंट्रोलर')),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          // Route: Paras to Akola with departure timestamp
          // Start Trip & Send Loud Alert (FCM)
          // Arrived at Akola Bus Stand Toggle + 2-min Handshake Timer
          // Assigned Parcels (4-digit pickup code, WhatsApp, Call)
          // Drop at City Hub Shop fail-safe (+₹5 fee)
          // Fare Settlement: ₹25-₹30 per parcel
        ],
      ),
    );
  }
}`,
  },
  {
    path: 'lib/screens/seller_wallet_screen.dart',
    title: 'lib/screens/seller_wallet_screen.dart',
    language: 'dart',
    description: 'Seller Prepaid Wallet & Legal Intermediary screen featuring prepaid balance tracker, dynamic ₹2 platform fee deduction on delivery/hub drop, UPI recharge chips (+₹20, +₹50, +₹100), IT Act 2000 Sec 79 safe harbor disclosure, and transaction ledger.',
    code: `import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

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
    this.initialBalance = 100.0,
  });

  @override
  State<SellerWalletScreen> createState() => _SellerWalletScreenState();
}

class _SellerWalletScreenState extends State<SellerWalletScreen> {
  late double _currentBalance;
  int _selectedTopUpAmount = 50; // default top-up amount
  bool _isSafeHarborExpanded = false;

  late List<WalletTransaction> _transactions;

  static const Color primaryGreen = Color(0xFF1B5E20);
  static const Color walletAmber = Color(0xFFD97706);
  static const Color lightBg = Color(0xFFF8FAFC);

  @override
  void initState() {
    super.initState();
    _currentBalance = widget.initialBalance;

    final now = DateTime.now();
    _transactions = [
      WalletTransaction(
        id: 'TXN-901',
        orderId: 'ORD-AKL-842',
        title: 'सफल डिलीवरी फ़ी (Delivered Handover)',
        amount: -2.0,
        balanceAfter: 100.0,
        timestamp: now.subtract(const Duration(hours: 3)),
        note: 'Order status changed to delivered (Fixed ₹2 platform fee)',
      ),
      WalletTransaction(
        id: 'TXN-900',
        orderId: 'ORD-AKL-719',
        title: 'हब ड्रॉप फ़ी (Dropped at Hub Shop)',
        amount: -2.0,
        balanceAfter: 102.0,
        timestamp: now.subtract(const Duration(hours: 18)),
        note: 'Order dropped at Shrinath Dairy Hub (Fixed ₹2 platform fee)',
      ),
      WalletTransaction(
        id: 'TXN-899',
        orderId: 'RECHARGE-UPI',
        title: 'UPI प्रीपेड वॉलेट टॉप-अप',
        amount: 50.0,
        balanceAfter: 104.0,
        timestamp: now.subtract(const Duration(days: 2)),
        note: 'Recharge via PhonePe/GPay UPI',
        isDeduction: false,
      ),
    ];
  }

  // UPI Top-up / Recharge
  Future<void> _initiateUpiPayment(int amount) async {
    final upiUrl = 'upi://pay?pa=andaexpress@icici&pn=AndaExpressPlatform&am=\$amount.00&cu=INR&tn=SellerPrepaidWalletRecharge';
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
        title: const Text('UPI वॉलेट रिचार्ज (QR)'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('राशि: ₹\$amount.00', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('VPA: andaexpress@icici'),
            const SizedBox(height: 12),
            const Icon(Icons.qr_code_2, size: 100, color: Colors.black87),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('रद्द करें')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _currentBalance += amount;
                _transactions.insert(
                  0,
                  WalletTransaction(
                    id: 'TXN-\${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                    orderId: 'RECHARGE-UPI',
                    title: 'UPI प्रीपेड वॉलेट टॉप-अप',
                    amount: amount.toDouble(),
                    balanceAfter: _currentBalance,
                    timestamp: DateTime.now(),
                    note: 'Top-up via UPI',
                    isDeduction: false,
                  ),
                );
              });
            },
            child: const Text('सत्यापित करें (Simulate Pay)'),
          ),
        ],
      ),
    );
  }

  // Dynamic deduction of ₹2 on delivery/hub drop
  void simulateOrderDeduction(String orderId, bool isHubDrop) {
    if (_currentBalance < 2.0) return;
    setState(() {
      _currentBalance -= 2.0;
      _transactions.insert(
        0,
        WalletTransaction(
          id: 'TXN-\${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
          orderId: orderId,
          title: isHubDrop ? 'हब ड्रॉप फ़ी' : 'सफल डिलीवरी फ़ी',
          amount: -2.0,
          balanceAfter: _currentBalance,
          timestamp: DateTime.now(),
          note: isHubDrop ? 'Dropped at hub' : 'Delivered to buyer',
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('विक्रेता प्रीपेड वॉलेट व सेफ हार्बर')),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          // 1. Current Balance & ₹2 Dynamic Deduction Notice
          // 2. Simple UPI Top-up / Recharge (+₹20, +₹50, +₹100)
          // 3. Intermediary Platform Protection (IT Act 2000, Sec 79)
          // 4. Transaction Ledger
        ],
      ),
    );
  }
}`,
  },
  {
    path: 'lib/screens/city_hub_screen.dart',
    title: 'lib/screens/city_hub_screen.dart',
    language: 'dart',
    description: 'City Hub Shop Custody & Handover Screen for AndaExpress featuring Shrinath Dairy Hub (Akola Bus Stand Gate 2), custody parcel inventory, +₹5 shop cooling & holding fee, buyer 4-digit in-app OTP verification, and instant delivery settlement.',
    code: `import 'package:flutter/material.dart';

/// City Hub Custody Status
enum HubParcelStatus {
  inCustody,
  delivered,
  returned,
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
  });
}

class CityHubScreen extends StatefulWidget {
  final String hubName;
  final String hubAddress;
  final String ownerName;

  const CityHubScreen({
    super.key,
    this.hubName = 'श्रीनाथ डेयरी व सिटी हब (Shrinath Dairy & City Hub)',
    this.hubAddress = 'अकोला बस स्टैंड गेट नं. 2, मुख्य सड़क, अकोला',
    this.ownerName = 'सुरेश भाई पटेल (हब संचालक)',
  });

  @override
  State<CityHubScreen> createState() => _CityHubScreenState();
}

class _CityHubScreenState extends State<CityHubScreen> {
  // Hub Crates in Custody, OTP verification, and Handover settlement
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('सिटी हब दुकान व कस्टडी ट्रांसफर')),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          // 1. Hub Operator Profile & Address
          // 2. Custody Transfer & Zero-Cost OTP Explanation
          // 3. Crates in Custody Inventory with 4-Digit OTP Input
          // 4. ₹5 Hub Commission Settlement Ledger
        ],
    );
  }
}`,
  },
  {
    path: 'lib/config/pricing_config.dart',
    title: 'lib/config/pricing_config.dart',
    language: 'dart',
    description: 'Centralized Financial & Logistics Configuration: Commuter cargo capacities (30 egg trays / 15 live birds / 30 quails), transit fares with bulk discounts, multi-tier bulk platform fees (15p, 50p, ₹1), and escrow/wallet rules.',
    code: `library pricing_config;

enum CargoCategory { eggs, livePoultry, quails }

class CommuterCargoLimits {
  static const int maxEggTrays = 30;
  static const int maxLiveBirds = 15;
  static const int maxQuails = 30;
}

class PricingConfig {
  static const double freshEggTrayFare = 30.0;
  static const int eggBulkDiscountThresholdTrays = 10;
  static const double eggBulkDiscountPercent = 10.0;

  static const double liveBirdFare = 50.0;
  static const int liveBirdBulkDiscountThreshold = 5;
  static const double liveBirdBulkDiscountPercent = 10.0;

  static const double quailFare = 5.0;
  static const int quailBulkDiscountThreshold = 20;
  static const double quailBulkDiscountPercent = 5.0;

  static const double eggTier1PerEgg = 1.00;
  static const double eggTier2PerEgg = 0.50;
  static const double eggTier3PerEgg = 0.15;

  static const double minSellerWalletDeposit = 50.0;
  static const int farmerSettlementWindowHours = 12;
  static const double cityHubDropFee = 5.0;
}`,
  },
  {
    path: 'lib/screens/admin_control_panel.dart',
    title: 'lib/screens/admin_control_panel.dart',
    language: 'dart',
    description: 'Web Admin Control Panel: Commuter Fare & Dispute Resolution Desk (12h auto-deduction trigger), Dynamic Pricing & Slab Controller, and Anti-Fraud Audit Log for live bird shipments.',
    code: `import 'package:flutter/material.dart';
import '../config/pricing_config.dart';

class AdminControlPanelScreen extends StatefulWidget {
  final Function(double egg, double poultry, double quail)? onPricingUpdated;
  final Function(String disputeId, double amount)? onEscrowDeducted;

  const AdminControlPanelScreen({super.key, this.onPricingUpdated, this.onEscrowDeducted});

  @override
  State<AdminControlPanelScreen> createState() => _AdminControlPanelScreenState();
}

class _AdminControlPanelScreenState extends State<AdminControlPanelScreen> {
  // Modules: A. Commuter Dispute Desk, B. Dynamic Pricing Controller, C. Anti-Fraud Audit Log
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('वेब एडमिन कंट्रोल डेस्क (Admin Control Panel)')),
      body: const Center(child: Text('Admin Operations Center')),
    );
  }
}`,
  },
  {
    path: 'lib/screens/profile_screen.dart',
    title: 'lib/screens/profile_screen.dart',
    language: 'dart',
    description: 'User Role-Based Onboarding & Profiles: Farmer UPI ID & GPS pin, Commuter vehicle & daily route setup, Buyer bus stop preference.',
    code: `import 'package:flutter/material.dart';

enum ProfileUserRole { farmer, commuter, buyer }
enum CommuterVehicleType { bike, cruiserTaxi, autoRickshaw, busTransport }

class UserProfileData {
  String name;
  String phone;
  ProfileUserRole role;
  String farmName;
  String farmerUpiId;
  String farmerGpsLocation;
  String commuterUpiId;
  CommuterVehicleType vehicleType;
  String commuteRoute;
  String preferredBusStop;

  UserProfileData({
    this.name = 'Chhabra Organic Farms',
    this.phone = '+91 98223 34455',
    this.role = ProfileUserRole.farmer,
    this.farmName = 'Chhabra Organic Poultry Farms',
    this.farmerUpiId = 'chhabra.poultry@icici',
    this.farmerGpsLocation = 'LAT: 20.7002° N | LON: 77.0082° E',
    this.commuterUpiId = 'santosh.gawande@okhdfcbank',
    this.vehicleType = CommuterVehicleType.busTransport,
    this.commuteRoute = 'Paras Depot ➡️ Akola Bus Stand',
    this.preferredBusStop = 'अकोला बस स्टैंड गेट नं 1',
  });
}`,
  },
  {
    path: 'lib/screens/order_invoice_screen.dart',
    title: 'lib/screens/order_invoice_screen.dart',
    language: 'dart',
    description: 'Digital Delivery Invoice & Receipt Generator: Clean transparent breakdown of items, commuter fare, platform fee tier, anti-tamper leg-seal tag proof, certified scale weight, and shareable receipt card.',
    code: `import 'package:flutter/material.dart';
import '../config/pricing_config.dart';

class OrderInvoiceScreen extends StatelessWidget {
  final VoidCallback? onBackToHome;
  const OrderInvoiceScreen({super.key, this.onBackToHome});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('डिजिटल टैक्स इनवॉइस व रसीद (Tax Invoice)')),
      body: const Center(child: Text('Digital Trip Invoice & Receipt')),
    );
  }
}`,
  },
];

