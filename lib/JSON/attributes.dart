class Attributes {
  int? currentPosition;
  bool? editable;
  String? id;
  String? userId;
  String? friendlyName;
  String? entityPicture;
  String? unitOfMeasurement;
  List? rgbColor;
  int? brightness;
  String? effect;

  Attributes(
      {this.currentPosition,
      this.editable,
      this.id,
      this.userId,
      this.friendlyName,
      this.entityPicture,
      this.unitOfMeasurement,
      this.rgbColor,
      this.brightness,
      this.effect});

  Attributes.fromJson(Map<String, dynamic> json) {
    currentPosition = json['current_position'];
    editable = json['editable'];
    id = json['id'];
    userId = json['user_id'];
    friendlyName = json['friendly_name'];
    entityPicture = json['entity_picture'];
    unitOfMeasurement = json['unit_of_measurement'];
    rgbColor = json['rgb_color'];
    brightness = json['brightness'];
    effect = json['effect'];
  }

  void update(Attributes attributes) {
    currentPosition = attributes.currentPosition;
    editable = attributes.editable;
    id = attributes.id;
    userId = attributes.userId;
    friendlyName = attributes.friendlyName;
    entityPicture = attributes.entityPicture;
    unitOfMeasurement = attributes.unitOfMeasurement;
    rgbColor = attributes.rgbColor ?? rgbColor;
    brightness = attributes.brightness ?? brightness;
    effect = attributes.effect ?? effect;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_position'] = currentPosition;
    data['editable'] = editable;
    data['id'] = id;
    data['user_id'] = userId;
    data['friendly_name'] = friendlyName;
    data['entity_picture'] = entityPicture;
    data['unit_of_measurement'] = unitOfMeasurement;
    data['rgb_color'] = rgbColor;
    data['brightness'] = brightness;
    data['effect'] = effect;
    return data;
  }
}
