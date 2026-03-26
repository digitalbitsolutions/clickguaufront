import 'package:bubbly/modal/sound/sound.dart';

class FavouriteMusic {
  int? _status;
  String? _message;
  List<SoundList>? _data;

  int? get status => _status;

  String? get message => _message;

  List<SoundList>? get data => _data;

  FavouriteMusic({int? status, String? message, List<SoundList>? data}) {
    _status = status;
    _message = message;
    _data = data;
  }

  FavouriteMusic.fromJson(dynamic json) {
    _status = json["status"];
    _message = json["message"];
    if (json["data"] != null) {
      _data = [];
      json["data"].forEach((v) {
        _data!.add(SoundList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = _status;
    map["message"] = _message;
    if (_data != null) {
      map["data"] = _data!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
