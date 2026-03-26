// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

class Conversation {
  bool? _block;
  bool? _blockFromOther;
  String? _conversationId;
  String? _deletedId;
  bool? _isDeleted;
  bool? _isMute;
  String? _lastMsg;
  String? _newMsg;
  double? _time;
  ChatUser? _user;

  Conversation({
    String? conversationId,
    bool? blockFromOther,
    bool? block,
    String? deletedId,
    bool? isDeleted,
    bool? isMute,
    String? lastMsg,
    String? newMsg,
    ChatUser? user,
    double? time,
  }) {
    _conversationId = conversationId;
    _blockFromOther = blockFromOther;
    _block = block;
    _deletedId = deletedId;
    _isDeleted = isDeleted;
    _isMute = isMute;
    _lastMsg = lastMsg;
    _newMsg = newMsg;
    _user = user;
    _time = time;
  }

  Conversation.fromJson(Map<String, dynamic> json) {
    _conversationId = json["conversationId"];
    _blockFromOther = json["blockFromOther"];
    _block = json["block"];
    _deletedId = json["deletedId"];
    _isDeleted = json["isDeleted"];
    _isMute = json["isMute"];
    _lastMsg = json["lastMsg"];
    _newMsg = json["newMsg"];
    _time = json["time"];
    _user = ChatUser.fromJson(json["user"]);
  }

  Map<String, Object?> toJson() {
    return {
      "conversationId": _conversationId,
      "blockFromOther": _blockFromOther,
      "block": _block,
      "deletedId": _deletedId,
      "isDeleted": _isDeleted,
      "isMute": _isMute,
      "lastMsg": _lastMsg,
      "newMsg": _newMsg,
      "user": _user?.toJson(),
      "time": _time,
    };
  }

  String? get conversationId => _conversationId;

  void setConversationId(String? con) {
    _conversationId = con;
  }

  bool? get blockFromOther => _blockFromOther;

  bool? get block => _block;

  ChatUser? get user => _user;

  double? get time => _time;

  String? get newMsg => _newMsg;

  String? get lastMsg => _lastMsg;

  bool? get isMute => _isMute;

  bool? get isDeleted => _isDeleted;

  String? get deletedId => _deletedId;
}

class ChatUser {
  int? _userid;
  String? _username;
  String? _userFullName;
  String? _image;
  String? _userIdentity;
  bool? _isVerified;
  bool? _isNewMsg;
  double? _date;

  ChatUser({
    String? username,
    String? userFullName,
    String? image,
    String? userIdentity,
    bool? isVerified,
    bool? isNewMsg,
    int? userid,
    double? date,
  }) {
    _username = username;
    _userFullName = userFullName;
    _image = image;
    _userIdentity = userIdentity;
    _isVerified = isVerified;
    _isNewMsg = isNewMsg;
    _userid = userid;
    _date = date;
  }

  Map<String, dynamic> toJson() {
    return {
      "username": _username,
      "userFullName": _userFullName,
      "image": _image,
      "userIdentity": _userIdentity,
      "isVerified": _isVerified,
      "isNewMsg": _isNewMsg,
      "userid": _userid,
      "date": _date,
    };
  }

  ChatUser.fromJson(Map<String, dynamic> json) {
    _username = json["username"];
    _userFullName = json["userFullName"];
    _image = json["image"];
    _userIdentity = json["userIdentity"];
    _isVerified = json["isVerified"];
    _isNewMsg = json["isNewMsg"];
    _userid = json["userid"];
    _date = json["date"];
  }

  double? get date => _date;

  set date(double? value) {
    _date = value;
  }

  bool? get isNewMsg => _isNewMsg;

  set isNewMsg(bool? value) {
    _isNewMsg = value;
  }

  bool? get isVerified => _isVerified;

  set isVerified(bool? value) {
    _isVerified = value;
  }

  String? get userIdentity => _userIdentity;

  set userIdentity(String? value) {
    _userIdentity = value;
  }

  String? get image => _image;

  set image(String? value) {
    _image = value;
  }

  String? get userFullName => _userFullName;

  set userFullName(String? value) {
    _userFullName = value;
  }

  String? get username => _username;

  set username(String? value) {
    _username = value;
  }

  int? get userid => _userid;

  set userid(int? value) {
    _userid = value;
  }
}

class ChatMessage {
  String? _id;
  String? _image;
  String? _video;
  String? _msg;
  String? _msgType;
  double? _time;
  List<String>? _notDeletedIdentities;
  ChatUser? _senderUser;

  ChatMessage(
      {String? id,
      String? image,
      String? video,
      String? msg,
      String? msgType,
      double? time,
      ChatUser? senderUser,
      List<String>? notDeletedIdentities}) {
    _id = id;
    _image = image;
    _video = video;
    _msg = msg;
    _msgType = msgType;
    _time = time;
    _senderUser = senderUser;
    _notDeletedIdentities = notDeletedIdentities;
  }

  Map<String, dynamic> toJson() {
    return {
      "id": _id,
      "image": _image,
      "video": _video,
      "msg": _msg,
      "msgType": _msgType,
      "time": _time,
      "senderUser": _senderUser?.toJson(),
      "not_deleted_identities": _notDeletedIdentities?.map((v) => v).toList()
    };
  }

  ChatMessage.fromJson(Map<String, dynamic>? json) {
    _id = json?["id"];
    _image = json?["image"];
    _video = json?["video"];
    _msg = json?["msg"];
    _msgType = json?["msgType"];
    _time = json?["time"];
    _senderUser = ChatUser.fromJson(json?["senderUser"]);
    if (json?['not_deleted_identities'] != null) {
      _notDeletedIdentities = [];
      json?['not_deleted_identities'].forEach((v) {
        _notDeletedIdentities?.add(v);
      });
    }
  }

  factory ChatMessage.fromFireStore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    List<String> notDeletedIdentities = [];
    data?['not_deleted_identities'].forEach((v) {
      notDeletedIdentities.add(v);
    });
    return ChatMessage(
      id: data?['id'],
      image: data?['image'],
      video: data?['video'],
      msg: data?['msg'],
      msgType: data?['msgType'],
      time: data?['time'],
      notDeletedIdentities: notDeletedIdentities,
      senderUser: ChatUser.fromJson(data?["senderUser"]),
    );
  }

  Map<String, dynamic> toFireStore() {
    return {
      if (id != null) "id": _id,
      if (image != null) "image": _image,
      if (video != null) "video": _video,
      if (msg != null) "msg": _msg,
      if (msgType != null) "msgType": _msgType,
      if (time != null) "time": _time,
      if (senderUser != null) "senderUser": _senderUser,
      if (notDeletedIdentities != null)
        "not_deleted_identities": _notDeletedIdentities?.map((v) => v).toList()
    };
  }

  String? get video => _video;

  List<String>? get notDeletedIdentities => _notDeletedIdentities;

  ChatUser? get senderUser => _senderUser;

  double? get time => _time;

  String? get msgType => _msgType;

  String? get msg => _msg;

  String? get image => _image;

  String? get id => _id;
}
