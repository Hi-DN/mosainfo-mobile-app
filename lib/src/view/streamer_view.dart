// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:apivideo_live_stream/apivideo_live_stream.dart';
import 'package:flutter/services.dart';
import 'package:mosainfo_mobile_app/src/api/http_client.dart';
import 'package:mosainfo_mobile_app/src/constants/colors.dart';
import 'package:mosainfo_mobile_app/src/provider/process_provider.dart';
import 'package:mosainfo_mobile_app/src/types/params.dart';
import 'package:mosainfo_mobile_app/src/view/streamer_settings_view.dart';
import 'package:mosainfo_mobile_app/src/view/text_style.dart';
import 'package:mosainfo_mobile_app/utils/dialog.dart';
import 'package:provider/provider.dart';

class StreamerView extends StatefulWidget {
  const StreamerView({Key? key, required this.processId}) : super(key: key);
  final int processId;

  @override
  State<StreamerView> createState() => _StreamerViewState();
}

class _StreamerViewState extends State<StreamerView> with WidgetsBindingObserver{
  Params config = Params();
  late final LiveStreamController _controller;
  late final Future<int> textureId;
  late BuildContext? _context;

  String rtmpUrl = "${HttpClient.rtmpUrl}/live";
  late final int processId;
  late final String streamKey;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    _controller = initLiveStreamController();
    textureId = _controller.create(
        initialAudioConfig: config.audio, initialVideoConfig: config.video);
    processId = widget.processId;
    streamKey = widget.processId.toString();
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
      appBar: AppBar(
        title: Text("Stream ID: $streamKey", style: styleBGreyNavy),
        backgroundColor: white,
        leading: _arrowBackLeadingIcon(),
        actions: [_settingsActionIcon()],
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: Center(
                  child: buildPreview(controller: _controller),
                ),
              ),
            ),
            _controlRowWidget()
          ],
        )
      )
    );
  }

  Widget _arrowBackLeadingIcon() {
    return Padding(
          padding: const EdgeInsets.only(left: 14),
          child: GestureDetector(
              onTap: () {
                _showEndingConfirmDialog();
              },
              child: const Icon(Icons.arrow_back, color: greyNavy)),
    );
  }

  Widget _settingsActionIcon() {
    return GestureDetector(
            onTap: () {_awaitResultFromSettingsFinal(context);},
            child: const Padding(
              padding: EdgeInsets.only(right: 15),
              child: Icon(Icons.settings, color: greyNavy),
            )
          );
  }

  void _awaitResultFromSettingsFinal(BuildContext context) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => StreamerSettingsView(params: config)));
    _controller.setVideoConfig(config.video);
    _controller.setAudioConfig(config.audio);
  }

  /// Display the control bar with buttons to take pictures and record videos.
  Widget _controlRowWidget() {
    final LiveStreamController liveStreamController = _controller;

    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.cameraswitch),
            color: black,
            onPressed:
                liveStreamController != null ? onSwitchCameraButtonPressed : null,
          ),
          IconButton(
            icon: const Icon(Icons.mic_off),
            color: black,
            onPressed: liveStreamController != null
                ? onToggleMicrophoneButtonPressed
                : null,
          ),
          IconButton(
            icon: const Icon(Icons.fiber_manual_record),
            color: black,
            onPressed:
                !liveStreamController.isStreaming
                    ? onStartStreamingButtonPressed
                    : null,
          ),
          IconButton(
            icon: const Icon(Icons.stop),
            color: black,
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
          Provider.of<ProcessProvider>(_context!, listen: false).startMosaic(processId);
        });
      }
    });
  }

  void onStopStreamingButtonPressed() {
    stopStreaming().then((_) {
      if (mounted) {
        setState(() {
          Provider.of<ProcessProvider>(_context!, listen: false).releaseProcess(processId);
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
    _scaffoldKey.currentState?.showSnackBar(SnackBar(content: Text(message)));
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
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const R14Text(text: "네, 종료할게요!", textColor: Colors.blue),
            ),
          ],
        );
      }
    );
  }
}
  