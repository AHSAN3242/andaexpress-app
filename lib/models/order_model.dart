import 'package:cloud_firestore/cloud_firestore.dart';

/// Single purchased item line inside an Order
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

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      productId: map['product_id'] as String? ?? '',
      title: map['title'] as String? ?? 'Farm Eggs',
      eggType: map['egg_type'] as String? ?? 'desi',
      unitPrice: (map['unit_price'] as num?)?.toDouble() ?? 0.0,
      quantity: (map['quantity'] as num?)?.toInt() ?? 1,
      subtotal: (map['subtotal'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'product_id': productId,
      'title': title,
      'egg_type': eggType,
      'unit_price': unitPrice,
      'quantity': quantity,
      'subtotal': subtotal,
    };
  }
}

/// Order transaction model for AndaExpress
class OrderModel {
  final String orderId;
  final String buyer_id;
  final String seller_id;
  final List<OrderItem> items;
  final double item_amount;
  final double platform_fee;
  final String order_type; // 'Pickup' or 'Courier'
  final String payment_mode; // 'cod', 'upi', 'card', 'wallet'
  final String status; // 'pending', 'confirmed', 'packed', 'out_for_delivery', 'delivered', 'cancelled', 'disputed'
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

  /// Total amount charged to buyer (item_amount + platform_fee)
  double get grandTotal => item_amount + platform_fee;

  /// Seller net payout before any delivery costs
  double get sellerPayout => item_amount;

  bool get isDelivered => status == 'delivered';
  bool get isDisputed => status == 'disputed';
  bool get isCancelled => status == 'cancelled';
  bool get isPending => status == 'pending';

  factory OrderModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    if (data == null) {
      throw StateError('OrderModel document snapshot data is null');
    }
    return OrderModel.fromMap(data);
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    final rawItems = map['items'] as List<dynamic>? ?? [];
    final items = rawItems
        .map((item) => OrderItem.fromMap(Map<String, dynamic>.from(item as Map)))
        .toList();

    DateTime parseDate(dynamic val) {
      if (val is Timestamp) return val.toDate();
      if (val is String) return DateTime.tryParse(val) ?? DateTime.now();
      return DateTime.now();
    }

    return OrderModel(
      orderId: map['order_id'] as String? ?? '',
      buyer_id: map['buyer_id'] as String? ?? '',
      seller_id: map['seller_id'] as String? ?? '',
      items: items,
      item_amount: (map['item_amount'] as num?)?.toDouble() ?? 0.0,
      platform_fee: (map['platform_fee'] as num?)?.toDouble() ?? 0.0,
      order_type: map['order_type'] as String? ?? 'Courier',
      payment_mode: map['payment_mode'] as String? ?? 'cod',
      status: map['status'] as String? ?? 'pending',
      network_timestamp: parseDate(map['network_timestamp']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
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
  }

  OrderModel copyWith({
    String? orderId,
    String? buyer_id,
    String? seller_id,
    List<OrderItem>? items,
    double? item_amount,
    double? platform_fee,
    String? order_type,
    String? payment_mode,
    String? status,
    DateTime? network_timestamp,
  }) {
    return OrderModel(
      orderId: orderId ?? this.orderId,
      buyer_id: buyer_id ?? this.buyer_id,
      seller_id: seller_id ?? this.seller_id,
      items: items ?? this.items,
      item_amount: item_amount ?? this.item_amount,
      platform_fee: platform_fee ?? this.platform_fee,
      order_type: order_type ?? this.order_type,
      payment_mode: payment_mode ?? this.payment_mode,
      status: status ?? this.status,
      network_timestamp: network_timestamp ?? this.network_timestamp,
    );
  }
}
