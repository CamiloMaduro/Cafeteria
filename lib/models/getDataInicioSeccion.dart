class InicioDeSesionGo {
  OkMessage? okMessage;
  ErrorMessage? errorMessage;
  Datos? datos;

  InicioDeSesionGo({this.okMessage, this.errorMessage, this.datos});

  factory InicioDeSesionGo.fromJson(Map<String, dynamic> parsedJson) {
    return InicioDeSesionGo(
      okMessage: parsedJson['ok_message'] != null
          ? OkMessage.fromJson(parsedJson['ok_message'])
          : null,
      errorMessage: parsedJson['error_message'] != null
          ? ErrorMessage.fromJson(parsedJson['error_message'])
          : null,
      datos: parsedJson['data'] != null
          ? Datos.fromJson(parsedJson['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ok_message': okMessage?.toJson(),
      'error_message': errorMessage?.toJson(),
      'data': datos?.toJson(),
    };
  }
}

class OkMessage {
  String? code;
  String? message;

  OkMessage({this.code, this.message});

  factory OkMessage.fromJson(Map<String, dynamic> json) {
    return OkMessage(
      code: json['code'] ?? '',
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
    };
  }
}

class ErrorMessage {
  String? code;
  String? message;

  ErrorMessage({this.code, this.message});

  factory ErrorMessage.fromJson(Map<String, dynamic> json) {
    return ErrorMessage(
      code: json['code'] ?? '',
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
    };
  }
}

class Datos {
  Usuario? usuario;
  String? token;

  Datos({this.usuario, this.token});

  factory Datos.fromJson(Map<String, dynamic> json) {
    return Datos(
      usuario:
          json['Usuario'] != null ? Usuario.fromJson(json['Usuario']) : null,
      token: json['Token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Usuario': usuario?.toJson(),
      'Token': token,
    };
  }
}

class Usuario {
  int? id;
  String? fechaRegistro;
  String? identificacion;
  String? nombre;
  String? direccion;
  String? telefono;
  bool? onOff;

  Usuario({
    this.id,
    this.fechaRegistro,
    this.identificacion,
    this.nombre,
    this.direccion,
    this.telefono,
    this.onOff,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      fechaRegistro: json['fecha_registro'],
      identificacion: json['identificacion'],
      nombre: json['nombre'],
      direccion: json['direccion'],
      telefono: json['telefono'],
      onOff: json['on_off'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fecha_registro': fechaRegistro,
      'identificacion': identificacion,
      'nombre': nombre,
      'direccion': direccion,
      'telefono': telefono,
      'on_off': onOff,
    };
  }
}
