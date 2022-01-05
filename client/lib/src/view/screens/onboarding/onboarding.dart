import 'package:client/src/utils/constants/constansts.dart';
import 'package:client/src/utils/constants/palette.dart';
import 'package:client/src/view/reused_widgets/reused_widgets.dart';
import 'package:client/src/view/reused_widgets/widgets/comcont.dart';
import 'package:client/src/view/reused_widgets/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:client/src/utils/responsivity/responsivity.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                ReusedWidgets.spaceOut(h: 20.h),
                const AppLogo(),
                ReusedWidgets.spaceOut(h: 50.h),
                ComCont(
                  withShadow: true,
                  givenMarg: EdgeInsets.symmetric(horizontal: 20.w),
                  givenPadd: EdgeInsets.zero,
                  height: 348.h,
                  width: 275.w,
                  kid: Column(
                    children: [
                      TabBar(
                        controller: _tabController,
                        indicatorColor: Theme.of(context).primaryColor,
                        padding: EdgeInsets.zero,
                        labelPadding: EdgeInsets.zero,
                        unselectedLabelColor: whiteClr.withOpacity(0.75),
                        tabs: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: Text('Sign in', style: TextStyle(fontSize: 18.sp))
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: Text('Sign Up', style: TextStyle(fontSize: 18.sp))
                          ),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              // mainAxisSize: MainAxisSize.min,
                              children: [
                                ReusedWidgets.spaceOut(h: 50.h),
                                ComInputField(),
                                ReusedWidgets.spaceOut(h: 14.h),
                                ComInputField(),
                              ],
                            ),
                            Container(),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AppLogo extends StatelessWidget {
  final double? bigTitleSize;
  final double? smallTitleSize;
  const AppLogo({Key? key, this.bigTitleSize, this.smallTitleSize}) : super(key: key);

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
            letterSpacing: 5,
          ),
        ),
        CustomText(txt: '  Challenge your mind.', size: smallTitleSize ?? 20)
      ],
    );
  }
}


class ComInputField extends StatelessWidget {
  const ComInputField({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ComCont(
      givenPadd: EdgeInsets.zero,
      givenMarg: EdgeInsets.symmetric(horizontal: 20),
      withShadow: true,
      kid: TextField(
        decoration: InputDecoration(hintText: 'Hello there'),
      ),
    );
  }
}