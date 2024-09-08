class TrueFalseGo {
  Ok_message ok_message;
  Error_message error_message;
  bool data;

  TrueFalseGo({
    required this.error_message,
    required this.data,
    required this.ok_message,
  });

  factory TrueFalseGo.fromJson(Map<String, dynamic> parsedJson) {
    return TrueFalseGo(
      ok_message: Ok_message.fromJson(parsedJson['ok_message'] ?? {}),
      error_message: Error_message.fromJson(parsedJson['error_message'] ?? {}),
      data: parsedJson['data'] ?? false,
    );
  }
}

class Ok_message {
  String code;
  String message;

  Ok_message({
    required this.code,
    required this.message,
  });

  factory Ok_message.fromJson(Map<String, dynamic> json) {
    return Ok_message(
      code: json['code'] ?? "",
      message: json['message'] ?? "",
    );
  }
}

class Error_message {
  String code;
  String message;

  Error_message({
    required this.code,
    required this.message,
  });

  factory Error_message.fromJson(Map<String, dynamic> json) {
    return Error_message(
      code: json['code'] ?? "",
      message: json['message'] ?? "",
    );
  }
}
