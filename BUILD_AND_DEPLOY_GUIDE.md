# AndaExpress - Production Deployment & Android APK Compilation Guide

## 1. Project Overview & Architecture
AndaExpress is a high-trust hyper-local distribution network connecting organic poultry and egg farmers in rural belts (Paras, Akola, Maharashtra) to city consumers via verified daily commuters and city hub drop points.

- **Frontend Mobile App**: Flutter 3.24+ (Material 3), Riverpod 2.6, Zero-cost in-app OTP, Camera NTP & GPS watermarking.
- **Web Admin Control Panel**: React 18, Tailwind CSS, TypeScript, Real-time Operations Desk, Dispute Resolution, and Dynamic Pricing Slab Controller.
- **Backend / Cloud**: Firebase Cloud Firestore v2, Firebase Storage, and Zero-Trust ABAC Security Rules.

---

## 2. Codebase Structure
```
anda_express/
├── android/                   # Native Android Gradle configuration (minSdkVersion 21, targetSdkVersion 34)
├── assets/images/             # High-resolution logos, brand badges, and egg carton assets
├── firestore.rules            # Production Firestore ABAC rules (multi-party order access, admin config lock)
├── storage.rules              # Production Storage rules (leg-seal, scale proof, 5MB size limit & MIME check)
├── firebase-blueprint.json    # Complete Firestore schemas and field data types
├── pubspec.yaml               # Flutter dependency configuration
└── lib/
    ├── main.dart
    ├── config/
    │   └── pricing_config.dart # Financial slabs, commuter formulas, cargo capacities
    ├── constants/
    │   └── firebase_constants.dart
    ├── models/
    │   ├── app_settings_model.dart
    │   ├── dispute_model.dart
    │   ├── order_model.dart
    │   ├── product_model.dart
    │   └── user_model.dart
    ├── screens/
    │   ├── add_listing_screen.dart
    │   ├── admin_control_panel.dart
    │   ├── checkout_screen.dart
    │   ├── city_hub_screen.dart
    │   ├── commuter_trip_screen.dart
    │   ├── connected_flow_app.dart
    │   ├── customer_feed_screen.dart
    │   ├── dispute_screen.dart
    │   ├── login_screen.dart
    │   ├── order_invoice_screen.dart
    │   ├── profile_screen.dart
    │   ├── seller_upload_screen.dart
    │   └── seller_wallet_screen.dart
    └── services/
        ├── dispute_service.dart
        ├── firebase_service.dart
        ├── order_service.dart
        └── product_service.dart
```

---

## 3. Step-by-Step Android APK Compilation via Flutter CLI

### Step 1: Install System Prerequisites
Ensure your build workstation has:
1. **Flutter SDK**: Version 3.24.0 or newer (`flutter --version`).
2. **Java Development Kit**: OpenJDK 17 or 21 (`java -version`).
3. **Android SDK**: Build Tools 34.0.0 and Platform 34.

Verify setup with:
```bash
flutter doctor -v
```

### Step 2: Install Project Dependencies
Run from the root of the project:
```bash
flutter pub get
```

### Step 3: Firebase Android Configuration
Place your `google-services.json` file inside `android/app/`:
```
android/app/google-services.json
```

### Step 4: Run Static Code Analysis & Verification
Ensure 100% clean analysis before building:
```bash
flutter analyze
```

### Step 5: Build Debug APK (For Testing)
To test on physical devices or emulators:
```bash
flutter build apk --debug
```
Output: `build/app/outputs/flutter-apk/app-debug.apk`

### Step 6: Build Production Release APK (Optimized for Play Store & Direct Distribution)
Generate optimized split APKs for minimal download size:
```bash
flutter build apk --release --split-per-abi
```
Output files:
- `build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk` (Old 32-bit Android phones)
- `build/app/outputs/flutter-apk/app-arm64-v8a-release.apk` (Modern 64-bit Android smartphones)
- `build/app/outputs/flutter-apk/app-x86_64-release.apk` (x86_64 devices and Chromebooks)

Or generate an Android App Bundle (AAB) for Google Play Store upload:
```bash
flutter build appbundle --release
```
Output: `build/app/outputs/bundle/release/app-release.aab`

---

## 4. Deploying Firebase Production Rules

Deploy both `firestore.rules` and `storage.rules`:
```bash
firebase deploy --only firestore:rules,storage:rules
```

Key Protections Enforced:
1. **Orders Collection**: Restricted to involved parties (Farmer, Commuter, Buyer, Hub).
2. **Pricing Config & App Settings**: Writeable strictly by verified Administrators.
3. **Scale & Leg-Seal Media**: Restricted to verified Farmers with 5MB cap and image MIME validation.
4. **Wallets Collection**: Anti-inflation rule preventing client-side credit generation without payment reference.
