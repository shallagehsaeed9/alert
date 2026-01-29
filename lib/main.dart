import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔥 Full immersive mode (hide status + navigation bars)
  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WebViewPage(),
    );
  }
}

class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage>
    with WidgetsBindingObserver {

  late final WebViewController controller;

@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addObserver(this);

  final PlatformWebViewControllerCreationParams params =
      const PlatformWebViewControllerCreationParams();

  controller = WebViewController.fromPlatformCreationParams(params)
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..loadRequest(Uri.parse("http://54.38.152.132:5000/"));

  // ✅ فعال‌سازی DOM Storage برای Android
  if (controller.platform is AndroidWebViewController) {
    final androidController =
        controller.platform as AndroidWebViewController;

    androidController.setJavaScriptEnabled(true);
    androidController.setDomStorageEnabled(true);
  }
}



  // 🔒 re-hide system bars after resume
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.immersiveSticky,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebViewWidget(controller: controller),
    );
  }
}


