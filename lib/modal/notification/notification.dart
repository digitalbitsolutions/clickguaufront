class UserNotifications {
  UserNotifications({
    int? status,
    String? message,
    List<NotificationData>? data,
  }) {
    _status = status;
    _message = message;
    _data = data;
  }

  UserNotifications.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(NotificationData.fromJson(v));
      });
    }
  }

  int? _status;
  String? _message;
  List<NotificationData>? _data;

  UserNotifications copyWith({
    int? status,
    String? message,
    List<NotificationData>? data,
  }) =>
      UserNotifications(
        status: status ?? _status,
        message: message ?? _message,
        data: data ?? _data,
      );

  int? get status => _status;

  String? get message => _message;

  List<NotificationData>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class NotificationData {
  NotificationData({
    int? notificationId,
    int? senderUserId,
    int? receivedUserId,
    int? notificationType,
    int? itemId,
    String? message,
    String? createdAt,
    dynamic updatedAt,
    SenderUser? senderUser,
  }) {
    _notificationId = notificationId;
    _senderUserId = senderUserId;
    _receivedUserId = receivedUserId;
    _notificationType = notificationType;
    _itemId = itemId;
    _message = message;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _senderUser = senderUser;
  }

  NotificationData.fromJson(dynamic json) {
    _notificationId = json['notification_id'];
    _senderUserId = json['sender_user_id'];
    _receivedUserId = json['received_user_id'];
    _notificationType = json['notification_type'];
    _itemId = json['item_id'];
    _message = json['message'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _senderUser = json['sender_user'] != null
        ? SenderUser.fromJson(json['sender_user'])
        : null;
  }

  int? _notificationId;
  int? _senderUserId;
  int? _receivedUserId;
  int? _notificationType;
  int? _itemId;
  String? _message;
  String? _createdAt;
  dynamic _updatedAt;
  SenderUser? _senderUser;

  NotificationData copyWith({
    int? notificationId,
    int? senderUserId,
    int? receivedUserId,
    int? notificationType,
    int? itemId,
    String? message,
    String? createdAt,
    dynamic updatedAt,
    SenderUser? senderUser,
  }) =>
      NotificationData(
        notificationId: notificationId ?? _notificationId,
        senderUserId: senderUserId ?? _senderUserId,
        receivedUserId: receivedUserId ?? _receivedUserId,
        notificationType: notificationType ?? _notificationType,
        itemId: itemId ?? _itemId,
        message: message ?? _message,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
        senderUser: senderUser ?? _senderUser,
      );

  int? get notificationId => _notificationId;

  int? get senderUserId => _senderUserId;

  int? get receivedUserId => _receivedUserId;

  int? get notificationType => _notificationType;

  int? get itemId => _itemId;

  String? get message => _message;

  String? get createdAt => _createdAt;

  dynamic get updatedAt => _updatedAt;

  SenderUser? get senderUser => _senderUser;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['notification_id'] = _notificationId;
    map['sender_user_id'] = _senderUserId;
    map['received_user_id'] = _receivedUserId;
    map['notification_type'] = _notificationType;
    map['item_id'] = _itemId;
    map['message'] = _message;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    if (_senderUser != null) {
      map['sender_user'] = _senderUser?.toJson();
    }
    return map;
  }
}

