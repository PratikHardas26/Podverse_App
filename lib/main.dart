//import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:podverse_app/View/splash_Screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyCyC3VQ2oz3rXz4ljBIsdpoQgETE7NBg18",
      appId: "1:458919584513:android:eeecd67a794e9dd147b100",
      messagingSenderId: "458919584513",
      projectId: "fir-demo-ac7d1",
      storageBucket: "fir-demo-ac7d1.firebasestorage.app",
    ),
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: SplashScreen());
  }
}
