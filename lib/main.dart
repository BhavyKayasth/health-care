import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_colors.dart';
import 'firebase_options.dart';
import 'splash/screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //----------------------------------------------------------
  // INITIALIZE FIREBASE
  //----------------------------------------------------------

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //----------------------------------------------------------
  // INITIALIZE STEP BACKGROUND SERVICE
  //----------------------------------------------------------

  // await initializeStepBackgroundService();

  //----------------------------------------------------------
  // START APP
  //----------------------------------------------------------

  runApp(
    const ProviderScope(
      child: HealthCareApp(),
    ),
  );
}

class HealthCareApp extends StatelessWidget {
  const HealthCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HealthCare AI',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Poppins',

        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ),
      ),

      home: const SplashScreen(),
    );
  }
}