import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_implementation/views/inappwebview_page.dart';
import 'package:webview_implementation/views/webview_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Get.to(const InappwebviewPage()),
              child: const Text('InappwebviewPage'),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Get.to(const WebViewPage()),
              child: const Text('WebviewPage'),
            ),
          ],
        ),
      ),
    );
  }
}
