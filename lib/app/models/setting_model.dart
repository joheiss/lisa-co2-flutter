class Setting {
  String key;
  String value;

  Setting({this.key, this.value});

  Setting.fromJSON(Map<String, dynamic> json)
      : key = json['id'],
        value = json['value'] ?? '';

  Map<String, dynamic> toJSON() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['value'] = this.value;
    return data;
  }
}