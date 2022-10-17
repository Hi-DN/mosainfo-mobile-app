import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:mosainfo_mobile_app/src/constants/colors.dart';
import 'package:mosainfo_mobile_app/src/view/text_style.dart';

class StreamingView extends StatefulWidget {
  const StreamingView({Key? key, required this.processId}) : super(key: key);

  final int processId;

  @override
  State<StreamingView> createState() => _StreamingViewState();
}

class _StreamingViewState extends State<StreamingView> {
  late VlcPlayerController _vlcViewController;

  @override
  void initState() {
    _vlcViewController = VlcPlayerController.network(
      "rtmp://54.180.150.130/live-out/${widget.processId}",
      autoPlay: true,
    );
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    return Scaffold(
      appBar: AppBar(
        title: Text("Stream ID: ${widget.processId}", style: styleBGreyNavy),
        backgroundColor: white,
        leading: _arrowBackLeadingIcon()
      ),
      body: Center(
        child: SizedBox(
          width: screenWidth, height: screenHeight,
          child: VlcPlayer(
            controller: _vlcViewController, 
            aspectRatio: screenWidth / screenHeight,
            placeholder: Container(
              width: 200,
              height: 200,
              color: Colors.red,
              child: const Text("Please Wait:)")),),
        )
      )
    );
  }

  Widget _arrowBackLeadingIcon() {
    return Padding(
          padding: const EdgeInsets.only(left: 14),
          child: GestureDetector(
              onTap: () {
                  Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back, color: greyNavy)),
    );
  }
}