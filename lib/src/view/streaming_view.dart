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

  bool isStarted = true;

  @override
  void initState() {
    _vlcViewController = VlcPlayerController.network(
      // "${HttpClient.rtmpUrl}/live-out/${widget.processId}",
      "rtmp://43.201.75.227/live/${widget.processId}",
      autoPlay: true,
      options: VlcPlayerOptions()
      // onInit:() { 
      //   setState(() {
      //     isStarted = true;
      //   });
      // }
    );

    super.initState();
  }

  _vlcInitListener() {
    setState(() {
          isStarted = true;
        });
  }

  @override
  void dispose() {
    _vlcViewController.dispose();
    super.dispose();
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
                child: Container(
                  color: white,
                  width: screenWidth, height: screenHeight,
                  child: _vlcViewController.value == VlcPlayerValue.uninitialized()
                  ? const Center(child: CircularProgressIndicator())
                  : VlcPlayer(
                    controller: _vlcViewController, 
                    aspectRatio: screenWidth / screenHeight,
                    placeholder: const Center(child: Text("Please Wait")))
                )
              )
            );    

    // return FutureBuilder<bool?>(
    //   future: _vlcViewController.isPlaying(),
    //   builder: (context, snapshot) {
    //     if(snapshot.hasData) {
    //       bool isPlaying = snapshot.data!;
    //       return Scaffold(
    //           appBar: AppBar(
    //             title: Text("Stream ID: ${widget.processId}", style: styleBGreyNavy),
    //             backgroundColor: white,
    //             leading: _arrowBackLeadingIcon()
    //           ),
    //           body: Center(
    //             child: Container(
    //               color: white,
    //               width: screenWidth, height: screenHeight,
    //               child: isPlaying
    //               ? VlcPlayer(
    //                 controller: _vlcViewController, 
    //                 aspectRatio: screenWidth / screenHeight,
    //                 placeholder: const Center(child: CircularProgressIndicator()))
    //               : const Center(child: CircularProgressIndicator())
    //             )
    //           )
    //         );    
    //     } else {
    //       return Scaffold(
    //           appBar: AppBar(
    //             title: Text("Stream ID: ${widget.processId}", style: styleBGreyNavy),
    //             backgroundColor: white,
    //             leading: _arrowBackLeadingIcon()
    //           ),
    //           body: const Center(
    //             child: Center(child: CircularProgressIndicator())
    //           )
    //         );    
    //     }
    //   },
    // );
    
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