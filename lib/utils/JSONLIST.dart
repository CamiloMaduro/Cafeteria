// ignore_for_file: use_build_context_synchronously

import 'package:control_ganadero/models/getDataRaza.dart';
import 'package:control_ganadero/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:control_ganadero/utils/JSONLIST.dart' as JSONALIST;
import 'package:control_ganadero/utils/text_styles.dart';

import '../models/getDataEspecie.dart';

JSONALIST.jsonalist JSON = JSONALIST.jsonalist();

class jsonalist {
  // DropDownMenu Tallas Camisas
  Future<List<DropdownMenuItem<String>>> GetDatoDropGeneral(
    String apidir,
    String Token,
    BuildContext context,
  ) async {
    List<DropdownMenuItem<String>> dropDown = [];

    GetDataEspecie GetDatosDropDownGeneral =
        await ApiService(apidir).getDataEspecie(apidir, Token);

    try {
      for (int i = 0; i < GetDatosDropDownGeneral.datosEspecie!.length; i++) {
        // selectedCliente=clientes![i].dato!;

        dropDown.add(
          DropdownMenuItem(
              value: GetDatosDropDownGeneral.datosEspecie![i].Id.toString(),
              child: TextStyles.bodyLarge(context,
                  '${GetDatosDropDownGeneral.datosEspecie![i].NombreEspecie}')),
        );
      }
    } catch (e) {
      print(e);
    }
    return dropDown;
  }

  Future<List<DropdownMenuItem<String>>> GetDatoBusqueda(
    String apidir,
    String Token,
    String IdBusqueda,
    BuildContext context,
  ) async {
    List<DropdownMenuItem<String>> dropDown = [];

    GetDataRaza GetDatosDropDownBusqueda =
        await ApiService(apidir).getDataRaza(apidir, Token, IdBusqueda);

    try {
      for (int i = 0; i < GetDatosDropDownBusqueda.datosEspecie!.length; i++) {
        // selectedCliente=clientes![i].dato!;

        dropDown.add(
          DropdownMenuItem(
              value: GetDatosDropDownBusqueda.datosEspecie![i].Id.toString(),
              child: TextStyles.bodyLarge(context,
                  '${GetDatosDropDownBusqueda.datosEspecie![i].NombreEspecie}')),
        );
      }
    } catch (e) {
      print(e);
    }
    return dropDown;
  }
}
