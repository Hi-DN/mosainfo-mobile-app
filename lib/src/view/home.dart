import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mosainfo_mobile_app/src/api/streaming_model.dart';
import 'package:mosainfo_mobile_app/src/constants/colors.dart';
import 'package:mosainfo_mobile_app/src/provider/streaming_provider.dart';
import 'package:mosainfo_mobile_app/src/view/streaming_view.dart';
import 'package:mosainfo_mobile_app/utils/category_enum.dart';
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
    return Scaffold(
      appBar: const CustomAppBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: greyNavy,
        child: const Icon(Icons.add),
        onPressed: () async {
          _showNewStreamingModal();
        }
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(child: _streamingListSection())
        ],
      )
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

  Widget _streamingListSection() {
    return NotificationListener<ScrollNotification>(
      child: RefreshIndicator(
        displacement: 22,
        onRefresh: () async {
          Provider.of<StreamingProvider>(_context!, listen: false).fetchProcessList();
        },
        child: const ProcessListSection()));
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
        StreamingModel streaming = streamingList[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(context,
              MaterialPageRoute(builder: (context) => StreamingView(streaming: streaming)))
              .then((_) => Provider.of<StreamingProvider>(context, listen: false).fetchProcessList());
          },
          child: Container(
            padding: const EdgeInsets.only(left:18, top: 10, right: 18, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(color: greyNavy, width: 2.0),
                    ),
                  child: SvgPicture.asset(
                    StreamingCategory.getIconFileById(streaming.categoryId!),
                    height: 36, 
                    width: 36
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        streaming.title!,
                        softWrap: true,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text("${streaming.startTime!.replaceFirst('T', ' ')} ~")
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward_ios, size: 20)
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