import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ButtonCustom extends StatelessWidget {
  // const ButtonCustom({super.key});
  final String btnText;
  final String fontText;
  final int widthText;
  final int heightText;
  final String paddingText;
  final String radiousText;
  final String colorText;
  final String btncolor;
  final String fontsizeText;
  final Function onPress;
  // final String ButtonCustomText;
  const ButtonCustom(
      this.btnText,
      this.btncolor,
      this.colorText,
      this.fontText,
      this.fontsizeText,
      this.heightText,
      this.onPress,
      this.paddingText,
      this.radiousText,
      this.widthText,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(12),
      child: InkWell(
        onTap: () {},
      ),
    );
  }
}
