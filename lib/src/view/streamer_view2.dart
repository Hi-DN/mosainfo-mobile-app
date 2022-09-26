// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:apivideo_live_stream/apivideo_live_stream.dart';
import 'package:flutter/services.dart';
import 'package:mosainfo_mobile_app/src/constants/colors.dart';
import 'package:mosainfo_mobile_app/src/types/params.dart';
import 'package:mosainfo_mobile_app/src/view/streamer_settings_view.dart';
import 'package:mosainfo_mobile_app/src/view/text_style.dart';
import 'package:mosainfo_mobile_app/utils/dialog.dart';

class StreamerView2 extends StatefulWidget {
  const StreamerView2({Key? key}) : super(key: key);

  static const routeName = 'streamer-view2';

  @override
  State<StreamerView2> createState() => _StreamerView2State();
}

class _StreamerView2State extends State<StreamerView2> with WidgetsBindingObserver{
  Params config = Params();
  late final LiveStreamController _controller;
  late final Future<int> textureId;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    _controller = initLiveStreamController();
    textureId = _controller.create(
        initialAudioConfig: config.audio, initialVideoConfig: config.video);
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
    return Scaffold(
      key:_scaffoldKey,
      appBar: AppBar(
        title: Text('Enjoy Streaming!', style: styleBGreyNavy),
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
                  Navigator.pop(context);
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
                    ? onStopStreamingButtonPressed
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
          streamKey: config.streamKey, url: config.rtmpUrl);
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
        setState(() {});
      }
    });
  }

  void onStopStreamingButtonPressed() {
    stopStreaming().then((_) {
      if (mounted) {
        setState(() {});
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
  }
  