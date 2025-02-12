import 'package:control_ganadero/screens/Comprador/HomeScreenComprador.dart';
import 'package:control_ganadero/screens/InicioSeccion/inicioSeccion.dart';
import 'package:control_ganadero/screens/InicioSeccion/splash_screen.dart';
import 'package:control_ganadero/screens/Vendedor/HomeScreenVendedor.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(
    RouteSettings settings,
    VoidCallback onThemeToggle,
  ) {
    switch (settings.name) {
      case '/splash':
        return _createPageRoute(
          SplashScreen(),
          settings,
        );

      case '/login':
        return _createPageRoute(
          LoginScreen(onThemeToggle: onThemeToggle),
          settings,
        );
      case '/home':
        final args = settings.arguments
            as Map<String, dynamic>?; // Recupera los argumentos
        final tipoUserId = args?['tipoUserId'];

        final tipoUserIdInt = tipoUserId is int
            ? tipoUserId
            : int.tryParse(tipoUserId.toString() ?? '0');

        if (tipoUserIdInt == 1) {
          return _createPageRoute(
            HomeScreenVendedor(
              userToken: args?['userToken'],
              nameUser: args?['userName'],
              userId: args?['userId'],
              empresaId: args?['empresaId'],
              tipoUserId: tipoUserIdInt.toString(),
            ),
            settings,
          );
        } else {
          return _createPageRoute(
            HomeScreenComprador(
              userToken: args?['userToken'],
              nameUser: args?['userName'],
              userId: args?['userId'],
              empresaId: args?['empresaId'],
              tipoUserId: tipoUserIdInt.toString(),
            ),
            settings,
          );
        }

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }

  static PageRouteBuilder _createPageRoute(
      Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Ajusta la duración y la curva de la animación
        const begin = Offset(0.0, 1.0); // Desplazamiento hacia arriba
        const end = Offset.zero; // Desplazamiento final
        const curve = Curves.easeInOut; // Curva de animación

        var slideTween = Tween<Offset>(begin: begin, end: end)
            .chain(CurveTween(curve: curve));
        var slideAnimation = animation.drive(slideTween);

        var fadeAnimation = Tween<double>(begin: 0.0, end: 1.0)
            .animate(CurvedAnimation(parent: animation, curve: curve));

        // Aplicar la animación de deslizamiento y desvanecimiento
        return FadeTransition(
          opacity: fadeAnimation,
          child: SlideTransition(
            position: slideAnimation,
            child: child,
          ),
        );
      },
      transitionDuration:
          Duration(milliseconds: 800), // Ajusta la duración aquí
    );
  }
}
