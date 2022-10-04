import 'package:mosainfo_mobile_app/src/api/http_client.dart';
import 'package:mosainfo_mobile_app/src/api/process_model.dart';

HttpClient _httpClient = HttpClient();

class ProcessService {

  // 프로세스 리스트 조회
  Future<List<ProcessModel>> getProcessList() async {
    Map<String, dynamic> data = await _httpClient.getRequest('/processes');

    List<dynamic> list = data['list'];
    List<ProcessModel> processList = list.map((e) => ProcessModel.fromJson(e)).toList();
    
    return processList;
      
  }

  // 새로운 프로세스 ID 받기
  Future<ProcessModel?> getProcessId() async {
    Map<String, dynamic> data = await _httpClient.getRequest('/get-id');

    if (data['result'] == 'true') {
      return ProcessModel.fromJson(data);
    } else {
      return null;
    }
  }

  // 모자이크 시작하기
  Future<bool?> startMosaic(int processId) async {
    Map<String, dynamic> data = await _httpClient.getRequest('/mosaic/$processId');

    if (data['result'] == 'true') {
      return true;
    } else {
      return false;
    }
  }
}

