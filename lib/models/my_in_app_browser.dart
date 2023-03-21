import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:webview_implementation/views/payment_success_page.dart';
import 'package:webview_implementation/views/paymente_fail_page.dart';

import '../data/url.dart';

class MyInAppBrowser extends InAppBrowser {
  final String orderID;
  final String orderType;
  final double orderAmount;
  final double maxCodOrderAmount;
  final bool isCashOnDelivery;

  MyInAppBrowser({
    required this.orderID,
    required this.orderType,
    required this.orderAmount,
    required this.maxCodOrderAmount,
    required this.isCashOnDelivery,
  });

  bool _canRedirect = true;

  @override
  Future onBrowserCreated() async {
    print("\n\nBrowser Created!\n\n");
  }

  @override
  Future onLoadStart(url) async {
    print("\n\nStarted: $url\n\n");
    _redirect(url.toString());
  }

  @override
  Future onLoadStop(url) async {
    pullToRefreshController?.endRefreshing();
    print("\n\nStopped: $url\n\n");
    _redirect(url.toString());
  }

  @override
  void onLoadError(url, code, message) {
    pullToRefreshController?.endRefreshing();
    print("Can't load [$url] Error: $message");
  }

  @override
  void onProgressChanged(progress) {
    if (progress == 100) {
      pullToRefreshController?.endRefreshing();
    }
  }

  @override
  void onExit() {
    Get.back();
  }

  @override
  Future<NavigationActionPolicy> shouldOverrideUrlLoading(
      navigationAction) async {
    print("\n\nOverride ${navigationAction.request.url}\n\n");
    return NavigationActionPolicy.ALLOW;
  }

  @override
  void onLoadResource(response) {
    print("Started at: " +
        response.startTime.toString() +
        "ms ---> duration: " +
        response.duration.toString() +
        "ms " +
        (response.url ?? '').toString());
  }

  @override
  void onConsoleMessage(consoleMessage) {
    //   print("""
    //   console output:
    //     message: ${consoleMessage.message}
    //     messageLevel: ${consoleMessage.messageLevel.toValue()}
    //  """);
  }

  void _redirect(String url) {
    if (_canRedirect) {
      bool isSuccess = url.contains('success') && url.contains(mainUrl);
      bool isFailed = url.contains('fail') && url.contains(mainUrl);
      bool isCancel = url.contains('cancel') && url.contains(mainUrl);

      if (isSuccess || isFailed || isCancel) {
        _canRedirect = false;
        close();
      }

      if (isSuccess) {
        Get.off(() => const PaymentSuccessPage());
      } else if (isFailed || isCancel) {
        Get.off(() => const PaymentFailPage());
      }
    }
  }
}
