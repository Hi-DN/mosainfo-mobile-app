// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:mosainfo_mobile_app/src/constants/colors.dart';

TextStyle styleR =
    const TextStyle(height: 1.2, color: black, fontWeight: FontWeight.w400);

TextStyle styleB =
    const TextStyle(height: 1.2, color: black, fontWeight: FontWeight.w700);

TextStyle styleL =
    const TextStyle(height: 1.2, color: black, fontWeight: FontWeight.w100);

TextStyle styleBGreyNavy =
    const TextStyle(height: 1.2, color: greyNavy, fontWeight: FontWeight.w700);

class R12Text extends StatelessWidget {
  const R12Text({Key? key, @required this.text, this.textColor = black})
      : super(key: key);

  final String? text;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Text(text!,
        style: styleR.copyWith(fontSize: 12, color: textColor));
  }
}

class B12Text extends StatelessWidget {
  const B12Text({Key? key, @required this.text, this.textColor = black})
      : super(key: key);

  final String? text;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Text(text!,
        style: styleB.copyWith(fontSize: 12, color: textColor));
  }
}

class R14Text extends StatelessWidget {
  const R14Text({Key? key, @required this.text, this.textColor = black})
      : super(key: key);

  final String? text;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Text(text!,
        style: styleR.copyWith(fontSize: 14, color: textColor));
  }
}

class B14Text extends StatelessWidget {
  const B14Text({Key? key, @required this.text, this.textColor = black})
      : super(key: key);

  final String? text;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Text(text!,
        style: styleB.copyWith(fontSize: 14, color: textColor));
  }
}

class R16Text extends StatelessWidget {
  const R16Text({Key? key, @required this.text, this.textColor = black})
      : super(key: key);

  final String? text;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Text(text!,
        style: styleR.copyWith(fontSize: 16, color: textColor));
  }
}

class B16Text extends StatelessWidget {
  const B16Text({Key? key, @required this.text, this.textColor = black})
      : super(key: key);

  final String? text;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Text(text!,
        style: styleB.copyWith(fontSize:16, color: textColor));
  }
}

class R18Text extends StatelessWidget {
  const R18Text({Key? key, @required this.text, this.textColor = black})
      : super(key: key);

  final String? text;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Text(text!,
        style: styleR.copyWith(fontSize: 18, color: textColor));
  }
}

class B18Text extends StatelessWidget {
  const B18Text({Key? key, @required this.text, this.textColor = black})
      : super(key: key);

  final String? text;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Text(text!,
        style: styleB.copyWith(fontSize: 18, color: textColor));
  }
}

class R20Text extends StatelessWidget {
  const R20Text({Key? key, @required this.text, this.textColor = black})
      : super(key: key);

  final String? text;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Text(text!,
        style: styleR.copyWith(fontSize: 20, color: textColor));
  }
}

class B20Text extends StatelessWidget {
  const B20Text({Key? key, @required this.text, this.textColor = black})
      : super(key: key);

  final String? text;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Text(text!,
        style: styleB.copyWith(fontSize: 20, color: textColor));
  }
}
