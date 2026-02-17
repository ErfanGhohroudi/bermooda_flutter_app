---
description: استفاده از Object به جای Map و تبدیل به Map فقط هنگام ساخت body برای API
alwaysApply: true
---

# استفاده از Object به جای Map

این rule استفاده از کلاس‌ها و object ها را به جای Map ها الزامی می‌کند و تبدیل به Map را فقط هنگام ساخت body برای ارسال به API مجاز می‌داند.

## 📋 اصول کلی

1. **استفاده از Object**: همیشه از کلاس‌ها و object ها برای نگهداری داده‌ها استفاده کن
2. **تبدیل به Map فقط برای API**: تبدیل object به Map فقط هنگام ساخت body برای ارسال به API انجام شود
3. **متد toMap()**: object ها باید متد `toMap()` داشته باشند برای تبدیل به Map

## ✅ DO - استفاده صحیح

### تعریف کلاس برای پارامترها

```dart
// ✅ GOOD: استفاده از کلاس برای پارامترها
class InvoiceParams {
  final int customerId;
  final String invoiceNumber;
  final double totalAmount;
  final List<InvoiceItemParams> items;

  InvoiceParams({
    required this.customerId,
    required this.invoiceNumber,
    required this.totalAmount,
    required this.items,
  });

  // تبدیل به Map فقط برای API
  Map<String, dynamic> toMap() {
    return {
      'customer_id': customerId,
      'invoice_number': invoiceNumber,
      'total_amount': totalAmount,
      'items': items.map((item) => item.toMap()).toList(),
    };
  }
}

class InvoiceItemParams {
  final int productId;
  final int quantity;
  final double price;

  InvoiceItemParams({
    required this.productId,
    required this.quantity,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'product_id': productId,
      'quantity': quantity,
      'price': price,
    };
  }
}
```

### استفاده در DataSource

```dart
// ✅ GOOD: دریافت object و تبدیل به Map فقط هنگام ساخت body
class InvoiceDataSource {
  final ApiClient _apiClient = Get.find();

  Future<void> createInvoice({
    required InvoiceParams params,
    required Function(GenericResponse<InvoiceDto> response) onResponse,
    required Function(GenericResponse<dynamic> errorResponse) onError,
  }) async {
    try {
      final response = await _apiClient.post(
        '/api/invoices',
        data: params.toMap(), // تبدیل به Map فقط اینجا
        skipRetry: false,
      );

      if (response.isOk) {
        onResponse(GenericResponse<InvoiceDto>.fromJson(response.data));
      } else {
        onError(GenericResponse<dynamic>.fromJson(response.data));
      }
    } on DioException {
      onError(GenericResponse());
    }
  }
}
```

### استفاده در Controller

```dart
// ✅ GOOD: استفاده از object در controller
class CreateInvoiceController extends GetxController {
  final CreateInvoiceUseCase _createInvoiceUseCase;

  CreateInvoiceController({required CreateInvoiceUseCase createInvoiceUseCase})
      : _createInvoiceUseCase = createInvoiceUseCase;

  Future<void> createInvoice() async {
    // ساخت object
    final params = InvoiceParams(
      customerId: _selectedCustomerId.value,
      invoiceNumber: _invoiceNumberController.text,
      totalAmount: _totalAmount.value,
      items: _items.map((item) => InvoiceItemParams(
        productId: item.productId,
        quantity: item.quantity,
        price: item.price,
      )).toList(),
    );

    // ارسال object به use case
    await _createInvoiceUseCase.call(params);
  }
}
```

### استفاده در Use Case

```dart
// ✅ GOOD: استفاده از object در use case
class CreateInvoiceUseCase {
  final InvoiceRepository _repository;

  CreateInvoiceUseCase({required InvoiceRepository repository})
      : _repository = repository;

  Future<Either<Failure, InvoiceEntity>> call(InvoiceParams params) async {
    // ارسال object به repository
    return await _repository.createInvoice(params);
  }
}
```

## ❌ DON'T - استفاده نادرست

### استفاده مستقیم از Map

```dart
// ❌ BAD: استفاده مستقیم از Map برای نگهداری داده
class CreateInvoiceController extends GetxController {
  final Map<String, dynamic> invoiceData = {}; // Wrong!

  void setCustomerId(int id) {
    invoiceData['customer_id'] = id; // Wrong!
  }

  void setInvoiceNumber(String number) {
    invoiceData['invoice_number'] = number; // Wrong!
  }
}
```

### ساخت Map در Controller

