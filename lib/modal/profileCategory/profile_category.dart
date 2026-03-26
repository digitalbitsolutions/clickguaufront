class ProfileCategory {
  int? _status;
  String? _message;
  List<ProfileCategoryData>? _data;

  int? get status => _status;

  String? get message => _message;

  List<ProfileCategoryData>? get data => _data;

  ProfileCategory(
      {int? status, String? message, List<ProfileCategoryData>? data}) {
    _status = status;
    _message = message;
    _data = data;
  }

  ProfileCategory.fromJson(dynamic json) {
    _status = json["status"];
    _message = json["message"];
    if (json["data"] != null) {
      _data = [];
      json["data"].forEach((v) {
        _data!.add(ProfileCategoryData.fromJson(v));
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

class ProfileCategoryData {
  int? _profileCategoryId;
  String? _profileCategoryName;
  String? _profileCategoryImage;

  int? get profileCategoryId => _profileCategoryId;

  String? get profileCategoryName => _profileCategoryName;

  String? get profileCategoryImage => _profileCategoryImage;

  ProfileCategoryData(
      {int? profileCategoryId,
      String? profileCategoryName,
      String? profileCategoryImage}) {
    _profileCategoryId = profileCategoryId;
    _profileCategoryName = profileCategoryName;
    _profileCategoryImage = profileCategoryImage;
  }

  ProfileCategoryData.fromJson(dynamic json) {
    _profileCategoryId = json["profile_category_id"];
    _profileCategoryName = json["profile_category_name"];
    _profileCategoryImage = json["profile_category_image"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["profile_category_id"] = _profileCategoryId;
    map["profile_category_name"] = _profileCategoryName;
    map["profile_category_image"] = _profileCategoryImage;
    return map;
  }
}
