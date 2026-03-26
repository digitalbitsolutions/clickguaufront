class Comment {
  int? _status;
  String? _message;
  List<CommentData>? _data;

  int? get status => _status;

  String? get message => _message;

  List<CommentData>? get data => _data;

  Comment({int? status, String? message, List<CommentData>? data}) {
    _status = status;
    _message = message;
    _data = data;
  }

  Comment.fromJson(dynamic json) {
    _status = json["status"];
    _message = json["message"];
    if (json["data"] != null) {
      _data = [];
      json["data"].forEach((v) {
        _data!.add(CommentData.fromJson(v));
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

class CommentData {
  int? _commentsId;
  String? _comment;
  String? _createdDate;
  int? _userId;
  String? _fullName;
  String? _userName;
  String? _userProfile;
  int? _isVerify;

  int? get commentsId => _commentsId;

  String? get comment => _comment;

  String? get createdDate => _createdDate;

  int? get userId => _userId;

  String? get fullName => _fullName;

  String? get userName => _userName;

  String? get userProfile => _userProfile;

  int? get isVerify => _isVerify;

  CommentData(
      {int? commentsId,
      String? comment,
      String? createdDate,
      int? userId,
      String? fullName,
      String? userName,
      String? userProfile,
      int? isVerify}) {
    _commentsId = commentsId;
    _comment = comment;
    _createdDate = createdDate;
    _userId = userId;
    _fullName = fullName;
    _userName = userName;
    _userProfile = userProfile;
    _isVerify = isVerify;
  }

  CommentData.fromJson(dynamic json) {
    _commentsId = json["comments_id"];
    _comment = json["comment"];
    _createdDate = json["created_date"];
    _userId = json["user_id"];
    _fullName = json["full_name"];
    _userName = json["user_name"];
    _userProfile = json["user_profile"];
    _isVerify = json["is_verify"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["comments_id"] = _commentsId;
    map["comment"] = _comment;
    map["created_date"] = _createdDate;
    map["user_id"] = _userId;
    map["full_name"] = _fullName;
    map["user_name"] = _userName;
    map["user_profile"] = _userProfile;
    map["is_verify"] = _isVerify;
    return map;
  }
}
