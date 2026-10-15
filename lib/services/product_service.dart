import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../constants/firebase_constants.dart';
import '../models/product_model.dart';
import 'firebase_service.dart';

/// Service managing egg & poultry inventory, batch codes, and lay date verification
class ProductService {
  final FirebaseFirestore _firestore = FirebaseService.firestore;
  static const _uuid = Uuid();

  /// Create a fresh farm lot listing
  Future<ProductModel> createProductBatch({
    required String sellerId,
    required String category,
    required String eggType,
    required double price,
    required int stock,
    required DateTime layDate,
    required String uniqueBatchCode,
    required String photoUrl,
    required GeoPoint farmCoordinates,
    int shelfLifeDays = 21,
  }) async {
    final productId = 'prod_${_uuid.v4().substring(0, 8)}';
    final expiryDate = layDate.add(Duration(days: shelfLifeDays));
    final now = DateTime.now();

    final product = ProductModel(
      productId: productId,
      seller_id: sellerId,
      category: category,
      egg_type: eggType,
      price: price,
      stock: stock,
      lay_date: layDate,
      expiry_date: expiryDate,
      unique_batch_code: uniqueBatchCode,
      photo_url: photoUrl,
      network_timestamp: now,
      gps_lat_long: farmCoordinates,
    );

    try {
      await _firestore
          .collection(FirebaseConstants.productsCollection)
          .doc(productId)
          .set(product.toFirestore());
      return product;
    } catch (e) {
      FirebaseService.logFirestoreError(
        error: e,
        operation: 'create_product',
        path: '${FirebaseConstants.productsCollection}/$productId',
      );
      rethrow;
    }
  }

  /// Stream all fresh available inventory
  Stream<List<ProductModel>> streamAvailableProducts({String? eggTypeFilter}) {
    Query<Map<String, dynamic>> query = _firestore
        .collection(FirebaseConstants.productsCollection)
        .where('stock', isGreaterThan: 0);

    if (eggTypeFilter != null && eggTypeFilter.isNotEmpty && eggTypeFilter != 'all') {
      query = query.where('egg_type', isEqualTo: eggTypeFilter);
    }

    return query.snapshots().map(
      (snapshot) => snapshot.docs.map(ProductModel.fromFirestore).toList(),
    );
  }

  /// Search a batch by its QR / Lot code (Farm traceability)
  Future<ProductModel?> traceBatchByCode(String batchCode) async {
    try {
      final snapshot = await _firestore
          .collection(FirebaseConstants.productsCollection)
          .where('unique_batch_code', isEqualTo: batchCode)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return ProductModel.fromFirestore(snapshot.docs.first);
      }
      return null;
    } catch (e) {
      FirebaseService.logFirestoreError(
        error: e,
        operation: 'query_batch_code',
        path: FirebaseConstants.productsCollection,
      );
      return null;
    }
  }
}
