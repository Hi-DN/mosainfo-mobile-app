class Response {
  String? result;
  StreamingModel? streaming;

  Response({this.result, this.streaming});

  Response.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    streaming = json['streaming'] != null
        ? StreamingModel.fromJson(json['streaming'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['result'] = result;
    if (streaming != null) {
      data['streaming'] = streaming!.toJson();
    }
    return data;
  }
}

class StreamingModel {
  int? categoryId;
  int? id;
  String? startTime;
  String? title;

  StreamingModel(
      {this.categoryId,
      this.id,
      this.startTime,
      this.title});

  StreamingModel.fromJson(Map<String, dynamic> json) {
    categoryId = int.parse(json['streaming_category'] ?? "0");
    id = json['streaming_id'];
    startTime = json['streaming_start_time'];
    title = json['streaming_title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['streaming_category'] = categoryId.toString;
    data['streaming_id'] = id;
    data['streaming_start_time'] = startTime;
    data['streaming_title'] = title;
    return data;
  }
}
