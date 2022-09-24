import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lexp/core/res/color.dart';
import 'package:lexp/models/user.dart';
import 'package:lexp/models/user_unity.dart';
import 'package:lexp/pages/page.dart';
import 'package:lexp/widgets/circle_gradient_icon.dart';
import 'package:lexp/widgets/circle_gradient_text.dart';
import 'package:lexp/widgets/gradient_text.dart';
import 'package:lexp/services/rest_provider.dart' as rest;
import 'package:lexp/services/shared_service.dart' as shared;

class MyThematicsScreen extends StatefulWidget {
  const MyThematicsScreen({super.key, required this.user});

  final UserModel user;

  @override
  State<StatefulWidget> createState() {
    return _MyThematicsScreenState();
  }
}

class _MyThematicsScreenState extends State<MyThematicsScreen> {
  late final Future _future;
  late final List<UserUnityModel> _myTUnits;
  late final List<UserUnityModel> _filteredFinalized;
  late final List<UserUnityModel> _filteredToDo;

  @override
  void initState() {
    var params = {
      "data": {"idUser": widget.user.idUser}
    };
    _future = rest.RestProvider().callMethod("/uuc/gabu", params);
    _future.then((value) => {
          _myTUnits = shared.SharedService().getEnrolls(value),
          _filteredFinalized = _myTUnits.where((element) => element.finalCalification != null).toList(),
          _filteredToDo = _myTUnits.where((element) => element.finalCalification == null).toList(),
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(
                  child: Text("Continuar aprendiendo", style: TextStyle(color: AppColors.customPurple)),
                ),
                Tab(
                  child: Text("Finalizado", style: TextStyle(color: AppColors.customPurple)),
                ),
              ],
            ),
            title: GradientText(
              "Mis cursos",
              gradient: AppColors.textGradient,
            ),
          ),
          body: FutureBuilder(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                if (snapshot.error.toString().contains("SocketException")) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.wifi_off,
                          size: 100,
                          color: AppColors.customPurple,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "No hay conexión con el servidor",
                          style: TextStyle(
                            color: AppColors.customPurple,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error,
                          size: 100,
                          color: AppColors.customPurple,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Ha ocurrido un error inesperado",
                          style: TextStyle(
                            color: AppColors.customPurple,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  );
                }
              }
              if (snapshot.hasData) {
                return TabBarView(children: [_buildBody(context, _filteredToDo), _buildBody(context, _filteredFinalized)]);
              } else {
                return Center(
                    child: Container(
                        color: AppColors.drawerColor,
                        child: SpinKitFadingCube(
                          color: AppColors.customPurple,
                          size: 42.0,
                        )));
              }
            },
          ),
        ));
  }

  Widget _buildBody(BuildContext context, List<UserUnityModel> units) {
    return Stack(
      children: [
        GridView.builder(
            itemCount: units.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.6),
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                  padding: EdgeInsets.only(
                      top: index % 2 == 0 ? 10 : 10,
                      right: index % 2 == 0 ? 5 : 20,
                      left: index % 2 == 1 ? 5 : 20,
                      bottom: index % 2 == 1 ? 10 : 10),
                  child: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              AppColors.degradedImage1Color,
                              const Color.fromARGB(255, 4, 201, 194),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 5, offset: const Offset(0, 5))]),
                      child: Column(
                        children: [
                          Expanded(
                              child: Stack(
                            children: [
                              ClipRRect(
                                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                                  child: CachedNetworkImage(
                                    imageUrl: units[index].thematicUnit!.portrait,
                                    placeholder: (context, url) => SpinKitFadingCube(
                                      color: AppColors.customPurple,
                                      size: 30,
                                    ),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                  )),
                              Positioned(
                                  bottom: 10,
                                  left: 10,
                                  child: CircleGradientIcon(
                                    color: AppColors.customPinkCyan,
                                    icon: Icons.play_arrow,
                                    size: 42,
                                    iconSize: 24,
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => PageScreen(
                                                    user: widget.user,
                                                    userUnity: units[index],
                                                  )));
                                    },
                                  )),
                              Positioned(
                                bottom: 10,
                                right: 10,
                                child: CircleGradientText(
                                  inCircleText:
                                      "${getPercent(units[index].thematicUnit!.listOfContent!.length, units[index].advQtty).toStringAsFixed(0)}%",
                                  textSize: 12,
                                  color: AppColors.customPinkCyan,
                                  size: 42,
                                  onTap: () {},
                                ),
                              )
                            ],
                          )),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  units[index].thematicUnit!.thematicUnitName,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),
                          )
                        ],
                      )));
            }),
      ],
    );
  }

  double getPercent(int length, int adv) {
    double percent = (adv / length) * 100;
    return percent;
  }
}
