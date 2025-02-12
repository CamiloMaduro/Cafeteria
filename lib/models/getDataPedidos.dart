class GetDataPedidos {
  OkMessage? okMessage;
  ErrorMessage? errorMessage;
  List<DatoPedidos>? datosEspecie;

  GetDataPedidos({this.okMessage, this.errorMessage, this.datosEspecie});

  factory GetDataPedidos.fromJson(Map<String, dynamic>? parsedJson) {
    if (parsedJson == null) return GetDataPedidos();

    var list = parsedJson['data'] as List?;
    List<DatoPedidos>? datosList =
        list?.map((i) => DatoPedidos.fromJson(i)).toList();

    return GetDataPedidos(
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

class DatoPedidos {
  int? Id;
  String? NombreProducto;
  String? Cantidad;
  String? FechaEntrega;
  String? Cafeteria;

  DatoPedidos({
    this.Id,
    this.NombreProducto,
    this.Cantidad,
    this.FechaEntrega,
    this.Cafeteria,
  });

  factory DatoPedidos.fromJson(Map<String, dynamic> json) {
    return DatoPedidos(
      Id: json['id'] as int?,
      NombreProducto: json['producto'] as String?,
      Cantidad: json['cantidad'] as String?,
      FechaEntrega: json['fecha_entrega'] as String?,
      Cafeteria: json['cafeteria'] as String?,
    );
  }
}
