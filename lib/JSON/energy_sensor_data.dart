class EnergySensorData {
  int? start;
  DateTime? end;
  int? mean;
  int? min;
  int? max;
  int? lastReset;
  double? state;
  double? sum;

  EnergySensorData(
      {this.start,
      this.end,
      this.mean,
      this.min,
      this.max,
      this.lastReset,
      this.state,
      this.sum});

  EnergySensorData.fromJson(Map<String, dynamic> json) {
    start = json['start'];
    end = DateTime.fromMillisecondsSinceEpoch(json['end']);
    mean = json['mean'];
    min = json['min'];
    max = json['max'];
    lastReset = json['last_reset'];
    state = json['state'];
    sum = json['sum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['start'] = start;
    data['end'] = end;
    data['mean'] = mean;
    data['min'] = min;
    data['max'] = max;
    data['last_reset'] = lastReset;
    data['state'] = state;
    data['sum'] = sum;
    return data;
  }
}
