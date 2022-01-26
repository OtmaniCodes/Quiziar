import 'dart:io';

import 'package:client/src/models/category.dart';
import 'package:client/src/services/api/api.dart';
import 'package:client/src/state/categories_controller.dart';
import 'package:client/src/state/controllers/categry_search_controller.dart';
import 'package:client/src/state/controllers/profile_image_controller.dart';
import 'package:client/src/utils/constants/enums.dart';
import 'package:client/src/utils/constants/palette.dart';
import 'package:client/src/utils/helpers/help_functions.dart';
import 'package:client/src/utils/responsivity/responsivity.dart';
import 'package:client/src/utils/service_locator.dart';
import 'package:client/src/view/reused_widgets/reused_widgets.dart';
import 'package:client/src/view/reused_widgets/widgets/comcont.dart';
import 'package:client/src/view/reused_widgets/widgets/custom_text.dart';
import 'package:client/src/view/reused_widgets/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart' as animatedo;
import 'dart:math' as math;


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TextEditingController _searchController;

  @override
  void initState() {
    _searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final CategoriesController _cateController = Get.put(CategoriesController());
    // final ProfileImageController _profileImageController = Get.find<ProfileImageController>();
    final ProfileImageController _profileImageController = Get.put(ProfileImageController());
    return Scaffold(
      body: GetBuilder(
        init: CategorySearchController(),
        builder: (CategorySearchController state) {
          final bool _isSearch = state.isSearch;
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                toolbarHeight: 76,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.75),
                elevation: 0,
                floating: true,
                leadingWidth: 60,
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: (){
                      Get.toNamed('/settings');
                    },
                    child: ReusedWidgets.getProfileImage(
                      isAvatar: _profileImageController.imagePicturePath.isEmpty,
                      avatarIndex: _profileImageController.imageAvatarIndex.isEmpty ? math.Random().nextInt(16)+1 : [1, 2].contains(_profileImageController.imageAvatarIndex.length) ? int.parse(_profileImageController.imageAvatarIndex)+1 : 1,
                      imageFilePath: _profileImageController.imagePicturePath
                    ),
                  )
                ),
                actions: [
                  IconButton(
                    onPressed: (){
                      HelpFuncs.hapticFeedback(HapticIntensity.medium);
                      state.toggleSearchState();
                      if(state.isSearch == false){
                        _searchController.text = '';
                        state.updateSearchTerm('');
                        if(FocusScope.of(context).hasFocus) FocusScope.of(context).unfocus();
                      }
                    },
                    icon: FaIcon(!_isSearch ? FontAwesomeIcons.search : FontAwesomeIcons.times, color: whiteClr),
                  ),
                ],
                title: _isSearch
                  ? animatedo.FadeInDown(
                    duration: const Duration(milliseconds: 300),
                    child: _buildSearchBar(state)
                  )
                : const AppLogo(
                    bigTitleSize: 35,
                    smallTitleSize: 11,
                    lettersSpacing: 3,
                  ),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  ReusedWidgets.spaceOut(h: 30.h),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: state.searchTerm.isEmpty && _isSearch == false
                      ? [
                        Padding(
                          padding: EdgeInsets.only(left: 10.w),
                          child: const CustomText(txt: "Categories"),
                        ),
                        ReusedWidgets.spaceOut(h: 10.h),
                        _cateController.categories.isEmpty
                          ? FutureBuilder<List<Category>>(
                            future: locator<ApiService>().getAllCategories(),
                            builder: (BuildContext context, categoriesSnap){
                              final bool _hasData = categoriesSnap.hasData ? categoriesSnap.data != null : false;
                              if(_hasData){
                                final List<Category> _categoriesData = categoriesSnap.data!;
                                _cateController.setCategories(_categoriesData);
                                if(_categoriesData.isNotEmpty){
                                  return _buildGridView(_categoriesData);
                                }else{
                                  return const Center(
                                    child: CustomText(txt: 'No Categories Available')
                                  );
                                }
                              }else{
                                return const Center(
                                  child: CustomText(txt: 'Loading...')
                                );
                              }
                            },
                          )
                        : _buildGridView(_cateController.categories)
                      ] : _cateController.categories.where((Category cate) => cate.name!.toLowerCase().startsWith(state.searchTerm.toLowerCase())).toList().isNotEmpty
                        ? List.generate(_cateController.categories.where((Category cate) => cate.name!.toLowerCase().startsWith(state.searchTerm.toLowerCase())).toList().length, (index)
                          => Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.w),
                            child: CategoryCard(category: _cateController.categories.where((Category cate) => cate.name!.toLowerCase().startsWith(state.searchTerm.toLowerCase())).toList()[index],
                              index: index, verticalLayout: false),
                          )) : <Widget>[CustomText(txt: 'couldn\'t find what you\'re looking for.')]
                    )
                  ],
                ),
              ),
            ],
          );
        }
      ),
    );
  }

  Widget _buildSearchBar(CategorySearchController state){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        children: [
          Expanded(
            child: ComCont(
              withBorder: true,
              borderColor: Theme.of(context).primaryColor,
              roundingLevel: 40,
              givenPadd: EdgeInsets.symmetric(horizontal: 19.w),
              givenMarg: EdgeInsets.zero,
              bgColor: Theme.of(context).scaffoldBackgroundColor,
              withShadow: true,
              kid: Row(
                children: [
                  FaIcon(FontAwesomeIcons.search, color: whiteClr.withOpacity(0.15)),
                  ReusedWidgets.spaceOut(w: 10.w),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value){
                        state.updateSearchTerm(value.trim());
                      },
                      onSubmitted: (value){
                        state.updateSearchTerm(value.trim());
                      },
                      maxLines: 1,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        hintText: 'Search for category, topic...',
                        border: InputBorder.none
                      ),
                    ),
                  ),
                ],
              )
            ),
          ), 
        ],
      ),
    );
  }

  GridView _buildGridView(List<Category> _categoriesData) {
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _categoriesData.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.w
      ),
      itemBuilder: (BuildContext context, int index)
        => CategoryCard(category: _categoriesData[index], index: index),
    );
  }
}


class CategoryCard extends StatelessWidget {
  final Category category;
  final int index;
  final bool verticalLayout;
  const CategoryCard({
    Key? key,
    this.verticalLayout = true,
    required this.category,
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
    return ReusedWidgets.wrapWithInkEffect(
      ComCont(
        withShadow: true,
        givenMarg: EdgeInsets.zero,
        givenPadd: verticalLayout ? null : const EdgeInsets.all(10),
        kid: verticalLayout
          ? Column(
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
          )
        : ListTile(
          leading: _getIndexWidget(),
          trailing: _getQuestionsCount(),
          title: CustomText(
            // alignment: TextAlign.center,
            txt: category.name ?? '',
            size: 15.sp,
            fontFam: 'boldPoppins',
          ),
        )
      ),
      onTap: (){
        print("hello");
      }
    );
  }
}