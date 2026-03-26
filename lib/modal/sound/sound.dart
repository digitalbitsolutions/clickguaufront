class Sound {
  int? _status;
  String? _message;
  List<SoundData>? _data;

  int? get status => _status;

  String? get message => _message;

  List<SoundData>? get data => _data;

  Sound({int? status, String? message, List<SoundData>? data}) {
    _status = status;
    _message = message;
    _data = data;
  }

  Sound.fromJson(dynamic json) {
    _status = json["status"];
    _message = json["message"];
    if (json["data"] != null) {
      _data = [];
      json["data"].forEach((v) {
        _data!.add(SoundData.fromJson(v));
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

class SoundData {
  int? _soundCategoryId;
  String? _soundCategoryName;
  String? _soundCategoryProfile;
  List<SoundList>? _soundList;

  int? get soundCategoryId => _soundCategoryId;

  String? get soundCategoryName => _soundCategoryName;

  String? get soundCategoryProfile => _soundCategoryProfile;

  List<SoundList>? get soundList => _soundList;

  SoundData(
      {int? soundCategoryId,
      String? soundCategoryName,
      String? soundCategoryProfile,
      List<SoundList>? soundList}) {
    _soundCategoryId = soundCategoryId;
    _soundCategoryName = soundCategoryName;
    _soundCategoryProfile = soundCategoryProfile;
    _soundList = soundList;
  }

  SoundData.fromJson(dynamic json) {
    _soundCategoryId = json["sound_category_id"];
    _soundCategoryName = json["sound_category_name"];
    _soundCategoryProfile = json["sound_category_profile"];
    if (json["sound_list"] != null) {
      _soundList = [];
      json["sound_list"].forEach((v) {
        _soundList!.add(SoundList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["sound_category_id"] = _soundCategoryId;
    map["sound_category_name"] = _soundCategoryName;
    map["sound_category_profile"] = _soundCategoryProfile;
    if (_soundList != null) {
      map["sound_list"] = _soundList!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class SoundList {
  int? _soundId;
  int? _soundCategoryId;
  String? _soundTitle;
  String? _sound;
  String? _duration;
  String? _singer;
  String? _soundImage;
  String? _addedBy;
  String? _createdAt;
  dynamic _updatedAt;

  int? get soundId => _soundId;

  int? get soundCategoryId => _soundCategoryId;

  String? get soundTitle => _soundTitle;

  String? get sound => _sound;

  String? get duration => _duration;

  String? get singer => _singer;

  String? get soundImage => _soundImage;

  String? get addedBy => _addedBy;

  String? get createdAt => _createdAt;

  dynamic get updatedAt => _updatedAt;

  SoundList(
      {int? soundId,
      int? soundCategoryId,
      String? soundTitle,
      String? sound,
      String? duration,
      String? singer,
      String? soundImage,
      String? addedBy,
      String? createdAt,
      dynamic updatedAt}) {
    _soundId = soundId;
    _soundCategoryId = soundCategoryId;
    _soundTitle = soundTitle;
    _sound = sound;
    _duration = duration;
    _singer = singer;
    _soundImage = soundImage;
    _addedBy = addedBy;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  SoundList.fromJson(dynamic json) {
    _soundId = json["sound_id"];
    _soundCategoryId = json["sound_category_id"];
    _soundTitle = json["sound_title"];
    _sound = json["sound"];
    _duration = json["duration"];
    _singer = json["singer"];
    _soundImage = json["sound_image"];
    _addedBy = json["added_by"];
    _createdAt = json["created_at"];
    _updatedAt = json["updated_at"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["sound_id"] = _soundId;
    map["sound_category_id"] = _soundCategoryId;
    map["sound_title"] = _soundTitle;
    map["sound"] = _sound;
    map["duration"] = _duration;
    map["singer"] = _singer;
    map["sound_image"] = _soundImage;
    map["added_by"] = _addedBy;
    map["created_at"] = _createdAt;
    map["updated_at"] = _updatedAt;
    return map;
  }
}
