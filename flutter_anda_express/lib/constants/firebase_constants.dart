/// Firestore Collection and Document Paths for AndaExpress
class FirebaseConstants {
  static const String usersCollection = 'users';
  static const String productsCollection = 'products';
  static const String ordersCollection = 'orders';
  static const String appSettingsCollection = 'app_settings';
  static const String generalSettingsDoc = 'general';
  static const String disputesCollection = 'disputes';
  static const String adminsCollection = 'admins';

  // Storage paths
  static const String floatTestProofsStorage = 'dispute_proofs';
  static const String productPhotosStorage = 'product_photos';
}

/// User roles in AndaExpress
enum UserRole {
  buyer,
  seller,
  admin,
}

/// Order fulfillment modes
enum OrderType {
  pickup,
  courier,
}

/// Payment modes
enum PaymentMode {
  cod,
  upi,
  card,
  wallet,
}

/// Order lifecycle statuses
enum OrderStatus {
  pending,
  confirmed,
  packed,
  outForDelivery,
  delivered,
  cancelled,
  disputed,
}

/// Dispute ticket statuses
enum DisputeStatus {
  opened,
  underReview,
  resolvedRefund,
  rejected,
}
