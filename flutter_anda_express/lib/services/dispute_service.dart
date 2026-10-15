import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import '../constants/firebase_constants.dart';
import '../models/dispute_model.dart';
import 'firebase_service.dart';

/// Service handling customer complaints & scientific egg float-test proofs
class DisputeService {
  final FirebaseFirestore _firestore = FirebaseService.firestore;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  static const _uuid = Uuid();

  /// Upload float test evidence photo to Firebase Storage
  Future<String> uploadFloatTestProof({
    required String orderId,
    required File imageFile,
  }) async {
    final fileName = 'float_proof_${orderId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final ref = _storage.ref().child('${FirebaseConstants.floatTestProofsStorage}/$fileName');

    final uploadTask = await ref.putFile(
      imageFile,
      SettableMetadata(contentType: 'image/jpeg', customMetadata: {'order_id': orderId}),
    );

    return await uploadTask.ref.getDownloadURL();
  }

  /// Submit a formal dispute ticket with mandatory float-test proof URL
  Future<DisputeModel> fileFreshnessDispute({
    required String orderId,
    required String buyerId,
    required String sellerId,
    required String reason,
    required String floatTestProofPhotoUrl,
  }) async {
    if (floatTestProofPhotoUrl.trim().isEmpty) {
      throw ArgumentError('A valid float-test photo proof is required for egg freshness disputes.');
    }

    final disputeId = 'disp_${_uuid.v4().substring(0, 8)}';
    final now = DateTime.now();

    final dispute = DisputeModel(
      disputeId: disputeId,
      orderId: orderId,
      buyer_id: buyerId,
      seller_id: sellerId,
      reason: reason,
      float_test_proof_photo_url: floatTestProofPhotoUrl,
      status: 'opened',
      admin_remarks: '',
      createdAt: now,
      updatedAt: now,
    );

    final batch = _firestore.batch();

    // 1. Create dispute record
    final disputeRef = _firestore
        .collection(FirebaseConstants.disputesCollection)
        .doc(disputeId);
    batch.set(disputeRef, dispute.toFirestore());

    // 2. Mark order as disputed
    final orderRef = _firestore
        .collection(FirebaseConstants.ordersCollection)
        .doc(orderId);
    batch.update(orderRef, {'status': 'disputed'});

    try {
      await batch.commit();
      return dispute;
    } catch (e) {
      FirebaseService.logFirestoreError(
        error: e,
        operation: 'create_dispute_batch',
        path: '${FirebaseConstants.disputesCollection}/$disputeId',
      );
      rethrow;
    }
  }

  /// Stream disputes for an order
  Stream<List<DisputeModel>> streamOrderDisputes(String orderId) {
    return _firestore
        .collection(FirebaseConstants.disputesCollection)
        .where('order_id', isEqualTo: orderId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(DisputeModel.fromFirestore).toList());
  }
}
