import 'package:action_slider/action_slider.dart';
import 'package:u/utilities.dart';

import '../../../../../../core/widgets/widgets.dart';
import '../../../../../../core/core.dart';
import '../../../../../../core/navigator/navigator.dart';
import '../../../../../../core/theme.dart';

class LocationHelper {
  LocationHelper(final ActionSliderController actionSliderController): _actionSliderController = actionSliderController;

  final ActionSliderController _actionSliderController;

  void getLocationPermission({required final VoidCallback action}) async {
    _actionSliderController.loading();
    // Check GPS is Enable
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _actionSliderController.reset();
      return showAppDialog(
        AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 24,
            children: [
              Text('${s.gpsIsOff}\n\n${s.getLocationDescribe}').bodyMedium(),
              UElevatedButton(
                width: navigatorKey.currentContext!.width,
                title: s.settings,
                onTap: () async {
                  UNavigator.back();
                  await Geolocator.openLocationSettings();
                  return;
                },
              ),
            ],
          ),
        ),
      );
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if ((permission == LocationPermission.whileInUse || permission == LocationPermission.always)) {
      action();
    } else {
      _actionSliderController.reset();
      showAppDialog(
        AlertDialog(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 5,
            children: [
              UImage(AppIcons.locationOutline, size: 25, color: navigatorKey.currentContext!.theme.primaryColorDark),
              Text(s.locationPermission).titleMedium(),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 24,
            children: [
              Text(s.getLocationDescribe).bodyMedium(),
              UElevatedButton(
                width: navigatorKey.currentContext!.width,
                title: s.confirm,
                onTap: () {
                  UNavigator.back();
                  _checkLocationPermission(permission, action: action);
                },
              ),
            ],
          ),
        ),
      );
    }
  }

  void _checkLocationPermission(LocationPermission permission, {required final VoidCallback action}) async {
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // If user denied permission
        _actionSliderController.reset();
        return AppNavigator.snackbarRed(title: s.error, subtitle: s.locationIsRequiredToAttendance);
      }
    }

    // If user denied permission forever
    if (permission == LocationPermission.deniedForever) {
      return _showPermissionDeniedDialog();
    }

    // If user accepted permission
    if ((permission == LocationPermission.whileInUse || permission == LocationPermission.always)) {
      action();
    }
  }

  void _showPermissionDeniedDialog() {
    _actionSliderController.reset();
    showAppDialog(AlertDialog(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 5,
        children: [
          UImage(AppIcons.locationOutline, size: 25, color: navigatorKey.currentContext!.theme.primaryColorDark),
          Text(s.locationPermission).titleMedium(),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 24,
        children: [
          Text(s.enableLocationAccess).bodyMedium(),
          Row(
            spacing: 10,
            children: [
              UElevatedButton(
                title: s.cancel,
                backgroundColor: navigatorKey.currentContext!.theme.hintColor,
                onTap: UNavigator.back,
              ).expanded(),
              UElevatedButton(
                title: s.settings,
                onTap: () {
                  UNavigator.back();
                  Geolocator.openAppSettings();
                },
              ).expanded(),
            ],
          ),
        ],
      ),
    ));
  }
}