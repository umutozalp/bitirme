import 'package:flutter/material.dart';
import 'dart:ui' show PointerDeviceKind;
import 'package:bitirme/core/app_theme.dart';
import 'package:bitirme/src/view/screen/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Stripe'ı başlat
  Stripe.publishableKey =
      'pk_test_51Qc0Z5FsTMJbzVuHIS8tZL17mLNFhhUydweQll93uF3Gt46FAIBIAVuwWVrn1jRnEYJVlh9VPlMqfjzSJ6ML5dDY00M8chSssd';
  await Stripe.instance.applySettings();

  // Firebase başlatma
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
        },
      ),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
      theme: AppTheme.lightAppTheme,
    );
  }
}
