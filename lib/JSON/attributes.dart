class Attributes {
  int? currentPosition;
  bool? editable;
  String? id;
  String? userId;
  String? friendlyName;
  String? unitOfMeasurement;

  Attributes(
      {this.currentPosition,
      this.editable,
      this.id,
      this.userId,
      this.friendlyName,
      this.unitOfMeasurement});

  Attributes.fromJson(Map<String, dynamic> json) {
    currentPosition = json['current_position'];
    editable = json['editable'];
    id = json['id'];
    userId = json['user_id'];
    friendlyName = json['friendly_name'];
    unitOfMeasurement = json['unit_of_measurement'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_position'] = currentPosition;
    data['editable'] = editable;
    data['id'] = id;
    data['user_id'] = userId;
    data['friendly_name'] = friendlyName;
    data['unit_of_measurement'] = unitOfMeasurement;
    return data;
  }
}
