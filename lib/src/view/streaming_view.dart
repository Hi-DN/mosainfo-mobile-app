import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:mosainfo_mobile_app/src/constants/colors.dart';
import 'package:mosainfo_mobile_app/src/view/text_style.dart';

class StreamingView extends StatefulWidget {
  const StreamingView({Key? key}) : super(key: key);

  static const routeName = 'streaming-view';

  @override
  State<StreamingView> createState() => _StreamingViewState();
}

class _StreamingViewState extends State<StreamingView> {
  final VlcPlayerController _vlcViewController = VlcPlayerController.network(
    "rtmp://52.79.237.154/live/test",
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