class GetDataTotalProductosVendidos {
  OkMessage? okMessage;
  ErrorMessage? errorMessage;
  List<DatoTotalProductoVendido>? datosEspecie;

  GetDataTotalProductosVendidos(
      {this.okMessage, this.errorMessage, this.datosEspecie});

  factory GetDataTotalProductosVendidos.fromJson(
      Map<String, dynamic>? parsedJson) {
    if (parsedJson == null) return GetDataTotalProductosVendidos();

    var list = parsedJson['data'] as List?;
    List<DatoTotalProductoVendido>? datosList =
        list?.map((i) => DatoTotalProductoVendido.fromJson(i)).toList();

    return GetDataTotalProductosVendidos(
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

class DatoTotalProductoVendido {
  int? TotalProductosVendidos;

  DatoTotalProductoVendido({
    this.TotalProductosVendidos,
  });

  factory DatoTotalProductoVendido.fromJson(Map<String, dynamic> json) {
    return DatoTotalProductoVendido(
      TotalProductosVendidos: json['productosvendidos'] as int?,
    );
  }
}
