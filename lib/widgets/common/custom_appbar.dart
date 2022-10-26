import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mosainfo_mobile_app/src/constants/colors.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
const CustomAppBar({Key? key, this.leadingYn=false, this.titleTxt='Mosainfo'}) : 
      preferredSize = const Size.fromHeight(kToolbarHeight), super(key: key);

  @override
  final Size preferredSize;
  final bool? leadingYn;
  final String? titleTxt;

  @override
  Widget build(context) {

    return AppBar(
        leading: leadingYn ?? false
            ? Padding(
                padding: const EdgeInsets.only(left: 14),
                child: GestureDetector(
                    onTap: () {Navigator.of(context).pop();},
                    child: const Icon(Icons.arrow_back, color: Color.fromRGBO(153, 153, 153, 1))),
              )
            : Container(),
        backgroundColor: greyNavy,
        elevation: 0.0,
        title: SvgPicture.asset(
            'assets/images/logo.svg',
            height: 30
          ),
        );
  }
}
