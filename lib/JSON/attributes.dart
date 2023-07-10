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
  String? repeat;
  bool? shuffle;
  bool? isVolumeMuted;
  double? volumeLevel;
  String? mediaPlaylist;
  String? mediaTitle;
  String? mediaArtist;
  double? mediaPosition;
  double? mediaDuration;
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
      this.repeat,
      this.shuffle,
      this.isVolumeMuted,
      this.volumeLevel,
      this.mediaPlaylist,
      this.mediaTitle,
      this.mediaArtist,
      this.mediaPosition,
      this.mediaDuration,
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
    repeat = json['repeat'];
    shuffle = json['shuffle'];
    isVolumeMuted = json['is_volume_muted'];
    volumeLevel = json['volume_level'];
    mediaPlaylist = json['media_playlist'];
    mediaTitle = json['media_title'];
    mediaArtist = json['media_artist'];
    mediaPosition = json['media_position'];
    mediaDuration = json['media_duration'];
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
    repeat = attributes.repeat;
    shuffle = attributes.shuffle;
    isVolumeMuted = attributes.isVolumeMuted;
    volumeLevel = attributes.volumeLevel;
    mediaPlaylist = attributes.mediaPlaylist;
    mediaTitle = attributes.mediaTitle;
    mediaArtist = attributes.mediaArtist;
    mediaPosition = attributes.mediaPosition;
    mediaDuration = attributes.mediaDuration;
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
    data['repeat'] = repeat;
    data['shuffle'] = shuffle;
    data['is_volume_muted'] = isVolumeMuted;
    data['volume_level'] = volumeLevel;
    data['media_playlist'] = mediaPlaylist;
    data['media_title'] = mediaTitle;
    data['media_artist'] = mediaArtist;
    data['media_position'] = mediaPosition;
    data['media_duration'] = mediaDuration;
    data['source_list'] = sourceList;
    data['sound_mode_list'] = soundModeList;
    return data;
  }
}
