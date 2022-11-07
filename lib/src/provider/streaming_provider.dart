import 'package:flutter/material.dart';
import 'package:mosainfo_mobile_app/src/api/streaming_model.dart';
import 'package:mosainfo_mobile_app/src/api/streaming_service.dart';


class StreamingProvider with ChangeNotifier {
  final StreamingService _streamingService = StreamingService();

  late List<StreamingModel> _streamingList = [];
  List<List<StreamingModel>> _categoryStreamingList = [[],[],[],[],[],[],[],[],[],[],[],[]];
  bool _hasData = false;
  int _selectedCategoryId = 0;

  List<StreamingModel> get streamingList => _categoryStreamingList[_selectedCategoryId];
  bool get hasData => _hasData;
  int get selectedCategoryId => _selectedCategoryId;

  List<StreamingModel> getStreamingListByCategory(int categoryId) {
    return _categoryStreamingList[categoryId];
  }

  setSelectedCategoryId(int val) {
    _selectedCategoryId = val;
    
    if(_categoryStreamingList[_selectedCategoryId].isNotEmpty) {
      _hasData = true;
    } else {
      _hasData = false;
    }

    fetchStreamingList();
    notifyListeners();
  }

  fetchStreamingList() async {
    _streamingList = await _streamingService.getStreamingList();
    _categoryStreamingList = [_streamingList,[],[],[],[],[],[],[],[],[],[],[]];

    for (var streaming in _streamingList) {
      _categoryStreamingList[streaming.categoryId!].add(streaming);
    }

    if(_categoryStreamingList[_selectedCategoryId].isNotEmpty) {
      _hasData = true;
    } else {
      _hasData = false;
    }

    notifyListeners();
  }

  Future<StreamingModel?> createStreaming(int categoryId, String title) async {
    StreamingModel? streaming = await _streamingService.createStreaming(categoryId, title);
    _streamingList.add(streaming!);
    if(_selectedCategoryId == categoryId) _categoryStreamingList[_selectedCategoryId].add(streaming);
    _hasData = true;
    notifyListeners();
    return streaming;
  }

  Future<bool?> startMosaic(int streamingId) async {
    bool? result = await _streamingService.startMosaic(streamingId);
    return result;
  }

  Future<bool?> restartMosaic(int streamingId) async {
    bool? result = await _streamingService.restartMosaic(streamingId);
    return result;
  }

  Future<bool?> stopMosaic(int streamingId) async {
    bool? result = await _streamingService.stopMosaic(streamingId);
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
