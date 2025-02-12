import 'package:connectivity_plus/connectivity_plus.dart';

Future<bool> checkInternetConnection() async {
  final connectivityResult = await Connectivity().checkConnectivity();

  if (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi) {
    // Intenta realizar un ping a un servidor externo para confirmar
    try {
      final result = await Uri.parse("https://www.google.com")
          .resolve("favicon.ico")
          .toString();
      return result.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  return false; // Sin conexión a Internet.
}
