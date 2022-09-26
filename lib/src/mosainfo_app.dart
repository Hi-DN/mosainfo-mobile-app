import 'package:flutter/material.dart';
import 'package:mosainfo_mobile_app/src/view/home.dart';
import 'package:mosainfo_mobile_app/src/view/streamer_view.dart';
import 'package:mosainfo_mobile_app/src/view/streamer_view2.dart';
import 'package:mosainfo_mobile_app/src/view/streaming_view.dart';
import 'package:mosainfo_mobile_app/src/view/streaming_view2.dart';

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
        StreamerView2.routeName: (context) => const StreamerView2(),
        StreamingView.routeName: (context) => const StreamingView(),
        StreamingView2.routeName: (context) => const StreamingView2(),
      },
    );
  }
}
