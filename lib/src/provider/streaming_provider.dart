import 'package:flutter/material.dart';
import 'package:mosainfo_mobile_app/src/api/streaming_model.dart';
import 'package:mosainfo_mobile_app/src/api/streaming_service.dart';


class StreamingProvider with ChangeNotifier {
  final StreamingService _streamingService = StreamingService();

  late List<StreamingModel> _streamingList = [];
  bool _hasData = false;
  List<StreamingModel> get streamingList => _streamingList;
  bool get hasData => _hasData;

  fetchStreamingList() async {
    _streamingList = await _streamingService.getProcessList();
    if(_streamingList.isNotEmpty) {
      _hasData = true;
    } else {
      _hasData = false;
    }
    notifyListeners();
  }

  Future<StreamingModel?> createStreaming(int categoryId, String title) async {
    StreamingModel? streaming = await _streamingService.createStreaming(categoryId, title);
    _streamingList.add(streaming!);
    _hasData = true;
    notifyListeners();
    return streaming;
  }

  Future<bool?> startMosaic(int streamingId) async {
    bool? result = await _streamingService.startMosaic(streamingId);
    return result;
  }

  Future<bool?> releaseProcess(int streamingId) async {
    bool? result = await _streamingService.releaseProcess(streamingId);
    return result;
  }

  Future<bool?> checkStreaming(int streamingId) async {
    bool? result = await _streamingService.checkStreaming(streamingId);
    return result;
  }
}
