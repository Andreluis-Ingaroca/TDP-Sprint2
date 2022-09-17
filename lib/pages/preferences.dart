import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lexp/core/res/app.dart';
import 'package:lexp/core/res/color.dart';
import 'package:lexp/core/routes/routes.dart';
import 'package:lexp/models/category.dart';
import 'package:lexp/models/user.dart';
import 'package:lexp/services/rest_provider.dart' as rest;
import 'package:lexp/services/shared_service.dart' as shared;

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PreferencesScreenState();
  }
}

//TODO: check if the user setted their preferences

class _PreferencesScreenState extends State<PreferencesScreen> {
  int? timeQtty;
  int? preferences;

  void savePreferences(UserModel user) {
    var params = {"data": user};
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.322),
      builder: (BuildContext context) {
        return SpinKitFadingCube(
          color: AppColors.customPurple,
          size: 69.0,
        );
      },
    );
    rest.RestProvider().callMethod("/uc/su", params).then((userFetch) {
      Navigator.pop(context);
      var user = UserModel.fromJson(userFetch.data["data"]);
      shared.SharedService().saveUser("user", user);
      Navigator.pushNamedAndRemoveUntil(context, Routes.home, (_) => false);
    }, onError: (error) {
      const SnackBar snackBar = SnackBar(
          backgroundColor: Colors.red,
          content: Text('Hubo un error al guardar sus preferencias'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [
              AppColors.secondaryColor,
              AppColors.primaryColor,
            ],
          ),
        ),
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
            ),
            backgroundColor: Colors.transparent,
            body: FutureBuilder(
                future: shared.SharedService().getUser("user"),
                builder: (contextUpper, snapshotUpper) {
                  if (snapshotUpper.hasData) {
                    return Container(
                        alignment: Alignment.centerLeft,
                        child: ListView(shrinkWrap: true, children: <Widget>[
                          const Text('Queremos saber más sobre ti',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              )),
                          const SizedBox(height: 40),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.25,
                            child: Opacity(
                                opacity: 0.8,
                                child: SvgPicture.asset(AppConstants.logoSvg)),
                          ),
                          const SizedBox(height: 40),
                          Center(
                            child: DropdownButton<String>(
                              icon: const Icon(Icons.expand_more),
                              iconEnabledColor: Colors.white,
                              iconSize: 24,
                              elevation: 16,
                              hint: Container(
                                  width: 200,
                                  padding: const EdgeInsets.only(bottom: 50),
                                  child: const Text(
                                    '¿Cuánto tiempo quiere dedicarle a cada curso?',
                                    overflow: TextOverflow.visible,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )),
                              style: const TextStyle(
                                  color: Colors.deepPurple, fontSize: 17),
                              onChanged: (String? newValue) {
                                setState(() {
                                  timeQtty = int.parse(newValue!);
                                  SnackBar snackBar = const SnackBar(
                                      backgroundColor: Colors.green,
                                      content: Text(
                                          'Se guardó su preferencia de tiempo de estudio'));
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                });
                              },
                              items: AppConstants.timeQttyList
                                  .map<DropdownMenuItem<String>>((value) {
                                return DropdownMenuItem<String>(
                                  value: value.time.toString(),
                                  child: Text(value.qtty),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(height: 18),
                          FutureBuilder(
                              future: rest.RestProvider().callMethod("/cc/lac"),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  List<CategoryModel> categories =
                                      shared.SharedService()
                                          .getCategories(snapshot.data);
                                  return Center(
                                    child: DropdownButton<String>(
                                      icon: const Icon(Icons.expand_more),
                                      iconEnabledColor: Colors.white,
                                      iconSize: 24,
                                      elevation: 16,
                                      hint: Container(
                                          width: 200,
                                          padding:
                                              const EdgeInsets.only(bottom: 50),
                                          child: const Text(
                                            '¿Cuál son sus temas de interés?',
                                            overflow: TextOverflow.visible,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          )),
                                      style: const TextStyle(
                                          color: Colors.deepPurple,
                                          fontSize: 17),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          preferences = int.parse(newValue!);
                                          const SnackBar snackBar = SnackBar(
                                              backgroundColor: Colors.green,
                                              content: Text(
                                                  'Se guardó su preferencia de categoría'));
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                        });
                                      },
                                      items: categories
                                          .map<DropdownMenuItem<String>>(
                                              (value) {
                                        return DropdownMenuItem<String>(
                                          value: value.idCategory.toString(),
                                          child: Text(value.categoryName),
                                        );
                                      }).toList(),
                                    ),
                                  );
                                } else {
                                  return SpinKitFadingCube(
                                    color: AppColors.customPurple,
                                    size: 42.0,
                                  );
                                }
                              }),
                          const SizedBox(height: 18),
                          Center(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.customPurple,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32.0),
                                ),
                              ),
                              onPressed: () {
                                if (timeQtty != null && preferences != null) {
                                  UserModel? user = snapshotUpper.data;
                                  user!.timeQtty = timeQtty!;
                                  user.preferences = preferences!;
                                  savePreferences(user);
                                } else {
                                  const SnackBar snackBar = SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text(
                                          'Por favor, seleccione una opción para cada campo'));
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                }
                              },
                              child: const Text('Guardar preferencias'),
                            ),
                          ),
                        ]));
                  } else {
                    return SpinKitFadingCube(
                      color: AppColors.customPurple,
                      size: 42.0,
                    );
                  }
                })));
  }
}
