import 'package:u/utilities.dart';

import '../../../core/widgets/widgets.dart';
import '../../../core/core.dart';
import '../../../core/navigator/navigator.dart';
import 'payment_receipt/payment_receipt_page.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({
    required this.zibalGatewayUrl,
    this.onPaymentSuccess,
    this.onPaymentError,
    this.onPaymentCancel,
    super.key,
  });

  final String zibalGatewayUrl;
  final Function(String invoiceCode)? onPaymentSuccess;
  final Function(String invoiceCode)? onPaymentError;
  final VoidCallback? onPaymentCancel;

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _isNavigating = false;

  String _lastUrl = '';

  @override
  void initState() {
    _initializeWebView();
    super.initState();
  }

  void _showLoading() {
    if (!mounted || _isLoading == true) return;
    setState(() {
      _isLoading = true;
    });
  }

  void _hideLoading() {
    if (!mounted || _isLoading == false) return;
    setState(() {
      _isLoading = false;
    });
  }

  void _initializeWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (final int progress) {
            // Update loading progress if needed
          },
          onPageStarted: (final String url) {
            _showLoading();
          },
          onPageFinished: (final String url) {
            _hideLoading();
            _checkForCallback(url);
          },
          onUrlChange: (final UrlChange change) {
            if (change.url == null) return;
            // _checkForCallback(change.url!);
          },
          onWebResourceError: (final WebResourceError error) {
            _hideLoading();
            _handleError(error);
          },
          onNavigationRequest: (final NavigationRequest request) {
            _checkForCallback(request.url);
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.zibalGatewayUrl));
  }

  void _checkForCallback(final String url) {
    if (url == _lastUrl || !mounted || _isNavigating) return;
    _lastUrl = url;
    final uri = Uri.parse(url);
    final parameters = uri.queryParameters;
    final pathSegments = uri.pathSegments;

    final invoiceCode = parameters["invoice_code"];

    if (pathSegments.lastOrNull == "ApplyPayment" &&
        parameters["status"] == "3") {
      /// isCanceled
      _isNavigating = true;
      widget.onPaymentCancel?.call();
      _navigateBack();
    } else if (invoiceCode != null &&
        pathSegments.lastOrNull == 'successfulPayment') {
      /// isSuccess
      _isNavigating = true;
      widget.onPaymentSuccess?.call(invoiceCode);
      _navigateToInvoicePage(invoiceCode, PaymentReceiptStatus.success);
    } else if (invoiceCode != null &&
        pathSegments.lastOrNull == 'unsuccessfulPayment') {
      /// isError
      _isNavigating = true;
      widget.onPaymentError?.call(invoiceCode);
      _navigateToInvoicePage(invoiceCode, PaymentReceiptStatus.fail);
    }
  }

  void _handleError(final WebResourceError error) {
    AppNavigator.snackbarRed(
      title: s.error,
      subtitle: error.description,
    );
  }

  void _navigateToInvoicePage(
      final String invoiceCode, final PaymentReceiptStatus status) {
    if (!mounted || _isNavigating) return;
    _isNavigating = true;
    UNavigator.off(PaymentReceiptPage(invoiceCode: invoiceCode, status: status));
  }

  void _navigateBack() {
    if (!mounted) return;
    _isNavigating = true;
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  Future<void> _reload() async {
    _showLoading();
    await _controller.reload();
  }

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(s.payment),
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back),
        //   onPressed: _goBack,
        // ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _reload,
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 16,
                children: [
                  const WCircularLoading(),
                  Text(s.wait).titleMedium(color: Colors.grey),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
