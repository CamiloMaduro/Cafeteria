class GetDataRaza {
  OkMessage? okMessage;
  ErrorMessage? errorMessage;
  List<DatoRaza>? datosEspecie;

  GetDataRaza({this.okMessage, this.errorMessage, this.datosEspecie});

  factory GetDataRaza.fromJson(Map<String, dynamic>? parsedJson) {
    if (parsedJson == null) return GetDataRaza();

    var list = parsedJson['data'] as List?;
    List<DatoRaza>? datosList =
        list?.map((i) => DatoRaza.fromJson(i)).toList();

    return GetDataRaza(
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

class DatoRaza {
  int? Id;
  String? NombreEspecie;
  String? Descripcion;

  DatoRaza({
    this.Id,
    this.NombreEspecie,
    this.Descripcion,
  });

  factory DatoRaza.fromJson(Map<String, dynamic> json) {
    return DatoRaza(
      Id: json['id'] as int?,
      NombreEspecie: json['nombre'] as String?,
      Descripcion: json['descripcion'] as String?,
    );
  }
}
