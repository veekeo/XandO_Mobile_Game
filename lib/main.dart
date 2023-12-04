// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xando/Providers/Auth_providers/auth_provider.dart';
import 'package:xando/Providers/Auth_providers/phone_auth_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:xando/screens/splash_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthenticationProvider()),
        ChangeNotifierProvider(create: (_) => PhoneNumberAuthProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'X and O',
        theme: ThemeData.dark().copyWith(
          primaryColor: Color(0xFF3B4FFE),
          scaffoldBackgroundColor: Color.fromARGB(255, 0, 7, 38),
          cardColor: Color.fromARGB(255, 32, 40, 73),
          useMaterial3: true,
        ),
        home: SplashScreen(),
      ),
    );
  }
}
