// ignore_for_file: lines_longer_than_80_chars

import "package:flutter/material.dart";
import "package:flutter_phonepe_demo/screen/home_screen.dart";
import "package:flutter_phonepe_demo/singletons/dio_singleton.dart";
import "package:flutter_phonepe_demo/singletons/phonepe_singleton.dart";
import "package:keyboard_dismisser/keyboard_dismisser.dart";

/*
We are not providing dashboard support for the sandbox or test environment at this moment. You've to test it within the package scope.
      - PhonePe : Help & Support Team
*/

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PhonePeSingleton().init();
  await DioSingleton().addPrettyDioLoggerInterceptor();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return KeyboardDismisser(
      child: MaterialApp(
        title: "PhonePe Demo",
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.light,
          colorSchemeSeed: Colors.blue,
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          colorSchemeSeed: Colors.blue,
        ),
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
