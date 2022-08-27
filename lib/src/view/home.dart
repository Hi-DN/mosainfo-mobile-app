import 'package:flutter/material.dart';
import 'package:mosainfo_mobile_app/src/constants/colors.dart';
import 'package:mosainfo_mobile_app/widgets/common/custom_appbar.dart';
import 'package:mosainfo_mobile_app/src/view/streamer_view.dart';
import 'package:mosainfo_mobile_app/src/view/streaming_view.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(StreamerView.routeName);
              },
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(greyNavy)),
              child: const Text(
                '스트림 하기'
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(greyNavy)),
              onPressed: () {
                Navigator.of(context).pushNamed(StreamingView.routeName);
              },
              child: const Text(
                '방송 보기',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
