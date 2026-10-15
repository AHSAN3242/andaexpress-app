import 'package:cloud_firestore/cloud_firestore.dart';

/// Farm-Fresh Product batch model in AndaExpress
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

  /// Days elapsed since egg collection from farm
  int get daysSinceLay {
    return DateTime.now().difference(lay_date).inDays;
  }

  /// True if product is within prime freshness window (0-7 days)
  bool get isUltraFresh => daysSinceLay <= 7;

  /// True if product is still within safe consumption window
  bool get isSafeForConsumption => DateTime.now().isBefore(expiry_date);

  factory ProductModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    if (data == null) {
      throw StateError('ProductModel document snapshot data is null');
    }
    return ProductModel.fromMap(data);
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
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

  Map<String, dynamic> toFirestore() {
    return {
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
      'gps_lat_long': {
        'latitude': gps_lat_long.latitude,
        'longitude': gps_lat_long.longitude,
      },
    };
  }
}
