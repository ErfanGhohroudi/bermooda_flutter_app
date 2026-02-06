---
description: Clean Architecture, SOLID, DRY, and Dependency Injection principles for Flutter/Dart
alwaysApply: true
---

# Clean Architecture, SOLID, DRY & Dependency Injection Rules

این rule اصول Clean Architecture، SOLID، DRY و Dependency Injection را برای پروژه Flutter/Dart اعمال می‌کند.

## 🏗️ Clean Architecture Structure

### Layer Separation

هر Feature باید ساختار زیر را داشته باشد:

```
feature_name/
  domain/
    entities/          # Business objects (pure Dart, no dependencies)
    repositories/      # Abstract repository interfaces
    usecases/         # Business logic (one use case per operation)
  data/
    repositories/      # Repository implementations
    datasources/      # Remote/Local data sources
    dto/              # Data Transfer Objects
  presentation/
    controllers/      # State management (GetX controllers)
    pages/            # Screen widgets
    widgets/          # Reusable UI components
```

### ✅ DO

```dart
// ✅ Domain Layer - Pure Dart, no Flutter dependencies
class InvoiceEntity {
  final int id;
  final String code;
  final double total;
  
  InvoiceEntity({required this.id, required this.code, required this.total});
}

// ✅ Domain Repository - Abstract interface
abstract class InvoiceRepository {
  Future<InvoiceEntity> getInvoiceById(int id);
}

// ✅ Use Case - Single responsibility, business logic
class GetInvoiceByIdUseCase {
  final InvoiceRepository repository;
  
  GetInvoiceByIdUseCase(this.repository);
  
  Future<InvoiceEntity> call(int id) => repository.getInvoiceById(id);
}

// ✅ Data Layer - Implementation
class InvoiceRepositoryImpl implements InvoiceRepository {
  final InvoiceRemoteDataSource remoteDataSource;
  
  InvoiceRepositoryImpl({required this.remoteDataSource});
  
  @override
  Future<InvoiceEntity> getInvoiceById(int id) {
    return remoteDataSource.getInvoiceById(id);
  }
}
```

### ❌ DON'T

```dart
// ❌ DON'T: Business logic in controllers
class InvoiceController extends GetxController {
  Future<void> getInvoice(int id) async {
    final response = await http.get('/invoice/$id'); // Direct API call
    // Business logic here...
  }
}

// ❌ DON'T: Domain depends on data layer
import '../data/datasources/invoice_remote_datasource.dart'; // Wrong!

// ❌ DON'T: Entities with Flutter dependencies
import 'package:flutter/material.dart'; // Wrong in domain layer!
```

---

## 🔷 SOLID Principles

### 1. Single Responsibility Principle (SRP)

هر کلاس باید فقط یک دلیل برای تغییر داشته باشد.

```dart
// ✅ GOOD: Separate concerns
class InvoiceValidator {
  bool validate(InvoiceEntity invoice) { /* validation logic */ }
}

class InvoiceCalculator {
  double calculateTotal(List<InvoiceProduct> products) { /* calculation */ }
}

// ❌ BAD: Multiple responsibilities
class InvoiceManager {
  bool validate(InvoiceEntity invoice) { /* validation */ }
  double calculateTotal(List<InvoiceProduct> products) { /* calculation */ }
  Future<void> save(InvoiceEntity invoice) { /* persistence */ }
  void sendEmail(InvoiceEntity invoice) { /* notification */ }
}
```

### 2. Open/Closed Principle (OCP)

کلاس‌ها باید برای توسعه باز و برای تغییر بسته باشند.

```dart
// ✅ GOOD: Use interfaces/abstract classes
abstract class PaymentMethod {
  Future<void> pay(double amount);
}

class CashPayment implements PaymentMethod {
  @override
  Future<void> pay(double amount) { /* cash logic */ }
}

class CreditCardPayment implements PaymentMethod {
  @override
  Future<void> pay(double amount) { /* card logic */ }
}

// ❌ BAD: Modify existing class for new payment method
class PaymentProcessor {
  Future<void> payCash(double amount) { /* cash */ }
  Future<void> payCard(double amount) { /* card */ }
  // Adding new method requires modifying this class
}
```

### 3. Liskov Substitution Principle (LSP)

زیرکلاس‌ها باید بتوانند جایگزین کلاس والد شوند بدون تغییر رفتار.

```dart
// ✅ GOOD: Proper inheritance
abstract class DataSource {
  Future<Map<String, dynamic>> fetch(String id);
}

class RemoteDataSource implements DataSource {
  @override
  Future<Map<String, dynamic>> fetch(String id) { /* network call */ }
}

class LocalDataSource implements DataSource {
  @override
  Future<Map<String, dynamic>> fetch(String id) { /* local storage */ }
}

// Repository can use any DataSource implementation
class Repository {
  final DataSource dataSource;
  Repository(this.dataSource);
  
  Future<Map<String, dynamic>> getData(String id) => dataSource.fetch(id);
}
```

### 4. Interface Segregation Principle (ISP)

کلاینت‌ها نباید به متدهایی که استفاده نمی‌کنند وابسته باشند.

