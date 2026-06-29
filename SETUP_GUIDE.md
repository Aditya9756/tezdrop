# TezDrop Flutter App — Setup & Run Guide ⚡

## ✅ Project Summary
- **53 Dart files** | **55 total files**
- Firebase Realtime DB — real orders, ratings, rider location
- 2Factor.in — real OTP authentication
- OSRM — real road path routing
- Nominatim — GPS reverse geocoding
- flutter_map — Leaflet equivalent (Google Maps tiles)
- Provider — single AppStateProvider for all state

---

## 📁 Folder Structure (final)
```
tezdrop/
├── pubspec.yaml
├── android/app/src/main/AndroidManifest.xml
├── assets/images/
└── lib/
    ├── main.dart
    ├── core/
    │   ├── constants/   (app_colors, app_strings, app_theme)
    │   ├── models/      (user, product, restaurant, cart_item, address, order)
    │   ├── services/    (otp, firebase, location, routing)
    │   └── routes/      (app_routes)
    ├── providers/
    │   └── app_state_provider.dart
    └── views/
        ├── onboarding/  (splash, onboarding, login, otp, privacy)
        ├── home/        (home_screen + 6 widgets)
        ├── search/
        ├── grocery/
        ├── restaurants/ (list + detail)
        ├── product/
        ├── wishlist/
        ├── cart/
        ├── address/     (select, add, list)
        ├── payment/
        ├── order/       (loader, success, tracking, orders, invoice)
        ├── profile/     (profile + edit)
        ├── wallet/
        ├── offers/
        ├── refer/
        ├── notifications/
        ├── rating/
        └── support/
```

---

## 🚀 Step 1 — Flutter Project Create Karo

```bash
# PC/Mac pe terminal mein
flutter create tezdrop
cd tezdrop

# Purani lib/ delete karo
rm -rf lib/

# Downloaded zip extract karo aur copy karo
# tezdrop/lib/ → project/lib/
# tezdrop/pubspec.yaml → project/pubspec.yaml
# tezdrop/android/app/src/main/AndroidManifest.xml → project ka AndroidManifest.xml
```

---

## 🚀 Step 2 — Firebase Setup

### 2a. Firebase Console pe
1. **console.firebase.google.com** → New Project → "TezDrop"
2. **Realtime Database** → Create database → Start in test mode
3. Database URL copy karo and set it using environment variable.

### 2b. Firebase Rules (test ke liye)
```json
{
  "rules": {
    ".read": true,
    ".write": true
  }
}
```

### 2c. google-services.json
1. Firebase Console → Project Settings → Android app add karo
2. Package name: `com.tezdrop.app`
3. `google-services.json` download karo
4. `android/app/google-services.json` pe paste karo

### 2d. android/build.gradle mein add karo
```gradle
// android/build.gradle
buildscript {
  dependencies {
    classpath 'com.google.gms:google-services:4.4.1'
  }
}
```

### 2e. android/app/build.gradle mein add karo
```gradle
// android/app/build.gradle — file ke bilkul end mein
apply plugin: 'com.google.gms.google-services'
```

---

## 🚀 Step 3 — Dependencies Install

```bash
flutter pub get
```

Agar koi error aaye:
```bash
flutter pub upgrade
flutter clean
flutter pub get
```

---

## 🚀 Step 4 — Run Karo

```bash
# Android device/emulator pe
flutter run

# APK build karo
flutter build apk --release
# APK milegi: build/app/outputs/flutter-apk/app-release.apk
```

---

## 📱 AIDE pe Setup (Mobile Development)

AIDE Flutter support nahi karta seedha. Isliye:

### Option A — Sketchware Pro (Recommended)
- Sketchware Pro mein Flutter support nahi, lekin tum **APK directly install** kar sakte ho PC se build karke

### Option B — GitHub + Codespaces (Free Cloud Build)
1. GitHub pe naya repo banao
2. Code → Codespaces → New Codespace
3. Terminal mein:
   ```bash
   flutter pub get
   flutter build apk
   ```
4. APK download karo

### Option C — Codemagic CI/CD (Free tier)
1. codemagic.io pe account banao
2. GitHub repo connect karo
3. Auto build → APK download

---

## 🔑 Important Keys (app_strings.dart mein pehle se set hain)

