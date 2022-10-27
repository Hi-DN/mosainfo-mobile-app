// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:apivideo_live_stream/apivideo_live_stream.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mosainfo_mobile_app/src/api/http_client.dart';
import 'package:mosainfo_mobile_app/src/api/streaming_model.dart';
import 'package:mosainfo_mobile_app/src/constants/colors.dart';
import 'package:mosainfo_mobile_app/src/provider/streaming_provider.dart';
import 'package:mosainfo_mobile_app/src/types/params.dart';
import 'package:mosainfo_mobile_app/src/view/text_style.dart';
import 'package:mosainfo_mobile_app/utils/category_enum.dart';
import 'package:mosainfo_mobile_app/utils/dialog.dart';
import 'package:mosainfo_mobile_app/widgets/common/custom_appbar.dart';
import 'package:provider/provider.dart';

class StreamerView extends StatefulWidget {
  const StreamerView({Key? key, required this.streaming}) : super(key: key);
  final StreamingModel streaming;

  @override
  State<StreamerView> createState() => _StreamerViewState();
}

class _StreamerViewState extends State<StreamerView> with WidgetsBindingObserver{
  Params config = Params();
  late final LiveStreamController _controller;
  late final Future<int> textureId;
  late BuildContext? _context;

  String rtmpUrl = "${HttpClient.rtmpUrl}/live";
  late final int streamingId;
  late final String streamKey;

  late StreamingModel streaming;

