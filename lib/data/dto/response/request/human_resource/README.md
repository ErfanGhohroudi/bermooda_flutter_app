# مدل‌های Response جدید برای درخواست‌ها

این فولدر شامل مدل‌های response جدید برای API های مربوط به درخواست‌ها است که با همان ساختار و key های مدل‌های request مطابقت دارند.

## فایل‌های موجود

### 1. `base_response.dart`
کلاس پایه برای تمام مدل‌های response که شامل فیلدهای مشترک است:
- `id`: شناسه درخواست
- `requestingUserId`: شناسه کاربر درخواست‌دهنده
- `requestType`: نوع درخواست
- `description`: توضیحات
- `status`: وضعیت درخواست

### 2. مدل‌های Response خاص

#### `employment_response.dart`
مدل response برای درخواست‌های استخدام شامل:
- اطلاعات شغل (عنوان، واحد سازمانی، نوع همکاری)
- جزئیات استخدام (تعداد پرسنل مورد نیاز، خلاصه شغل)
- الزامات (تحصیلات، تجربه، مهارت‌ها)

#### `general_response.dart`
مدل response برای درخواست‌های عمومی شامل:
- تغییر اطلاعات شخصی
- گواهی اشتغال
- معرفی‌نامه

#### `leave_attendance_response.dart`
مدل response برای درخواست‌های مرخصی و حضور و غیاب شامل:
- انواع مختلف مرخصی (استحقاقی، استعلاجی، بدون حقوق، ساعتی، مناسبتی)
- جزئیات مربوط به هر نوع مرخصی

#### `mission_work_response.dart`
مدل response برای درخواست‌های مأموریت و کار شامل:
- مأموریت برون‌شهری
- مأموریت درون‌شهری
- پرداخت هزینه‌های مأموریت

#### `support_procurement_response.dart`
مدل response برای درخواست‌های پشتیبانی و تدارکات شامل:
- خرید تجهیزات
- لوازم مصرفی اداری
- تعمیر تجهیزات

#### `welfare_financial_response.dart`
مدل response برای درخواست‌های رفاهی و مالی شامل:
- وام یا مساعده
- بیمه تکمیلی
- کمک‌هزینه‌ها
- سایر خدمات رفاهی

### 3. `response_factory.dart`
Factory class برای ایجاد مدل‌های response مناسب بر اساس نوع درخواست.

## نحوه استفاده

### استفاده از Factory

```dart
// ایجاد مدل response از JSON
final response = RequestEntityFactory.createResponseFromMap(jsonData);

// ایجاد مدل response از JSON string
final response = RequestEntityFactory.createResponseFromJson(jsonString);

// ایجاد لیست مدل‌های response
final responses = RequestEntityFactory.createResponseListFromMaps(jsonList);
```

### استفاده از API

```dart
final datasource = EmployeeRequestDatasource(baseUrl: "https://api.example.com");

// ایجاد درخواست با مدل‌های response جدید
datasource.create(
  dto: requestParams,
  onResponse: (final response) {
    final result = response.result!;
    print('Created request with ID: ${result.id}');
    
    // دسترسی type-safe به فیلدهای خاص
    if (result is EmploymentResponseRequestEntity) {
      print('Job Title: ${result.jobTitle}');
    }
  },
  onError: (final error) {
    print('Error: ${error.message}');
  },
);
```
