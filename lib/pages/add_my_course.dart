import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lexp/core/res/color.dart';
import 'package:lexp/models/category.dart';
import 'package:lexp/models/content.dart';
import 'package:lexp/models/thematic_unit.dart';
import 'package:lexp/services/rest_provider.dart' as rest;
import 'package:lexp/services/shared_service.dart' as shared;


enum SingingCharacter { lafayette, jefferson, anuel }


class AddMyCourseScreen extends StatefulWidget {
  const AddMyCourseScreen({Key? key}) : super(key: key);

  @override
  State<AddMyCourseScreen> createState() => _AddMyCourseScreenState();
}

class _AddMyCourseScreenState extends State<AddMyCourseScreen> {

  int _currentStep = 0;
  StepperType stepperType = StepperType.horizontal;

  List<String> idsCategories = [];
  late String dropdownValue = "1";

  late final Future _future;
  late final List<CategoryModel> _categories;

  final TextEditingController nameThematicController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController portraitController = TextEditingController();
  final TextEditingController idCategoryController = TextEditingController();
  final TextEditingController nivelController = TextEditingController();
  final TextEditingController minCalificationController = TextEditingController();
  final TextEditingController starRateController = TextEditingController();
  final TextEditingController nTimeController = TextEditingController();
  final TextEditingController nBagdeController = TextEditingController();

  final TextEditingController linkContentControllerV = TextEditingController();
  final TextEditingController nameContentControllerV = TextEditingController();
  final TextEditingController positionContentControllerV = TextEditingController();

  final TextEditingController linkContentControllerI = TextEditingController();
  final TextEditingController nameContentControllerI = TextEditingController();
  final TextEditingController positionContentControllerI = TextEditingController();

  late List<TextEditingController> listControllerV = [];
  late List<TextEditingController> listControllerI = [];

  late Future _future2;
  late List<ContentModel> _contentsV = [];
  late final List<ContentModel> filterContentV = [];

  late Future _future3;
  late List<ContentModel> _contentsI = [];
  late final List<ContentModel> filterContentI = [];

  final TextEditingController questionController = TextEditingController();
  final TextEditingController alternative1Controller = TextEditingController();
  final TextEditingController alternative2Controller = TextEditingController();
  final TextEditingController alternative3Controller = TextEditingController();
  final TextEditingController alternative4Controller = TextEditingController();


  int statusSave = 0;
  int indicatorV = 0;
  int indicatorI = 0;
  int indicatorQ = 0;
  bool eliminated = false;

  late List<Widget> widgetV;
  late List<Widget> widgetI;
  late List<Widget> widgetQuestion;
  late List<List<Widget>> doubleListQuestion;

  int idThematic = 0;
  //List<int> idsVideos = [];
  Map<int, String> idsVideos = {};
  List<int> idsD = [];
  int idVideo = 0;

