import 'package:flutter/material.dart';
import 'package:control_ganadero/services/api_service.dart';
import 'package:control_ganadero/utils/network_utils.dart';
import 'package:control_ganadero/utils/ui_utilis.dart';
import '../../utils/direccionesApi.dart';
import '../../widgets/app_bar.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onThemeToggle;

  const LoginScreen({super.key, required this.onThemeToggle});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _controllerIdentificacion;
  late TextEditingController _controllerPassword;

  @override
  void initState() {
    super.initState();
    _controllerIdentificacion = TextEditingController();
    _controllerPassword = TextEditingController();
  }

  @override
  void dispose() {
    _controllerIdentificacion.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }

  void _login() async {
    if (_controllerIdentificacion.text.isEmpty ||
        _controllerPassword.text.isEmpty) {
      showSnackbar(context, 'Por favor, completa todos los campos.');
      return;
    }

    showSnackbar(context, 'Intentando iniciar sesión...');

    try {
      bool isConnected = await checkInternetConnection();
      if (!isConnected) {
        showSnackbar(
            context, 'No hay conexión a Internet. Verifica tu conexión.');
        return;
      }

      var apiService = ApiService(baseUrl);
      var response = await apiService.getDatainiciodeSesionGo(
        urllogin,
        _controllerIdentificacion.text,
        _controllerPassword.text,
        1,
        1.0,
      );

      if (response.okMessage != null) {
        Navigator.pushReplacementNamed(
          context,
          '/home',
          arguments: {
            'userToken': '${response.datos?.token}',
            'userName': '${response.datos?.usuario?.nombre}',
            'userId': '${response.datos?.usuario?.id}',
          },
        );
      } else if (response.errorMessage != null) {
        showSnackbar(context,
            'Código de error: ${response.errorMessage!.code} - ${response.errorMessage!.message}');
      } else {
        showSnackbar(context, 'Estructura de respuesta inesperada.');
      }
    } catch (e) {
      showSnackbar(context, 'Ocurrió un error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Obtén el tema actual

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'InnovGoEx', // Pasa solo el texto como string
        elevation: 1.0,
      ),
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShowLogo(isActive: true),
                const SizedBox(height: 40),
                TextField(
                  controller: _controllerIdentificacion,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: theme.inputDecorationTheme.fillColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: theme.dividerColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: theme.primaryColorDark),
                    ),
                    hintText: 'Identificación',
                    hintStyle: TextStyle(
                      color: theme.hintColor,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Nunito',
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _controllerPassword,
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: theme.inputDecorationTheme.fillColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: theme.dividerColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: theme.primaryColorDark),
                    ),
                    hintText: 'Contraseña',
                    hintStyle: TextStyle(
                      color: theme.hintColor,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Nunito',
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _login,
                  child: Text('Iniciar Sesión',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: widget.onThemeToggle,
        child: Icon(
          Theme.of(context).brightness == Brightness.dark
              ? Icons.wb_sunny // Sol para el modo oscuro
              : Icons.nightlight_round, // Luna para el modo claro
        ),
      ),
    );
  }
}
