import 'package:base_app_flutter/component/Component.dart';
import 'package:base_app_flutter/utility/Constrants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:get/get.dart';

class PaymentWebview extends StatefulWidget {
  var url;
  var title;

  PaymentWebview({required this.url, required this.title, Key? key})
      : super(key: key);

  @override
  State<PaymentWebview> createState() => _PaymentWebviewState(
        url,
        title,
      );
}

class _PaymentWebviewState extends State<PaymentWebview> {
  final flutterWebViewPlugin = FlutterWebviewPlugin();
  var url;
  var title;


  _PaymentWebviewState(this.url, this.title);

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

    flutterWebViewPlugin.onUrlChanged.listen((String url) {
      if (url.contains("ssl/callback/success")) {
        showAlert("Payment Successful");
      } else if (url.contains("ssl/callback/failed")) {
        showAlert("Payment failed, Try again");
      } else if (url.contains("ssl/callback/cancelled")) {
        showAlert("Payment failed, Try again");
      } else if (url.contains("bkash/agreement/callback")) {
        if (url.contains("status=success")) {
          Constants.showToast("Agreement successful");
          // Intent returnIntent = new Intent();
          // setResult(Activity.RESULT_OK, returnIntent);
          // finish();
        } else if (url.contains("status=cancel")) {
          Constants.showToast("Agreement unsuccessful");
        }
      } else if (url.contains("bkash/payment/callback")) {
        if (url.contains("status=success")) {
          showAlert("Payment successful");
        } else {
          Constants.showFailedToast("Payment failed, Try again");
        }
      }
    });

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

  void showAlert(String s) {
    showDialog(
        context: Get.context!,
        builder: (context) {
          return AlertDialog(
            // title: Text("Test Title"),
            content: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(s),
                  ElevatedButton(
                      onPressed: () => {Get.back()},
                      child: Text("Close"))
                ],
              ),
            ),
          );
        });
  }
}