```dart
// ❌ BAD: ساخت Map در controller
class CreateInvoiceController extends GetxController {
  Future<void> createInvoice() async {
    // ساخت Map در controller - Wrong!
    final body = {
      'customer_id': _selectedCustomerId.value,
      'invoice_number': _invoiceNumberController.text,
      'total_amount': _totalAmount.value,
      'items': _items.map((item) => {
        'product_id': item.productId,
        'quantity': item.quantity,
        'price': item.price,
      }).toList(),
    };

    await _createInvoiceUseCase.call(body); // Wrong!
  }
}
```

### استفاده از Map در Use Case

```dart
// ❌ BAD: استفاده از Map در use case
class CreateInvoiceUseCase {
  Future<Either<Failure, InvoiceEntity>> call(Map<String, dynamic> params) async {
    // استفاده از Map - Wrong!
    return await _repository.createInvoice(params);
  }
}
```

### استفاده از Map برای نگهداری state

```dart
// ❌ BAD: استفاده از Map برای state
class InvoiceController extends GetxController {
  final RxMap<String, dynamic> invoiceData = <String, dynamic>{}.obs; // Wrong!

  void updateInvoice(Map<String, dynamic> data) {
    invoiceData.value = data; // Wrong!
  }
}

// ✅ GOOD: استفاده از object برای state
class InvoiceController extends GetxController {
  final Rx<InvoiceParams?> invoiceParams = Rx<InvoiceParams?>(null);

  void updateInvoice(InvoiceParams params) {
    invoiceParams.value = params; // Correct!
  }
}
```

## 🔄 تبدیل Object به Map

تبدیل object به Map فقط در این موارد مجاز است:

1. **در DataSource**: هنگام ساخت body برای API call
2. **در متد toMap()**: برای پیاده‌سازی تبدیل object به Map
3. **در Serialization**: برای تبدیل به JSON

```dart
// ✅ GOOD: تبدیل در DataSource
class InvoiceDataSource {
  Future<void> createInvoice(InvoiceParams params) async {
    await _apiClient.post(
      '/api/invoices',
      data: params.toMap(), // تبدیل فقط اینجا
    );
  }
}

// ✅ GOOD: تبدیل در متد toMap()
class InvoiceParams {
  Map<String, dynamic> toMap() {
    return {
      'customer_id': customerId,
      'invoice_number': invoiceNumber,
    };
  }
}

// ❌ BAD: تبدیل در Controller
class CreateInvoiceController extends GetxController {
  void createInvoice() {
    final params = InvoiceParams(...);
    final map = params.toMap(); // Wrong! نباید اینجا تبدیل شود
    // ...
  }
}
```

## 📝 مثال‌های واقعی از پروژه

### استفاده از BaseRequestParams

```dart
// ✅ GOOD: استفاده از کلاس BaseRequestParams
class MissionWorkRequestParams extends BaseRequestParams {
  const MissionWorkRequestParams({
    super.requestingUserId,
    required super.categoryType,
    super.description,
    required this.missionType,
    this.destination,
    // ...
  });

  final MissionType missionType;
  final String? destination;
  // ...

  @override
  Map<String, dynamic> toMap() {
    // تبدیل به Map فقط برای API
    return {
      ...super.toMap(),
      'subcategory': missionType.name,
      'mission_destination': destination,
      // ...
    };
  }
}
```

### استفاده در DataSource

```dart
// ✅ GOOD: دریافت object و تبدیل در DataSource
class BaseHistoryDatasource {
  Future<void> create({
    required final int? sourceId,
    required final IReportParams params, // Object
    // ...
  }) async {
    final response = await _apiClient.post(
      createUrl(params: params),
      data: createBody(id: sourceId, params: params), // تبدیل به Map اینجا
    );
  }

  Map<String, dynamic> createBody({
    required final int? id,
    required final IReportParams params,
  }) {
    // تبدیل object به Map فقط اینجا
    return params.toMap();
  }
}
```

## ⚠️ نکات مهم

1. **همیشه از Object استفاده کن**: برای نگهداری داده‌ها، state، و پارامترها از کلاس استفاده کن
2. **تبدیل فقط برای API**: تبدیل به Map فقط هنگام ساخت body برای API call انجام شود
3. **متد toMap()**: هر object که نیاز به تبدیل دارد باید متد `toMap()` داشته باشد
4. **Type Safety**: استفاده از object ها type safety را افزایش می‌دهد
5. **IntelliSense**: استفاده از object ها autocomplete و IntelliSense را فعال می‌کند

## 🔍 Checklist

قبل از commit کردن تغییرات:

- [ ] به جای Map از کلاس/object استفاده کردم؟
- [ ] متد `toMap()` را فقط برای تبدیل به Map برای API استفاده کردم؟
- [ ] در Controller از object استفاده کردم نه Map؟
- [ ] در Use Case از object استفاده کردم نه Map؟
- [ ] تبدیل به Map فقط در DataSource انجام می‌شود؟
- [ ] state ها به صورت object نگهداری می‌شوند نه Map؟
