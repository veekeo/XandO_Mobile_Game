import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';
import 'package:xando/APIs/firebase_api.dart';
import 'package:xando/Providers/Auth_providers/affliate_provider.dart';
import 'package:xando/Providers/Auth_providers/auth_provider.dart';
import 'package:xando/Providers/Auth_providers/google_auth_provider.dart';
import 'package:xando/Providers/Auth_providers/phone_auth_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:xando/Providers/Database/db_provider.dart';
import 'package:xando/Providers/Game/audio_provider.dart';
import 'package:xando/Providers/Game/create_game_provider.dart';
import 'package:xando/Providers/Game/get_available_games_provider.dart';
import 'package:xando/Providers/Profile/edit_profile_provider.dart';
import 'package:xando/Providers/avatar_provider.dart';
import 'package:xando/Providers/dependency_injection.dart';
import 'package:xando/Providers/firestore_service.dart';
import 'package:xando/Providers/internet_provider.dart';
import 'package:xando/Providers/paystack_provider.dart';
import 'package:xando/Providers/snackbar_provider.dart';
import 'package:xando/screens/splash_screen.dart';
import 'package:xando/utils/dynamic_links.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  DependencyInjection.init();
  await FirebaseApi().requestNotificationPermission();
  FirebaseApi().initNotif();
  FirebaseApi().initializeFirebaseMessaging();
  runApp(const MyApp());
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthenticationProvider()),
        ChangeNotifierProvider(create: (_) => AffliateProvider()),
        ChangeNotifierProvider(create: (_) => PointerSnackbarProvider()),
        ChangeNotifierProvider(create: (_) => PhoneNumberAuthProvider()),
        ChangeNotifierProvider(create: (_) => GoogleAuthenticationProvider()),
        ChangeNotifierProvider(create: (_) => InternetProvider()),
        ChangeNotifierProvider(create: (_) => DatabaseProvider()),
        ChangeNotifierProvider(create: (_) => AvatarProvider()),
        ChangeNotifierProvider(create: (_) => EditProfileProvider()),
        ChangeNotifierProvider(create: (_) => CreateGameProvider()),
        ChangeNotifierProvider(create: (_) => GetAvailableGamesProvider()),
        ChangeNotifierProvider(create: (_) => PaystackProvider()),
        ChangeNotifierProvider(create: (_) => FireStoreServiceProvider()),
        ChangeNotifierProvider(create: (_) => DynamicLinksProvider()),
        ChangeNotifierProvider(create: (_) => AudioProvider()),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'XOXO',
        theme: ThemeData.dark().copyWith(
          primaryColor: const Color(0xFF3B4FFE),
          scaffoldBackgroundColor: const Color.fromARGB(255, 0, 7, 38),
          cardColor: const Color.fromARGB(255, 32, 40, 73),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
