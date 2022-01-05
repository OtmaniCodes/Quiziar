import 'package:client/src/utils/constants/constansts.dart';
import 'package:client/src/view/reused_widgets/widgets/comcont.dart';
import 'package:client/src/view/reused_widgets/widgets/custom_text.dart';
import 'package:flutter/material.dart';

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
          child: Column(
            children: [
              const SizedBox(height: 15),
              const AppLogo(),
              const SizedBox(height: 50),
              ComCont(
                givenPadd: EdgeInsets.zero,
                height: 400,
                width: 400,
                kid: Column(
                  children: [
                    TabBar(
                      padding: EdgeInsets.zero,
                      controller: _tabController,
                      tabs: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: CustomText(txt: 'Sign up'),
                        ),
                        Container(
                          padding: const EdgeInsets.all(10),
                          child: CustomText(txt: 'Sign in'),
                        ),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          Column(
                            // mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      decoration: InputDecoration(hintText: 'Hello there'),
                                    ),
                                  ),
                                ],
                              )
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
    );
  }
}

class AppLogo extends StatelessWidget {
  const AppLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5.0),
          child: CustomText(
            txt: kAppTitle,
            size: 60,
            clr: Theme.of(context).primaryColor,
            fontFam: 'boldPoppins',
            letterSpacing: 5,
          ),
        ),
        const CustomText(txt: '  Challenge your mind.', size: 15)
      ],
    );
  }
}
