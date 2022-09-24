import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lexp/core/res/app.dart';
import 'package:lexp/core/res/color.dart';
import 'package:lexp/models/task.dart';
import 'package:lexp/models/thematic_unit.dart';
import 'package:lexp/models/user.dart';
import 'package:lexp/pages/t_unit_preview.dart';
import 'package:lexp/widgets/block_menu.dart';
import 'package:lexp/widgets/circle_gradient_icon.dart';
import 'package:lexp/widgets/gradient_text.dart';
import 'package:lexp/widgets/lxp_search.dart';
import 'package:lexp/widgets/page_message.dart';
import 'package:lexp/widgets/task.dart';
import 'package:lexp/services/rest_provider.dart' as rest;
import 'package:lexp/services/shared_service.dart' as shared;

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({Key? key, required this.user}) : super(key: key);

  final UserModel user;

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> with SingleTickerProviderStateMixin {
  //late TabController _controller;
  late int _tUnitIndex;
  final double _width = 170;
  final double _margin = 5;
  final _scrollControllerMat = ScrollController();
  final _scrollControllerRec = ScrollController();
  final _scrollControllerSug = ScrollController();
  final List<TaskModel> _tasksList = [
    TaskModel(from: DateTime(2022, 03, 16, 10, 00), to: DateTime(2022, 03, 16, 15, 00), taskName: "Finanzas comerciales"),
    TaskModel(from: DateTime(2022, 03, 16, 4, 00), to: DateTime(2022, 03, 16, 5, 00), taskName: "Clase de Hipoteca"),
  ];
  late final Future _future;
  late final Future _getMoreMat;
  late final Future _getMoreRecent;
  late final Future _getSuggested; //Algorithm to get suggested TUnits
  late final List<ThematicUnitModel> _moreMat;
  late final List<ThematicUnitModel> _moreRecent;
  late final List<ThematicUnitModel> _suggested;

  void getInfo() {
    _tUnitIndex = 0;
    _getMoreMat.then((value) => _moreMat = shared.SharedService().getTUnits(value));
    _getMoreRecent.then((value) => _moreRecent = shared.SharedService().getTUnits(value));
    _getSuggested.then((value) => _suggested = shared.SharedService().getTUnits(value));
  }

  void _scroll(ScrollController controller, int offset) {
    controller.animateTo(
      (offset * _tUnitIndex.toDouble()) + (_tUnitIndex.toDouble() * _width) - (_tUnitIndex * _margin),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeIn,
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 16.0,
          ),
        ),
        backgroundColor: AppColors.customPurple,
        behavior: SnackBarBehavior.floating,
        elevation: 1.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
    );
  }

  @override
  void initState() {
    _getMoreMat = rest.RestProvider().callMethod("/tuc/mmtu");
    // 0 is the first page
    _getMoreRecent = rest.RestProvider().callMethod("/tuc/pgmr/0");
    _getSuggested = rest.RestProvider().callMethod("/tuc/mmtu");
    _future = Future.wait([_getMoreMat, _getMoreRecent, _getSuggested]);
    getInfo();
    super.initState();
    //_controller = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: GradientText(
            'Explora más cursos',
            gradient: AppColors.textGradient,
          ),
        ),
        body: FutureBuilder(
            future: _future,
            builder: ((context, snapshot) {
              if (snapshot.hasError) {
                if (snapshot.error.toString().contains("SocketException")) {
                  return const PageMessage(
                    messagePage: "No hay conexión con el servidor",
                    iconPage: Icons.signal_wifi_off,
                  );
                } else {
                  return const PageMessage(
                    messagePage: "Ha ocurrido un error inesperado",
                    iconPage: Icons.error_outline_outlined,
                  );
                }
              }
              if (snapshot.hasData) {
                return _buildBody(context);
              } else {
                return Center(
                    child: Container(
                        color: AppColors.drawerColor,
                        child: SpinKitFadingCube(
                          color: AppColors.customPurple,
                          size: 42.0,
                        )));
              }
            })));
  }

  Stack _buildBody(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppConstants.space,
                _buildHeader(context, "Sugeridos"),
                _buildScrollable(_suggested, _scrollControllerSug, Axis.horizontal),
                AppConstants.space,
                _buildHeader(context, "Más recientes", "2 cursos nuevos"),
                _buildScrollable(_moreRecent, _scrollControllerRec, Axis.horizontal),
                AppConstants.space,
                _buildHeader(context, "Más populares"),
                _buildScrollable(_moreMat, _scrollControllerMat, Axis.horizontal),
                AppConstants.space,
                Column(
                  children: _tasksList
                      .map(
                        (e) => TaskWidget(
                          taskModel: e,
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 30,
          right: 30,
          child: CircleGradientIcon(
            color: AppColors.searchColor,
            onTap: () {
              showSearch(context: context, delegate: LXPSearch(ThematicUnitModel, widget.user));
            },
            size: 60,
            iconSize: 30,
            icon: Icons.search,
          ),
        )
      ],
    );
  }

  Row _buildHeader(BuildContext context, String tittle, [String subtitle = ""]) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tittle,
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ],
        ),
      ],
    );
  }

  SizedBox _buildScrollable(List<ThematicUnitModel> list, ScrollController scroller, Axis axis) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: axis,
        itemCount: list.length,
        controller: scroller,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              _tUnitIndex = index;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ThematicUnitScreen(tUnit: list[index], user: widget.user),
                ),
              );
            },
            onDoubleTap: () {
              _tUnitIndex = index;
              _scroll(scroller, list.length);
              _showSnackBar("Presione 1 vez para ver el curso");
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
                    ],
                  ),
                )),
          );
        },
      ),
    );
  }
}
