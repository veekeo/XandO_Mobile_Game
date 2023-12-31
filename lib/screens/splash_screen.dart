import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:xando/Providers/Auth_providers/auth_provider.dart';
import 'package:xando/Providers/Database/db_provider.dart';
import 'package:xando/main_page.dart';
import 'package:xando/screens/Auth_Screens/onboarding_screen.dart';
import 'package:xando/screens/Auth_Screens/signin_screen.dart';
import 'package:xando/screens/Auth_Screens/signup_screen.dart';
import 'package:xando/utils/dynamic_links.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    final dbProvider = context.read<DatabaseProvider>();

    super.initState();
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    // print(dbProvider.usr);

    Future.delayed(
      const Duration(seconds: 2),
      () {
        dbProvider.getContact().then((value) async {
          if (value == '') {
            Navigator.of(context)
                .pushReplacement(CupertinoPageRoute(builder: (context) {
              return const OnboardingScreen();
            }));
          } else {
            dbProvider.getUserRemembrance().then((value) {
              if (value == true) {
                Navigator.of(context)
                    .pushReplacement(CupertinoPageRoute(builder: (context) {
                  return MainPage();
                }));
              } else {
                Navigator.of(context)
                    .pushReplacement(CupertinoPageRoute(builder: (context) {
                  return const SignInScreen();
                }));
              }
            });
          }
        });
      },
    );
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final dynamicLinksProvider = context.read<DynamicLinksProvider>();
    final affliateRefCode = dynamicLinksProvider.affliateRefCode;

    dynamicLinksProvider.initializeDynamicLink().then((value) {
      if (value == true) {
        Navigator.of(context)
            .pushReplacement(CupertinoPageRoute(builder: (context) {
          return SignUpScreen(
            affliateCode: affliateRefCode,
          );
        }));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 170,
          height: 170,
          child: Image.asset('assets/images/logo.png'),
        ),
      ),
    );
  }
}
