class ProcessModel {
  int? id;
  String? result;

  ProcessModel({this.id, this.result});

  ProcessModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['result'] = result;
    return data;
  }
}
