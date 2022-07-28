import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
const CustomAppBar({Key? key, this.leadingYn=false}) : 
      preferredSize = const Size.fromHeight(kToolbarHeight), super(key: key);

  @override
  final Size preferredSize;
  final bool? leadingYn;

  @override
  Widget build(BuildContext context) {

    return AppBar(
        leadingWidth: 0,
        leading: leadingYn ?? false
            ? Padding(
                padding: const EdgeInsets.only(left: 14),
                child: GestureDetector(
                    onTap: () {
                        Navigator.pop(context);
                    },
                    child: const Icon(Icons.arrow_back, color: Color.fromRGBO(153, 153, 153, 1))),
              )
            : Container(),
        backgroundColor: Colors.white,
        title: const Text('Mosainfo', 
          style: TextStyle(color: Color(0xFF2F4858), fontWeight: FontWeight.w700)));
  }
}
