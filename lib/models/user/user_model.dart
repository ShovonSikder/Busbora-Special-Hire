class UserModel {
  UserModel({
    this.post,
    this.bID,
    this.bTitle,
    this.allCurrency,
    this.counterName,
    this.counterID,
    this.cnCurrency,
  });

  UserModel.fromJson(dynamic json) {
    post = json['post'] != null ? Post.fromJson(json['post']) : null;
    bID = json['bID'];
    bTitle = json['bTitle'];
    if (json['allCurrency'] != null) {
      allCurrency = [];
      json['allCurrency'].forEach((v) {
        allCurrency?.add(AllCurrency.fromJson(v));
      });
    }
    counterName = json['counterName'];
    counterID = json['counterID'];
    cnCurrency = json['cnCurrency'];
  }
  Post? post;
  String? bID;
  String? bTitle;
  List<AllCurrency>? allCurrency;
  List<dynamic>? brands;
  String? counterName;
  String? counterID;
  String? cnCurrency;
  UserModel copyWith({
    Post? post,
    String? bID,
    String? bTitle,
    List<AllCurrency>? allCurrency,
    String? counterName,
    String? counterID,
    String? cnCurrency,
  }) =>
      UserModel(
        post: post ?? this.post,
        bID: bID ?? this.bID,
        bTitle: bTitle ?? this.bTitle,
        allCurrency: allCurrency ?? this.allCurrency,
        counterName: counterName ?? this.counterName,
        counterID: counterID ?? this.counterID,
        cnCurrency: cnCurrency ?? this.cnCurrency,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (post != null) {
      map['post'] = post?.toJson();
    }
    map['bID'] = bID;
    map['bTitle'] = bTitle;
    if (allCurrency != null) {
      map['allCurrency'] = allCurrency?.map((v) => v.toJson()).toList();
    }
    if (brands != null) {
      map['brands'] = brands?.map((v) => v.toJson()).toList();
    }
    map['counterName'] = counterName;
    map['counterID'] = counterID;
    map['cnCurrency'] = cnCurrency;
    return map;
  }
}

class AllCurrency {
  AllCurrency({
    this.crID,
    this.crTitle,
    this.crSymbol,
    this.crRate,
  });

  AllCurrency.fromJson(dynamic json) {
    crID = json['crID'];
    crTitle = json['crTitle'];
    crSymbol = json['crSymbol'];
    crRate = json['crRate'];
  }
  num? crID;
  String? crTitle;
  String? crSymbol;
  num? crRate;
  AllCurrency copyWith({
    num? crID,
    String? crTitle,
    String? crSymbol,
    num? crRate,
  }) =>
      AllCurrency(
        crID: crID ?? this.crID,
        crTitle: crTitle ?? this.crTitle,
        crSymbol: crSymbol ?? this.crSymbol,
        crRate: crRate ?? this.crRate,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['crID'] = crID;
    map['crTitle'] = crTitle;
    map['crSymbol'] = crSymbol;
    map['crRate'] = crRate;
    return map;
  }
}

class Post {
  Post({
    this.username,
  });

  Post.fromJson(dynamic json) {
    username = json['username'];
  }
  String? username;
  Post copyWith({
    String? username,
  }) =>
      Post(
        username: username ?? this.username,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['username'] = username;
    return map;
  }
}
