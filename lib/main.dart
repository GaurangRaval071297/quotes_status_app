import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/main_screen.dart';
import 'package:provider/provider.dart';
import 'services/firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(const QuotesApp());
}

class QuotesApp extends StatelessWidget {
  const QuotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<FirebaseService>(
      create: (_) => FirebaseService(),
      child: MaterialApp(
        title: 'Quotes For Every MOOD!',
        theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
        home: const MainScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}