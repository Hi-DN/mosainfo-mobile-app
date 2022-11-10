import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mosainfo_mobile_app/src/mosainfo_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: ((context) => const MosainfoApp())
    ));
}
