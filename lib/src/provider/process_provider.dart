import 'package:flutter/material.dart';
import 'package:mosainfo_mobile_app/src/api/process_model.dart';
import 'package:mosainfo_mobile_app/src/api/process_service.dart';


class ProcessProvider with ChangeNotifier {
  final ProcessService _processService = ProcessService();

  late List<ProcessModel> _processList = [];
  List<ProcessModel> get processList => _processList;

  fetchProcessList() async {
    _processList = await _processService.getProcessList();

    notifyListeners();
  }

  Future<ProcessModel?> getNewProcess() async {
    ProcessModel? process = await _processService.getProcessId();
    _processList.add(process!);
    notifyListeners();
    return process;
  }

  // deleteSelectedHeart(int heartId) async {
  //   await _heartService.deleteHeartByHeartId(heartId);
  // }

  // saveSelectedHeart(int productId) async {
  //   await _heartService.saveHeart(productId, userId);
  // }
}
