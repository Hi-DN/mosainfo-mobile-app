import 'package:mosainfo_mobile_app/src/api/http_client.dart';
import 'package:mosainfo_mobile_app/src/api/streaming_model.dart';

HttpClient _httpClient = HttpClient();

class StreamingService {

  // 전체 스트리밍 리스트 조회
  Future<List<StreamingModel>> getStreamingList() async {
    Map<String, dynamic> data = await _httpClient.getRequest('/streamings');

    List<dynamic> list = data['list'];
    List<StreamingModel> streamingList = list.map((e) => StreamingModel.fromJson(e)).toList();
    
    return streamingList;
  }

  // 카테고리별 스트리밍 리스트 조회
  Future<List<StreamingModel>> getStreamingListByCategory(int categoryId) async {
    Map<String, dynamic> data = await _httpClient.getRequest('/streamings?category=$categoryId');

    List<dynamic> list = data['list'];
    List<StreamingModel> streamingList = list.map((e) => StreamingModel.fromJson(e)).toList();
    
    return streamingList;
  }

  // 새로운 프로세스 생성
  Future<StreamingModel?> createStreaming(int categoryId, String title) async {
    Map<String, dynamic> data = await _httpClient.postRequest('/streaming?category=$categoryId&title=$title', {});

    if (data['result'] == 'true') {
      return StreamingModel.fromJson(data['streaming']);
    } else {
      return null;
    }
  }

  // 모자이크 시작하기
  Future<bool?> startMosaic(int streamingId) async {
    Map<String, dynamic> data = await _httpClient.getRequest('/mosaic/$streamingId');

    if (data['result'] == 'true') {
      return true;
    } else {
      return false;
    }
  }

  // 스트림 종료시 프로세스 릴리즈
  Future<bool?> releaseProcess(int streamingId) async {
    Map<String, dynamic> data = await _httpClient.getRequest('/release/$streamingId');

    if (data['result'] == 'true') {
      return true;
    } else {
      return false;
    }
  }

  // 특정 id로 스트리밍 진행여부 확인
  Future<bool?> checkStreaming(int streamingId) async {
    Map<String, dynamic> data = await _httpClient.getRequest('/streaming/$streamingId');

    if (data['result'] == 'true') {
      return true;
    } else {
      return false;
    }
  }
}

