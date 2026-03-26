class Status {
  Status({
    int? status,
    String? message,
  }) {
    _status = status;
    _message = message;
  }

  Status.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
  }

  int? _status;
  String? _message;

  int? get status => _status;

  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    return map;
  }
}
