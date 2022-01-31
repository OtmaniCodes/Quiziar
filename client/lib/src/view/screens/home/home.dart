import 'dart:io';

import 'package:client/src/models/category.dart';
import 'package:client/src/services/api/api.dart';
import 'package:client/src/services/db/local_storage/local_storage.dart';
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
import 'package:client/src/view/screens/home/local_widgets/category_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
    print(LocalStorage().getUserID());
    return Scaffold(
      body: GetBuilder(
        init: CategorySearchController(),
        builder: (CategorySearchController state) {
          final bool _isSearch = state.isSearch;
          void _resetSearch(){
            _searchController.text = '';
            state.updateSearchTerm('');
            if(FocusScope.of(context).hasFocus) FocusScope.of(context).unfocus();
          }
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
                      if(state.isSearch){
                        state.toggleSearchState();
                        _resetSearch();
                      }
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
                      if(state.isSearch == false) _resetSearch();
                    },
                    icon: FaIcon(
                      !_isSearch ? FontAwesomeIcons.search : FontAwesomeIcons.times,
                      color: Theme.of(context).iconTheme.color,
                    ),
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
                                return Center(
                                  child: ReusedWidgets.showLoading()
                                );
                              }
                            },
                          )
                        : _buildGridView(_cateController.categories)
                      ] : _cateController.categories.where((Category cate) => cate.name!.toLowerCase().startsWith(state.searchTerm.toLowerCase())).toList().isNotEmpty
                        ? List.generate(_cateController.categories.where((Category cate) => cate.name!.toLowerCase().startsWith(state.searchTerm.toLowerCase())).toList().length, (index)
                          => Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.w),
                            child: CategoryCard(
                              category: _cateController.categories.where((Category cate) => cate.name!.toLowerCase().startsWith(state.searchTerm.toLowerCase())).toList()[index],
                              index: index,
                              verticalLayout: false,
                              onTap: (){
                              if(state.isSearch){
                                _resetSearch();
                              }
                            },
                            ),
                          ),
                        ) : <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(txt: 'couldn\'t find what you\'re looking for', size: 15.sp, alignment: TextAlign.center),
                            ],
                          )
                      ]
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
                  FaIcon(FontAwesomeIcons.search, color: Theme.of(context).iconTheme.color?.withOpacity(0.3)),
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
                      decoration: InputDecoration(
                        hintStyle: TextStyle(color: Theme.of(context).iconTheme.color?.withOpacity(0.3)),
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
      => CategoryCard(
        category: _categoriesData[index],
        index: index,
      ),
    );
  }
}


