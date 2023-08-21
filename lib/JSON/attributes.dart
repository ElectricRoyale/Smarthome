class Attributes {
  int? currentPosition;
  bool? editable;
  String? id;
  String? deviceClass;
  String? userId;
  String? friendlyName;
  String? entityPicture;
  String? icon;
  String? unitOfMeasurement;
  List? rgbColor;
  int? brightness;
  String? effect;
  List? effectList;
  bool? isVolumeMuted;
  double volumeLevel = 0;
  List? sourceList;
  List? soundModeList;

  Attributes(
      {this.currentPosition,
      this.editable,
      this.id,
      this.deviceClass,
      this.userId,
      this.friendlyName,
      this.entityPicture,
      this.icon,
      this.unitOfMeasurement,
      this.rgbColor,
      this.brightness,
      this.effect,
      this.effectList,
      this.isVolumeMuted,
      this.volumeLevel = 0,
      this.sourceList,
      this.soundModeList});

  Attributes.fromJson(Map<String, dynamic> json) {
    currentPosition = json['current_position'];
    editable = json['editable'];
    id = json['id'];
    deviceClass = json['device_class'];
    userId = json['user_id'];
    friendlyName = json['friendly_name'];
    entityPicture = json['entity_picture'];
    icon = json['icon'];
    unitOfMeasurement = json['unit_of_measurement'];
    rgbColor = json['rgb_color'];
    brightness = json['brightness'];
    effect = json['effect'];
    effectList = json['effect_list'];
    isVolumeMuted = json['is_volume_muted'];
    volumeLevel = json['volume_level'] ?? 0;
    sourceList = json['source_list'];
    soundModeList = json['sound_mode_list'];
  }

  void update(Attributes attributes) {
    currentPosition = attributes.currentPosition;
    editable = attributes.editable;
    id = attributes.id;
    deviceClass = attributes.deviceClass;
    userId = attributes.userId;
    friendlyName = attributes.friendlyName;
    entityPicture = attributes.entityPicture;
    icon = attributes.icon;
    unitOfMeasurement = attributes.unitOfMeasurement;
    rgbColor = attributes.rgbColor ?? rgbColor;
    brightness = attributes.brightness ?? brightness;
    effect = attributes.effect;
    effectList = attributes.effectList;
    isVolumeMuted = attributes.isVolumeMuted;
    volumeLevel = attributes.volumeLevel;
    sourceList = attributes.sourceList;
    soundModeList = attributes.soundModeList;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_position'] = currentPosition;
    data['editable'] = editable;
    data['id'] = id;
    data['device_class'] = deviceClass;
    data['user_id'] = userId;
    data['friendly_name'] = friendlyName;
    data['entity_picture'] = entityPicture;
    data['icon'] = icon;
    data['unit_of_measurement'] = unitOfMeasurement;
    data['rgb_color'] = rgbColor;
    data['brightness'] = brightness;
    data['effect'] = effect;
    data['effect_list'] = effectList;
    data['is_volume_muted'] = isVolumeMuted;
    data['volume_level'] = volumeLevel;
    data['source_list'] = sourceList;
    data['sound_mode_list'] = soundModeList;
    return data;
  }
}
