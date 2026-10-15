import 'package:cloud_firestore/cloud_firestore.dart';

/// Dispute ticket model with egg float-test photo verification
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
  bool get isResolvedRefund => status == 'resolved_refund';

  factory DisputeModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    if (data == null) {
      throw StateError('DisputeModel document snapshot data is null');
    }
    return DisputeModel.fromMap(data);
  }

  factory DisputeModel.fromMap(Map<String, dynamic> map) {
    DateTime? parseDate(dynamic val) {
      if (val is Timestamp) return val.toDate();
      if (val is String) return DateTime.tryParse(val);
      return null;
    }

    return DisputeModel(
      disputeId: map['dispute_id'] as String? ?? '',
      orderId: map['order_id'] as String? ?? '',
      buyer_id: map['buyer_id'] as String? ?? '',
      seller_id: map['seller_id'] as String? ?? '',
      reason: map['reason'] as String? ?? '',
      float_test_proof_photo_url: map['float_test_proof_photo_url'] as String? ?? '',
      status: map['status'] as String? ?? 'opened',
      admin_remarks: map['admin_remarks'] as String? ?? '',
      createdAt: parseDate(map['created_at']),
      updatedAt: parseDate(map['updated_at']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'dispute_id': disputeId,
      'order_id': orderId,
      'buyer_id': buyer_id,
      'seller_id': seller_id,
      'reason': reason,
      'float_test_proof_photo_url': float_test_proof_photo_url,
      'status': status,
      'admin_remarks': admin_remarks,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  DisputeModel copyWith({
    String? disputeId,
    String? orderId,
    String? buyer_id,
    String? seller_id,
    String? reason,
    String? float_test_proof_photo_url,
    String? status,
    String? admin_remarks,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return DisputeModel(
      disputeId: disputeId ?? this.disputeId,
      orderId: orderId ?? this.orderId,
      buyer_id: buyer_id ?? this.buyer_id,
      seller_id: seller_id ?? this.seller_id,
      reason: reason ?? this.reason,
      float_test_proof_photo_url: float_test_proof_photo_url ?? this.float_test_proof_photo_url,
      status: status ?? this.status,
      admin_remarks: admin_remarks ?? this.admin_remarks,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
