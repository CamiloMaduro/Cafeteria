class GetDataEspecie {
  OkMessage? okMessage;
  ErrorMessage? errorMessage;
  List<DatoEspecie>? datosEspecie;

  GetDataEspecie({this.okMessage, this.errorMessage, this.datosEspecie});

  factory GetDataEspecie.fromJson(Map<String, dynamic>? parsedJson) {
    if (parsedJson == null) return GetDataEspecie();

    var list = parsedJson['data'] as List?;
    List<DatoEspecie>? datosList =
        list?.map((i) => DatoEspecie.fromJson(i)).toList();

    return GetDataEspecie(
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

class DatoEspecie {
  int? Id;
  String? NombreEspecie;

  DatoEspecie({
    this.Id,
    this.NombreEspecie,
  });

  factory DatoEspecie.fromJson(Map<String, dynamic> json) {
    return DatoEspecie(
      Id: json['id'] as int?,
      NombreEspecie: json['nombre'] as String?,
    );
  }
}
