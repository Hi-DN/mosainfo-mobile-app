import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:mosainfo_mobile_app/src/constants/colors.dart';
import 'package:mosainfo_mobile_app/src/view/text_style.dart';

class StreamingView2 extends StatefulWidget {
  const StreamingView2({Key? key}) : super(key: key);

  static const routeName = 'streaming-view2';

  @override
  State<StreamingView2> createState() => _StreamingView2State();
}

class _StreamingView2State extends State<StreamingView2> {
  final VlcPlayerController _vlcViewController = VlcPlayerController.network(
    "rtmp://43.201.8.14/live-out",
    autoPlay: true,
  );

  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Enjoy Watching!', style: styleBGreyNavy),
        backgroundColor: white,
        leading: _arrowBackLeadingIcon()
      ),
      body: Center(
        child: SizedBox(
          width: screenWidth, height: screenHeight,
          child: VlcPlayer(
            controller: _vlcViewController, 
            aspectRatio: screenWidth / screenHeight,
            placeholder: const Text("Please Wait:)"),),
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