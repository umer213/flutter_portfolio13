import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/parallax_portfolio_screen.dart';
import 'theme/professional_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyDu5l2f7KUrvTX-z8bIeMeig3ARZRpcxFE",
        authDomain: "myportfolio-358c3.firebaseapp.com",
        projectId: "myportfolio-358c3",
        storageBucket: "myportfolio-358c3.firebasestorage.app",
        messagingSenderId: "99208627923",
        appId: "1:99208627923:web:a11d68ccc06ce2f3623626"),
  );
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Portfolio',
      debugShowCheckedModeBanner: false,
      theme: ProfessionalTheme.darkTheme,
      themeMode: ThemeMode.dark,
      home: const ParallaxPortfolioScreen(),
    );
  }
}
