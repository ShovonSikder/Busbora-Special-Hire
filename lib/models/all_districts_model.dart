class AllDistrictsModel {
  AllDistrictsModel({
    this.districts,
  });

  AllDistrictsModel.fromJson(dynamic json) {
    if (json['districts'] != null) {
      districts = [];
      json['districts'].forEach((v) {
        districts?.add(Districts.fromJson(v));
      });
    }
  }
  List<Districts>? districts;
  AllDistrictsModel copyWith({
    List<Districts>? districts,
  }) =>
      AllDistrictsModel(
        districts: districts ?? this.districts,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (districts != null) {
      map['districts'] = districts?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Districts {
  Districts({
    this.distID,
    this.distTitle,
  });

  Districts.fromJson(dynamic json) {
    distID = json['distID'];
    distTitle = json['distTitle'];
  }
  String? distID;
  String? distTitle;
  Districts copyWith({
    String? distID,
    String? distTitle,
  }) =>
      Districts(
        distID: distID ?? this.distID,
        distTitle: distTitle ?? this.distTitle,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['distID'] = distID;
    map['distTitle'] = distTitle;
    return map;
  }

  @override
  String toString() => distTitle ?? '';
}
