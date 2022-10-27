import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mosainfo_mobile_app/src/api/streaming_model.dart';
import 'package:mosainfo_mobile_app/src/constants/colors.dart';
import 'package:mosainfo_mobile_app/src/provider/process_provider.dart';
import 'package:mosainfo_mobile_app/src/view/streamer_view.dart';
import 'package:provider/provider.dart';

class NewStreamingModal extends StatefulWidget {
  const NewStreamingModal({Key? key}) : super(key: key);

  @override
  State<NewStreamingModal> createState() => _NewStreamingModalState();
}

class _NewStreamingModalState extends State<NewStreamingModal> {

  FocusNode? _titleFNode;
  int _selectedCategoryId = 0;
  String? _title;
  bool _isTitleValid = true;

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
    return GestureDetector(
      onTap: () {
        _titleFNode!.unfocus();
      },
      child: Container(
        padding: const EdgeInsets.only(top: 5, left: 26, right: 26),
        height: 520,
        child: Column(
          children: [
            _greyStick(),
            const SizedBox(height: 25),
            _titleTextField(),
            const SizedBox(height: 20),
            _categorySelectSection(),
            const SizedBox(height: 30),
            _confirmBtn()
          ],
        ),
      ),
    );
  }

   Widget _greyStick() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(height: 3, width: 40,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(10)))
      ]),
    );
  }

  Widget _titleTextField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        focusNode: _titleFNode,
        onChanged: (value) {
          setState(() {
            _title = value;
            _isTitleValid = true;
          });
        },
        decoration: InputDecoration(
          hintText: "새로운 스트리밍의 제목을 입력해주세요",
          hintStyle: TextStyle(color: _isTitleValid ? Colors.black54 : const Color.fromARGB(255, 181, 29, 18)),
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 0,
            vertical: 10,
          ),
          enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black12)),
          focusedBorder: _isTitleValid 
            ? const UnderlineInputBorder(
              borderSide: BorderSide(color: greyNavy))
            : const UnderlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 181, 29, 18))),
        ),
      ),
    );
  }

  Widget _categorySelectSection() {
    return Wrap(
      runSpacing: 10,
      children: [
        _categoryTile(0, "기본", "assets/images/video-player.svg"),
        _categoryTile(1, "먹방", "assets/images/drink-tea.svg"),
        _categoryTile(2, "일상", "assets/images/rock-on.svg"),
        _categoryTile(3, "여행", "assets/images/air-balloon.svg"),
        _categoryTile(4, "영화", "assets/images/video-camera.svg"),
        _categoryTile(5, "음악", "assets/images/cd-music.svg"),
        _categoryTile(6, "술방", "assets/images/drink-cocktail.svg"),
        _categoryTile(7, "언박싱", "assets/images/diamond.svg"),
        _categoryTile(8, "공부", "assets/images/ipad.svg"),
        _categoryTile(9, "쇼핑", "assets/images/shopping-cart.svg"),
        _categoryTile(10, "기타", "assets/images/comment.svg"),
      ],
    );
  }

  Widget _categoryTile(int id, String name, String iconFile) {
    bool isSelected = _selectedCategoryId == id;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategoryId = id;  
        });
      },
      child: Container(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: isSelected ? greyNavy : Colors.black26, width: 2.0),
                color: isSelected ? const Color.fromARGB(147, 127, 137, 170) : Colors.white
              ),
              child: SvgPicture.asset(
                iconFile,
                height: 30, width: 30),
            ),
            const SizedBox(height: 5),
            Text(name)
          ],
        ),
      ),
    );
  }

  Widget _confirmBtn() {
    return GestureDetector(
      onTap: () async {
        if (_title == null || _title == "") {
          _checkTitleField();
        } else {
          StreamingModel? streaming = await Provider.of<StreamingProvider>(context, listen: false).createStreaming(_selectedCategoryId, _title!);
          if(streaming != null) {
            Provider.of<StreamingProvider>(context, listen: false).fetchProcessList();
            Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (BuildContext context) => StreamerView(processId: streaming.id!)));
          }
        }
      },
      child: Container(
        height: 50,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: greyNavy, width: 2.0),
        ),
        child: const Text(
          "시작하기", 
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: greyNavy),
        ),
      ),
    );
  }

  _checkTitleField() {
    FocusScope.of(context).requestFocus(_titleFNode);
    setState(() {
      _isTitleValid = false;
    });
  }

}