  @override
  void initState() {
    _future = rest.RestProvider().callMethod("/cc/lac");
    _future.then((value) => {
      _categories = shared.SharedService().getCategories(value),
      for (CategoryModel c in _categories) {
        idsCategories.add(c.idCategory.toString()),
        //dropdownValue = _categories[0].idCategory.toString(),
        dropdownValue = idsCategories.first,
      },
      //print("CATGEORUA  "+ _categories.length.toString())
    });

    var params = {
      "data": {
        "idThematicUnit": dropdownValue
      }
    };


    //_future2 = rest.RestProvider().callMethod("/cntc/fabtui", params);
    // _future2.then((value) => {
    //   _contents = shared.SharedService().getContents(value),
    //   // for (ContentModel c in _contents) {
    //   //   if ( c.multimedia == linkContentController.text && c.posicion.toString() == positionContentController.text
    //   //   && c.contentName == nameContentController.text && c.idThematicUnit.toString() == dropdownValue) {
    //   //     filterContent = c,
    //   //     print(filterContent.toJson().toString())
    //   //   }
    //   // },
    //   print(_contents.toString()),
    // });

    // TODO: implement initState
    super.initState();

    widgetV = [
      TextFormField(
        controller: linkContentControllerV,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: 'Enlace',
            labelStyle: TextStyle(
              color: AppColors.labelTextTematicaColor,
            ),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.borderTematicaColor,
                )),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.borderFocusedTematicaColor,
                ))),
        style: TextStyle(color: AppColors.textTematicaColor),
      ),
      TextFormField(
        controller: nameContentControllerV,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: 'Nombre',
            labelStyle: TextStyle(
              color: AppColors.labelTextTematicaColor,
            ),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.borderTematicaColor,
                )),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.borderFocusedTematicaColor,
                ))),
        style: TextStyle(color: AppColors.textTematicaColor),
      ),
      TextFormField(
        controller: positionContentControllerV,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: 'Posicion',
            labelStyle: TextStyle(
              color: AppColors.labelTextTematicaColor,
            ),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.borderTematicaColor,
                )),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.borderFocusedTematicaColor,
                ))),
        style: TextStyle(color: AppColors.textTematicaColor),
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 25),
        child: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          iconSize: 25,
          onPressed: () {
            if (linkContentControllerV.text.isNotEmpty && positionContentControllerV.text.isNotEmpty && nameContentControllerV.text.isNotEmpty) {
              filterContentV;
              setState(() {
                filterV(linkContentControllerV.text, positionContentControllerV.text, nameContentControllerV.text);
                linkContentControllerV.text = "";
                positionContentControllerV.text = "";
                nameContentControllerV.text = "";
                widgetV.removeLast();
                widgetV.removeLast();
                widgetV.removeLast();
                widgetV.removeLast();
                filterContentV;
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Agrega la fila para eliminar"),
              ));
            }

          },
        ),
      )
    ];

    widgetI = [
      TextFormField(
        controller: linkContentControllerI,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: 'Enlace',
            labelStyle: TextStyle(
              color: AppColors.labelTextTematicaColor,
            ),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.borderTematicaColor,
                )),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.borderFocusedTematicaColor,
                ))),
        style: TextStyle(color: AppColors.textTematicaColor),
      ),
      TextFormField(
        controller: nameContentControllerI,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: 'Nombre',
            labelStyle: TextStyle(
              color: AppColors.labelTextTematicaColor,
            ),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.borderTematicaColor,
                )),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.borderFocusedTematicaColor,
                ))),
        style: TextStyle(color: AppColors.textTematicaColor),
      ),
      TextFormField(
        controller: positionContentControllerI,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: 'Posicion',
            labelStyle: TextStyle(
              color: AppColors.labelTextTematicaColor,
            ),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.borderTematicaColor,
                )),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.borderFocusedTematicaColor,
                ))),
        style: TextStyle(color: AppColors.textTematicaColor),
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 25),
        child: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          iconSize: 25,
          onPressed: () {
            if (linkContentControllerI.text.isNotEmpty && positionContentControllerI.text.isNotEmpty && nameContentControllerI.text.isNotEmpty) {
              filterContentI;
              setState(() {
                filterI(linkContentControllerI.text, positionContentControllerI.text, nameContentControllerI.text);
                linkContentControllerI.text = "";
                positionContentControllerI.text = "";
                nameContentControllerI.text = "";
                widgetI.removeLast();
                widgetI.removeLast();
                widgetI.removeLast();
                widgetI.removeLast();
                filterContentI;
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Agrega la fila para eliminar"),
              ));
            }

          },
        ),
      )
    ];



    doubleListQuestion = [
      [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.question_answer, color: Colors.purple, size: 30),
            const SizedBox(
              width: 15,
            ),
            Expanded(
                child: TextFormField(
                  controller: questionController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Pregunta',
                      labelStyle: TextStyle(
                        color: AppColors.labelTextTematicaColor,
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.borderTematicaColor,
                          )),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.borderFocusedTematicaColor,
                          ))),
                  style: TextStyle(color: AppColors.textTematicaColor),
                )
            ),
            IconButton(
                onPressed: () {
                  if (questionController.text.isNotEmpty && alternative1Controller.text.isNotEmpty &&
                      alternative2Controller.text.isNotEmpty && alternative3Controller.text.isNotEmpty &&
                      alternative4Controller.text.isNotEmpty) {
                    indicatorQ -= 1;
                    setState(() {
                      print("ENTROO");
                      //widgetQuestion.removeRange(0, 6);
                      doubleListQuestion.removeAt(0);
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Agregar la pregunta y sus alternativas para eliminar"),
                    ));
                  }
                },
                icon: Icon(Icons.delete, color: Colors.red)
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.circle_outlined, color: Colors.purple, size: 30),
            const SizedBox(
              width: 15,
            ),
            Expanded(
                child: TextFormField(
                  controller: alternative1Controller,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Alternativa 1',
                      labelStyle: TextStyle(
                        color: AppColors.labelTextTematicaColor,
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.borderTematicaColor,
                          )),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.borderFocusedTematicaColor,
                          ))),
                  style: TextStyle(color: AppColors.textTematicaColor),
                )
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.circle_outlined, color: Colors.purple, size: 30),
            const SizedBox(
              width: 15,
            ),
            Expanded(
                child: TextFormField(
                  controller: alternative2Controller,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Alternativa 2',
                      labelStyle: TextStyle(
                        color: AppColors.labelTextTematicaColor,
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.borderTematicaColor,
                          )),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.borderFocusedTematicaColor,
                          ))),
                  style: TextStyle(color: AppColors.textTematicaColor),
                )
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.circle_outlined, color: Colors.purple, size: 30),
            const SizedBox(
              width: 15,
            ),
            Expanded(
                child: TextFormField(
                  controller: alternative3Controller,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Alternativa 3',
                      labelStyle: TextStyle(
                        color: AppColors.labelTextTematicaColor,
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.borderTematicaColor,
                          )),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.borderFocusedTematicaColor,
                          ))),
                  style: TextStyle(color: AppColors.textTematicaColor),
                )
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.circle_outlined, color: Colors.purple, size: 30),
            const SizedBox(
              width: 15,
            ),
            Expanded(
                child: TextFormField(
                  controller: alternative4Controller,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Alternativa 4',
                      labelStyle: TextStyle(
                        color: AppColors.labelTextTematicaColor,
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.borderTematicaColor,
                          )),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.borderFocusedTematicaColor,
                          ))),
                  style: TextStyle(color: AppColors.textTematicaColor),
                )
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    ];
  }

  Future getAllContentsV() async {
    var params = {
      "data": {
        "idThematicUnit": dropdownValue
      }
    };
    _future2 = rest.RestProvider().callMethod("/cntc/fabtui", params);
    _future2.then((value) => {
      _contentsV = shared.SharedService().getContents(value),
      print("GETALL " + _contentsV.length.toString()),
    });
  }

  Future getAllContentsI() async {
    var params = {
      "data": {
        "idThematicUnit": dropdownValue
      }
    };
    _future3 = rest.RestProvider().callMethod("/cntc/fabtui", params);
    _future3.then((value) => {
      _contentsI = shared.SharedService().getContents(value),
      print("GETALL " + _contentsI.length.toString()),
    });
  }

  Future filterV(String multimedia, String position, String name) async {
    var params = {
      "data": {
        "idThematicUnit": idThematic
      }
    };
    _future2 = rest.RestProvider().callMethod("/cntc/fabtui", params);
    _future2.then((value) => {
      _contentsV = shared.SharedService().getContents(value),
      for (ContentModel c in _contentsV) {
        print("LONGITUD ${_contentsV.length}"),
        if ( c.multimedia == multimedia && c.posicion.toString() == position
            && c.contentName == name && c.idThematicUnit == idThematic) {
          filterContentV.add(c),
          print(filterContentV[0].toJson().toString()),
        } else {
          print("AQUI NOOO"),
        }
      },

    deleteContentV(filterContentV[0].idContent.toString()),
    filterContentV.clear(),
    });
  }

  Future filterI(String multimedia, String position, String name) async {
    var params = {
      "data": {
        "idThematicUnit": idThematic
      }
    };
    _future3 = rest.RestProvider().callMethod("/cntc/fabtui", params);
    _future3.then((value) => {
      _contentsI = shared.SharedService().getContents(value),
      for (ContentModel c in _contentsI) {
        print("LONGITUD ${_contentsI.length}"),
        if ( c.multimedia == multimedia && c.posicion.toString() == position
            && c.contentName == name && c.idThematicUnit == idThematic) {
          filterContentI.add(c),
          print(filterContentI[0].toJson().toString()),
        } else {
          print("AQUI NOOO"),
        }
      },

      deleteContentI(filterContentI[0].idContent.toString()),
      filterContentI.clear(),
    });
  }

  saveThematic(String nameThematic, int idCategory, String description, String portrait, int nivel, int minCalification, int starRate, int nTime, int nBadge) async {

    if (nameThematic.isNotEmpty && description.isNotEmpty && portrait.isNotEmpty && idCategory.toString().isNotEmpty
    && nivel.toString().isNotEmpty && minCalification.toString().isNotEmpty && starRate.toString().isNotEmpty
    && nTime.toString().isNotEmpty && nBadge.toString().isNotEmpty) {
      var params = {
        "data": {
          "thematicUnitName": nameThematic,
          "idCategory": idCategory,
          "description": description,
          "portrait": "https://bit.ly/3L70FMi",
          "nivel": nivel,
          "minCalification": minCalification,
          "starRate": starRate,
          "nTime": nTime,
          "nBadge": nBadge
        }
      };

      rest.RestProvider().callMethod("/tuc/stu", params).then((res) {
        print("Successful: ${res.statusCode}");
        statusSave = 200;
        var enc = jsonEncode(res.data);
        var dat = jsonDecode(enc);
        //ThematicUnitModel t = res.data;
        //print("AQUI"+ t.idThematicUnit.toString());
        ThematicUnitModel thematic = ThematicUnitModel.fromJson(res.data["data"]);
        //ThematicUnitModel the = dat["data"];
        //idThematic = dat["data"]["idThematicUnit"];
        idThematic = thematic.idThematicUnit;
        print("IDDDDD"+ dat["data"].toString());
        setState((){

        });
      }).catchError((err) {
        print("Failed: ${ err }");
      });
    } else {
      print("Completar los campos requeridos");
      statusSave = 400;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Completar todos los campos para continuar"),
      ));
    }

  }

  saveContentV(String contentName, int idThematicUnit, String posicion, String multimedia) {

    var params = {
      "data": {
        "contentName": contentName,
        "idThematicUnit": idThematicUnit,
        "posicion": posicion,
        "multimedia": multimedia,
      }
    };

    rest.RestProvider().callMethod("/cntc/sc", params).then((res) {
      print("Successful: ${res.statusCode}");
      var enc = jsonEncode(res.data);
      var dat = jsonDecode(enc);
      idVideo = dat["data"]["idContent"];
      var nameVideo = dat["data"]["contentName"];
      idsVideos[idVideo] = nameVideo;
      // var id = dat["data"]["idContent"];
      // print("IDDD + " + id.toString());
    }).catchError((err) {
      print("Failed: ${ err }");
    });

  }

  saveContentI(String contentName, int idThematicUnit, String posicion, String multimedia) {

    var params = {
      "data": {
        "contentName": contentName,
        "idThematicUnit": idThematicUnit,
        "posicion": posicion,
        "multimedia": multimedia,
      }
    };

    rest.RestProvider().callMethod("/cntc/sc", params).then((res) {
      print("Successful: ${res.statusCode}");
    }).catchError((err) {
      print("Failed: ${ err }");
    });

  }

  deleteContentV(String idContent) {
    var params = {
      "data": {
        "idContent": idContent
      }
    };

    rest.RestProvider().callMethod("/cntc/del", params).then((res) {
      print("Successful: ${res.statusCode}");
    }).catchError((err) {
      print("Failed: ${ err }");
    });
  }

  deleteContentI(String idContent) {
    var params = {
      "data": {
        "idContent": idContent
      }
    };

    rest.RestProvider().callMethod("/cntc/del", params).then((res) {
      print("Successful: ${res.statusCode}");
    }).catchError((err) {
      print("Failed: ${ err }");
    });
  }

  addRowV(TextEditingController linkAddContentController, TextEditingController nameAddContentController, TextEditingController positionAddContentController) {
    indicatorV += 1;
    widgetV.add(TextFormField(
      controller: linkAddContentController,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: 'Enlace',
          labelStyle: TextStyle(
            color: AppColors.labelTextTematicaColor,
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.borderTematicaColor,
              )),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.borderFocusedTematicaColor,
              ))),
      style: TextStyle(color: AppColors.textTematicaColor),
    ));
    widgetV.add(TextFormField(
      controller: nameAddContentController,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: 'Nombre',
          labelStyle: TextStyle(
            color: AppColors.labelTextTematicaColor,
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.borderTematicaColor,
              )),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.borderFocusedTematicaColor,
              ))),
      style: TextStyle(color: AppColors.textTematicaColor),
    ));
    widgetV.add(TextFormField(
      controller: positionAddContentController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: 'Posicion',
          labelStyle: TextStyle(
            color: AppColors.labelTextTematicaColor,
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.borderTematicaColor,
              )),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.borderFocusedTematicaColor,
              ))),
      style: TextStyle(color: AppColors.textTematicaColor),
    ));
    widgetV.add(Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: IconButton(
        icon: const Icon(Icons.delete, color: Colors.red),
        iconSize: 25,
        onPressed: () {
          if (linkAddContentController.text.isNotEmpty && positionAddContentController.text.isNotEmpty && nameAddContentController.text.isNotEmpty) {
            idsD.add(idVideo);
            idsVideos.remove(idVideo);
            filterContentV;
            setState(() {
              filterV(linkAddContentController.text, positionAddContentController.text, nameAddContentController.text);
              linkAddContentController.text = "";
              positionAddContentController.text = "";
              nameAddContentController.text = "";
              widgetV.removeLast();
              widgetV.removeLast();
              widgetV.removeLast();
              widgetV.removeLast();
              filterContentV;
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Agrega la fila para eliminar"),
            ));
          }
        },
      ),
    ));
    setState(() {
      getAllContentsV();
      _contentsV;
    });
  }

  addRowI(TextEditingController linkAddContentController, TextEditingController nameAddContentController, TextEditingController positionAddContentController) {
    indicatorI += 1;
    widgetI.add(TextFormField(
      controller: linkAddContentController,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: 'Enlace',
          labelStyle: TextStyle(
            color: AppColors.labelTextTematicaColor,
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.borderTematicaColor,
              )),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.borderFocusedTematicaColor,
              ))),
      style: TextStyle(color: AppColors.textTematicaColor),
    ));
    widgetI.add(TextFormField(
      controller: nameAddContentController,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: 'Nombre',
          labelStyle: TextStyle(
            color: AppColors.labelTextTematicaColor,
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.borderTematicaColor,
              )),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.borderFocusedTematicaColor,
              ))),
      style: TextStyle(color: AppColors.textTematicaColor),
    ));
    widgetI.add(TextFormField(
      controller: positionAddContentController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: 'Posicion',
          labelStyle: TextStyle(
            color: AppColors.labelTextTematicaColor,
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.borderTematicaColor,
              )),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.borderFocusedTematicaColor,
              ))),
      style: TextStyle(color: AppColors.textTematicaColor),
    ));
    widgetI.add(Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: IconButton(
        icon: const Icon(Icons.delete, color: Colors.red),
        iconSize: 25,
        onPressed: () {
          if (linkAddContentController.text.isNotEmpty && positionAddContentController.text.isNotEmpty && nameAddContentController.text.isNotEmpty) {
            filterContentI;
            setState(() {
              filterI(linkAddContentController.text, positionAddContentController.text, nameAddContentController.text);
              linkAddContentController.text = "";
              positionAddContentController.text = "";
              nameAddContentController.text = "";
              widgetI.removeLast();
              widgetI.removeLast();
              widgetI.removeLast();
              widgetI.removeLast();
              filterContentI;
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Agrega la fila para eliminar"),
            ));
          }
        },
      ),
    ));
    setState(() {
      getAllContentsI();
      _contentsI;
    });
  }

  addQuestion(TextEditingController questController, TextEditingController alt1Controller, TextEditingController alt2Controller, TextEditingController alt3Controller, TextEditingController alt4Controller) {
    indicatorQ += 1;
    doubleListQuestion.add([
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.question_answer, color: Colors.purple, size: 30),
          const SizedBox(
            width: 15,
          ),
          Expanded(
              child: TextFormField(
                controller: questController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Pregunta',
                    labelStyle: TextStyle(
                      color: AppColors.labelTextTematicaColor,
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.borderTematicaColor,
                        )),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.borderFocusedTematicaColor,
                        ))),
                style: TextStyle(color: AppColors.textTematicaColor),
              )
          ),
          IconButton(
              onPressed: () {
                //eliminated = true;
                indicatorQ -= 1;
                if (questController.text.isNotEmpty && alt1Controller.text.isNotEmpty &&
                    alt2Controller.text.isNotEmpty && alt3Controller.text.isNotEmpty &&
                    alt4Controller.text.isNotEmpty) {
                  setState(() {
                    print("TAMBIEN ENTROO");
                    //widgetQuestion.removeRange((indicatorQ)*6, (indicatorQ)*6 + 6);
                    doubleListQuestion.removeAt(indicatorQ);
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Agregar la pregunta y sus alternativas para eliminar"),
                  ));
                }
              },
              icon: Icon(Icons.delete, color: Colors.red)
          ),
        ],
      ),
      const SizedBox(
        height: 10,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.circle_outlined, color: Colors.purple, size: 30),
          const SizedBox(
            width: 15,
          ),
          Expanded(
              child: TextFormField(
                controller: alt1Controller,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Alternativa 1',
                    labelStyle: TextStyle(
                      color: AppColors.labelTextTematicaColor,
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.borderTematicaColor,
                        )),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.borderFocusedTematicaColor,
                        ))),
                style: TextStyle(color: AppColors.textTematicaColor),
              )
          ),
        ],
      ),
      const SizedBox(
        height: 10,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.circle_outlined, color: Colors.purple, size: 30),
          const SizedBox(
            width: 15,
          ),
          Expanded(
              child: TextFormField(
                controller: alt2Controller,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Alternativa 2',
                    labelStyle: TextStyle(
                      color: AppColors.labelTextTematicaColor,
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.borderTematicaColor,
                        )),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.borderFocusedTematicaColor,
                        ))),
                style: TextStyle(color: AppColors.textTematicaColor),
              )
          ),
        ],
      ),
      const SizedBox(
        height: 10,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.circle_outlined, color: Colors.purple, size: 30),
          const SizedBox(
            width: 15,
          ),
          Expanded(
              child: TextFormField(
                controller: alt3Controller,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Alternativa 3',
                    labelStyle: TextStyle(
                      color: AppColors.labelTextTematicaColor,
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.borderTematicaColor,
                        )),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.borderFocusedTematicaColor,
                        ))),
                style: TextStyle(color: AppColors.textTematicaColor),
              )
          ),
        ],
      ),
      const SizedBox(
        height: 10,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.circle_outlined, color: Colors.purple, size: 30),
          const SizedBox(
            width: 15,
          ),
          Expanded(
              child: TextFormField(
                controller: alt4Controller,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Alternativa 4',
                    labelStyle: TextStyle(
                      color: AppColors.labelTextTematicaColor,
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.borderTematicaColor,
                        )),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.borderFocusedTematicaColor,
                        ))),
                style: TextStyle(color: AppColors.textTematicaColor),
              )
          ),
        ],
      ),
      const SizedBox(
        height: 10,
      ),
    ]);


    // widgetQuestion.add(Row(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   children: [
    //     const Icon(Icons.question_answer, color: Colors.purple, size: 30),
    //     const SizedBox(
    //       width: 15,
    //     ),
    //     Expanded(
    //         child: TextFormField(
    //           controller: questController,
    //           keyboardType: TextInputType.text,
    //           decoration: InputDecoration(
    //               border: const OutlineInputBorder(),
    //               labelText: 'Pregunta',
    //               labelStyle: TextStyle(
    //                 color: AppColors.labelTextTematicaColor,
    //               ),
    //               enabledBorder: OutlineInputBorder(
    //                   borderSide: BorderSide(
    //                     color: AppColors.borderTematicaColor,
    //                   )),
    //               focusedBorder: OutlineInputBorder(
    //                   borderSide: BorderSide(
    //                     color: AppColors.borderFocusedTematicaColor,
    //                   ))),
    //           style: TextStyle(color: AppColors.textTematicaColor),
    //         )
    //     ),
    //     IconButton(
    //         onPressed: () {
    //           //eliminated = true;
    //           indicatorQ -= 1;
    //           if (questController.text.isNotEmpty && alt1Controller.text.isNotEmpty &&
    //               alt2Controller.text.isNotEmpty && alt3Controller.text.isNotEmpty &&
    //               alt4Controller.text.isNotEmpty) {
    //             setState(() {
    //               print("TAMBIEN ENTROO");
    //               widgetQuestion.removeRange((indicatorQ)*6, (indicatorQ)*6 + 6);
    //             });
    //           } else {
    //             ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //               content: Text("Agregar la pregunta y sus alternativas para eliminar"),
    //             ));
    //           }
    //         },
    //         icon: Icon(Icons.delete, color: Colors.red)
    //     ),
    //   ],
    // ));
    // widgetQuestion.add(Row(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   children: [
    //     const Icon(Icons.circle_outlined, color: Colors.purple, size: 30),
    //     const SizedBox(
    //       width: 15,
    //     ),
    //     Expanded(
    //         child: TextFormField(
    //           controller: alt1Controller,
    //           keyboardType: TextInputType.text,
    //           decoration: InputDecoration(
    //               border: const OutlineInputBorder(),
    //               labelText: 'Alternativa 1',
    //               labelStyle: TextStyle(
    //                 color: AppColors.labelTextTematicaColor,
    //               ),
    //               enabledBorder: OutlineInputBorder(
    //                   borderSide: BorderSide(
    //                     color: AppColors.borderTematicaColor,
    //                   )),
    //               focusedBorder: OutlineInputBorder(
    //                   borderSide: BorderSide(
    //                     color: AppColors.borderFocusedTematicaColor,
    //                   ))),
    //           style: TextStyle(color: AppColors.textTematicaColor),
    //         )
    //     ),
    //   ],
    // ));
    // widgetQuestion.add(Row(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   children: [
    //     const Icon(Icons.circle_outlined, color: Colors.purple, size: 30),
    //     const SizedBox(
    //       width: 15,
    //     ),
    //     Expanded(
    //         child: TextFormField(
    //           controller: alt2Controller,
    //           keyboardType: TextInputType.text,
    //           decoration: InputDecoration(
    //               border: const OutlineInputBorder(),
    //               labelText: 'Alternativa 2',
    //               labelStyle: TextStyle(
    //                 color: AppColors.labelTextTematicaColor,
    //               ),
    //               enabledBorder: OutlineInputBorder(
    //                   borderSide: BorderSide(
    //                     color: AppColors.borderTematicaColor,
    //                   )),
    //               focusedBorder: OutlineInputBorder(
    //                   borderSide: BorderSide(
    //                     color: AppColors.borderFocusedTematicaColor,
    //                   ))),
    //           style: TextStyle(color: AppColors.textTematicaColor),
    //         )
    //     ),
    //   ],
    // ));
    // widgetQuestion.add(Row(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   children: [
    //     const Icon(Icons.circle_outlined, color: Colors.purple, size: 30),
    //     const SizedBox(
    //       width: 15,
    //     ),
    //     Expanded(
    //         child: TextFormField(
    //           controller: alt3Controller,
    //           keyboardType: TextInputType.text,
    //           decoration: InputDecoration(
    //               border: const OutlineInputBorder(),
    //               labelText: 'Alternativa 3',
    //               labelStyle: TextStyle(
    //                 color: AppColors.labelTextTematicaColor,
    //               ),
    //               enabledBorder: OutlineInputBorder(
    //                   borderSide: BorderSide(
    //                     color: AppColors.borderTematicaColor,
    //                   )),
    //               focusedBorder: OutlineInputBorder(
    //                   borderSide: BorderSide(
    //                     color: AppColors.borderFocusedTematicaColor,
    //                   ))),
    //           style: TextStyle(color: AppColors.textTematicaColor),
    //         )
    //     ),
    //   ],
    // ));
    // widgetQuestion.add(Row(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   children: [
    //     const Icon(Icons.circle_outlined, color: Colors.purple, size: 30),
    //     const SizedBox(
    //       width: 15,
    //     ),
    //     Expanded(
    //         child: TextFormField(
    //           controller: alt4Controller,
    //           keyboardType: TextInputType.text,
    //           decoration: InputDecoration(
    //               border: const OutlineInputBorder(),
    //               labelText: 'Alternativa 4',
    //               labelStyle: TextStyle(
    //                 color: AppColors.labelTextTematicaColor,
    //               ),
    //               enabledBorder: OutlineInputBorder(
    //                   borderSide: BorderSide(
    //                     color: AppColors.borderTematicaColor,
    //                   )),
    //               focusedBorder: OutlineInputBorder(
    //                   borderSide: BorderSide(
    //                     color: AppColors.borderFocusedTematicaColor,
    //                   ))),
    //           style: TextStyle(color: AppColors.textTematicaColor),
    //         )
    //     ),
    //   ],
    // ));
    // widgetQuestion.add(const SizedBox(
    //   height: 10,
    // ));

  }

  saveExam(String idThematicUnit, String idContent, String nExamen) {
    var params = {
      "data": {
        "idThematicUnit": idThematicUnit,
        "idContent": idContent,
        "nExamen": nExamen,
      }
    };

    rest.RestProvider().callMethod("/cntc/sc", params).then((res) {
      print("Successful: ${res.statusCode}");
    }).catchError((err) {
      print("Failed: ${ err }");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),

      body: Column(
        children: [
          Expanded(
            child: Stepper(
              type: stepperType,
              physics: const ScrollPhysics(),
              currentStep: _currentStep,
              onStepTapped: (step) => tapped(step),
              // onStepContinue:  continued,
              // onStepCancel: cancel,
              controlsBuilder: (context, _) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                      onPressed: () {
                          if (_currentStep == 0) {
                            if (statusSave == 200) {
                              continued1();
                              statusSave = 0;
                            } else {
                              //COMENTAR
                              continued1();
                              statusSave = 0;
                            }
                          } else if (_currentStep == 1) {
                            if (indicatorV > 0) {
                              continued2();
                            } else {
                              //COMENTAR
                              print("NOPUEDESENTRAR");
                              continued2();
                            }
                          } else {
                            continued3();
                          }
                        },
                      child: const Text('Continuar', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                    ),
                    TextButton(
                      onPressed: (){
                        if (_currentStep == 0) {
                          cancel1();
                        } else if (_currentStep == 1) {
                          cancel2();
                        } else {
                          cancel3();
                        }
                      },
                      child: const Text('Salir', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                    ),
                  ],
                );
              },
              steps: <Step>[
                Step(
                  title: new Text('Temática'),
                  content: Column(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        controller: nameThematicController,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: 'Nombre',
                            labelStyle: TextStyle(
                              color: AppColors.labelTextTematicaColor,
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.borderTematicaColor,
                                )),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.borderFocusedTematicaColor,
                                ))),
                        style: TextStyle(color: AppColors.textTematicaColor),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: descriptionController,
                        keyboardType: TextInputType.name,
                        maxLines: 3,
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: 'Descripción',
                            labelStyle: TextStyle(
                              color: AppColors.labelTextTematicaColor,
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.borderTematicaColor,
                                )),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.borderFocusedTematicaColor,
                                ))),
                        style: TextStyle(color: AppColors.textTematicaColor),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: portraitController,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: 'Fondo',
                            labelStyle: TextStyle(
                              color: AppColors.labelTextTematicaColor,
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.borderTematicaColor,
                                )),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.borderFocusedTematicaColor,
                                ))),
                        style: TextStyle(color: AppColors.textTematicaColor),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text('ID Categoria', style: TextStyle(color: AppColors.labelTextTematicaColor)),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: nivelController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  labelText: 'Nivel',
                                  labelStyle: TextStyle(
                                    color: AppColors.labelTextTematicaColor,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: AppColors.borderTematicaColor,
                                      )),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: AppColors.borderFocusedTematicaColor,
                                      ))),
                              style: TextStyle(color: AppColors.textTematicaColor),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          FutureBuilder(
                              future: _future,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return SizedBox(
                                    height: 60,
                                    child: DropdownButton(
                                      value: dropdownValue,
                                      // icon: const Icon(Icons.arrow_downward),
                                      // elevation: 16,
                                      style: TextStyle(color: AppColors.labelTextTematicaColor, fontSize: 16),
                                      underline: Container(
                                        height: 2,
                                        color: AppColors.borderFocusedTematicaColor,
                                      ),


                                      icon: const Icon(Icons.expand_more),
                                      iconEnabledColor: Colors.purple,
                                      iconSize: 24,
                                      elevation: 16,
                                      hint: Center(
                                          child: Text(
                                            'CategoryId',
                                            style: TextStyle(color: AppColors.labelTextTematicaColor),
                                          )),
                                      onChanged: (value) {
                                        // if (dropdownValue == "ID Category") {
                                        //   idsCategories.removeAt(0);
                                        //   setState(() {
                                        //
                                        //   });
                                        // }
                                        // This is called when the user selects an item.
                                        setState(() {
                                          dropdownValue = value!;
                                          idsCategories;
                                        });
                                      },
                                      items: idsCategories.map((value) {
                                        return DropdownMenuItem(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                  );
                                } else {
                                  return const CircularProgressIndicator();
                                }
                              }
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: minCalificationController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  labelText: 'Calificacion',
                                  labelStyle: TextStyle(
                                    color: AppColors.labelTextTematicaColor,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: AppColors.borderTematicaColor,
                                      )),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: AppColors.borderFocusedTematicaColor,
                                      ))),
                              style: TextStyle(color: AppColors.textTematicaColor),
                              textAlign: TextAlign.justify,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: starRateController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  labelText: 'Estrella',
                                  labelStyle: TextStyle(
                                    color: AppColors.labelTextTematicaColor,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: AppColors.borderTematicaColor,
                                      )),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: AppColors.borderFocusedTematicaColor,
                                      ))),
                              style: TextStyle(color: AppColors.textTematicaColor),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: nTimeController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  labelText: 'Tiempo',
                                  labelStyle: TextStyle(
                                    color: AppColors.labelTextTematicaColor,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: AppColors.borderTematicaColor,
                                      )),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: AppColors.borderFocusedTematicaColor,
                                      ))),
                              style: TextStyle(color: AppColors.textTematicaColor),
                              textAlign: TextAlign.justify,
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: nBagdeController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  labelText: 'Insignia',
                                  labelStyle: TextStyle(
                                    color: AppColors.labelTextTematicaColor,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: AppColors.borderTematicaColor,
                                      )),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: AppColors.borderFocusedTematicaColor,
                                      ))),
                              style: TextStyle(color: AppColors.textTematicaColor),
                              textAlign: TextAlign.justify,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                    ],
                  ),
                  isActive: _currentStep >= 0,
                  state: _currentStep >= 0 ?
                  StepState.complete : StepState.disabled,
                ),
                Step(
                  title: const Text('Contenido'),
                  content: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: <Widget>[
                        const Text("Videos", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20)),

                        const SizedBox(
                          height: 30,
                        ),

                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Enlace", style: TextStyle(color: AppColors.textCategoriaColor, fontWeight: FontWeight.w900)),
                              SizedBox(
                                width: MediaQuery.of(context).size.width*0.1,
                              ),
                              Text("Nombre", style: TextStyle(color: AppColors.textCategoriaColor, fontWeight: FontWeight.w900)),
                              SizedBox(
                                width: MediaQuery.of(context).size.width*0.1,
                              ),
                              Text("Posicion", style: TextStyle(color: AppColors.textCategoriaColor, fontWeight: FontWeight.w900)),
                              SizedBox(
                                width: MediaQuery.of(context).size.width*0.1,
                              ),
                              IconButton(
                                icon: const Icon(Icons.add, color: Colors.green),
                                iconSize: 20,
                                onPressed: () {
                                  if (indicatorV == 0){
                                    if (linkContentControllerV.text.isNotEmpty && nameContentControllerV.text.isNotEmpty && positionContentControllerV.text.isNotEmpty) {
                                      saveContentV(nameContentControllerV.text, idThematic, positionContentControllerV.text, linkContentControllerV.text);
                                      listControllerV.add(TextEditingController());
                                      listControllerV.add(TextEditingController());
                                      listControllerV.add(TextEditingController());
                                      addRowV(listControllerV[0], listControllerV[1], listControllerV[2]);
                                      getAllContentsV();
                                      setState(() {
                                        getAllContentsV();
                                        _contentsV;
                                      });
                                      print("CONTENIDO " + _contentsV.length.toString());
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                        content: Text("Completar todos los campos para agregar una fila"),
                                      ));
                                    }
                                  } else {
                                    print("ENTRA ELSE");
                                    if (listControllerV[(indicatorV-1)*3].text.isNotEmpty && listControllerV[(indicatorV-1)*3+1].text.isNotEmpty && listControllerV[(indicatorV-1)*3+2].text.isNotEmpty) {
                                      print("ENTRA IF");
                                      saveContentV(listControllerV[(indicatorV-1)*3+1].text, idThematic, listControllerV[(indicatorV-1)*3+2].text, listControllerV[(indicatorV-1)*3].text);
                                      listControllerV.add(TextEditingController());
                                      listControllerV.add(TextEditingController());
                                      listControllerV.add(TextEditingController());
                                      addRowV(listControllerV[indicatorV*3], listControllerV[indicatorV*3+1], listControllerV[indicatorV*3+2]);
                                      getAllContentsV();
                                      setState(() {
                                        getAllContentsV();
                                        _contentsV;
                                      });
                                      print("CONTENIDO " + _contentsV.length.toString());
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                        content: Text("Completar todos los campos para agregar una fila"),
                                      ));
                                    }
                                  }
                                },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(
                          height: 5,
                        ),

                        SizedBox(
                          height: 200,
                          child: GridView.count(
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 5,
                              crossAxisCount: 4,
                              children: List.generate(widgetV.length, (index) {
                                return Container (
                                  child: widgetV[index],
                                );
                              })
                          ),
                        ),

                        const SizedBox(
                          height: 5,
                        ),

                        const Text("Imagenes", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20)),

                        const SizedBox(
                          height: 30,
                        ),

                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Enlace", style: TextStyle(color: AppColors.textCategoriaColor, fontWeight: FontWeight.w900)),
                              SizedBox(
                                width: MediaQuery.of(context).size.width*0.1,
                              ),
                              Text("Nombre", style: TextStyle(color: AppColors.textCategoriaColor, fontWeight: FontWeight.w900)),
                              SizedBox(
                                width: MediaQuery.of(context).size.width*0.1,
                              ),
                              Text("Posicion", style: TextStyle(color: AppColors.textCategoriaColor, fontWeight: FontWeight.w900)),
                              SizedBox(
                                width: MediaQuery.of(context).size.width*0.1,
                              ),
                              IconButton(
                                icon: const Icon(Icons.add, color: Colors.green),
                                iconSize: 20,
                                onPressed: () {
                                  if (indicatorI == 0){
                                    if (linkContentControllerI.text.isNotEmpty && nameContentControllerI.text.isNotEmpty && positionContentControllerI.text.isNotEmpty) {
                                      saveContentI(nameContentControllerI.text, idThematic, positionContentControllerI.text, linkContentControllerI.text);
                                      listControllerI.add(TextEditingController());
                                      listControllerI.add(TextEditingController());
                                      listControllerI.add(TextEditingController());
                                      addRowI(listControllerI[0], listControllerI[1], listControllerI[2]);
                                      getAllContentsI();
                                      setState(() {
                                        getAllContentsI();
                                        _contentsI;
                                      });
                                      print("CONTENIDO " + _contentsI.length.toString());
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                        content: Text("Completar todos los campos para agregar una fila"),
                                      ));
                                    }
                                  } else {
                                    if (listControllerI[(indicatorI-1)*3].text.isNotEmpty && listControllerI[(indicatorI-1)*3+1].text.isNotEmpty && listControllerI[(indicatorI-1)*3+2].text.isNotEmpty) {
                                      saveContentI(listControllerI[(indicatorI-1)*3+1].text, idThematic, listControllerI[(indicatorI-1)*3+2].text, listControllerI[(indicatorI-1)*3].text);
                                      listControllerI.add(TextEditingController());
                                      listControllerI.add(TextEditingController());
                                      listControllerI.add(TextEditingController());
                                      addRowI(listControllerI[indicatorI*3], listControllerI[indicatorI*3+1], listControllerI[indicatorI*3+2]);
                                      getAllContentsI();
                                      setState(() {
                                        getAllContentsI();
                                        _contentsI;
                                      });
                                      print("CONTENIDO " + _contentsI.length.toString());
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                        content: Text("Completar todos los campos para agregar una fila"),
                                      ));
                                    }
                                  }
                                },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(
                          height: 5,
                        ),

                        SizedBox(
                          height: 200,
                          child: GridView.count(
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 5,
                              crossAxisCount: 4,
                              children: List.generate(widgetI.length, (index) {
                                return Container (
                                  child: widgetI[index],
                                );
                              })
                          ),
                        ),

                      ],
                    ),
                  ),
                  isActive: _currentStep >= 0,
                  state: _currentStep >= 1 ?
                  StepState.complete : StepState.disabled,
                ),
                Step(
                  title: new Text('Preguntas'),
                  content: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("QUESTIONARIO", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24)),
                          IconButton(
                              onPressed: () {
                                if (indicatorQ >= 0 && questionController.text.isNotEmpty && alternative1Controller.text.isNotEmpty
                                && alternative2Controller.text.isNotEmpty && alternative3Controller.text.isNotEmpty
                                && alternative4Controller.text.isNotEmpty) {
                                  addQuestion(TextEditingController(), TextEditingController(), TextEditingController(), TextEditingController(), TextEditingController());
                                  print("FILTRO VIDEO" + _contentsV.length.toString());
                                  setState(() {
                                    //widgetQuestion;
                                    doubleListQuestion;
                                  });
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                    content: Text("Completar todos los campos para agregar una pregunta"),
                                  ));
                                }

                              },
                              icon: const Icon(Icons.add_box, color: Colors.green),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 30,
                      ),

                      for (int i = 0; i < idsVideos.length; i++)
                        SizedBox(
                        height: 400,
                        child: GridView.count(
                            childAspectRatio: 1,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                            crossAxisCount: 1,
                            children: List.generate(doubleListQuestion.length, (index) {
                                return SingleChildScrollView (
                                child: Column(
                                  children: [
                                    Text('Video $i', style: const TextStyle(fontWeight: FontWeight.w900)),
                                    SizedBox(height: 10),
                                    Column(
                                      children: List.generate(doubleListQuestion[index].length, (aux) {
                                        return Container(
                                          child: doubleListQuestion[index][aux],
                                        );
                                      }),
                                    )
                                  ]
                                )
                              );
                            })
                            // children: List.generate(widgetQuestion.length, (index) {
                            //   return Container (
                            //     child: widgetQuestion[index],
                            //   );
                            // })
                        ),
                      ),

                      Text(idsD.toString() + "ELIMIANDOS"),
                      Text(idsVideos.toString() + "TODOS"),

                    ],
                  ),
                  isActive:_currentStep >= 0,
                  state: _currentStep >= 2 ?
                  StepState.complete : StepState.disabled,
                ),
              ],
            ),
          ),
        ],
      ),
      //backgroundColor: Colors.white,
    );
  }
  tapped(int step){
    setState(() => _currentStep = step);
  }

  continued1(){
    _currentStep < 3 ?
    setState(() => _currentStep += 1): null;
    int idCat = int.parse(dropdownValue);
    saveThematic(nameThematicController.text, idCat, descriptionController.text, portraitController.text, int.parse(nivelController.text), int.parse(minCalificationController.text), int.parse(starRateController.text), int.parse(nTimeController.text), int.parse(nBagdeController.text));

    // setState(() {
    //   _currentStep += 1;
    // });
     print('HOLa');
  }

  continued2(){
    _currentStep < 3 ?
    setState(() => _currentStep += 1): null;
    // setState(() {
    //   _currentStep += 1;
    // });

    // idsVideos.forEach((k, v) {
    //   saveExam(idThematic.toString(), k.toString(), v);
    // });

    print('QUE TAL THEMTIC + ' + idThematic.toString());
  }

  continued3(){
    _currentStep < 3 ?
    setState(() => _currentStep += 0): null;
    // setState(() {
    //   _currentStep += 1;
    // });
    //thematic.status = 1;
     print('HOLAAA');
  }

  cancel1(){
    _currentStep > 0 ?
    setState(() => _currentStep -= 0) : null;
  }

  cancel2(){
    _currentStep > 0 ?
    setState(() => _currentStep -= 1) : null;
  }

  cancel3(){
    _currentStep > 0 ?
    setState(() => _currentStep -= 1) : null;
  }

}

