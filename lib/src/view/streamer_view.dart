// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:apivideo_live_stream/apivideo_live_stream.dart';
import 'package:flutter/services.dart';
import 'package:mosainfo_mobile_app/src/types/params.dart';
import 'package:mosainfo_mobile_app/src/view/streamer_settings_view.dart';

class StreamerView extends StatefulWidget {
  const StreamerView({Key? key}) : super(key: key);

  @override
  State<StreamerView> createState() => _StreamerViewState();
}

class _StreamerViewState extends State<StreamerView> with WidgetsBindingObserver{
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
      _showDialog(context, 'Connection failed', error);
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
        title: const Text('Mosainfo', 
        style: TextStyle(color: Color(0xFF2F4858), fontWeight: FontWeight.w700)),
        backgroundColor: Colors.white,
        leading: Padding(
              padding: const EdgeInsets.only(left: 14),
              child: GestureDetector(
                  onTap: () {
                      Navigator.pop(context);
                  },
                  child: const Icon(Icons.arrow_back, color: Color(0xFF2F4858))),
        ),
        actions: [
          GestureDetector(
            onTap: () {_awaitResultFromSettingsFinal(context);},
            child: const Padding(
              padding: EdgeInsets.only(right: 15),
              child: Icon(Icons.settings, color: Color(0xFF2F4858)),
            )
          )
        ],
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

  void _awaitResultFromSettingsFinal(BuildContext context) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SettingsScreen(params: config)));
    _controller.setVideoConfig(config.video);
    _controller.setAudioConfig(config.audio);
  }

  /// Display the control bar with buttons to take pictures and record videos.
  Widget _controlRowWidget() {
    final LiveStreamController liveStreamController = _controller;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.cameraswitch),
          color: Colors.black,
          onPressed:
              liveStreamController != null ? onSwitchCameraButtonPressed : null,
        ),
        IconButton(
          icon: const Icon(Icons.mic_off),
          color: Colors.black,
          onPressed: liveStreamController != null
              ? onToggleMicrophoneButtonPressed
              : null,
        ),
        IconButton(
          icon: const Icon(Icons.fiber_manual_record),
          color: Colors.black,
          onPressed:
              !liveStreamController.isStreaming
                  ? onStartStreamingButtonPressed
                  : null,
        ),
        IconButton(
          icon: const Icon(Icons.stop),
          color: Colors.black,
          onPressed:
              liveStreamController.isStreaming
                  ? onStopStreamingButtonPressed
                  : null,
        ),
      ],
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
        _showDialog(
            context, "Error", "Failed to switch camera: ${error.message}");
      } else {
        _showDialog(context, "Error", "Failed to switch camera: $error");
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
        _showDialog(
            context, "Error", "Failed to toggle mute: ${error.message}");
      } else {
        _showDialog(context, "Error", "Failed to toggle mute: $error");
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
        print("Error: failed to start stream: ${error.message}");
      } else {
        print("Error: failed to start stream: $error");
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
        _showDialog(
            context, "Error", "Failed to stop stream: ${error.message}");
      } else {
        _showDialog(context, "Error", "Failed to stop stream: $error");
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

Future<void> _showDialog(
    BuildContext context, String title, String description) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Text(description),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Dismiss'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}