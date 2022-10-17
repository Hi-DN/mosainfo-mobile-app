import 'dart:core';

import 'package:apivideo_live_stream/apivideo_live_stream.dart';
import './sample_rate.dart';

import 'channel.dart';
import 'resolution.dart';

List<int> fpsList = [24, 25, 30];
List<int> audioBitrateList = [32000, 64000, 128000, 192000];

String defaultValueTransformation(int e) {
  return "$e";
}

extension ListExtension on List<int> {
  Map<int, dynamic> toMap(
      {Function(int e) valueTransformation = defaultValueTransformation}) {
    var map = { for (var e in this) e : valueTransformation(e) };
    return map;
  }
}

String bitrateToPrettyString(int bitrate) {
  return "${bitrate / 1000} Kbps";
}

class Params {
  final VideoConfig video = VideoConfig.withDefaultBitrate();
  final AudioConfig audio = AudioConfig();

  String rtmpUrl = "rtmp://3.34.97.138/live";
  String streamKey = "test";

  String getResolutionToString() {
    return video.resolution.toPrettyString();
  }

  String getChannelToString() {
    return audio.channel.toPrettyString();
  }

  String getBitrateToString() {
    return bitrateToPrettyString(audio.bitrate);
  }

  String getSampleRateToString() {
    return audio.sampleRate.toPrettyString();
  }
}
