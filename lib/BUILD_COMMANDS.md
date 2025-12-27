# دستورات Build برای Flutter Project با Flavor ها

این فایل شامل تمام دستورات ترمینال برای build کردن اپلیکیشن با flavor های مختلف است.

## Bundle ID ها

- **Development**: `com.bermoodabusiness.app.dev`
- **Production**: `com.bermoodabusiness.app`

---

## Android Commands

### Development (Dev)

#### Build APK

```bash
flutter build apk --release --flavor dev --target lib/main_dev.dart --target-platform android-arm64,android-arm
```

#### Run در دستگاه

```bash
flutter run --flavor dev --target lib/main_dev.dart
```

---

### Production (Prod)

#### Build App Bundle (برای انتشار در Google Play)

```bash
flutter build appbundle --flavor prod --target lib/main_prod.dart
```

#### Build APK (signed)

```bash
flutter build apk --release --flavor prod --target lib/main_prod.dart --target-platform android-arm64,android-arm
```

#### Run در دستگاه

```bash
flutter run --flavor prod --target lib/main_prod.dart
```

---

## iOS Commands

### Development (Dev)

#### Build iOS (Debug)

```bash
flutter build ios --debug --flavor dev --target lib/main_dev.dart --scheme Runner-dev
```

#### Build iOS (Release)

```bash
flutter build ios --release --flavor dev --target lib/main_dev.dart --scheme Runner-dev
```

#### Build iOS برای Archive

```bash
flutter build ios --release --flavor dev --target lib/main_dev.dart --scheme Runner-dev
```

#### Run در Simulator/Device

```bash
flutter run --flavor dev --target lib/main_dev.dart --scheme Runner-dev
```

---

### Production (Prod)

#### Build iOS (Release - برای انتشار)

```bash
flutter build ios --release --flavor prod --target lib/main_prod.dart --scheme Runner-prod
```

#### Build iOS برای Archive

```bash
flutter build ios --release --flavor prod --target lib/main_prod.dart --scheme Runner-prod
```

#### Run در Simulator/Device

```bash
flutter run --flavor prod --target lib/main_prod.dart --scheme Runner-prod
```

---

## نکات مهم

1. **برای Android**: همیشه از `--flavor` و `--target` استفاده کنید
2. **برای iOS**: علاوه بر `--flavor` و `--target`، از `--scheme` هم استفاده کنید
3. **Production**: برای انتشار در استورها، همیشه از `--release` استفاده کنید
4. **Development**: می‌توانید از `--debug` یا بدون flag استفاده کنید

---

## استفاده در Xcode

برای iOS، می‌توانید از Xcode هم استفاده کنید:

1. پروژه را باز کنید: `ios/Runner.xcworkspace`
2. از منوی scheme (بالای صفحه) یکی از scheme های زیر را انتخاب کنید:
    - **Runner-dev** برای development
    - **Runner-prod** برای production
3. Build یا Archive کنید

---
