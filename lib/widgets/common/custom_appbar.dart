import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mosainfo_mobile_app/src/constants/colors.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
const CustomAppBar({Key? key, this.leadingYn=false, this.onTap, this.titleTxt='Mosainfo', this.actions}) : 
      preferredSize = const Size.fromHeight(65), super(key: key);

  @override
  final Size preferredSize;
  final bool? leadingYn;
  final VoidCallback? onTap;
  final String? titleTxt;
  final List<Widget>? actions;

  @override
  Widget build(context) {

    return AppBar(
      leading: leadingYn ?? false
        ? Padding(
            padding: const EdgeInsets.only(left: 14),
            child: GestureDetector(
                onTap: onTap,
                child: const Icon(Icons.arrow_back, color: white)),
          )
        : Container(),
      backgroundColor: greyNavy,
      elevation: 0.0,
      title: SvgPicture.asset(
          'assets/images/logo.svg',
          height: 30, width:80
        ),
      actions: actions
    );
  }
}
