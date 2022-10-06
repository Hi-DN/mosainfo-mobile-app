import 'package:flutter/material.dart';
import 'package:mosainfo_mobile_app/src/api/process_model.dart';
import 'package:mosainfo_mobile_app/src/constants/colors.dart';
import 'package:mosainfo_mobile_app/src/provider/process_provider.dart';
import 'package:mosainfo_mobile_app/src/view/streamer_view.dart';
import 'package:mosainfo_mobile_app/src/view/streaming_view.dart';
import 'package:mosainfo_mobile_app/widgets/common/custom_appbar.dart';
import 'package:provider/provider.dart';


// ignore: must_be_immutable
class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  late BuildContext? _context;

  @override
  Widget build(BuildContext context) {
    _context = context;
    Provider.of<ProcessProvider>(context, listen: false).fetchProcessList();
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Column(
        children: [
          _newProcessBtn(),
          const SizedBox(height: 20),
          Expanded(child: _scrollNotificationWidget())
        ],
      )
    );
  }

  Widget _scrollNotificationWidget() {
    
    return NotificationListener<ScrollNotification>(
        child: RefreshIndicator(
            
            displacement: 22,
            onRefresh: () async {
              Provider.of<ProcessProvider>(_context!, listen: false).fetchProcessList();
            },
            child: const ProcessListSection()));
  }

  Widget _newProcessBtn() {
    return GestureDetector(
      onTap: () async {
        ProcessModel? process = await Provider.of<ProcessProvider>(_context!, listen: false).getNewProcess();
        // ignore: use_build_context_synchronously
        Navigator.push(_context!,
          MaterialPageRoute(builder: (BuildContext context) => StreamerView(processId: process!.id!)));
      },
      child: Container(
        color: greyNavy,
        height: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.add, color: white, size: 28,),
            Text(
              " New Stream", 
              style: TextStyle(
                color: white,
                fontSize: 20,
              ),
            )
          ],
        ),
      ),
      
    );
  }
}

class ProcessListSection extends StatelessWidget {
  const ProcessListSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProcessProvider>(builder: (context, provider, widget) {
      return _processListView(provider.processList);
    });
  }

  _processListView(List<ProcessModel> processList) {
    return ListView.separated(
      itemBuilder: ((context, index) {
        int processId = processList[index].id!;
        return GestureDetector(
          onTap: () {
            Navigator.push(context,
              MaterialPageRoute(builder: (context) => StreamingView(processId: processId)));
          },
          child: Container(
            padding: const EdgeInsets.all(30),
            height: 90,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "스트림 ID: $processId",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Icon(Icons.arrow_forward_ios)
              ],
            ),
          ),
        );
      }),
      itemCount: processList.length,
      separatorBuilder: (context, index) => const Divider(),
    );
  }
}