import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../constants/firebase_constants.dart';
import '../models/app_settings_model.dart';
import '../models/order_model.dart';
import 'firebase_service.dart';

/// Business service managing purchases, platform fee tiers, and order tracking
class OrderService {
  final FirebaseFirestore _firestore = FirebaseService.firestore;
  static const _uuid = Uuid();

  /// Fetch active platform fee slabs from app_settings
  Future<AppSettingsModel> getAppSettings() async {
    try {
      final doc = await _firestore
          .collection(FirebaseConstants.appSettingsCollection)
          .doc(FirebaseConstants.generalSettingsDoc)
          .get();

      if (doc.exists && doc.data() != null) {
        return AppSettingsModel.fromFirestore(doc);
      }
      return AppSettingsModel(platformFeeSlabs: AppSettingsModel.defaultSlabs);
    } catch (e) {
      FirebaseService.logFirestoreError(
        error: e,
        operation: 'get',
        path: '${FirebaseConstants.appSettingsCollection}/${FirebaseConstants.generalSettingsDoc}',
      );
      return AppSettingsModel(platformFeeSlabs: AppSettingsModel.defaultSlabs);
    }
  }

  /// Compute platform fee given an item amount
  Future<double> calculateFee(double itemAmount) async {
    final settings = await getAppSettings();
    return settings.calculatePlatformFee(itemAmount);
  }

  /// Create an order using a Firestore atomic transaction
  /// Ensures stock is decremented and prevents inventory race conditions
  Future<OrderModel> placeOrder({
    required String buyerId,
    required String sellerId,
    required List<OrderItem> items,
    required String orderType, // 'Pickup' or 'Courier'
    required String paymentMode, // 'cod', 'upi', 'card', 'wallet'
  }) async {
    final orderId = 'ord_${_uuid.v4().substring(0, 8)}';

    // 1. Calculate item amount
    final double itemAmount = items.fold(0.0, (sum, item) => sum + item.subtotal);

    // 2. Calculate platform fee based on admin slabs
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

    try {
      // Run atomic transaction to verify stock and create order
      await _firestore.runTransaction((transaction) async {
        // Check and decrement stock for each item
        for (final item in items) {
          final productRef = _firestore
              .collection(FirebaseConstants.productsCollection)
              .doc(item.productId);
          final productSnapshot = await transaction.get(productRef);

          if (!productSnapshot.exists) {
            throw Exception('Product ${item.title} no longer exists.');
          }

          final currentStock = (productSnapshot.data()?['stock'] as num?)?.toInt() ?? 0;
          if (currentStock < item.quantity) {
            throw Exception('Insufficient stock for ${item.title}. Available: $currentStock, Requested: ${item.quantity}');
          }

          // Decrement stock
          transaction.update(productRef, {'stock': currentStock - item.quantity});
        }

        // Commit order doc
        final orderRef = _firestore
            .collection(FirebaseConstants.ordersCollection)
            .doc(orderId);
        transaction.set(orderRef, newOrder.toFirestore());
      });

      return newOrder;
    } catch (e) {
      FirebaseService.logFirestoreError(
        error: e,
        operation: 'transaction_create_order',
        path: '${FirebaseConstants.ordersCollection}/$orderId',
      );
      rethrow;
    }
  }

  /// Stream active orders for a buyer
  Stream<List<OrderModel>> streamBuyerOrders(String buyerId) {
    return _firestore
        .collection(FirebaseConstants.ordersCollection)
        .where('buyer_id', isEqualTo: buyerId)
        .orderBy('network_timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(OrderModel.fromFirestore).toList());
  }

  /// Stream active orders for a seller farm
  Stream<List<OrderModel>> streamSellerOrders(String sellerId) {
    return _firestore
        .collection(FirebaseConstants.ordersCollection)
        .where('seller_id', isEqualTo: sellerId)
        .orderBy('network_timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(OrderModel.fromFirestore).toList());
  }

  /// Seller updates order status ('confirmed', 'packed', 'out_for_delivery', 'delivered')
  Future<void> updateOrderStatus({
    required String orderId,
    required String newStatus,
  }) async {
    try {
      await _firestore
          .collection(FirebaseConstants.ordersCollection)
          .doc(orderId)
          .update({'status': newStatus});
    } catch (e) {
      FirebaseService.logFirestoreError(
        error: e,
        operation: 'update_status',
        path: '${FirebaseConstants.ordersCollection}/$orderId',
      );
      rethrow;
    }
  }
}
