import 'package:flutter/material.dart';
import 'package:mosainfo_mobile_app/src/view/home.dart';
import 'package:mosainfo_mobile_app/src/view/streamer_view.dart';
import 'package:mosainfo_mobile_app/src/view/streaming_view.dart';

class MosainfoApp extends StatelessWidget {
  const MosainfoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mosainfo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const Home(),
      routes: {
        StreamerView.routeName: (context) => const StreamerView(),
        StreamingView.routeName: (context) => const StreamingView(),
      },
    );
  }
}