  bool _isStreamingInfoOn = true;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    _controller = initLiveStreamController();
    textureId = _controller.create(
        initialAudioConfig: config.audio, initialVideoConfig: config.video);
    streaming = widget.streaming;
    streamingId = widget.streaming.id!;
    streamKey = widget.streaming.id!.toString();
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      _controller.stop();
    } else if (state == AppLifecycleState.resumed) {
      _controller.startPreview();
    }
  }

  LiveStreamController initLiveStreamController() {
    return LiveStreamController(onConnectionSuccess: () {
      debugPrint('Connection succedded');
    }, onConnectionFailed: (error) {
      debugPrint('Connection failed: $error');
      showCustomDialog(context, 'Connection failed', error);
      if (mounted) {
        setState(() {});
      }
    }, onDisconnection: () {
      showInSnackBar('Disconnected');
      if (mounted) {
        setState(() {});
      }
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      key:_scaffoldKey,
      appBar: CustomAppBar(
        leadingYn: true,
        onTap: _showEndingConfirmDialog,
        actions: [_appbarInfoIcon()],
      ),
      body: Center(
        child: Stack(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: Center(
                  child: buildPreview(controller: _controller),
                ),
              ),
            ),
            _isStreamingInfoOn
            ? Container(
              // height: double.infinity,
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
            : Container()
          ],
        )
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
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
        ),
        Container(height: 2, color: white,),
        _controlRowWidget()
      ],
    );
  }

  /// Display the control bar with buttons to take pictures and record videos.
  Widget _controlRowWidget() {
    final LiveStreamController liveStreamController = _controller;

    return Container(
      padding: const EdgeInsets.only(top: 15, bottom: 10, left: 15, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.cameraswitch),
            color: white,
            disabledColor: white.withOpacity(0.5),
            onPressed:
                liveStreamController != null ? onSwitchCameraButtonPressed : null,
          ),
          IconButton(
            icon: const Icon(Icons.mic_off),
            color: white,
            disabledColor: white.withOpacity(0.5),
            onPressed: liveStreamController != null
                ? onToggleMicrophoneButtonPressed
                : null,
          ),
          IconButton(
            icon: const Icon(Icons.play_arrow_rounded),
            color: white,
            disabledColor: white.withOpacity(0.5),
            onPressed:
                !liveStreamController.isStreaming
                    ? onStartStreamingButtonPressed
                    : null,
          ),
          IconButton(
            icon: const Icon(Icons.stop),
            color: white,
            disabledColor: white.withOpacity(0.5),
            onPressed:
                liveStreamController.isStreaming
                    ? _showEndingConfirmDialog
                    : null,
          ),
        ],
      ),
    );
  }

  Future<void> switchCamera() async {
    final LiveStreamController liveStreamController = _controller;

    if (liveStreamController == null) {
      showInSnackBar('Error: create a camera controller first.');
      return;
    }

    try {
      liveStreamController.switchCamera();
    } catch (error) {
      if (error is PlatformException) {
        showCustomDialog(
            context, "Error", "Failed to switch camera: ${error.message}");
      } else {
        showCustomDialog(context, "Error", "Failed to switch camera: $error");
      }
    }
  }

  Future<void> toggleMicrophone() async {
    final LiveStreamController liveStreamController = _controller;

    if (liveStreamController == null) {
      showInSnackBar('Error: create a camera controller first.');
      return;
    }

    try {
      liveStreamController.toggleMute();
    } catch (error) {
      if (error is PlatformException) {
        showCustomDialog(
            context, "Error", "Failed to toggle mute: ${error.message}");
      } else {
        showCustomDialog(context, "Error", "Failed to toggle mute: $error");
      }
    }
  }

  Future<void> startStreaming() async {
    final LiveStreamController liveStreamController = _controller;

    if (liveStreamController == null) {
      showInSnackBar('Error: create a camera controller first.');
      return;
    }

    try {
      await liveStreamController.startStreaming(
        streamKey: streamKey, url: rtmpUrl
      );
    } catch (error) {
      if (error is PlatformException) {
        debugPrint("Error: failed to start stream: ${error.message}");
      } else {
        debugPrint("Error: failed to start stream: $error");
      }
    }
  }

  Future<void> stopStreaming() async {
    final LiveStreamController liveStreamController = _controller;

    if (liveStreamController == null) {
      showInSnackBar('Error: create a camera controller first.');
      return;
    }

    try {
      liveStreamController.stopStreaming();
    } catch (error) {
      if (error is PlatformException) {
        showCustomDialog(
            context, "Error", "Failed to stop stream: ${error.message}");
      } else {
        showCustomDialog(context, "Error", "Failed to stop stream: $error");
      }
    }
  }

  void onSwitchCameraButtonPressed() {
    switchCamera().then((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  void onToggleMicrophoneButtonPressed() {
    toggleMicrophone().then((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  void onStartStreamingButtonPressed() {
    startStreaming().then((_) {
      if (mounted) {
        setState(() {
          Provider.of<StreamingProvider>(_context!, listen: false).startMosaic(streamingId);
        });
      }
    });
  }

  void onStopStreamingButtonPressed() {
    stopStreaming().then((_) async {
      if (mounted) {
        bool? result = await Provider.of<StreamingProvider>(_context!, listen: false).releaseProcess(streamingId);
        debugPrint(result!.toString());
        if(result) {
          Provider.of<StreamingProvider>(context, listen: false).fetchProcessList();
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        } 
        setState(() {
          // if(result) Provider.of<StreamingProvider>(context, listen: false).fetchProcessList();
        });
      }
    });
  }

  Widget buildPreview({required LiveStreamController controller}) {
    // Wait for [LiveStreamController.create] to finish.
    return FutureBuilder<int>(
        future: textureId,
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          if (!snapshot.hasData) {
            // while data is loading:
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return CameraPreview(controller: controller);
          }
        });
  }

  void showInSnackBar(String message) {
    // ignore: deprecated_member_use
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  _showEndingConfirmDialog() {
    return showDialog(
      context: _context!,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const R14Text(text: "스트리밍을 종료하시겠습니까?"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const R14Text(text: "아니요", textColor: Colors.black12),
            ),
            TextButton(
              onPressed: () { 
                onStopStreamingButtonPressed();
              },
              child: const R14Text(text: "네, 종료할게요!", textColor: Colors.blue),
            ),
          ],
        );
      }
    );
  }
}
  