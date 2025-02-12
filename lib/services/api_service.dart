import 'dart:convert';
import 'package:control_ganadero/models/getDataEspecie.dart';
import 'package:control_ganadero/models/getDataInicioSeccion.dart';
import 'package:control_ganadero/models/getDataPedidos.dart';
import 'package:control_ganadero/models/getDataProducto.dart';
import 'package:control_ganadero/models/getDataEstadisticas.dart';
import 'package:control_ganadero/models/getDataTotalProductosVendidos.dart';
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
    // print('$url');

    try {
      final response = await http.post(
        Uri.parse('$url'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "usuario": id,
          "password": password,
          "id_app": int.parse(idapp.toString()),
          "version": version,
        }),
      );
      // print(response.statusCode);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        // print(data);
        return InicioDeSesionGo.fromJson(data);
      } else {
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  Future<TrueFalseGo> updateCantidadEntregadas(
    String apidir,
    List<Map<String, dynamic>> productos,
    String Token,
  ) async {
    // print(apidir);
    final response = await http.put(
      Uri.parse("$apidir"),
      headers: {
        "Content-Type": "application/json; charset=UTF-8",
        'Authorization': 'Bearer $Token'
      },
      body: jsonEncode({
        "producto": productos,
      }),
    );
    var data = json.decode(response.body);
    // print(data);
    TrueFalseGo trueFalse = new TrueFalseGo.fromJson(data);
    return trueFalse;
  }

  Future<TrueFalseGo> pedidoConfirmado(
    String apidir,
    String fecha_entrega,
    String Token,
  ) async {
    // print(apidir);

    final response = await http.post(
      Uri.parse("$apidir"),
      headers: {
        "Content-Type": "application/json; charset=UTF-8",
        'Authorization': 'Bearer $Token'
      },
      body: jsonEncode({
        "fecha_entrega": fecha_entrega,
      }),
    );
    var data = json.decode(response.body);
    // print(data);
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

  Future<GetDataProductos> getDataProductos(String apidir, String Token) async {
    apidir = apidir;
    if (Token != "") {
      apidir = '$apidir';
    }
    // print(apidir);
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
    // print(data);
    GetDataProductos datos = GetDataProductos.fromJson(data);

    return datos;
  }

  Future<GetDataVentaMes> getDataVentasMes(
    String apidir,
    String Mes,
    String Year,
    String Token,
  ) async {
    apidir = apidir;
    if (Token != "") {
      apidir = '$apidir/$Mes/$Year';
    }
    // print(apidir);
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
    // print(data);
    GetDataVentaMes datos = GetDataVentaMes.fromJson(data);

    return datos;
  }

  Future<GetDataTotalProductosVendidos> getDataVentasProductosMes(
    String apidir,
    String Mes,
    String Year,
    String Token,
  ) async {
    apidir = apidir;
    if (Token != "") {
      apidir = '$apidir/$Mes/$Year';
    }
    // print(apidir);
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
    // print(data);
    GetDataTotalProductosVendidos datos =
        GetDataTotalProductosVendidos.fromJson(data);

    return datos;
  }

  Future<GetDataPedidos> getDataPedidos(
    String apidir,
    String mostrarTodo,
    String Cafeteria,
    String Token,
  ) async {
    apidir = apidir;
    if (Token != "") {
      apidir = '$apidir/$mostrarTodo/$Cafeteria';
    }
    // print(apidir);
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
    // print(data);
    GetDataPedidos datos = GetDataPedidos.fromJson(data);

    return datos;
  }

  Future<TrueFalseGo> crearPedido(
    String apidir,
    List<Map<String, dynamic>> productos,
    String FechaEntrega,
    String IdUsuarioRegistra,
    String Token,
  ) async {
    // print(apidir);
    // print(
    //   jsonEncode({
    //     "producto": productos,
    //     "fecha_entrega": FechaEntrega,
    //     "id_usuario_registra": IdUsuarioRegistra, // Corregido aquí
    //   }),
    // );

    final response = await http.post(
      Uri.parse("$apidir"),
      headers: {
        "Content-Type": "application/json; charset=UTF-8",
        'Authorization': 'Bearer $Token'
      },
      body: jsonEncode({
        "producto": productos,
        "fecha_entrega": FechaEntrega,
        "id_usuario_registra": IdUsuarioRegistra, // Corregido aquí
      }),
    );

    var data = json.decode(response.body);
    // print(data);

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
