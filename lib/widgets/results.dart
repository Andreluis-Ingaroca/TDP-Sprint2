import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lexp/core/res/app.dart';
import 'package:lexp/core/res/color.dart';
import 'package:lexp/models/category.dart';
import 'package:lexp/models/thematic_unit.dart';
import 'package:lexp/models/user.dart';
import 'package:lexp/pages/t_unit_preview.dart';
import 'package:lexp/services/rest_provider.dart' as rest;
import 'package:lexp/services/shared_service.dart' as shared;
import 'package:lexp/widgets/block_menu.dart';
import 'package:lexp/widgets/page_message.dart';

class ListResultsLXP extends StatefulWidget {
  const ListResultsLXP({
    Key? key,
    required this.query,
    required this.user,
  }) : super(key: key);

  final String query;
  final UserModel user;

  @override
  State<ListResultsLXP> createState() => _ListResultsLXPState();
}

class _ListResultsLXPState extends State<ListResultsLXP> {
  bool selectedLXP = false;
  final _controllerLXP = PageController(initialPage: 0);
  late final Future _futureLXP;
  late final Future _getCategories;
  late final Future _getThemes;
  late final List<ThematicUnitModel> _listLXP;
  late final List<CategoryModel> _listCategories;
  late List<ThematicUnitModel> _filteredList;
  final double _width = 170;
  final double _margin = 5;
  int _selectedCategory = -1;

  @override
  void initState() {
    _getThemes = rest.RestProvider().callMethod("/tuc/search/${widget.query}");
    _getThemes.then((value) => {
          _listLXP = shared.SharedService().getTUnits(value),
          _filteredList = _listLXP,
        });
    _getCategories = rest.RestProvider().callMethod("/cc/lac");
    _getCategories.then((value) => {_listCategories = shared.SharedService().getCategories(value)});
    _futureLXP = Future.wait([_getThemes, _getCategories]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _futureLXP,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(children: [
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            side: BorderSide(color: !selectedLXP ? AppColors.customPurple : Colors.transparent, width: 1),
                            borderRadius: BorderRadius.circular(5)),
                        foregroundColor: AppColors.customPurple,
                        backgroundColor: Colors.transparent,
                      ),
                      onPressed: () {
                        setState(() => selectedLXP = false);
                        _controllerLXP.animateToPage(0, duration: const Duration(milliseconds: 420), curve: Curves.ease);
                      },
                      child: const Text('Todos'),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            side: BorderSide(color: selectedLXP ? AppColors.customPurple : Colors.transparent, width: 1),
                            borderRadius: BorderRadius.circular(5)),
                        foregroundColor: AppColors.customPurple,
                        backgroundColor: Colors.transparent,
                      ),
                      onPressed: () {
                        setState(() => selectedLXP = true);
                        _controllerLXP.animateToPage(1, duration: const Duration(milliseconds: 420), curve: Curves.ease);
                      },
                      child: const Text('Por categoria'),
                    ),
                  ),
                ],
              ),
              Expanded(
                  child: PageView(
                controller: _controllerLXP,
                children: [
                  Center(
                    child: _buildScrollable(
                      _listLXP,
                      Axis.vertical,
                    ),
                  ),
                  Column(children: [
                    AppConstants.space,
                    Flexible(
                      flex: 2,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: _listCategories.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () => {
                              setState(
                                () => _selectedCategory = index,
                              ),
                              setState(
                                () => _filteredList =
                                    _listLXP.where((element) => element.idCategory == _listCategories[index].idCategory).toList(),
                              ),
                            },
                            child: Container(
                              margin: const EdgeInsets.all(5),
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                border: Border.all(color: _selectedCategory == index ? AppColors.customPurple : Colors.transparent, width: 1),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      _listCategories[index].categoryName,
                                      style: const TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: AppColors.customPurple,
                                    size: 15,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      flex: _filteredList.length,
                      child: _buildScrollable(_filteredList, Axis.vertical),
                    )
                  ]),
                ],
              ))
            ]);
          } else {
            return Container(
                color: AppColors.drawerColor,
                child: SpinKitFadingCube(
                  color: AppColors.customPurple,
                  size: 42.0,
                ));
          }
        });
  }

  Widget _buildScrollable(List<ThematicUnitModel> list, Axis axis) {
    return list.isNotEmpty
        ? ListView.builder(
            shrinkWrap: true,
            scrollDirection: axis,
            itemCount: list.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ThematicUnitScreen(tUnit: list[index], user: widget.user),
                    ),
                  );
                },
                child: Container(
                    width: _width,
                    margin: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: _margin,
                    ),
                    decoration: BoxDecoration(
                      gradient: AppColors.getLinearGradient(AppColors.customCyanPink),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 0.2,
                          //   offset: const Offset(2, 2),
                        )
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppConstants.space,
                          AppConstants.space,
                          Align(
                            alignment: Alignment.topCenter,
                            child: Text(
                              list[index].thematicUnitName,
                              maxLines: 2,
                              overflow: TextOverflow.fade,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          AppConstants.space,
                          Row(
                            children: [
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: TinyBlockContainer(
                                    color: Colors.deepPurple,
                                    image: list[index].portrait,
                                    blockTittle: list[index].thematicUnitName,
                                  )),
                              AppConstants.spacew,
                              RatingBar.builder(
                                ignoreGestures: true,
                                initialRating: list[index].starRate.toDouble(),
                                direction: Axis.horizontal,
                                itemCount: 5,
                                itemSize: 15,
                                itemBuilder: (context, _) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (rating) {
                                  null;
                                },
                              ),
                            ],
                          ),
                          AppConstants.space,
                          RichText(
                            text: TextSpan(
                              text: "Duración: ${list[index].nTime} min",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          AppConstants.space,
                        ],
                      ),
                    )),
              );
            },
          )
        : const PageMessage(iconPage: Icons.search_off, messagePage: "No se encontraron resultados");
  }
}
