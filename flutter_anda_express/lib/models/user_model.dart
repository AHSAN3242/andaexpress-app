import 'package:cloud_firestore/cloud_firestore.dart';

/// User profile model representing Buyers, Sellers, and Admins in AndaExpress
class UserModel {
  final String uid;
  final String phone;
  final String role; // 'buyer' or 'seller'
  final String name;
  final String address;
  final GeoPoint geoPoint;
  final String status; // 'active', 'suspended', 'pending_verification'
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const UserModel({
    required this.uid,
    required this.phone,
    required this.role,
    required this.name,
    required this.address,
    required this.geoPoint,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  bool get isSeller => role.toLowerCase() == 'seller';
  bool get isBuyer => role.toLowerCase() == 'buyer';
  bool get isActive => status.toLowerCase() == 'active';

  factory UserModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    if (data == null) {
      throw StateError('UserModel document snapshot data is null');
    }
    return UserModel.fromMap(data);
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    GeoPoint parsedGeo;
    if (map['geo_point'] is GeoPoint) {
      parsedGeo = map['geo_point'] as GeoPoint;
    } else if (map['geo_point'] is Map) {
      final m = map['geo_point'] as Map<String, dynamic>;
      parsedGeo = GeoPoint(
        (m['latitude'] as num?)?.toDouble() ?? 0.0,
        (m['longitude'] as num?)?.toDouble() ?? 0.0,
      );
    } else {
      parsedGeo = const GeoPoint(0.0, 0.0);
    }

    return UserModel(
      uid: map['uid'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      role: map['role'] as String? ?? 'buyer',
      name: map['name'] as String? ?? '',
      address: map['address'] as String? ?? '',
      geoPoint: parsedGeo,
      status: map['status'] as String? ?? 'active',
      createdAt: map['created_at'] != null
          ? (map['created_at'] is Timestamp
              ? (map['created_at'] as Timestamp).toDate()
              : DateTime.tryParse(map['created_at'].toString()))
          : null,
      updatedAt: map['updated_at'] != null
          ? (map['updated_at'] is Timestamp
              ? (map['updated_at'] as Timestamp).toDate()
              : DateTime.tryParse(map['updated_at'].toString()))
          : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'phone': phone,
      'role': role,
      'name': name,
      'address': address,
      'geo_point': {
        'latitude': geoPoint.latitude,
        'longitude': geoPoint.longitude,
      },
      'status': status,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  UserModel copyWith({
    String? uid,
    String? phone,
    String? role,
    String? name,
    String? address,
    GeoPoint? geoPoint,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      name: name ?? this.name,
      address: address ?? this.address,
      geoPoint: geoPoint ?? this.geoPoint,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
