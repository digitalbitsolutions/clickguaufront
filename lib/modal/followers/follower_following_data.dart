class FollowerFollowingData {
  int? _status;
  String? _message;
  List<FollowerUserData>? _data;

  int? get status => _status;

  String? get message => _message;

  List<FollowerUserData>? get data => _data;

  FollowerFollowingData(
      {int? status, String? message, List<FollowerUserData>? data}) {
    _status = status;
    _message = message;
    _data = data;
  }

  FollowerFollowingData.fromJson(dynamic json) {
    _status = json["status"];
    _message = json["message"];
    if (json["data"] != null) {
      _data = [];
      json["data"].forEach((v) {
        _data!.add(FollowerUserData.fromJson(v));
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

class FollowerUserData {
  int? _followerId;
  int? _fromUserId;
  int? _toUserId;
  String? _fullName;
  String? _userName;
  String? _userProfile;
  int? _isVerify;
  String? _createdDate;
  int? _followersCount;
  int? _followingCount;
  int? _myPostLikes;
  int? _myPostCount;

  int? get followerId => _followerId;

  int? get fromUserId => _fromUserId;

  int? get toUserId => _toUserId;

  String? get fullName => _fullName;

  String? get userName => _userName;

  String? get userProfile => _userProfile;

  int? get isVerify => _isVerify;

  String? get createdDate => _createdDate;

  int? get followersCount => _followersCount;

  int? get followingCount => _followingCount;

  int? get myPostLikes => _myPostLikes;

  int? get myPostCount => _myPostCount;

  FollowerUserData(
      {int? followerId,
      int? fromUserId,
      int? toUserId,
      String? fullName,
      String? userName,
      String? userProfile,
      int? isVerify,
      String? createdDate,
      int? followersCount,
      int? followingCount,
      int? myPostLikes,
      int? myPostCount}) {
    _followerId = followerId;
    _fromUserId = fromUserId;
    _toUserId = toUserId;
    _fullName = fullName;
    _userName = userName;
    _userProfile = userProfile;
    _isVerify = isVerify;
    _createdDate = createdDate;
    _followersCount = followersCount;
    _followingCount = followingCount;
    _myPostLikes = myPostLikes;
    _myPostCount = myPostCount;
  }

  FollowerUserData.fromJson(dynamic json) {
    _followerId = json["follower_id"];
    _fromUserId = json["from_user_id"];
    _toUserId = json["to_user_id"];
    _fullName = json["full_name"];
    _userName = json["user_name"];
    _userProfile = json["user_profile"];
    _isVerify = json["is_verify"];
    _createdDate = json["created_date"];
    _followersCount = json["followers_count"];
    _followingCount = json["following_count"];
    _myPostLikes = json["my_post_likes"];
    _myPostCount = json["my_post_count"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["follower_id"] = _followerId;
    map["from_user_id"] = _fromUserId;
    map["to_user_id"] = _toUserId;
    map["full_name"] = _fullName;
    map["user_name"] = _userName;
    map["user_profile"] = _userProfile;
    map["is_verify"] = _isVerify;
    map["created_date"] = _createdDate;
    map["followers_count"] = _followersCount;
    map["following_count"] = _followingCount;
    map["my_post_likes"] = _myPostLikes;
    map["my_post_count"] = _myPostCount;
    return map;
  }
}
