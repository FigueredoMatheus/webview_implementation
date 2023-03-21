import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:webview_implementation/data/url.dart';
import 'package:webview_implementation/models/my_in_app_browser.dart';
import 'dart:io';

class InappwebviewPage extends StatefulWidget {
  const InappwebviewPage({super.key});

  @override
  State<InappwebviewPage> createState() => _InappwebviewPageState();
}

class _InappwebviewPageState extends State<InappwebviewPage> {
  late MyInAppBrowser browser;
  late PullToRefreshController pullToRefreshController;

  @override
  void initState() {
    super.initState();
    browser = MyInAppBrowser(
      orderID: 'OrderID',
      orderType: 'orderType',
      orderAmount: 1,
      maxCodOrderAmount: 1,
      isCashOnDelivery: true,
    );

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.black,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          browser.webViewController.reload();
        } else if (Platform.isIOS) {
          browser.webViewController.loadUrl(
              urlRequest:
                  URLRequest(url: await browser.webViewController.getUrl()));
        }
      },
    );

    browser.pullToRefreshController = pullToRefreshController;

    openUrl();
  }

  openUrl() async {
    await browser.openUrlRequest(
      urlRequest: URLRequest(url: Uri.parse(PAYMENT_URL)),
      options: InAppBrowserClassOptions(
        crossPlatform: InAppBrowserOptions(
          hideUrlBar: true,
          hideToolbarTop: true,
          hideProgressBar: true,
        ),
        inAppWebViewGroupOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
            useShouldOverrideUrlLoading: true,
            useOnLoadResource: true,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
