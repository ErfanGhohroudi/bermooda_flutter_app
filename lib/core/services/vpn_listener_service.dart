import 'package:u/utilities.dart';

import '../core.dart';
import '../navigator/navigator.dart';

class VpnListenerService {
  static final VpnListenerService _instance = VpnListenerService._internal();

  factory VpnListenerService() => _instance;

  VpnListenerService._internal();

  StreamSubscription? _subscription;
  bool _isSnackBarShowing = false;

  void initialize() {
    if (_subscription != null) return;
    _onVPNActive();
    checkVPN(onIsActive: _onVPNActive, onIsNotActive: _onVPNNotActive);
    _subscription = Connectivity().onConnectivityChanged.listen((final List<ConnectivityResult> result) {
      checkVPN(onIsActive: _onVPNActive, onIsNotActive: _onVPNNotActive);
    });
  }

  void dispose() {
    _subscription?.cancel();
    _subscription = null;
    _isSnackBarShowing = false;
  }

  void checkVPN({
    required final VoidCallback onIsActive,
    required final VoidCallback onIsNotActive,
  }) async {
    final hasVpn = await UNetwork.hasVpn();
    try {
      if (hasVpn) {
        onIsActive();
      } else if (!hasVpn) {
        onIsNotActive();
      }
    } catch (e) {
      AppNavigator.snackbarRed(title: s.error, subtitle: "$e");
    }
  }

  void _onVPNActive() {
    if (_isSnackBarShowing == false) {
      _isSnackBarShowing = true;
      AppNavigator.snackbarRed(
        title: s.warning,
        subtitle: s.vpnText,
        duration: 5,
        dismissDirection: DismissDirection.none,
      );
    }
  }

  void _onVPNNotActive() {
    Get.closeAllSnackbars();
    _isSnackBarShowing = false;
  }
}
