class User {
  User({
    int? status,
    String? message,
    UserData? data,
  }) {
    _status = status;
    _message = message;
    _data = data;
  }

  User.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _data = json['data'] != null ? UserData.fromJson(json['data']) : null;
  }
  int? _status;
  String? _message;
  UserData? _data;

  int? get status => _status;
  String? get message => _message;
  UserData? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }
}

class UserData {
  UserData({
    int? userId,
    String? fullName,
    String? userName,
    String? userEmail,
    String? userMobileNo,
    String? userProfile,
    String? loginType,
    String? identity,
    int? platform,
    String? deviceToken,
    int? isVerify,
    int? isNotification,
    int? totalReceived,
    int? totalSend,
    int? myWallet,
    int? spenInApp,
    int? checkIn,
    int? uploadVideo,
    int? fromFans,
    int? purchased,
    String? bio,
    int? profileCategory,
    String? token,
    String? fbUrl,
    String? instaUrl,
    String? youtubeUrl,
    int? isFollowingEachOther,
    int? followersCount,
    int? followingCount,
    int? myPostLikes,
    String? profileCategoryName,
    int? isFollowing,
    int? blockOrNot,
  }) {
    _userId = userId;
    _fullName = fullName;
    _userName = userName;
    _userEmail = userEmail;
    _userMobileNo = userMobileNo;
    _userProfile = userProfile;
    _loginType = loginType;
    _identity = identity;
    _platform = platform;
    _deviceToken = deviceToken;
    _isVerify = isVerify;
    _isNotification = isNotification;
    _totalReceived = totalReceived;
    _totalSend = totalSend;
    _myWallet = myWallet;
    _spenInApp = spenInApp;
    _checkIn = checkIn;
    _uploadVideo = uploadVideo;
    _fromFans = fromFans;
    _purchased = purchased;
    _bio = bio;
    _profileCategory = profileCategory;
    _token = token;
    _fbUrl = fbUrl;
    _instaUrl = instaUrl;
    _youtubeUrl = youtubeUrl;
    _isFollowingEachOther = isFollowingEachOther;
    _followersCount = followersCount;
    _followingCount = followingCount;
    _myPostLikes = myPostLikes;
    _profileCategoryName = profileCategoryName;
    _isFollowing = isFollowing;
    _blockOrNot = blockOrNot;
  }

  UserData.fromJson(dynamic json) {
    _userId = json['user_id'];
    _fullName = json['full_name'];
    _userName = json['user_name'];
    _userEmail = json['user_email'];
    _userMobileNo = json['user_mobile_no'];
    _userProfile = json['user_profile'];
    _loginType = json['login_type'];
    _identity = json['identity'];
    _platform = json['platform'];
    _deviceToken = json['device_token'];
    _isVerify = json['is_verify'];
    _isNotification = json['is_notification'];
    _totalReceived = json['total_received'];
    _totalSend = json['total_send'];
    _myWallet = json['my_wallet'];
    _spenInApp = json['spen_in_app'];
    _checkIn = json['check_in'];
    _uploadVideo = json['upload_video'];
    _fromFans = json['from_fans'];
    _purchased = json['purchased'];
    _bio = json['bio'];
    _profileCategory =
        json['profile_category'] == "" ? -1 : json['profile_category'];
    _token = json['token'];
    _fbUrl = json['fb_url'];
    _instaUrl = json['insta_url'];
    _youtubeUrl = json['youtube_url'];
    _isFollowingEachOther = json['is_following_eachOther'];
    _followersCount = json['followers_count'];
    _followingCount = json['following_count'];
    _myPostLikes = json['my_post_likes'];
    _profileCategoryName = json['profile_category_name'];
    _isFollowing = json['is_following'];
    _blockOrNot = json['block_or_not'];
  }
  int? _userId;
  String? _fullName;
  String? _userName;
  String? _userEmail;
  String? _userMobileNo;
  String? _userProfile;
  String? _loginType;
  String? _identity;
  int? _platform;
  String? _deviceToken;
  int? _isVerify;
  int? _isNotification;
  int? _totalReceived;
  int? _totalSend;
  int? _myWallet;
  int? _spenInApp;
  int? _checkIn;
  int? _uploadVideo;
  int? _fromFans;
  int? _purchased;
  String? _bio;
  int? _profileCategory;
  String? _token;
  String? _fbUrl;
  String? _instaUrl;
  String? _youtubeUrl;
  int? _isFollowingEachOther;
  int? _followersCount;
  int? _followingCount;
  int? _myPostLikes;
  String? _profileCategoryName;
  int? _isFollowing;
  int? _blockOrNot;

  int? get userId => _userId;
  String? get fullName => _fullName;
  String? get userName => _userName;
  String? get userEmail => _userEmail;
  String? get userMobileNo => _userMobileNo;
  String? get userProfile => _userProfile;
  String? get loginType => _loginType;
  String? get identity => _identity;
  int? get platform => _platform;
  String? get deviceToken => _deviceToken;
  int? get isVerify => _isVerify;
  int? get isNotification => _isNotification;
  int? get totalReceived => _totalReceived;
  int? get totalSend => _totalSend;
  int? get myWallet => _myWallet;
  int? get spenInApp => _spenInApp;
  int? get checkIn => _checkIn;
  int? get uploadVideo => _uploadVideo;
  int? get fromFans => _fromFans;
  int? get purchased => _purchased;
  String? get bio => _bio;
  int? get profileCategory => _profileCategory;
  String? get token => _token;
  String? get fbUrl => _fbUrl;
  String? get instaUrl => _instaUrl;
  String? get youtubeUrl => _youtubeUrl;
  int? get isFollowingEachOther => _isFollowingEachOther;
  int? get followersCount => _followersCount;
  int? get followingCount => _followingCount;
  int? get myPostLikes => _myPostLikes;
  String? get profileCategoryName => _profileCategoryName;
  int? get isFollowing => _isFollowing;
  int? get blockOrNot => _blockOrNot;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['user_id'] = _userId;
    map['full_name'] = _fullName;
    map['user_name'] = _userName;
    map['user_email'] = _userEmail;
    map['user_mobile_no'] = _userMobileNo;
    map['user_profile'] = _userProfile;
    map['login_type'] = _loginType;
    map['identity'] = _identity;
    map['platform'] = _platform;
    map['device_token'] = _deviceToken;
    map['is_verify'] = _isVerify;
    map['is_notification'] = _isNotification;
    map['total_received'] = _totalReceived;
    map['total_send'] = _totalSend;
    map['my_wallet'] = _myWallet;
    map['spen_in_app'] = _spenInApp;
    map['check_in'] = _checkIn;
    map['upload_video'] = _uploadVideo;
    map['from_fans'] = _fromFans;
    map['purchased'] = _purchased;
    map['bio'] = _bio;
    map['profile_category'] = _profileCategory;
    map['token'] = _token;
    map['fb_url'] = _fbUrl;
    map['insta_url'] = _instaUrl;
    map['youtube_url'] = _youtubeUrl;
    map['is_following_eachOther'] = _isFollowingEachOther;
    map['followers_count'] = _followersCount;
    map['following_count'] = _followingCount;
    map['my_post_likes'] = _myPostLikes;
    map['profile_category_name'] = _profileCategoryName;
    map['is_following'] = _isFollowing;
    map['block_or_not'] = _blockOrNot;
    return map;
  }

  void setToken(String? accessToken) {
    _token = accessToken;
  }

  void addFollowerCount() {
    _followersCount = _followersCount! + 1;
  }

  void removeFollowerCount() {
    _followersCount = _followersCount! - 1;
  }
}
