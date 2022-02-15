import 'package:client/src/models/category.dart';
import 'package:client/src/services/api/api.dart';
import 'package:client/src/utils/constants/enums.dart';
import 'package:client/src/utils/helpers/help_functions.dart';
import 'package:client/src/utils/responsivity/responsivity.dart';
import 'package:client/src/services/service_locator.dart';
import 'package:client/src/view/reused_widgets/reused_widgets.dart';
import 'package:client/src/view/reused_widgets/widgets/comcont.dart';
import 'package:client/src/view/reused_widgets/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  final int index;
  final bool verticalLayout;
  final void Function()? onTap;
  const CategoryCard({
    Key? key,
    this.verticalLayout = true,
    required this.category,
    this.onTap,
    required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget _getIndexWidget({double? indexSize}) 
      => ComCont(
        givenMarg: EdgeInsets.zero,
        givenPadd: const EdgeInsets.all(5.0),
        bgColor: Theme.of(context).primaryColor,
        width: 50,
        height: 50,
        isCircular: true,
        withRadius: false,
        withBorder: true,
        withShadow: true,
        kid: Center(
          child: Text((index+1).toString(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: indexSize ?? 30,
            fontFamily: 'boldPoppins',
            shadows: const [
              Shadow(
                offset: Offset(0, 3),
                color: Colors.grey,
                blurRadius: 5  
              )
            ]
          ),
        ),
      ),
    );
    _getQuestionsCount({double? indexSize}) 
      => FutureBuilder<int>(
      future: locator<ApiService>().getCategoryQuestionsCount(category.id!),
      builder: (context, questionsCountSnap) {
        final bool _hasData = questionsCountSnap.hasData ? questionsCountSnap.data != null : false;
        if(_hasData){
          return CustomText(
          txt: "(${questionsCountSnap.data} questions)",
          size: indexSize ?? 12,
        );
        }else{
          return CustomText(
            txt: "...",
            size: indexSize ?? 12,
          );
        }
      }
    );
    return ComCont(
        withShadow: true,
        givenMarg: EdgeInsets.zero,
        givenPadd: EdgeInsets.zero,
        kid: ReusedWidgets.wrapWithInkEffect(
          verticalLayout
            ? Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  const Spacer(),
                  _getIndexWidget(),
                  const Spacer(flex: 2),
                  CustomText(
                    alignment: TextAlign.center,
                    txt: category.name ?? '',
                    size: 15.sp,
                    fontFam: 'boldPoppins',
                  ),
                  _getQuestionsCount(),
                  const Spacer(),
                ],
              ),
            )
          : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: ListTile(
              leading: _getIndexWidget(),
              trailing: _getQuestionsCount(),
              title: CustomText(
                // alignment: TextAlign.center,
                txt: category.name ?? '',
                size: 15.sp,
                fontFam: 'boldPoppins',
              ),
            ),
          ),
        onTap: (){
          HelpFuncs.hapticFeedback(HapticIntensity.light);
          onTap?.call();
          Get.toNamed('/questions', arguments: category);
        }
      )
    );
  }
}