import 'package:flutter/material.dart';
import 'package:control_ganadero/services/api_service.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;

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
    if (!_formKey.currentState!.validate()) {
      return;
    }
    const CircularProgressIndicator(
      backgroundColor: Colors.grey,
    );

    // try {
    // bool isConnected = await checkInternetConnection();
    // if (!isConnected) {
    //   showSnackbar(
    //       context, 'No hay conexión a Internet. Verifica tu conexión.');
    //   return;
    // }

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
          'userToken': response.datos?.token ?? '',
          'userName': response.datos?.usuario?.nombre ?? '',
          'userId': response.datos?.usuario?.id.toString() ?? '',
          'empresaId':
              response.datos?.usuario?.id_empresa_sitios_entregas ?? '',
          'tipoUserId': response.datos?.usuario?.id_tipo_usuario ?? '',
        },
      );
    } else if (response.errorMessage != null) {
      showSnackbar(
        context,
        'Código de error: ${response.errorMessage!.code}',
      );
    } else {
      showSnackbar(context, 'Estructura de respuesta inesperada.');
    }
    // }
    // catch (e) {
    //   showSnackbar(context, 'Ocurrió un error');
    // }
  }

  InputDecoration _buildInputDecoration({
    required String hintText,
    required BuildContext context,
    bool isPassword = false,
    VoidCallback? togglePasswordVisibility,
  }) {
    final theme = Theme.of(context);

    return InputDecoration(
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
      hintText: hintText,
      hintStyle: TextStyle(
        color: theme.hintColor,
        fontWeight: FontWeight.bold,
        fontFamily: 'Nunito',
      ),
      suffixIcon: isPassword
          ? IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: theme.hintColor,
              ),
              onPressed: togglePasswordVisibility,
            )
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'InnovExGo',
        elevation: 1.0,
        onPressed: () {},
      ),
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const ShowLogo(isActive: true),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: 500,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _controllerIdentificacion,
                          decoration: _buildInputDecoration(
                            hintText: 'Identificación',
                            context: context,
                          ),
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingrese su identificación';
                            }
                            return null;
                          },
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).nextFocus();
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _controllerPassword,
                          obscureText: !_isPasswordVisible,
                          decoration: _buildInputDecoration(
                            hintText: 'Contraseña',
                            context: context,
                            isPassword: true,
                            togglePasswordVisibility: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingrese su contraseña';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 50,
                      ),
                    ),
                    child: const Text(
                      'Iniciar Sesión',
                      style: TextStyle(
                        fontFamily: 'Nunito',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: widget.onThemeToggle,
        child: Icon(
          theme.brightness == Brightness.dark
              ? Icons.wb_sunny // Sol para el modo oscuro
              : Icons.nightlight_round, // Luna para el modo claro
        ),
      ),
    );
  }
}
