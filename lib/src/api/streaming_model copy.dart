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
  String? streamingCategory;
  int? streamingId;
  String? streamingStartTime;
  String? streamingTitle;

  StreamingModel(
      {this.streamingCategory,
      this.streamingId,
      this.streamingStartTime,
      this.streamingTitle});

  StreamingModel.fromJson(Map<String, dynamic> json) {
    streamingCategory = json['streaming_category'];
    streamingId = json['streaming_id'];
    streamingStartTime = json['streaming_start_time'];
    streamingTitle = json['streaming_title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['streaming_category'] = streamingCategory;
    data['streaming_id'] = streamingId;
    data['streaming_start_time'] = streamingStartTime;
    data['streaming_title'] = streamingTitle;
    return data;
  }
}
