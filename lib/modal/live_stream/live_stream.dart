import 'package:cloud_firestore/cloud_firestore.dart';

class LiveStreamUser {
  String? _agoraToken;
  int? _collectedDiamond;
  String? _fullName;
  String? _hostIdentity;
  int? _id;
  bool? _isVerified;
  String? _userName;
  List<String>? _joinedUser;
  int? _userId;
  String? _userImage;
  int? _watchingCount;
  int? _followers;

  LiveStreamUser(
      {String? agoraToken,
      int? collectedDiamond,
      String? fullName,
      String? hostIdentity,
      int? id,
      bool? isVerified,
      List<String>? joinedUser,
      int? userId,
      String? userImage,
    int? watchingCount,
    String? userName,
    int? followers}) {
    _agoraToken = agoraToken;
    _collectedDiamond = collectedDiamond;
    _fullName = fullName;
    _hostIdentity = hostIdentity;
    _id = id;
    _isVerified = isVerified;
    _joinedUser = joinedUser;
    _userId = userId;
    _userImage = userImage;
    _watchingCount = watchingCount;
    _userName = userName;
    _followers = followers;
  }

  Map<String, dynamic> toJson() {
    return {
      "agoraToken": _agoraToken,
      "collectedDiamond": _collectedDiamond,
      "fullName": _fullName,
      "hostIdentity": _hostIdentity,
      "id": _id,
      "isVerified": _isVerified,
      "joinedUser": _joinedUser?.map((e) => e).toList(),
      "userId": _userId,
      "userImage": _userImage,
      "watchingCount": _watchingCount,
      "userName": _userName,
      "followers": _followers
    };
  }

  LiveStreamUser.fromJson(Map<String, dynamic>? json) {
    _agoraToken = json?["agoraToken"];
    _collectedDiamond = json?["collectedDiamond"];
    _fullName = json?["fullName"];
    _hostIdentity = json?["hostIdentity"];
    _id = json?["id"];
    _isVerified = json?["_isVerified"];
    if (json?["joinedUser"] != null) {
      _joinedUser = [];
      json?["joinedUser"].forEach((e) {
        _joinedUser?.add(e);
      });
    }
    _userId = json?["_userId"];
    _userImage = json?["_userImage"];
    _watchingCount = json?["_watchingCount"];
    _userName = json?["userName"];
    _followers = json?["followers"];
  }

  Map<String, dynamic> toFireStore() {
    return {
      "agoraToken": _agoraToken,
      "collectedDiamond": _collectedDiamond,
      "fullName": _fullName,
      "hostIdentity": _hostIdentity,
      "id": _id,
      "isVerified": _isVerified,
      "joinedUser": _joinedUser,
      "userId": _userId,
      "userImage": _userImage,
      "watchingCount": _watchingCount,
      "userName": _userName,
      "followers": _followers
    };
  }

  factory LiveStreamUser.fromFireStore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    List<String> joinedUser = [];
    data?['joinedUser'].forEach((v) {
      joinedUser.add(v);
    });
    return LiveStreamUser(
      agoraToken: data?["agoraToken"],
      collectedDiamond: data?["collectedDiamond"],
      fullName: data?["fullName"],
      hostIdentity: data?["hostIdentity"],
      id: data?["id"],
      isVerified: data?["isVerified"],
      joinedUser: joinedUser,
      userId: data?["userId"],
      userImage: data?["userImage"],
      watchingCount: data?["watchingCount"],
      userName: data?["userName"],
      followers: data?["followers"],
    );
  }

  int? get watchingCount => _watchingCount;

  String? get userImage => _userImage;

  int? get userId => _userId;

  List<String>? get joinedUser => _joinedUser;

  bool? get isVerified => _isVerified;

  int? get id => _id;

  String? get hostIdentity => _hostIdentity;

  String? get fullName => _fullName;

  int? get collectedDiamond => _collectedDiamond;

  String? get agoraToken => _agoraToken;

  String? get userName => _userName;

  int? get followers => _followers;
}

class LiveStreamComment {
  String? _comment;
  String? _commentType;
  int? _id;
  bool? _isVerify;
  int? _userId;
  String? _userImage;
  String? _userName;
  String? _fullName;

  LiveStreamComment(
      {String? comment,
      String? commentType,
      int? id,
      bool? isVerify,
      int? userId,
      String? userImage,
      String? userName,
      String? fullName}) {
    _comment = comment;
    _commentType = commentType;
    _id = id;
    _isVerify = isVerify;
    _userId = userId;
    _userImage = userImage;
    _userName = userName;
    _fullName = fullName;
  }

  Map<String, dynamic> toJson() {
    return {
      "comment": _comment,
      "commentType": _commentType,
      "id": _id,
      "isVerify": _isVerify,
      "userId": _userId,
      "userImage": _userImage,
      "userName": _userName,
      "fullName": _fullName,
    };
  }

  LiveStreamComment.fromJson(Map<String, dynamic>? json) {
    _comment = json?["comment"];
    _commentType = json?["commentType"];
    _id = json?["id"];
    _isVerify = json?["isVerify"];
    _userId = json?["userId"];
    _userImage = json?["userImage"];
    _userName = json?["userName"];
    _fullName = json?["fullName"];
  }

  Map<String, dynamic> toFireStore() {
    return {
      "comment": _comment,
      "commentType": _commentType,
      "id": _id,
      "isVerify": _isVerify,
      "userId": _userId,
      "userImage": _userImage,
      "userName": _userName,
      "fullName": _fullName,
    };
  }

  factory LiveStreamComment.fromFireStore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return LiveStreamComment(
      comment: data?['comment'],
      commentType: data?['commentType'],
      id: data?['id'],
      isVerify: data?['isVerify'],
      userId: data?['userId'],
      userImage: data?['userImage'],
      userName: data?['userName'],
      fullName: data?['fullName'],
    );
  }

  String? get userName => _userName;

  String? get userImage => _userImage;

  int? get userId => _userId;

  bool? get isVerify => _isVerify;

  int? get id => _id;

  String? get commentType => _commentType;

  String? get comment => _comment;

  String? get fullName => _fullName;
}
