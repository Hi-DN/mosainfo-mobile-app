import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mosainfo_mobile_app/src/api/streaming_model.dart';
import 'package:mosainfo_mobile_app/src/constants/colors.dart';
import 'package:mosainfo_mobile_app/src/provider/streaming_provider.dart';
import 'package:mosainfo_mobile_app/src/view/streamer_view.dart';
import 'package:mosainfo_mobile_app/utils/category_enum.dart';
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
        _categoryTile(StreamingCategory.values[0]),
        _categoryTile(StreamingCategory.values[1]),
        _categoryTile(StreamingCategory.values[2]),
        _categoryTile(StreamingCategory.values[3]),
        _categoryTile(StreamingCategory.values[4]),
        _categoryTile(StreamingCategory.values[5]),
        _categoryTile(StreamingCategory.values[6]),
        _categoryTile(StreamingCategory.values[7]),
        _categoryTile(StreamingCategory.values[8]),
        _categoryTile(StreamingCategory.values[9]),
        _categoryTile(StreamingCategory.values[10])
      ],
    );
  }

  Widget _categoryTile(StreamingCategory category) {
    bool isSelected = _selectedCategoryId == category.id;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategoryId = category.id;  
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
                category.iconFile,
                height: 30, width: 30),
            ),
            const SizedBox(height: 5),
            Text(category.name)
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
              MaterialPageRoute(builder: (BuildContext context) => StreamerView(streaming: streaming)));
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