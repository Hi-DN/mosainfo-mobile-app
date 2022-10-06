import 'package:flutter/material.dart';
import 'package:mosainfo_mobile_app/src/provider/process_provider.dart';
import 'package:mosainfo_mobile_app/src/view/home.dart';
import 'package:provider/provider.dart';

class MosainfoApp extends StatelessWidget {
  const MosainfoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ProcessProvider()),
        ],
        child: MaterialApp(
          title: 'Mosainfo',
          theme: ThemeData(
            primarySwatch: Colors.indigo,
          ),
          home: Home(),
        )
      );
  }
}
