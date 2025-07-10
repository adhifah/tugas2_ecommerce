import 'package:flutter/foundation.dart'; // untuk kIsWeb
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (kIsWeb) {
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: "AIzaSyBgKdFylxdUlDH-we49EWVtQXD99cIfcbk",
          authDomain: "ecommerce-flutter-9cb73.firebaseapp.com",
          projectId: "ecommerce-flutter-9cb73",
          storageBucket: "ecommerce-flutter-9cb73.appspot.com",
          messagingSenderId: "436141298886",
          appId: "1:436141298886:web:027ed117bdfc5b629eb3c7",
          measurementId: "G-5X9GWVF4WR",
        ),
      );
    } else {
      await Firebase.initializeApp();
    }
  } catch (e) {
    print('Firebase init error: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();

    final user = FirebaseAuth.instance.currentUser;
    print("Current Firebase user: $user");

    if (user != null) return true;

    final shared = prefs.getBool("loggedIn") ?? false;
    print("SharedPreferences login status: $shared");

    return shared;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-Commerce App',
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      home: FutureBuilder<bool>(
        future: isLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.hasError) {
            return const Scaffold(
              body: Center(child: Text("Terjadi kesalahan saat cek login")),
            );
          }

          if (snapshot.data == true) {
            return HomeScreen();
          } else {
            return LoginScreen();
          }
        },
      ),
    );
  }
}
