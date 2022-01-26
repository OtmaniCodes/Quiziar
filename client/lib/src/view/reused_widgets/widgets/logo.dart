import 'package:client/src/utils/constants/constansts.dart';
import 'package:client/src/view/reused_widgets/widgets/custom_text.dart';
import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double? bigTitleSize;
  final double? smallTitleSize;
  final double? lettersSpacing;
  const AppLogo({Key? key, this.bigTitleSize, this.smallTitleSize, this.lettersSpacing}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: CustomText(
            txt: kAppTitle,
            size: bigTitleSize ?? 80,
            clr: Theme.of(context).primaryColor,
            fontFam: 'boldPoppins',
            letterSpacing: lettersSpacing ?? 5,
          ),
        ),
        CustomText(txt: '  Challenge your mind.', size: smallTitleSize ?? 20)
      ],
    );
  }
}

