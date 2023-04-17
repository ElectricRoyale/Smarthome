class Attributes {
  int? currentPosition;
  bool? editable;
  String? id;
  String? deviceClass;
  String? userId;
  String? friendlyName;
  String? entityPicture;
  String? unitOfMeasurement;
  List? rgbColor;
  int? brightness;
  String? effect;
  String? repeat;
  bool? shuffle;
  bool? isVolumeMuted;
  String? mediaPlaylist;
  String? mediaTitle;
  String? mediaArtist;
  double? mediaPosition;
  double? mediaDuration;
  List? sourceList;

  Attributes(
      {this.currentPosition,
      this.editable,
      this.id,
      this.deviceClass,
      this.userId,
      this.friendlyName,
      this.entityPicture,
      this.unitOfMeasurement,
      this.rgbColor,
      this.brightness,
      this.effect,
      this.repeat,
      this.shuffle,
      this.isVolumeMuted,
      this.mediaPlaylist,
      this.mediaTitle,
      this.mediaArtist,
      this.mediaPosition,
      this.mediaDuration,
      this.sourceList});

  Attributes.fromJson(Map<String, dynamic> json) {
    currentPosition = json['current_position'];
    editable = json['editable'];
    id = json['id'];
    deviceClass = json['device_class'];
    userId = json['user_id'];
    friendlyName = json['friendly_name'];
    entityPicture = json['entity_picture'];
    unitOfMeasurement = json['unit_of_measurement'];
    rgbColor = json['rgb_color'];
    brightness = json['brightness'];
    effect = json['effect'];
    repeat = json['repeat'];
    shuffle = json['shuffle'];
    isVolumeMuted = json['is_volume_muted'];
    mediaPlaylist = json['media_playlist'];
    mediaTitle = json['media_title'];
    mediaArtist = json['media_artist'];
    mediaPosition = json['media_position'];
    mediaDuration = json['media_duration'];
    sourceList = json['source_list'];
  }

  void update(Attributes attributes) {
    currentPosition = attributes.currentPosition;
    editable = attributes.editable;
    id = attributes.id;
    deviceClass = attributes.deviceClass;
    userId = attributes.userId;
    friendlyName = attributes.friendlyName;
    entityPicture = attributes.entityPicture;
    unitOfMeasurement = attributes.unitOfMeasurement;
    rgbColor = attributes.rgbColor ?? rgbColor;
    brightness = attributes.brightness ?? brightness;
    effect = attributes.effect;
    repeat = attributes.repeat;
    shuffle = attributes.shuffle;
    isVolumeMuted = attributes.isVolumeMuted;
    mediaPlaylist = attributes.mediaPlaylist;
    mediaTitle = attributes.mediaTitle;
    mediaArtist = attributes.mediaArtist;
    mediaPosition = attributes.mediaPosition;
    mediaDuration = attributes.mediaDuration;
    sourceList = attributes.sourceList;
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
    data['unit_of_measurement'] = unitOfMeasurement;
    data['rgb_color'] = rgbColor;
    data['brightness'] = brightness;
    data['effect'] = effect;
    data['repeat'] = repeat;
    data['shuffle'] = shuffle;
    data['is_volume_muted'] = isVolumeMuted;
    data['media_playlist'] = mediaPlaylist;
    data['media_title'] = mediaTitle;
    data['media_artist'] = mediaArtist;
    data['media_position'] = mediaPosition;
    data['media_duration'] = mediaDuration;
    data['source_list'] = sourceList;
    return data;
  }
}
