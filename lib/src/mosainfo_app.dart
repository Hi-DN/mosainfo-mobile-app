import 'package:flutter/material.dart';
import 'package:mosainfo_mobile_app/src/view/home.dart';

class MosainfoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
          title: 'Mosainfo',
          theme: ThemeData(
            primarySwatch: Colors.indigo,
          ),
          home: const Home(),
        );
  }
}
