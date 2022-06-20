class Attributes {
  bool? editable;
  String? id;
  String? userId;
  String? friendlyName;

  Attributes({this.editable, this.id, this.userId, this.friendlyName});

  Attributes.fromJson(Map<String, dynamic> json) {
    editable = json['editable'];
    id = json['id'];
    userId = json['user_id'];
    friendlyName = json['friendly_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['editable'] = editable;
    data['id'] = id;
    data['user_id'] = userId;
    data['friendly_name'] = friendlyName;
    return data;
  }
}