| Key | Value |
|-----|-------|
| Firebase URL | (Set via environment variables) |
| OTP API Key | (Set via environment variables) |
| Support Phone | `+919058055350` |
| Dev OTP | `123456` (localhost/emulator pe) |

---

## 🐛 Common Errors & Fixes

### Error: `google-services.json not found`
```
android/app/ folder mein google-services.json daalo
```

### Error: `Namespace not specified`
```gradle
// android/app/build.gradle mein add karo
android {
    namespace 'com.tezdrop.app'
    ...
}
```

### Error: `minSdkVersion`
```gradle
// android/app/build.gradle
defaultConfig {
    minSdkVersion 21  // 21 se kam mat karo
}
```

### Error: `flutter_map tiles not showing`
```
AndroidManifest.xml mein ye check karo:
android:usesCleartextTraffic="true"
```

### Error: `geolocator permission denied`
```xml
<!-- AndroidManifest.xml mein ye hona chahiye -->
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
```

### Error: `MissingPluginException (url_launcher)`
```bash
flutter clean && flutter pub get && flutter run
```

---

## 🗄️ Firebase Database Structure

App automatically ye structure banata hai:

```
tezdrop-84fb4-default-rtdb/
├── orders/
│   └── {pushKey}/
│       ├── orderId: "TD12345"
│       ├── phone: "+91 9876543210"
│       ├── address: "Sector 62, Noida"
│       ├── items: [{id, name, price, qty, isGrocery}]
│       ├── total: 280
│       ├── status: "Confirmed"
│       ├── rider: "Raju Kumar"
│       ├── riderPhone: "+919876543210"
│       ├── coinsUsed: 0
│       ├── coinsEarned: 3
│       └── timestamp: "2026-06-26 14:30:00"
│
├── ratings/
│   └── {pushKey}/
│       ├── phone, stars, review, tags, timestamp
│
├── rider_locations/
│   └── {orderId}/
│       ├── lat: 28.6315
│       ├── lng: 77.2167
│       └── ts: 1719392400000
│
├── products/     ← Optional, fallback data already hai app mein
├── grocery/      ← Optional
├── restaurants/  ← Optional
└── categories/   ← Optional
```

---

## 🎨 Theming

**Brand colors** `app_colors.dart` mein change karo:
```dart
static const Color primary   = Color(0xFFEF4444); // Red
static const Color secondary = Color(0xFFF97316); // Orange
```

---

## 📦 Dependencies List

| Package | Version | Use |
|---------|---------|-----|
| provider | ^6.1.1 | State management |
| firebase_database | ^10.4.9 | Realtime DB |
| flutter_map | ^6.1.0 | Map (Leaflet) |
| geolocator | ^10.1.0 | GPS |
| http | ^1.1.2 | API calls |
| shared_preferences | ^2.2.2 | Local storage |
| shimmer | ^3.0.0 | Loading skeleton |
| carousel_slider | ^4.2.1 | Promo banners |
| pinput | ^4.0.0 | OTP input boxes |
| google_fonts | ^6.1.0 | Inter font |
| confetti | ^0.7.0 | Order success animation |
| share_plus | ^7.2.1 | Refer & share |
| url_launcher | ^6.2.2 | Call + WhatsApp |
| latlong2 | ^0.9.0 | Map coordinates |
| intl | ^0.19.0 | Date formatting |

---

## ✅ Feature Checklist

| Feature | Status |
|---------|--------|
| OTP Login (2Factor real) | ✅ |
| Dark/Light Theme | ✅ |
| Firebase Orders | ✅ |
| GPS Location | ✅ |
| OSRM Road Routing | ✅ |
| Bike Animation on Map | ✅ |
| Cart + Bill Calculation | ✅ |
| Coupon Codes | ✅ |
| TezCoins System | ✅ |
| Wishlist | ✅ |
| Order Tracking | ✅ |
| Rider Location Polling | ✅ |
| Order History | ✅ |
| Invoice | ✅ |
| Ratings → Firebase | ✅ |
| Refer & Share | ✅ |
| WhatsApp Support | ✅ |
| Grocery Screen | ✅ |
| Search + Autocomplete | ✅ |
| Shimmer Loading | ✅ |
| Confetti Animation | ✅ |
| Micro tracking steps | ✅ |
| Address GPS + Mini Map | ✅ |
| Offline fallback data | ✅ |

---

> **Total: 53 Dart files | 25+ screens | Production-ready TezDrop Flutter App** ⚡
