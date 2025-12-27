import 'dart:async';
import '../../data/data.dart';

/// Event Bus برای مدیریت رویدادهای مربوط به درخواست‌ها
class RequestEventBus {
  static final RequestEventBus _instance = RequestEventBus._internal();
  factory RequestEventBus() => _instance;
  RequestEventBus._internal();

  StreamController<IRequestReadDto>? _requestUpdatedController;

  /// Stream برای گوش دادن به به‌روزرسانی درخواست‌ها
  Stream<IRequestReadDto> get requestUpdatedStream {
    _ensureController();
    return _requestUpdatedController!.stream;
  }

  /// اطمینان از وجود controller
  void _ensureController() {
    if (_requestUpdatedController == null ||
        _requestUpdatedController!.isClosed) {
      _requestUpdatedController = StreamController<IRequestReadDto>.broadcast();
    }
  }

  /// ارسال رویداد به‌روزرسانی درخواست
  void emitRequestUpdated(final IRequestReadDto updatedRequest) {
    _ensureController();
    if (!_requestUpdatedController!.isClosed) {
      _requestUpdatedController!.add(updatedRequest);
    }
  }

  /// بررسی وضعیت Event Bus
  bool get isClosed => _requestUpdatedController?.isClosed ?? true;

  /// باز کردن مجدد Event Bus
  void restart() {
    if (_requestUpdatedController != null &&
        !_requestUpdatedController!.isClosed) {
      _requestUpdatedController!.close();
    }
    _requestUpdatedController = StreamController<IRequestReadDto>.broadcast();
  }

  /// بستن Event Bus
  void dispose() {
    _requestUpdatedController?.close();
    _requestUpdatedController = null;
  }
}
