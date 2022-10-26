import 'package:flutter/material.dart';
import 'package:mosainfo_mobile_app/src/api/streaming_model.dart';
import 'package:mosainfo_mobile_app/src/constants/colors.dart';
import 'package:mosainfo_mobile_app/src/provider/process_provider.dart';
import 'package:mosainfo_mobile_app/src/view/streaming_view.dart';
import 'package:mosainfo_mobile_app/widgets/common/custom_appbar.dart';
import 'package:provider/provider.dart';

import 'new_streaming_modal.dart';


// ignore: must_be_immutable
class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  late BuildContext? _context;

  @override
  Widget build(BuildContext context) {
    _context = context;
    Provider.of<StreamingProvider>(context, listen: false).fetchProcessList();
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: const CustomAppBar(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: FloatingActionButton(
          backgroundColor: greyNavy,
          child: const Icon(Icons.add),
          onPressed: () async {
            _showNewStreamingModal();
            // StreamingModel? process = await Provider.of<StreamingProvider>(_context!, listen: false).createStreaming();
          // ignore: use_build_context_synchronously
          // Navigator.push(_context!,
          //   MaterialPageRoute(builder: (BuildContext context) => StreamerView(processId: process!.id!)));
          }
        ),
        body: Column(
          children: [
            _newProcessBtn(),
            const SizedBox(height: 20),
            Expanded(child: _scrollNotificationWidget())
          ],
        )
      ),
    );
  }

  _showNewStreamingModal() {
    final viewModel = Provider.of<StreamingProvider>(_context!, listen: false);
    
    showModalBottomSheet(
      context: _context!,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30), 
          topRight: Radius.circular(30)),
      ),
      builder: (context) {
        return ChangeNotifierProvider.value(value: viewModel, child: const NewStreamingModal());
      }
    );
  }

  Widget _scrollNotificationWidget() {
    
    return NotificationListener<ScrollNotification>(
        child: RefreshIndicator(
            
            displacement: 22,
            onRefresh: () async {
              Provider.of<StreamingProvider>(_context!, listen: false).fetchProcessList();
            },
            child: const ProcessListSection()));
  }

  Widget _newProcessBtn() {
    return GestureDetector(
      onTap: () async {
        // StreamingModel? process = await Provider.of<StreamingProvider>(_context!, listen: false).getNewProcess();
        // ignore: use_build_context_synchronously
        // Navigator.push(_context!,
        //   MaterialPageRoute(builder: (BuildContext context) => StreamerView(processId: process!.id!)));
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
    return Consumer<StreamingProvider>(builder: (context, provider, widget) {
      return _processListView(provider.streamingList);
    });
  }

  _processListView(List<StreamingModel> streamingList) {
    return ListView.separated(
      itemBuilder: ((context, index) {
        int streamingId = streamingList[index].id!;
        return GestureDetector(
          onTap: () {
            Navigator.push(context,
              MaterialPageRoute(builder: (context) => StreamingView(processId: streamingId)))
              .then((_) => Provider.of<StreamingProvider>(context, listen: false).fetchProcessList());
          },
          child: Container(
            padding: const EdgeInsets.all(30),
            height: 90,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "스트림 ID: $streamingId",
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
      itemCount: streamingList.length,
      separatorBuilder: (context, index) => const Divider(),
    );
  }
}