import 'package:flutter/material.dart';

class NoStreamingScreen extends StatelessWidget {
  const NoStreamingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: ((context, constraint) => 
          SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraint.maxHeight, minWidth: double.infinity),
              child: IntrinsicHeight(
                child: _noElementsNotice()
              ),
            ),
          )
      )
    );
  }

  Widget _noElementsNotice() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
        Text("진행중인 스트리밍이 없습니다:)")
    ]);
  }
}