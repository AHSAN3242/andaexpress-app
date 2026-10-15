import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:url_launcher/url_launcher.dart';

/// Service for FCM loud alerts, instant WhatsApp messages, and 1-tap emergency calling.
class AlertService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  /// Configure background and foreground message handlers for FCM loud alerts
  Future<void> configureFcmAlerts({
    required Function(RemoteMessage message) onAlertReceived,
  }) async {
    // Request notification permissions
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      sound: true,
      criticalAlert: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      FirebaseMessaging.onMessage.listen(onAlertReceived);
    }
  }

  /// 1-tap WhatsApp dispatch for dispute resolution and order confirmations
  static Future<bool> launchWhatsApp({
    required String phoneNumber,
    required String message,
  }) async {
    final cleanPhone = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    final encodedMessage = Uri.encodeComponent(message);
    final whatsappUri = Uri.parse('whatsapp://send?phone=$cleanPhone&text=$encodedMessage');
    final webFallbackUri = Uri.parse('https://wa.me/$cleanPhone?text=$encodedMessage');

    if (await canLaunchUrl(whatsappUri)) {
      return await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    } else if (await canLaunchUrl(webFallbackUri)) {
      return await launchUrl(webFallbackUri, mode: LaunchMode.externalApplication);
    }
    return false;
  }

  /// 1-tap direct phone call alert to farmer or buyer
  static Future<bool> makePhoneCall({required String phoneNumber}) async {
    final cleanPhone = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    final telUri = Uri.parse('tel:$cleanPhone');

    if (await canLaunchUrl(telUri)) {
      return await launchUrl(telUri, mode: LaunchMode.externalApplication);
    }
    return false;
  }
}
