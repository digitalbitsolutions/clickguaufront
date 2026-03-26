import 'package:bubbly/modal/user_video/user_video.dart';

class SinglePost {
  int? _status;
  String? _message;
  Data? _data;

  int? get status => _status;

  String? get message => _message;

  Data? get data => _data;

  SinglePost({int? status, String? message, Data? data}) {
    _status = status;
    _message = message;
    _data = data;
  }

  SinglePost.fromJson(dynamic json) {
    _status = json["status"];
    _message = json["message"];
    if (json['status'] != 401) {
      _data = Data.fromJson(json["data"]);
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = _status;
    map["message"] = _message;
    if (_data != null) {
      map["data"] = _data!.toJson();
    }
    return map;
  }
}
