class Agora {
  Agora({
    bool? success,
    String? message,
    AgoraData? data,
  }) {
    _success = success;
    _message = message;
    _data = data;
  }

  Agora.fromJson(dynamic json) {
    _success = json['success'];
    _message = json['message'];
    _data = json['data'] != null ? AgoraData.fromJson(json['data']) : null;
  }

  bool? _success;
  String? _message;
  AgoraData? _data;

  bool? get success => _success;
  String? get message => _message;

  AgoraData? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }
}

class AgoraData {
  AgoraData({
    bool? channelExist,
    int? mode,
    List<int>? broadcasters,
    List<int>? audience,
    int? audienceTotal,
  }) {
    _channelExist = channelExist;
    _mode = mode;
    _broadcasters = broadcasters;
    _audience = audience;
    _audienceTotal = audienceTotal;
  }

  AgoraData.fromJson(dynamic json) {
    _channelExist = json['channel_exist'];
    _mode = json['mode'];
    _broadcasters =
        json['broadcasters'] != null ? json['broadcasters'].cast<int>() : [];
    _audience = json['audience'] != null ? json['audience'].cast<int>() : [];
    _audienceTotal = json['audience_total'];
  }

  bool? _channelExist;
  int? _mode;
  List<int>? _broadcasters;
  List<int>? _audience;
  int? _audienceTotal;

  bool? get channelExist => _channelExist;

  int? get mode => _mode;

  List<int>? get broadcasters => _broadcasters;

  List<int>? get audience => _audience;

  int? get audienceTotal => _audienceTotal;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['channel_exist'] = _channelExist;
    map['mode'] = _mode;
    map['broadcasters'] = _broadcasters;
    map['audience'] = _audience;
    map['audience_total'] = _audienceTotal;
    return map;
  }
}
