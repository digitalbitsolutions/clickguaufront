class NudityMediaId {
  NudityMediaId({
    String? status,
    Request? request,
    Media? media,
    Error? error,
  }) {
    _status = status;
    _request = request;
    _media = media;
    _error = error;
  }

  NudityMediaId.fromJson(dynamic json) {
    _status = json['status'];
    _request =
        json['request'] != null ? Request.fromJson(json['request']) : null;
    _media = json['media'] != null ? Media.fromJson(json['media']) : null;
    _error = json['error'] != null ? Error.fromJson(json['error']) : null;
  }
  String? _status;
  Request? _request;
  Media? _media;
  Error? _error;

  String? get status => _status;
  Request? get request => _request;
  Media? get media => _media;
  Error? get error => _error;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    if (_request != null) {
      map['request'] = _request?.toJson();
    }
    if (_media != null) {
      map['media'] = _media?.toJson();
    }
    if (_error != null) {
      map['error'] = _error?.toJson();
    }
    return map;
  }
}

class Media {
  Media({
    String? id,
    String? uri,
  }) {
    _id = id;
    _uri = uri;
  }

  Media.fromJson(dynamic json) {
    _id = json['id'];
    _uri = json['uri'];
  }
  String? _id;
  String? _uri;

  String? get id => _id;
  String? get uri => _uri;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['uri'] = _uri;
    return map;
  }
}

class Request {
  Request({
    String? id,
    double? timestamp,
  }) {
    _id = id;
    _timestamp = timestamp;
  }

  Request.fromJson(dynamic json) {
    _id = json['id'];
    _timestamp = json['timestamp'];
  }
  String? _id;
  double? _timestamp;

  String? get id => _id;
  double? get timestamp => _timestamp;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['timestamp'] = _timestamp;
    return map;
  }
}

class Error {
  Error({
    String? type,
    int? code,
    String? message,
  }) {
    _type = type;
    _code = code;
    _message = message;
  }

  Error.fromJson(dynamic json) {
    _type = json['type'];
    _code = json['code'];
    _message = json['message'];
  }
  String? _type;
  int? _code;
  String? _message;

  String? get type => _type;
  int? get code => _code;
  String? get message => _message;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['type'] = _type;
    map['code'] = _code;
    map['message'] = _message;
    return map;
  }
}
