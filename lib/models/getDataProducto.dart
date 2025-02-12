class GetDataProductos {
  OkMessage? okMessage;
  ErrorMessage? errorMessage;
  List<DatoProductos>? datosEspecie;

  GetDataProductos({this.okMessage, this.errorMessage, this.datosEspecie});

  factory GetDataProductos.fromJson(Map<String, dynamic>? parsedJson) {
    if (parsedJson == null) return GetDataProductos();

    var list = parsedJson['data'] as List?;
    List<DatoProductos>? datosList =
        list?.map((i) => DatoProductos.fromJson(i)).toList();

    return GetDataProductos(
      okMessage: OkMessage.fromJson(parsedJson['ok_message']),
      errorMessage: ErrorMessage.fromJson(parsedJson['error_message']),
      datosEspecie: datosList,
    );
  }
}

class OkMessage {
  String? code;
  String? message;

  OkMessage({this.code, this.message});

  factory OkMessage.fromJson(Map<String, dynamic>? json) {
    if (json == null) return OkMessage();

    return OkMessage(
      code: json['code'],
      message: json['message'],
    );
  }
}

class ErrorMessage {
  String? code;
  String? message;

  ErrorMessage({this.code, this.message});

  factory ErrorMessage.fromJson(Map<String, dynamic>? json) {
    if (json == null) return ErrorMessage();

    return ErrorMessage(
      code: json['code'],
      message: json['message'],
    );
  }
}

class DatoProductos {
  int? Id;
  String? NombreProducto;
  String? TipoProducto;

  DatoProductos({
    this.Id,
    this.NombreProducto,
    this.TipoProducto,
  });

  factory DatoProductos.fromJson(Map<String, dynamic> json) {
    return DatoProductos(
      Id: json['id'] as int?,
      NombreProducto: json['nombre_producto'] as String?,
      TipoProducto: json['tipo_producto'] as String?,
    );
  }
}
