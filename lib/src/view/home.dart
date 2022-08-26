import 'package:flutter/material.dart';
import 'package:mosainfo_mobile_app/src/components/custom_appbar.dart';
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
              child: const Text(
                '스트림 하기',
              ),
              onPressed: () {
              },
            ),
            ElevatedButton(
              child: const Text(
                '방송 보기',
              ),
              onPressed: () {
                
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => const StreamingView()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
