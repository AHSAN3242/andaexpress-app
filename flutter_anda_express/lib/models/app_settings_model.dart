import 'package:cloud_firestore/cloud_firestore.dart';

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

  Map<String, dynamic> toMap() {
    return {
      'min': min,
      'max': max,
      'fee': fee,
    };
  }

  bool contains(double amount) {
    return amount >= min && amount <= max;
  }
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
    // Fallback to highest slab or default 10
    return platformFeeSlabs.isNotEmpty ? platformFeeSlabs.last.fee : 10.0;
  }

  factory AppSettingsModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    if (data == null) {
      return AppSettingsModel(platformFeeSlabs: defaultSlabs);
    }
    return AppSettingsModel.fromMap(data);
  }

  factory AppSettingsModel.fromMap(Map<String, dynamic> map) {
    final rawSlabs = map['platform_fee_slabs'] as List<dynamic>?;
    final slabs = rawSlabs != null
        ? rawSlabs.map((s) => PlatformFeeSlab.fromMap(Map<String, dynamic>.from(s as Map))).toList()
        : defaultSlabs;

    return AppSettingsModel(
      platformFeeSlabs: slabs,
      appName: map['app_name'] as String? ?? 'AndaExpress',
      supportPhone: map['support_phone'] as String? ?? '+91 98765 43210',
      freshnessGuaranteeDays: (map['freshness_guarantee_days'] as num?)?.toInt() ?? 7,
      updatedAt: map['updated_at'] != null ? DateTime.tryParse(map['updated_at'].toString()) : null,
      updatedBy: map['updated_by'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'platform_fee_slabs': platformFeeSlabs.map((s) => s.toMap()).toList(),
      'app_name': appName,
      'support_phone': supportPhone,
      'freshness_guarantee_days': freshnessGuaranteeDays,
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
      if (updatedBy != null) 'updated_by': updatedBy,
    };
  }
}
