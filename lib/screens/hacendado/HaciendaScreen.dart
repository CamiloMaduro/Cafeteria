import 'package:control_ganadero/screens/hacendado/Agregar%20Animal/AlertDialogAgregarAnimal.dart';
import 'package:control_ganadero/widgets/app_bar.dart';
import 'package:flutter/material.dart';

import '../../utils/devicesBox.dart';

class HaciendaScreen extends StatelessWidget {
  final String? userToken;
  final String? nameUser;
  final String? userId;

  HaciendaScreen({this.userToken, this.nameUser, this.userId});

  void _logout(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    final double horizontalPadding = 40;

    List<Map<String, dynamic>> myDevices = [
      {
        "name": "Agregar Animal",
        "iconPath": "assets/images/Cow's Head 3D Model (HD).png",
        "onTap": () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialogAgregarAnimal(
                token: userToken!,
                userId: userId!,
              );
            },
          );
        } as VoidCallback
      },
      {
        "name": "Agregar Empleado",
        "iconPath": "assets/images/Farm Boots 3D Model (HD).png",
        "onTap": () {
          // Acción para Producción
          print('Producción tapped');
          print(userId);
          print(userToken);
          print(nameUser);
        } as VoidCallback
      },
      {
        "name": "Mis Animales",
        "iconPath": "assets/images/Cow's Head 3D Model (HD) (1).png",
        "onTap": () {
          // Acción para Reporte
          print('Reporte tapped');
        } as VoidCallback
      },
      {
        "name": "Mi Producción",
        "iconPath": "assets/images/Milk Bucket 3D Model (HD).png",
        "onTap": () {
          // Acción para Producción
          print('Producción tapped');
        } as VoidCallback
      },
      {
        "name": "Plan De Vacunas",
        "iconPath": "assets/images/Vaccination (HD).png",
        "onTap": () {
          // Acción para Estadísticas
          print('Estadísticas tapped');
        } as VoidCallback
      },
      {
        "name": "Actividades",
        "iconPath": "assets/images/Working Hours 3D Model (HD).png",
        "onTap": () {
          // Acción para Estadísticas
          print('Estadísticas tapped');
        } as VoidCallback
      },
      {
        "name": "Reporte",
        "iconPath": "assets/images/Pitch Deck 3D Animated Icon.gif",
        "onTap": () {
          // Acción para Reporte
          print('Reporte tapped');
        } as VoidCallback
      },
      {
        "name": "Estadísticas",
        "iconPath": "assets/images/Pitch Deck 3D Animated Icon (1).gif",
        "onTap": () {
          // Acción para Estadísticas
          print('Estadísticas tapped');
        } as VoidCallback
      },
    ];

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Hacienda',
        showLeading: true,
        route: '/home',
        arguments: {
          'userToken': '$userToken',
          'userName': '$nameUser',
          'userId': '$userId',
        },
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
