class ExploreHashTag {
  int? _status;
  String? _message;
  List<ExploreData>? _data;

  int? get status => _status;

  String? get message => _message;

  List<ExploreData>? get data => _data;

  ExploreHashTag({int? status, String? message, List<ExploreData>? data}) {
    _status = status;
    _message = message;
    _data = data;
  }

  ExploreHashTag.fromJson(dynamic json) {
    _status = json["status"];
    _message = json["message"];
    if (json["data"] != null) {
      _data = [];
      json["data"].forEach((v) {
        _data!.add(ExploreData.fromJson(v));
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

class ExploreData {
  String? _hashTagName;
  String? _hashTagProfile;
  int? _hashTagVideosCount;

  String? get hashTagName => _hashTagName;

  String? get hashTagProfile => _hashTagProfile;

  int? get hashTagVideosCount => _hashTagVideosCount;

  ExploreData(
      {String? hashTagName, String? hashTagProfile, int? hashTagVideosCount}) {
    _hashTagName = hashTagName;
    _hashTagProfile = hashTagProfile;
    _hashTagVideosCount = hashTagVideosCount;
  }

  ExploreData.fromJson(dynamic json) {
    _hashTagName = json["hash_tag_name"];
    _hashTagProfile = json["hash_tag_profile"];
    _hashTagVideosCount = json["hash_tag_videos_count"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["hash_tag_name"] = _hashTagName;
    map["hash_tag_profile"] = _hashTagProfile;
    map["hash_tag_videos_count"] = _hashTagVideosCount;
    return map;
  }
}
