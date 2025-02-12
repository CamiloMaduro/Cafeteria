class GetDataVentaMes {
  OkMessage? okMessage;
  ErrorMessage? errorMessage;
  List<DatoVentaMes>? datosEspecie;

  GetDataVentaMes({this.okMessage, this.errorMessage, this.datosEspecie});

  factory GetDataVentaMes.fromJson(Map<String, dynamic>? parsedJson) {
    if (parsedJson == null) return GetDataVentaMes();

    var list = parsedJson['data'] as List?;
    List<DatoVentaMes>? datosList =
        list?.map((i) => DatoVentaMes.fromJson(i)).toList();

    return GetDataVentaMes(
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

class DatoVentaMes {
  int? TotalVentas;

  DatoVentaMes({
    this.TotalVentas,
  });

  factory DatoVentaMes.fromJson(Map<String, dynamic> json) {
    return DatoVentaMes(
      TotalVentas: json['totalventas'] as int?,
    );
  }
}
