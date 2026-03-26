import 'nudity_media_id.dart';

class NudityChecker {
  NudityChecker({
    String? status,
    Request? request,
    Output? output,
    Error? error,
  }) {
    _status = status;
    _request = request;
    _output = output;
    _error = error;
  }

  NudityChecker.fromJson(dynamic json) {
    _status = json['status'];
    _request =
        json['request'] != null ? Request.fromJson(json['request']) : null;
    _output = json['output'] != null ? Output.fromJson(json['output']) : null;
    _error = json['error'] != null ? Error.fromJson(json['error']) : null;
  }
  String? _status;
  Request? _request;
  Output? _output;
  Error? _error;

  String? get status => _status;
  Request? get request => _request;
  Output? get output => _output;
  Error? get error => _error;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    if (_request != null) {
      map['request'] = _request?.toJson();
    }
    if (_output != null) {
      map['output'] = _output?.toJson();
    }
    if (_error != null) {
      map['error'] = _error?.toJson();
    }
    return map;
  }
}

class Output {
  Output({
    Media? media,
    String? request,
    Data? data,
  }) {
    _media = media;
    _request = request;
    _data = data;
  }

  Output.fromJson(dynamic json) {
    _media = json['media'] != null ? Media.fromJson(json['media']) : null;
    _request = json['request'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  Media? _media;
  String? _request;
  Data? _data;

  Media? get media => _media;
  String? get request => _request;
  Data? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_media != null) {
      map['media'] = _media?.toJson();
    }
    map['request'] = _request;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }
}

class Data {
  Data({
    String? status,
    double? started,
    double? lastUpdate,
    int? operations,
    num? progress,
    List<Frames>? frames,
  }) {
    _status = status;
    _started = started;
    _lastUpdate = lastUpdate;
    _operations = operations;
    _progress = progress;
    _frames = frames;
  }

  Data.fromJson(dynamic json) {
    _status = json['status'];
    _started = json['started'];
    _lastUpdate = json['last_update'];
    _operations = json['operations'];
    _progress = json['progress'];
    if (json['frames'] != null) {
      _frames = [];
      json['frames'].forEach((v) {
        _frames?.add(Frames.fromJson(v));
      });
    }
  }
  String? _status;
  double? _started;
  double? _lastUpdate;
  int? _operations;
  num? _progress;
  List<Frames>? _frames;

  String? get status => _status;
  double? get started => _started;
  double? get lastUpdate => _lastUpdate;
  int? get operations => _operations;
  num? get progress => _progress;
  List<Frames>? get frames => _frames;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['started'] = _started;
    map['last_update'] = _lastUpdate;
    map['operations'] = _operations;
    map['progress'] = _progress;
    if (_frames != null) {
      map['frames'] = _frames?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Frames {
  Frames({
    Info? info,
    Nudity? nudity,
    double? weapon,
    double? alcohol,
    double? drugs,
    double? medicalDrugs,
    double? recreationalDrugs,
    double? weaponFirearm,
    double? weaponKnife,
  }) {
    _info = info;
    _nudity = nudity;
    _weapon = weapon;
    _alcohol = alcohol;
    _drugs = drugs;
    _medicalDrugs = medicalDrugs;
    _recreationalDrugs = recreationalDrugs;
    _weaponFirearm = weaponFirearm;
    _weaponKnife = weaponKnife;
  }

  Frames.fromJson(dynamic json) {
    _info = json['info'] != null ? Info.fromJson(json['info']) : null;
    _nudity = json['nudity'] != null ? Nudity.fromJson(json['nudity']) : null;
    _weapon = json['weapon'];
    _alcohol = json['alcohol'];
    _drugs = json['drugs'];
    _medicalDrugs = json['medical_drugs'];
    _recreationalDrugs = json['recreational_drugs'];
    _weaponFirearm = json['weapon_firearm'];
    _weaponKnife = json['weapon_knife'];
  }
  Info? _info;
  Nudity? _nudity;
  double? _weapon;
  double? _alcohol;
  double? _drugs;
  double? _medicalDrugs;
  double? _recreationalDrugs;
  double? _weaponFirearm;
  double? _weaponKnife;

  Info? get info => _info;
  Nudity? get nudity => _nudity;
  double? get weapon => _weapon;
  double? get alcohol => _alcohol;
  double? get drugs => _drugs;
  double? get medicalDrugs => _medicalDrugs;
  double? get recreationalDrugs => _recreationalDrugs;
  double? get weaponFirearm => _weaponFirearm;
  double? get weaponKnife => _weaponKnife;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_info != null) {
      map['info'] = _info?.toJson();
    }
    if (_nudity != null) {
      map['nudity'] = _nudity?.toJson();
    }
    map['weapon'] = _weapon;
    map['alcohol'] = _alcohol;
    map['drugs'] = _drugs;
    map['medical_drugs'] = _medicalDrugs;
    map['recreational_drugs'] = _recreationalDrugs;
    map['weapon_firearm'] = _weaponFirearm;
    map['weapon_knife'] = _weaponKnife;
    return map;
  }
}

class Nudity {
  Nudity({
    double? raw,
    double? safe,
    double? partial,
  }) {
    _raw = raw;
    _safe = safe;
    _partial = partial;
  }

  Nudity.fromJson(dynamic json) {
    _raw = json['raw'];
    _safe = json['safe'];
    _partial = json['partial'];
  }
  double? _raw;
  double? _safe;
  double? _partial;

  double? get raw => _raw;
  double? get safe => _safe;
  double? get partial => _partial;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['raw'] = _raw;
    map['safe'] = _safe;
    map['partial'] = _partial;
    return map;
  }
}

class Info {
  Info({
    String? id,
    int? position,
  }) {
    _id = id;
    _position = position;
  }

  Info.fromJson(dynamic json) {
    _id = json['id'];
    _position = json['position'];
  }
  String? _id;
  int? _position;

  String? get id => _id;
  int? get position => _position;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['position'] = _position;
    return map;
  }
}

class Media {
  Media({
    String? id,
    String? uri,
  }) {
    _id = id;
    _uri = uri;
  }

  Media.fromJson(dynamic json) {
    _id = json['id'];
    _uri = json['uri'];
  }
  String? _id;
  String? _uri;

  String? get id => _id;
  String? get uri => _uri;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['uri'] = _uri;
    return map;
  }
}

class Request {
  Request({
    String? id,
    double? timestamp,
    int? operations,
  }) {
    _id = id;
    _timestamp = timestamp;
    _operations = operations;
  }

  Request.fromJson(dynamic json) {
    _id = json['id'];
    _timestamp = json['timestamp'];
    _operations = json['operations'];
  }
  String? _id;
  double? _timestamp;
  int? _operations;

  String? get id => _id;
  double? get timestamp => _timestamp;
  int? get operations => _operations;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['timestamp'] = _timestamp;
    map['operations'] = _operations;
    return map;
  }
}
