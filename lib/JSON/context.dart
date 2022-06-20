class Context {
  String? id;
  String? parentId;
  String? userId;

  Context({this.id, this.parentId, this.userId});

  Context.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parentId = json['parent_id'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['parent_id'] = parentId;
    data['user_id'] = userId;
    return data;
  }
}
