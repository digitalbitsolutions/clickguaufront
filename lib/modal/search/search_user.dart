class SearchUser {
  int? _status;
  String? _message;
  List<SearchUserData>? _data;

  int? get status => _status;

  String? get message => _message;

  List<SearchUserData>? get data => _data;

  SearchUser({int? status, String? message, List<SearchUserData>? data}) {
    _status = status;
    _message = message;
    _data = data;
  }

  SearchUser.fromJson(dynamic json) {
    _status = json["status"];
    _message = json["message"];
    if (json["data"] != null) {
      _data = [];
      json["data"].forEach((v) {
        _data!.add(SearchUserData.fromJson(v));
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

class SearchUserData {
  int? _userId;
  String? _fullName;
  String? _userName;
  String? _userEmail;
  String? _userMobileNo;
  String? _userProfile;
  int? _isVerify;
  String? _bio;
  String? _fbUrl;
  String? _instaUrl;
  String? _youtubeUrl;
  int? _followersCount;
  int? _followingCount;
  int? _myPostLikes;
  int? _myPostCount;

  int? get userId => _userId;

  String? get fullName => _fullName;

  String? get userName => _userName;

  String? get userEmail => _userEmail;

  String? get userMobileNo => _userMobileNo;

  String? get userProfile => _userProfile;

  int? get isVerify => _isVerify;

  String? get bio => _bio;

  String? get fbUrl => _fbUrl;

  String? get instaUrl => _instaUrl;

  String? get youtubeUrl => _youtubeUrl;

  int? get followersCount => _followersCount;

  int? get followingCount => _followingCount;

  int? get myPostLikes => _myPostLikes;

  int? get myPostCount => _myPostCount;

  SearchUserData(
      {int? userId,
      String? fullName,
      String? userName,
      String? userEmail,
      String? userMobileNo,
      String? userProfile,
      int? isVerify,
      String? bio,
      String? fbUrl,
      String? instaUrl,
      String? youtubeUrl,
      int? followersCount,
      int? followingCount,
      int? myPostLikes,
      int? myPostCount}) {
    _userId = userId;
    _fullName = fullName;
    _userName = userName;
    _userEmail = userEmail;
    _userMobileNo = userMobileNo;
    _userProfile = userProfile;
    _isVerify = isVerify;
    _bio = bio;
    _fbUrl = fbUrl;
    _instaUrl = instaUrl;
    _youtubeUrl = youtubeUrl;
    _followersCount = followersCount;
    _followingCount = followingCount;
    _myPostLikes = myPostLikes;
    _myPostCount = myPostCount;
  }

  SearchUserData.fromJson(dynamic json) {
    _userId = json["user_id"];
    _fullName = json["full_name"];
    _userName = json["user_name"];
    _userEmail = json["user_email"];
    _userMobileNo = json["user_mobile_no"];
    _userProfile = json["user_profile"];
    _isVerify = json["is_verify"];
    _bio = json["bio"];
    _fbUrl = json["fb_url"];
    _instaUrl = json["insta_url"];
    _youtubeUrl = json["youtube_url"];
    _followersCount = json["followers_count"];
    _followingCount = json["following_count"];
    _myPostLikes = json["my_post_likes"];
    _myPostCount = json["my_post_count"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["user_id"] = _userId;
    map["full_name"] = _fullName;
    map["user_name"] = _userName;
    map["user_email"] = _userEmail;
    map["user_mobile_no"] = _userMobileNo;
    map["user_profile"] = _userProfile;
    map["is_verify"] = _isVerify;
    map["bio"] = _bio;
    map["fb_url"] = _fbUrl;
    map["insta_url"] = _instaUrl;
    map["youtube_url"] = _youtubeUrl;
    map["followers_count"] = _followersCount;
    map["following_count"] = _followingCount;
    map["my_post_likes"] = _myPostLikes;
    map["my_post_count"] = _myPostCount;
    return map;
  }
}
