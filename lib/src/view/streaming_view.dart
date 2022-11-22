import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:mosainfo_mobile_app/src/api/http_client.dart';
import 'package:mosainfo_mobile_app/src/api/streaming_model.dart';
import 'package:mosainfo_mobile_app/src/constants/colors.dart';
import 'package:mosainfo_mobile_app/src/provider/streaming_provider.dart';
import 'package:mosainfo_mobile_app/widgets/common/text_style.dart';
import 'package:mosainfo_mobile_app/utils/category_enum.dart';
import 'package:mosainfo_mobile_app/widgets/common/custom_appbar.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class StreamingView extends StatefulWidget {
  const StreamingView({Key? key, required this.streaming}) : super(key: key);

  final StreamingModel streaming;

  @override
  State<StreamingView> createState() => _StreamingViewState();
}

class _StreamingViewState extends State<StreamingView> {
  late VideoPlayerController _controller;
  late final VlcPlayerController _vlcPlayerController;
  late BuildContext? _context;
  late StreamingModel streaming;

  late final bool _isVideo;

  bool _isLoading = true;
  final bool _isTimerOn = true;
  bool _isWarningDialogOpen = false;
  Timer? timer;

  bool _isStreamingInfoOn = true;

  @override
  void initState() {
    _isVideo = widget.streaming.id == 0;
    streaming = widget.streaming;

    if(_isVideo) {
      _controller = VideoPlayerController.asset(
        'assets/images/plate480.mp4'
      )..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
          _controller.play();
          _controller.setLooping(true);
        });
      });
    } else {
      _vlcPlayerController =  VlcPlayerController.network(
        "${HttpClient.rtmpUrl}/live-out/${widget.streaming.id}",
        autoPlay: true
      );
      timer = Timer.periodic(const Duration(seconds: 10), (Timer t) => _checkLoading());
    }

    super.initState();
  }

  void _checkLoading() async {
    if(!_isLoading) {
      debugPrint("isLoading false so stop timer()");
      // timer!.cancel(); // 화면 멈춤 오류
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
      });

      
    } 

    if(_vlcPlayerController.value.isInitialized) {
      bool? isStillPlaying = await Provider.of<StreamingProvider>(context, listen: false).checkStreaming(streaming.id!);
      if(!_isWarningDialogOpen && !isStillPlaying!) {
        debugPrint("isEnded");
        _isWarningDialogOpen = true;
        _showWarningDialog();
      }
    }
  }

  _showWarningDialog() {
    return showDialog(
      barrierDismissible: false,
      context: _context!,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const R14Text(text: "스트리밍이 종료되었습니다."),
          actions: <Widget>[
            TextButton(
              onPressed: () { 
                Provider.of<StreamingProvider>(context, listen: false).fetchStreamingList();
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
    if(_isTimerOn) timer?.cancel();
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
      appBar: CustomAppBar(
        leadingYn: true,
        onTap: () => Navigator.of(context).pop(),
        actions: [_appbarInfoIcon()],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: Container(
              color: white,
              width: screenWidth, height: screenHeight,
              child: _isVideo
              ? _controller.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                  : Container()
              : VlcPlayer(
                controller: _vlcPlayerController, 
                aspectRatio: screenWidth / (screenHeight - kToolbarHeight),
                placeholder: const Center(child: CircularProgressIndicator()))
            )
          ),
          _isStreamingInfoOn
          ? Container(
            alignment: Alignment.bottomCenter,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [black.withOpacity(0.5), black.withOpacity(0.1), black.withOpacity(0)],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter
              )
            ),
            child: _streamingInfo()
          )
          : Container(),
          _isLoading 
                  ? const Center(child: CircularProgressIndicator())
                  : Container()
        ],
      )
    );
  }

  _appbarInfoIcon() {
    return GestureDetector(
      onTap: () {
        setState(() {
           _isStreamingInfoOn = !_isStreamingInfoOn;
        });
      },
      child: const Padding(
        padding: EdgeInsets.all(15),
        child: Icon(Icons.info_rounded, color: white, size: 20),
      ),
    );
  }

  Widget _streamingInfo() {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 25),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: greyNavy, width: 2.0),
            ),
          child: SvgPicture.asset(
            StreamingCategory.getIconFileById(streaming.categoryId!),
            height: 20, width: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, 
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                streaming.title!,
                softWrap: true,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: white
                ),
              ),
              const SizedBox(height: 10),
              Text("${streaming.startTime!.replaceFirst('T', ' ')} ~", style: const TextStyle(color: white),)
            ],
          ),
        ),
        const SizedBox(width: 20),
        GestureDetector(
          onTap: () {
            setState(() {
              _isStreamingInfoOn = false;
            });
          },
          child: const Icon(Icons.keyboard_arrow_down, size: 24, color: white),
        )
      ]),
    );
  }
}