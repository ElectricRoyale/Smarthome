class Attributes {
  bool? editable;
  String? id;
  String? userId;
  String? friendlyName;
  String? unitOfMeasurement;

  Attributes(
      {this.editable,
      this.id,
      this.userId,
      this.friendlyName,
      this.unitOfMeasurement});

  Attributes.fromJson(Map<String, dynamic> json) {
    editable = json['editable'];
    id = json['id'];
    userId = json['user_id'];
    friendlyName = json['friendly_name'];
    unitOfMeasurement = json['unit_of_measurement'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['editable'] = editable;
    data['id'] = id;
    data['user_id'] = userId;
    data['friendly_name'] = friendlyName;
    data['unit_of_measurement'] = unitOfMeasurement;
    return data;
  }
}
