import 'package:control_ganadero/services/api_service.dart';
import 'package:control_ganadero/utils/alertDialog.dart';
import 'package:control_ganadero/utils/direccionesApi.dart';
import 'package:control_ganadero/widgets/app_bar.dart';
import 'package:flutter/material.dart';

import '../../utils/devicesBox.dart';
import '../../utils/text_styles.dart';

class HomeScreen extends StatefulWidget {
  final String? userToken;
  final String? nameUser;
  final String? userId;

  HomeScreen({this.userToken, this.nameUser, this.userId});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ApiService apiService;

  @override
  void initState() {
    super.initState();
    apiService = ApiService(baseUrl);
  }

  void _logout(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _showProductionDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomAlertDialog(
          title: 'Formulario',
          iconPath: 'assets/images/Milk Bucket 3D Model (HD).png',
          Token: widget.userToken!,
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Nombre'),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Correo electrónico'),
              ),
            ],
          ),
          onTap: () async {
            var response = await apiService.getDataEspecie(
                urlgetespecie, widget.userToken!);
            print(response.datosEspecie![0].NombreEspecie);
            // Manejar envío de formulario
            print('Formulario enviado');
          },
          positiveButtonText: 'Enviar',
          negativeButtonText: 'Cancelar',
          onNegativePressed: () {
            print('Formulario cancelado');
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const double horizontalPadding = 40;

    List<Map<String, dynamic>> myDevices = [
      {
        "name": "Hacienda",
        "iconPath": "assets/images/Farmhouse 3D Model (HD).png",
        "onTap": () {
          Navigator.pushReplacementNamed(
            context,
            '/Hacienda',
            arguments: {
              'userToken': widget.userToken,
              'userName': widget.nameUser,
              'userId': widget.userId,
            },
          );
        }
      },
      {
        "name": "Producción",
        "iconPath": "assets/images/Milk Bucket 3D Model (HD).png",
        "onTap": () {
          _showProductionDialog(context);
        },
      },
    ];

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Control Ganadero',
        onLogout: () => _logout(context),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextStyles.bodyLarge(context, 'Hola,'),
            TextStyles.headlineMedium(context, '${widget.nameUser}'),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                itemCount: myDevices.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1 / 1.3,
                ),
                itemBuilder: (context, index) {
                  final device = myDevices[index];
                  return DevicesBox(
                    name: device['name'],
                    iconPath: device['iconPath'],
                    onTap: device['onTap'], // Pasa la función aquí
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
