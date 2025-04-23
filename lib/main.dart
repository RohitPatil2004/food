import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'services/theme_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/login_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Provider.of<ThemeService>(context);

    return MaterialApp(
      title: 'Food App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        brightness: Brightness.light,
        appBarTheme: const AppBarTheme(
          color: Colors.deepOrange,
          elevation: 0,
        ),
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.orange,
        brightness: Brightness.dark,
        appBarTheme: AppBarTheme(
          color: Colors.grey[900],
          elevation: 0,
        ),
      ),
      themeMode: themeService.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: AuthenticationWrapper(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          if (user == null) {
            return const LoginScreen();
          }
          return const HomeScreen();
        } else {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
