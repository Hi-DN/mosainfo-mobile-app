import 'package:flutter/material.dart';
import 'package:mosainfo_mobile_app/src/home.dart';

class MosainfoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
          title: 'Navada',
          theme: ThemeData(
            primarySwatch: Colors.green,
          ),
          home: const Home(),
        );
  }
}
