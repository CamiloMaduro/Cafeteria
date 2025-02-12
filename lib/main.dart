import 'package:control_ganadero/models/theme.dart';
import 'package:control_ganadero/routes.dart';
import 'package:flutter/material.dart';

void main() async {
  // HttpOverrides.global = CustomHttpOverrides();
  // WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

// class CustomHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext? context) {
//     final client = super.createHttpClient(context);
//     dCertificateCallback(X509Certificate cert, String host, int port) => true;
//     return client;
//   }
// }

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light; // Estado inicial del tema

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tipyk',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode, // Usa el estado del tema
      initialRoute: '/splash', // Ruta inicial del splash screen
      onGenerateRoute: (settings) => RouteGenerator.generateRoute(
        settings,
        _toggleTheme, // Pasar la función de cambio de tema aquí
      ),
    );
  }
}
