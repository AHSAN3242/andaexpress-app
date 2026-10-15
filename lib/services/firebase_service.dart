import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

/// Centralized Firebase Service for AndaExpress
class FirebaseService {
  static FirebaseFirestore get firestore => FirebaseFirestore.instance;
  static FirebaseAuth get auth => FirebaseAuth.instance;
  static FirebaseMessaging get messaging => FirebaseMessaging.instance;

  /// Initialize Firebase with offline persistence cache and FCM messaging
  static Future<void> initialize() async {
    await Firebase.initializeApp();

    // Configure offline caching for low-connectivity farm areas
    firestore.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );

    // Request notification permissions for FCM loud alerts
    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      criticalAlert: true,
    );
  }

  /// Current authenticated user
  static User? get currentUser => auth.currentUser;

  /// Check if user is logged in
  static bool get isAuthenticated => currentUser != null;

  /// Structured error logger matching FirestoreErrorInfo standard
  static void logFirestoreError({
    required Object error,
    required String operation,
    required String path,
  }) {
    // In production, forward to Crashlytics / telemetry
    // ignore: avoid_print
    print('[AndaExpress Firestore Error] Op: $operation, Path: $path, Error: $error');
  }
}
