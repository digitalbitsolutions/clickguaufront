class RestResponse {
  int? _status;
  String? _message;

  int? get status => _status;

  String? get message => _message;

  RestResponse({int? status, String? message}) {
    _status = status;
    _message = message;
  }

  RestResponse.fromJson(dynamic json) {
    _status = json["status"];
    _message = json["message"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = _status;
    map["message"] = _message;
    return map;
  }
}
