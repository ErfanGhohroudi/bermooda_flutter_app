import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:u/utilities.dart';

import '../../../../../../../core/core.dart';
import '../../../../../../../core/theme.dart';


class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({
    required this.action,
    required this.onPopScope,
    super.key,
  });

  final Function(String uuid) action;
  final VoidCallback onPopScope;

  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> with WidgetsBindingObserver {
  /// MobileScannerController to handle barcode scanning
  final MobileScannerController controller = MobileScannerController();

  /// Variable to store the last scanned barcode
  String? barcode;

  @override
  void initState() {
    super.initState();
    /// Register the observer to listen for lifecycle changes
    WidgetsBinding.instance.addObserver(this);

    /// Start the barcode scanner
    controller.start();
  }

  @override
  void dispose() {
    /// Remove the observer when disposing the widget
    WidgetsBinding.instance.removeObserver(this);

    /// Stop and dispose of the scanner to release camera resources
    controller.stop();
    controller.dispose();

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(final AppLifecycleState state) {
    /// Ensure the app has camera permission before controlling the scanner
    if (!controller.value.hasCameraPermission) return;

    switch (state) {
      case AppLifecycleState.resumed:
      /// Resume scanning when the app is back in the foreground
        controller.start();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      /// Stop scanning when the app is no longer active
        controller.stop();
        break;
      default:
        break;
    }
  }

  @override
  Widget build(final BuildContext context) {
    final size = MediaQuery.of(context).size;

    /// Define the scan window as a square with 50px horizontal padding
    final scanWindow = Rect.fromLTWH(
      50, // Left padding
      (size.height - size.width) / 2, // Center vertically
      size.width - 100, // Width (screen width minus 100px padding)
      size.width - 100, // Height (same as width to make it a square)
    );

    return PopScope(
      onPopInvokedWithResult: (final didPop, final result) => widget.onPopScope(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(s.scanQRCode),
        ),
        body: Stack(
          children: [
            /// Barcode scanner with a restricted scanning area
            MobileScanner(
              controller: controller,
              scanWindow: scanWindow, // Define the scan window
              onDetect: (final BarcodeCapture capture) {
                final List<Barcode> barcodes = capture.barcodes;
                if (barcodes.isNotEmpty) {
                  final newBarcode = barcodes.first.rawValue;
                  /// Ensure the scanned barcode is new before updating state
                  if (newBarcode != null && newBarcode != barcode) {
                    setState(() => barcode = newBarcode);

                    /// Trigger the action with the scanned barcode
                    widget.action(newBarcode);

                    /// Navigate back after a successful scan
                    UNavigator.back();
                  }
                }
              },
            ),

            /// Scanner animation overlay positioned over the scan window
            Positioned(
              left: scanWindow.left,
              top: scanWindow.top,
              child: UImage(
                AppLottie.scanner,
                width: scanWindow.width,
                height: scanWindow.height,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
