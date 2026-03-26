class MyWallet {
  int? _status;
  String? _message;
  MyWalletData? _data;

  int? get status => _status;

  String? get message => _message;

  MyWalletData? get data => _data;

  MyWallet({int? status, String? message, MyWalletData? data}) {
    _status = status;
    _message = message;
    _data = data;
  }

  MyWallet.fromJson(dynamic json) {
    _status = json["status"];
    _message = json["message"];
    _data = json["data"] != null ? MyWalletData.fromJson(json["data"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = _status;
    map["message"] = _message;
    if (_data != null) {
      map["data"] = _data!.toJson();
    }
    return map;
  }
}

class MyWalletData {
  int? _totalReceived;
  int? _totalSend;
  int? _myWallet;
  int? _spenInApp;
  int? _checkIn;
  int? _uploadVideo;
  int? _fromFans;
  int? _purchased;

  int? get totalReceived => _totalReceived;

  int? get totalSend => _totalSend;

  int? get myWallet => _myWallet;

  int? get spenInApp => _spenInApp;

  int? get checkIn => _checkIn;

  int? get uploadVideo => _uploadVideo;

  int? get fromFans => _fromFans;

  int? get purchased => _purchased;

  MyWalletData(
      {int? totalReceived,
      int? totalSend,
      int? myWallet,
      int? spenInApp,
      int? checkIn,
      int? uploadVideo,
      int? fromFans,
      int? purchased}) {
    _totalReceived = totalReceived;
    _totalSend = totalSend;
    _myWallet = myWallet;
    _spenInApp = spenInApp;
    _checkIn = checkIn;
    _uploadVideo = uploadVideo;
    _fromFans = fromFans;
    _purchased = purchased;
  }

  MyWalletData.fromJson(dynamic json) {
    _totalReceived = json["total_received"];
    _totalSend = json["total_send"];
    _myWallet = json["my_wallet"];
    _spenInApp = json["spen_in_app"];
    _checkIn = json["check_in"];
    _uploadVideo = json["upload_video"];
    _fromFans = json["from_fans"];
    _purchased = json["purchased"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["total_received"] = _totalReceived;
    map["total_send"] = _totalSend;
    map["my_wallet"] = _myWallet;
    map["spen_in_app"] = _spenInApp;
    map["check_in"] = _checkIn;
    map["upload_video"] = _uploadVideo;
    map["from_fans"] = _fromFans;
    map["purchased"] = _purchased;
    return map;
  }
}
