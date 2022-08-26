import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

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
      appBar: AppBar(
        title: const Text('Enjoy Watching!', 
        style: TextStyle(color: Color(0xFF2F4858), fontWeight: FontWeight.w700)),
        backgroundColor: Colors.white,
        leading: Padding(
              padding: const EdgeInsets.only(left: 14),
              child: GestureDetector(
                  onTap: () {
                      Navigator.pop(context);
                  },
                  child: const Icon(Icons.arrow_back, color: Color(0xFF2F4858))),
        )
      ),
      body: Center(
        child: VlcPlayer(
          controller: _vlcViewController, 
          aspectRatio: 16/9, 
          placeholder: const Text("귀여운 칸초"),)
      )
    );
  }
}