import 'package:base_app_flutter/component/Component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebviewPage extends StatefulWidget {
  var url;
  var title;

  WebviewPage({required this.url, required this.title, Key? key})
      : super(key: key);

  @override
  State<WebviewPage> createState() => _WebviewPageState(
        url,
        title,
      );
}

class _WebviewPageState extends State<WebviewPage> {
  final flutterWebViewPlugin = FlutterWebviewPlugin();
  var url;
  var title;


  _WebviewPageState(this.url, this.title);

  @override
  void initState() {
    super.initState();
    flutterWebViewPlugin.close();
  }

  @override
  void dispose() {
    super.dispose();
    flutterWebViewPlugin.dispose();
  }

  @override
  Widget build(BuildContext context) {
     return WebviewScaffold(
      appBar: Component.appbar(name: title),
      initialChild: const Expanded(
        child: Center(
            child: SizedBox(
                height: 64, width: 64, child: CircularProgressIndicator())),
      ),
      url: url,
      hidden: false,
      appCacheEnabled: true,
      withJavascript: true,
      // withLocalStorage: true,
    );
  }
}
