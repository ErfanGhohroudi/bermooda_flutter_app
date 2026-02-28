import '../../../../../core/core.dart';

enum RoomConnectionState {
  connecting("Connecting...", "در حال اتصال..."),
  update("Update...", "بروزرسانی..."),
  done("", "");

  const RoomConnectionState(this.tEn, this.tFa);

  String get title => !isPersianLang ? tEn : tFa;

  final String tEn;
  final String tFa;
}

extension RoomConnectionStateExt on RoomConnectionState {
  RoomConnectionState connecting() => RoomConnectionState.connecting;
  RoomConnectionState update() => RoomConnectionState.update;
  RoomConnectionState done() => RoomConnectionState.done;
}