```dart
// ✅ GOOD: Small, focused interfaces
abstract class ReadableRepository {
  Future<InvoiceEntity> getById(int id);
}

abstract class WritableRepository {
  Future<void> create(InvoiceEntity entity);
  Future<void> update(InvoiceEntity entity);
}

class InvoiceRepository implements ReadableRepository, WritableRepository {
  // Implement both interfaces
}

// ❌ BAD: Large interface forcing implementation of unused methods
abstract class Repository {
  Future<InvoiceEntity> getById(int id);
  Future<void> create(InvoiceEntity entity);
  Future<void> update(InvoiceEntity entity);
  Future<void> delete(int id);
  Future<void> sendEmail(int id); // Not all repositories need this!
}
```

### 5. Dependency Inversion Principle (DIP)

وابستگی‌ها باید به abstractions باشند، نه concrete implementations.

```dart
// ✅ GOOD: Depend on abstraction
class GetInvoiceUseCase {
  final InvoiceRepository repository; // Interface, not implementation
  
  GetInvoiceUseCase(this.repository);
  
  Future<InvoiceEntity> call(int id) => repository.getInvoiceById(id);
}

// ❌ BAD: Depend on concrete implementation
class GetInvoiceUseCase {
  final InvoiceRepositoryImpl repository; // Concrete class!
  
  GetInvoiceUseCase(this.repository);
}
```

---

## 🔄 DRY (Don't Repeat Yourself)

### Extract Common Logic

```dart
// ✅ GOOD: Reusable utility/helper
class DateFormatter {
  static String format(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }
}

// Use everywhere
final formatted = DateFormatter.format(DateTime.now());

// ❌ BAD: Repeated code
String formatDate1(DateTime date) => '${date.year}-${date.month}-${date.day}';
String formatDate2(DateTime date) => '${date.year}-${date.month}-${date.day}';
String formatDate3(DateTime date) => '${date.year}-${date.month}-${date.day}';
```

### Extract Common Widgets

```dart
// ✅ GOOD: Reusable widget
class LoadingButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  
  const LoadingButton({
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading ? CircularProgressIndicator() : Text(text),
    );
  }
}

// ❌ BAD: Repeated widget code in multiple places
```

---

## 💉 Dependency Injection

### Use Constructor Injection

```dart
// ✅ GOOD: Constructor injection
class InvoiceController extends GetxController {
  final GetInvoiceByIdUseCase getInvoiceUseCase;
  final CreateInvoiceUseCase createInvoiceUseCase;
  
  InvoiceController({
    required this.getInvoiceUseCase,
    required this.createInvoiceUseCase,
  });
}

// ❌ BAD: Service locator pattern (tight coupling)
class InvoiceController extends GetxController {
  void getInvoice(int id) {
    final useCase = Get.find<GetInvoiceByIdUseCase>(); // Hidden dependency
  }
}
```

### Register Dependencies Properly

```dart
// ✅ GOOD: Register in dependency_injection.dart
class DependencyInjector {
  static Future<void> init() async {
    // Data Sources
    Get.lazyPut<InvoiceRemoteDataSource>(
      () => InvoiceRemoteDataSourceImpl(client: Get.find()),
    );
    
    // Repositories
    Get.lazyPut<InvoiceRepository>(
      () => InvoiceRepositoryImpl(
        remoteDataSource: Get.find(),
      ),
    );
    
    // Use Cases
    Get.lazyPut<GetInvoiceByIdUseCase>(
      () => GetInvoiceByIdUseCase(repository: Get.find()),
    );
    
    // Controllers (use Bindings for page-specific controllers)
  }
}
```

### Use Bindings for Page Controllers

```dart
// ✅ GOOD: Page-specific bindings
class InvoiceDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => InvoiceDetailController(
      getInvoiceUseCase: Get.find(),
    ));
  }
}

// In routes
GetPage(
  name: '/invoice/:id',
  page: () => InvoiceDetailPage(),
  binding: InvoiceDetailBinding(),
);
```

---

## 📋 Checklist for New Features

هنگام ایجاد Feature جدید، این موارد را رعایت کنید:

- [ ] ساختار Clean Architecture (domain/data/presentation)
- [ ] Entities در domain بدون وابستگی به Flutter
- [ ] Repository interface در domain
- [ ] Repository implementation در data
- [ ] Use Cases برای هر عملیات business
- [ ] Controller فقط state management، نه business logic
- [ ] Dependency Injection از طریق constructor
- [ ] ثبت dependencies در dependency_injection.dart
- [ ] استفاده از abstractions نه concrete classes
- [ ] عدم تکرار کد (DRY)
- [ ] هر کلاس یک مسئولیت (SRP)

---

## 🎯 Examples from This Project

### ✅ Good Example: Invoice Feature

```
invoice/
  domain/
    entities/invoice.dart          # Pure Dart entity
    repositories/invoice_repository.dart  # Abstract interface
    usecases/get_invoice_by_id.dart       # Single use case
  data/
    repositories/invoice_repository_impl.dart  # Implementation
    datasources/invoice_remote_datasource.dart # Data source
  presentation/
    controllers/invoice_detail_controller.dart # State management
    pages/invoice_detail_page.dart             # UI
```

### ❌ Anti-Patterns to Avoid

- Business logic در controllers
- Direct API calls در controllers
- Entities با Flutter dependencies
- Use Cases با multiple responsibilities
- Concrete dependencies به جای abstractions
- Repeated validation/formatting logic
