import 'package:flutter/material.dart';
import 'package:mosainfo_mobile_app/src/components/custom_appbar.dart';
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
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) => const StreamerView()));
              },
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF2F4858))),
              child: const Text(
                '스트림 하기'
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF2F4858))),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) => const StreamingView()));
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
