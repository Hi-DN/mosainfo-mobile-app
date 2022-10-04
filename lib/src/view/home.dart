import 'package:flutter/material.dart';
import 'package:mosainfo_mobile_app/src/api/process_model.dart';
import 'package:mosainfo_mobile_app/src/constants/colors.dart';
import 'package:mosainfo_mobile_app/src/provider/process_provider.dart';
import 'package:mosainfo_mobile_app/src/view/streamer_view.dart';
import 'package:mosainfo_mobile_app/widgets/common/custom_appbar.dart';
import 'package:provider/provider.dart';


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
          const SizedBox(height: 30),
          // const Expanded(child: ProcessListSection())
          Expanded(child: _scrollNotificationWidget())
        ],
      )
    );
  }

  Widget _scrollNotificationWidget() {
    
    return NotificationListener<ScrollNotification>(
        onNotification: _scrollNotification,
        child: RefreshIndicator(
            
            displacement: 22,
            onRefresh: () async {
              Provider.of<ProcessProvider>(_context!, listen: false).fetchProcessList();
            },
            child: const ProcessListSection()));
  }

  bool _scrollNotification(ScrollNotification scrollInfo) {
    if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
      Provider.of<ProcessProvider>(_context!, listen: false).fetchProcessList();
    }
    return true;
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
      // if (provider.processList.isNotEmpty) {
      //   return _processListView(provider.processList);
      // }
      // return const Center(child: CircularProgressIndicator());
    });
  }

  _processListView(List<ProcessModel> processList) {
    return ListView.separated(
      itemBuilder: ((context, index) {
        return ListTile(
          title: SizedBox(
            height: 90,
            child: Text(processList[index].id.toString())),
        );
      }),
      itemCount: processList.length,
      separatorBuilder: (context, index) => const Divider(),
    );
  }
}