import 'package:flutter/material.dart';
import 'package:mosainfo_mobile_app/src/constants/colors.dart';

class NewStreamingModal extends StatefulWidget {
  const NewStreamingModal({Key? key}) : super(key: key);

  @override
  State<NewStreamingModal> createState() => _NewStreamingModalState();
}

class _NewStreamingModalState extends State<NewStreamingModal> {

  FocusNode? _titleFNode;
  final int _categoryId = 0;
  String? _title;

  @override
  void initState() {
    super.initState();
    _titleFNode = FocusNode();
  }

  @override
  void dispose() {
    _titleFNode?.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 15, left: 26, right: 26),
      height: 420,
      child: Column(
        children: [
          const SizedBox(height: 30),
          TextFormField(
              focusNode: _titleFNode,
              onChanged: (value) {
                setState(() {
                  _title = value;
                });
              },
              decoration: const InputDecoration(
                hintText: "새로운 스트리밍의 제목을 입력해주세요",
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 0,
                  vertical: 10,
                ),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black12)),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: greyNavy)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _categorySelectSection() {
    return Wrap(
      children: [
        _categoryTile(1, "기본", "")
      ],
    );
  }

  Widget _categoryTile(int id, String name, String iconFile) {
    return GestureDetector(

    );
  }
}