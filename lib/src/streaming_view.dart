import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:mosainfo_mobile_app/src/custom_appbar.dart';

class StreamingView extends StatefulWidget {
  const StreamingView({Key? key}) : super(key: key);

  @override
  State<StreamingView> createState() => _StreamingViewState();
}

class _StreamingViewState extends State<StreamingView> {
  final VlcPlayerController _vlcViewController = VlcPlayerController.network(
    "rtsp://192.168.25.53",
    autoPlay: true,
  );

  @override
  void initState() {
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(leadingYn: true),
      body: Center(
        child: VlcPlayer(
          controller: _vlcViewController, 
          aspectRatio: 16/9, 
          placeholder: const Text("귀여운 칸초"),)
      )
    );
  }
}