class CoinPlans {
  int? _status;
  String? _message;
  List<CoinPlanData>? _data;

  int? get status => _status;

  String? get message => _message;

  List<CoinPlanData>? get data => _data;

  CoinPlans({int? status, String? message, List<CoinPlanData>? data}) {
    _status = status;
    _message = message;
    _data = data;
  }

  CoinPlans.fromJson(dynamic json) {
    _status = json["status"];
    _message = json["message"];
    if (json["data"] != null) {
      _data = [];
      json["data"].forEach((v) {
        _data!.add(CoinPlanData.fromJson(v));
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

class CoinPlanData {
  int? _coinPlanId;
  String? _coinPlanName;
  String? _coinPlanDescription;
  String? _coinPlanPrice;
  int? _coinAmount;
  String? _playstoreProductId;
  String? _appstoreProductId;
  String? _createdAt;
  dynamic _updatedAt;

  int? get coinPlanId => _coinPlanId;

  String? get coinPlanName => _coinPlanName;

  String? get coinPlanDescription => _coinPlanDescription;

  String? get coinPlanPrice => _coinPlanPrice;

  int? get coinAmount => _coinAmount;

  String? get playstoreProductId => _playstoreProductId;

  String? get appstoreProductId => _appstoreProductId;

  String? get createdAt => _createdAt;

  dynamic get updatedAt => _updatedAt;

  CoinPlanData(
      {int? coinPlanId,
      String? coinPlanName,
      String? coinPlanDescription,
      String? coinPlanPrice,
      int? coinAmount,
      String? playstoreProductId,
      String? appstoreProductId,
      String? createdAt,
      dynamic updatedAt}) {
    _coinPlanId = coinPlanId;
    _coinPlanName = coinPlanName;
    _coinPlanDescription = coinPlanDescription;
    _coinPlanPrice = coinPlanPrice;
    _coinAmount = coinAmount;
    _playstoreProductId = playstoreProductId;
    _appstoreProductId = appstoreProductId;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  CoinPlanData.fromJson(dynamic json) {
    _coinPlanId = json["coin_plan_id"];
    _coinPlanName = json["coin_plan_name"];
    _coinPlanDescription = json["coin_plan_description"];
    _coinPlanPrice = json["coin_plan_price"];
    _coinAmount = json["coin_amount"];
    _playstoreProductId = json["playstore_product_id"];
    _appstoreProductId = json["appstore_product_id"];
    _createdAt = json["created_at"];
    _updatedAt = json["updated_at"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["coin_plan_id"] = _coinPlanId;
    map["coin_plan_name"] = _coinPlanName;
    map["coin_plan_description"] = _coinPlanDescription;
    map["coin_plan_price"] = _coinPlanPrice;
    map["coin_amount"] = _coinAmount;
    map["playstore_product_id"] = _playstoreProductId;
    map["appstore_product_id"] = _appstoreProductId;
    map["created_at"] = _createdAt;
    map["updated_at"] = _updatedAt;
    return map;
  }
}
