import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:whatsapp_me/common/routes/routes.dart';
import 'package:whatsapp_me/common/theme/dark_theme.dart';
import 'package:whatsapp_me/common/theme/light_theme.dart';
import 'package:whatsapp_me/feature/auth/controller/auth_controller.dart';
import 'package:whatsapp_me/feature/home/pages/home_page.dart';
import 'package:whatsapp_me/feature/welcome/pages/welcome_page.dart';
import 'package:whatsapp_me/firebase_options.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  //this keeps splashscreen on until it loaded up all req data
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Whatsapp Me',
      theme: lightTheme(),
      darkTheme: darkTheme(),
      themeMode: ThemeMode.system,
      // home: const WelcomePage(),
      // onGenerateRoute: Routes.onGenerateRoute,
      home: ref.watch(userInfoAuthProvider).when(
        data: (user) {
          //will remove splash screen as soon as data loaded
          FlutterNativeSplash.remove();
          if (user == null) return const WelcomePage();
          return const HomePage();
        },
        error: (error, trace) {
          return const Scaffold(
            body: Center(
              child: Text('Something wrong happened!'),
            ),
          );
        },
        loading: () {
          return const Scaffold(
            body: Center(
              child: Icon(
                FontAwesomeIcons.whatsapp,
                size: 50,
              ),
            ),
          );
          // return const SizedBox();
        },
      ),
      onGenerateRoute: Routes.onGenerateRoute,
    );
  }
}
