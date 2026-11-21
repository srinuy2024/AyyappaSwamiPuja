import 'package:flutter/material.dart';
import 'constants/app_typography.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PujaMandiramApp());
}

class PujaMandiramApp extends StatelessWidget {
  const PujaMandiramApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'పూజా మందిరం',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppTypography.primaryMaroon,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppTypography.primaryMaroon,
          primary: AppTypography.primaryMaroon,
          secondary: AppTypography.templeDeepOrange,
        ),
        scaffoldBackgroundColor: AppTypography.saffronBackground,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppTypography.primaryMaroon,
          foregroundColor: Colors.white,
          elevation: 2,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
