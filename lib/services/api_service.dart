import 'dart:convert';
import 'package:control_ganadero/models/getDataEspecie.dart';
import 'package:control_ganadero/models/getDataInicioSeccion.dart';
import 'package:control_ganadero/models/getDataRaza.dart';
import 'package:control_ganadero/models/trueFalseGo.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  Future<InicioDeSesionGo> getDatainiciodeSesionGo(
    String url,
    String id,
    String password,
    int idapp,
    double version,
  ) async {
    // print('$baseUrl/$url');

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$url'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "usuario": id,
          "password": password,
          "id_app": idapp,
          "version": version,
        }),
      );
      // print(response.statusCode);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return InicioDeSesionGo.fromJson(data);
      } else {
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  Future<TrueFalseGo> insertFinca(
    String apidir,
    String id,
    String password,
    int idapp,
    double version,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(apidir),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "nombre": id,
          "ubicacion": password,
          "id_usuario": idapp,
          "id_usuario_registra": version,
        }),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return TrueFalseGo.fromJson(data);
      } else {
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  Future<TrueFalseGo> transferirEquipo(
    String apidir,
    String id_usuario,
    String id_dispositivo,
    String usuario_registra,
    String fecha_inicio,
    String fecha_fin,
    String Token,
  ) async {
    final response = await http.put(
      Uri.parse("$apidir"),
      headers: {
        "Content-Type": "application/json; charset=UTF-8",
        'Authorization': 'Bearer $Token'
      },
      body: jsonEncode({
        "id_usuario": int.parse(id_usuario),
        "id_dispositivo": int.parse(id_dispositivo),
        "fecha_inicio": fecha_inicio,
        "fecha_fin": fecha_fin,
        "usuario_registra": int.parse(usuario_registra),
      }),
    );
    var data = json.decode(response.body);
    TrueFalseGo trueFalse = new TrueFalseGo.fromJson(data);
    return trueFalse;
  }

  Future<GetDataEspecie> getDataEspecie(String apidir, String Token) async {
    apidir = apidir;
    if (Token != "") {
      apidir = apidir;
    }
    final response =
        //whereproyectos ,-, whereusuarios
        await http.get(
      Uri.parse("$apidir"),
      headers: {
        "Content-Type": "application/json; charset=UTF-8",
        'Authorization': 'Bearer $Token'
      },
      //headers: {"content-type": "application/x-www-form-urlencoded; charset=UTF-8",},
      // body:{"id":id,
      // "password":password}
    );
    var data = json.decode(response.body);
    GetDataEspecie datosEntrevista = GetDataEspecie.fromJson(data);

    return datosEntrevista;
  }

  Future<GetDataEspecie> getDataEstado(String apidir, String Token) async {
    apidir = apidir;
    if (Token != "") {
      apidir = apidir;
    }
    final response =
        //whereproyectos ,-, whereusuarios
        await http.get(
      Uri.parse("$apidir"),
      headers: {
        "Content-Type": "application/json; charset=UTF-8",
        'Authorization': 'Bearer $Token'
      },
      //headers: {"content-type": "application/x-www-form-urlencoded; charset=UTF-8",},
      // body:{"id":id,
      // "password":password}
    );
    var data = json.decode(response.body);
    GetDataEspecie datosEntrevista = GetDataEspecie.fromJson(data);

    return datosEntrevista;
  }

  Future<GetDataRaza> getDataRaza(
      String apidir, String Token, String idEspecie) async {
    apidir = apidir;
    if (Token != "") {
      apidir = '$apidir/$idEspecie';
    }
    print(apidir);
    final response =
        //whereproyectos ,-, whereusuarios
        await http.get(
      Uri.parse("$apidir"),
      headers: {
        "Content-Type": "application/json; charset=UTF-8",
        'Authorization': 'Bearer $Token'
      },
      //headers: {"content-type": "application/x-www-form-urlencoded; charset=UTF-8",},
      // body:{"id":id,
      // "password":password}
    );
    var data = json.decode(response.body);
    print(data);
    GetDataRaza datosRaza = GetDataRaza.fromJson(data);

    return datosRaza;
  }

  Future<TrueFalseGo> crearAnimal(
    String apidir,
    String Nombre,
    String NumeroIdentificacion,
    String FechaNacimiento,
    String IdSexo,
    String IdRaza,
    String IdFinca,
    String IdUsuario,
    String FechaIngreso,
    String PesoInicial,
    String IdEstadoActual,
    String? RutaFoto,
    String IdUsuarioRegistra,
    String Token,
  ) async {
    print(apidir);
    print(
      jsonEncode({
        "nombre": Nombre,
        "numero_identificacion": NumeroIdentificacion,
        "fecha_nacimiento": FechaNacimiento,
        "id_sexo": IdSexo,
        "id_raza": int.parse(IdRaza),
        "id_finca": 1,
        "id_usuario": IdUsuario,
        "fecha_ingreso": FechaIngreso,
        "peso_inicial": PesoInicial,
        "id_estado_actual": int.parse(IdEstadoActual),
        "ruta_foto": RutaFoto == null ? '' : RutaFoto,
        "id_usuario_registra": IdUsuarioRegistra,
      }),
    );
    final response = await http.post(
      Uri.parse("$apidir"),
      headers: {
        "Content-Type": "application/json; charset=UTF-8",
        'Authorization': 'Bearer $Token'
      },
      body: jsonEncode({
        "nombre": Nombre,
        "numero_identificacion": NumeroIdentificacion,
        "fecha_nacimiento": FechaNacimiento,
        "id_sexo": IdSexo,
        "id_raza": int.parse(IdRaza),
        "id_finca": 1,
        "id_usuario": int.parse(IdUsuario),
        "fecha_ingreso": FechaIngreso,
        "peso_inicial": double.parse(PesoInicial),
        "id_estado_actual": int.parse(IdEstadoActual),
        "ruta_foto": RutaFoto == null ? '' : RutaFoto,
        "id_usuario_registra": int.parse(IdUsuarioRegistra),
      }),
    );
    var data = json.decode(response.body);
    TrueFalseGo trueFalse = TrueFalseGo.fromJson(data);
    return trueFalse;
  }

  Future<GetDataEspecie> getDataSexo(String apidir, String Token) async {
    apidir = apidir;
    if (Token != "") {
      apidir = apidir;
    }
    final response =
        //whereproyectos ,-, whereusuarios
        await http.get(
      Uri.parse("$apidir"),
      headers: {
        "Content-Type": "application/json; charset=UTF-8",
        'Authorization': 'Bearer $Token'
      },
      //headers: {"content-type": "application/x-www-form-urlencoded; charset=UTF-8",},
      // body:{"id":id,
      // "password":password}
    );
    var data = json.decode(response.body);
    GetDataEspecie datosEntrevista = GetDataEspecie.fromJson(data);

    return datosEntrevista;
  }
}
