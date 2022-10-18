import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:mosainfo_mobile_app/src/api/http_client.dart';
import 'package:mosainfo_mobile_app/src/constants/colors.dart';
import 'package:mosainfo_mobile_app/src/view/text_style.dart';

class StreamingView extends StatefulWidget {
  const StreamingView({Key? key, required this.processId}) : super(key: key);

  final int processId;

  @override
  State<StreamingView> createState() => _StreamingViewState();
}

class _StreamingViewState extends State<StreamingView> {
  late final VlcPlayerController _vlcPlayerController;
  late BuildContext? _context;

  bool _isLoading = true;
  Timer? timer;

  @override
  void initState() {
    _vlcPlayerController = VlcPlayerController.network(
      "${HttpClient.rtmpUrl}/live-out/${widget.processId}",
      autoPlay: true
    );

    timer = Timer.periodic(const Duration(seconds: 3), (Timer t) => _checkLoading());

    super.initState();
  }

  void _checkLoading() async {
    if(!_isLoading) {
      debugPrint("isLoading false so stop timer()");
      // timer!.cancel();
    }

    debugPrint("_checkLoading()");
    if(_vlcPlayerController.value.isInitialized){
      debugPrint("isInitialized");
      _vlcPlayerController.play();

      bool? isPlaying = await _vlcPlayerController.isPlaying();
      debugPrint("isPlaying? $isPlaying");

      setState(() {
        debugPrint("isLoading false");
        if(isPlaying!) _isLoading = false;  
        // timer?.cancel();
      });
    }
  }

  _showWarningDialog() {
    return showDialog(
      context: _context!,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const R14Text(text: "스트리밍이 종료되었습니다."),
          actions: <Widget>[
            TextButton(
              onPressed: () { 
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const R14Text(text: "확인"),
            ),
          ],
        );
      }
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    _vlcPlayerController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    _context = context;

    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: (() async { 
            // debugPrint(_vlcPlayerController.value.isInitialized.toString());
            bool? isPlaying = await _vlcPlayerController.isPlaying();
            debugPrint(isPlaying.toString());
          }),
          child: Text("Stream ID: ${widget.processId}", style: styleBGreyNavy)),
        backgroundColor: white,
        leading: _arrowBackLeadingIcon()
      ),
      body: Center(
        child: Container(
          color: white,
          width: screenWidth, height: screenHeight,
          child: Stack(
            fit: StackFit.passthrough,
            children: [
              VlcPlayer(
                controller: _vlcPlayerController, 
                aspectRatio: screenWidth / screenHeight,
                placeholder: const Center(child: Text("Please Wait"))),
              _isLoading 
              ? const Center(child: CircularProgressIndicator())
              : Container()
            ],
          )
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