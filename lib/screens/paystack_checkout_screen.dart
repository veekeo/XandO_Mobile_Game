import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:xando/Providers/Profile/edit_profile_provider.dart';
import 'package:xando/Providers/paystack_provider.dart';
import 'package:xando/models/user_profile_model.dart';

class PaystackCheckoutScreen extends StatefulWidget {
  const PaystackCheckoutScreen({super.key, required this.url});
  final String url;

  @override
  State<PaystackCheckoutScreen> createState() => _PaystackCheckoutScreenState();
}

class _PaystackCheckoutScreenState extends State<PaystackCheckoutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 7, 38),
        title: Text(
          'Account Deposit',
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.bold,
                fontSize: 18,
                useGoogleFonts: GoogleFonts.asMap()
                    .containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
              ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.height,
            height: MediaQuery.of(context).size.height,
            child: WebViewWidget(
              controller: WebViewController()
                ..setJavaScriptMode(JavaScriptMode.unrestricted)
                ..loadRequest(
                  Uri.parse(widget.url),
                )
                ..setNavigationDelegate(
                  NavigationDelegate(
                    onNavigationRequest: (NavigationRequest request) async {
                      final paystack = context.read<PaystackProvider>();
                      UserModel initialUserBalance =
                          await EditProfileProvider().getUserProfileData();
                      //-----------------
                      if (request.url.startsWith('https://google.com')) {
                        // ignore: use_build_context_synchronously
                        await paystack
                            .verifyTransaction(context)
                            .then((value) async {
                          await paystack
                              .calcUserTotalAmount(
                                  context, initialUserBalance.gamedata!.coin)
                              .then((value) => Navigator.pop(context));
                        });
                      }
                      if (request.url
                          .startsWith('https://standard.paystack.co/close')) {
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pop(); //close webview
                      }

                      return NavigationDecision.navigate;
                    },
                    onPageFinished: (String url) {
                      if (url
                          .startsWith('https://standard.paystack.co/close')) {
                        Navigator.of(context).pop(); //close webview
                      }
                    },
                  ),
                ),
            ),
          ),
        ),
      ),
    );
  }
}