class SenderUser {
  SenderUser({
    int? userId,
    String? fullName,
    String? userName,
    String? userEmail,
    dynamic userMobileNo,
    String? userProfile,
    String? loginType,
    String? identity,
    int? platform,
    String? deviceToken,
    int? isVerify,
    int? totalReceived,
    int? totalSend,
    int? myWallet,
    int? spenInApp,
    int? checkIn,
    int? uploadVideo,
    int? fromFans,
    int? purchased,
    dynamic bio,
    dynamic profileCategory,
    dynamic fbUrl,
    dynamic instaUrl,
    dynamic youtubeUrl,
    int? status,
    int? freezOrNot,
    String? timezone,
    String? createdAt,
    String? updatedAt,
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
    _fbUrl = fbUrl;
    _instaUrl = instaUrl;
    _youtubeUrl = youtubeUrl;
    _status = status;
    _freezOrNot = freezOrNot;
    _timezone = timezone;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  SenderUser.fromJson(dynamic json) {
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
    _totalReceived = json['total_received'];
    _totalSend = json['total_send'];
    _myWallet = json['my_wallet'];
    _spenInApp = json['spen_in_app'];
    _checkIn = json['check_in'];
    _uploadVideo = json['upload_video'];
    _fromFans = json['from_fans'];
    _purchased = json['purchased'];
    _bio = json['bio'];
    _profileCategory = json['profile_category'];
    _fbUrl = json['fb_url'];
    _instaUrl = json['insta_url'];
    _youtubeUrl = json['youtube_url'];
    _status = json['status'];
    _freezOrNot = json['freez_or_not'];
    _timezone = json['timezone'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  int? _userId;
  String? _fullName;
  String? _userName;
  String? _userEmail;
  dynamic _userMobileNo;
  String? _userProfile;
  String? _loginType;
  String? _identity;
  int? _platform;
  String? _deviceToken;
  int? _isVerify;
  int? _totalReceived;
  int? _totalSend;
  int? _myWallet;
  int? _spenInApp;
  int? _checkIn;
  int? _uploadVideo;
  int? _fromFans;
  int? _purchased;
  dynamic _bio;
  dynamic _profileCategory;
  dynamic _fbUrl;
  dynamic _instaUrl;
  dynamic _youtubeUrl;
  int? _status;
  int? _freezOrNot;
  String? _timezone;
  String? _createdAt;
  String? _updatedAt;

  SenderUser copyWith({
    int? userId,
    String? fullName,
    String? userName,
    String? userEmail,
    dynamic userMobileNo,
    String? userProfile,
    String? loginType,
    String? identity,
    int? platform,
    String? deviceToken,
    int? isVerify,
    int? totalReceived,
    int? totalSend,
    int? myWallet,
    int? spenInApp,
    int? checkIn,
    int? uploadVideo,
    int? fromFans,
    int? purchased,
    dynamic bio,
    dynamic profileCategory,
    dynamic fbUrl,
    dynamic instaUrl,
    dynamic youtubeUrl,
    int? status,
    int? freezOrNot,
    String? timezone,
    String? createdAt,
    String? updatedAt,
  }) =>
      SenderUser(
        userId: userId ?? _userId,
        fullName: fullName ?? _fullName,
        userName: userName ?? _userName,
        userEmail: userEmail ?? _userEmail,
        userMobileNo: userMobileNo ?? _userMobileNo,
        userProfile: userProfile ?? _userProfile,
        loginType: loginType ?? _loginType,
        identity: identity ?? _identity,
        platform: platform ?? _platform,
        deviceToken: deviceToken ?? _deviceToken,
        isVerify: isVerify ?? _isVerify,
        totalReceived: totalReceived ?? _totalReceived,
        totalSend: totalSend ?? _totalSend,
        myWallet: myWallet ?? _myWallet,
        spenInApp: spenInApp ?? _spenInApp,
        checkIn: checkIn ?? _checkIn,
        uploadVideo: uploadVideo ?? _uploadVideo,
        fromFans: fromFans ?? _fromFans,
        purchased: purchased ?? _purchased,
        bio: bio ?? _bio,
        profileCategory: profileCategory ?? _profileCategory,
        fbUrl: fbUrl ?? _fbUrl,
        instaUrl: instaUrl ?? _instaUrl,
        youtubeUrl: youtubeUrl ?? _youtubeUrl,
        status: status ?? _status,
        freezOrNot: freezOrNot ?? _freezOrNot,
        timezone: timezone ?? _timezone,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
      );

  int? get userId => _userId;

  String? get fullName => _fullName;

  String? get userName => _userName;

  String? get userEmail => _userEmail;

  dynamic get userMobileNo => _userMobileNo;

  String? get userProfile => _userProfile;

  String? get loginType => _loginType;

  String? get identity => _identity;

  int? get platform => _platform;

  String? get deviceToken => _deviceToken;

  int? get isVerify => _isVerify;

  int? get totalReceived => _totalReceived;

  int? get totalSend => _totalSend;

  int? get myWallet => _myWallet;

  int? get spenInApp => _spenInApp;

  int? get checkIn => _checkIn;

  int? get uploadVideo => _uploadVideo;

  int? get fromFans => _fromFans;

  int? get purchased => _purchased;

  dynamic get bio => _bio;

  dynamic get profileCategory => _profileCategory;

  dynamic get fbUrl => _fbUrl;

  dynamic get instaUrl => _instaUrl;

  dynamic get youtubeUrl => _youtubeUrl;

  int? get status => _status;

  int? get freezOrNot => _freezOrNot;

  String? get timezone => _timezone;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

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
    map['fb_url'] = _fbUrl;
    map['insta_url'] = _instaUrl;
    map['youtube_url'] = _youtubeUrl;
    map['status'] = _status;
    map['freez_or_not'] = _freezOrNot;
    map['timezone'] = _timezone;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }
}