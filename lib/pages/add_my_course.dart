import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lexp/core/res/color.dart';
import 'package:lexp/core/routes/routes.dart';
import 'package:lexp/models/category.dart';
import 'package:lexp/models/content.dart';
import 'package:lexp/models/thematic_unit.dart';
import 'package:lexp/services/rest_provider.dart' as rest;
import 'package:lexp/services/shared_service.dart' as shared;

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
  final TextEditingController answerController = TextEditingController();
  
  final List<TextEditingController> listQuestionController = [];
  final List<TextEditingController> listAlternative1Controller = [];
  final List<TextEditingController> listAlternative2Controller = [];
  final List<TextEditingController> listAlternative3Controller = [];
  final List<TextEditingController> listAlternative4Controller = [];
  final List<TextEditingController> listAnswerController = [];

  late List<List<TextEditingController>> doubleListQuestionController = [[]];
  late List<List<TextEditingController>> doubleListAlternative1Controller = [[]];
  late List<List<TextEditingController>> doubleListAlternative2Controller = [[]];
  late List<List<TextEditingController>> doubleListAlternative3Controller = [[]];
  late List<List<TextEditingController>> doubleListAlternative4Controller = [[]];
  late List<List<TextEditingController>> doubleListAnswerController = [[]];
  late List<List<int>> doubleListIndicatorQ = [[]];

  int statusSave = 0;
  int indicatorV = 0;
  int indicatorI = 0;
  int indicatorQ = 0;
  List<int> listIndicatorQ = [];
  bool eliminated = false;

  late List<Widget> widgetV;
  late List<Widget> widgetI;
  late List<Widget> widgetQuestion;
  late List<List<Widget>> doubleListQuestion = [[]];
  late List<List<int>> idsQuestions = [[]];

  int idThematic = 0;
  //int statusThematic = 0;
  late ThematicUnitModel thematicData;
  Map<int, String> idsVideos = {};
  List<int> idsExams = [];
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

  }

  Future getAllContentsV() async {
    var params = {
      "data": {
        "idThematicUnit": idThematic
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
        "idThematicUnit": idThematic
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
    print("SAVE THEMATIC");
    if (nameThematic.isNotEmpty && description.isNotEmpty && portrait.isNotEmpty && idCategory.toString().isNotEmpty
    && nivel.toString().isNotEmpty && minCalification.toString().isNotEmpty && starRate.toString().isNotEmpty
    && nTime.toString().isNotEmpty && nBadge.toString().isNotEmpty) {
      var params = {
        "data": {
          "thematicUnitName": nameThematic,
          "idCategory": idCategory,
          "description": description,
          "portrait": portrait,
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
        thematicData = ThematicUnitModel.fromJson(res.data["data"]);
        //ThematicUnitModel the = dat["data"];
        //idThematic = dat["data"]["idThematicUnit"];
        idThematic = thematicData.idThematicUnit;
        thematicData.status = 0;
        print("IDDDDD"+ dat["data"].toString());
        print("IDDDDSS"+ statusSave.toString());

        _currentStep < 3 ?
        setState(() => _currentStep += 1): null;

        setState((){
          statusSave;
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

  addQuestion(TextEditingController questController, TextEditingController alt1Controller, TextEditingController alt2Controller, TextEditingController alt3Controller, TextEditingController alt4Controller, TextEditingController ansController, int cont) {
    //indicatorQ += 1;
    //listIndicatorQ[cont] += 1;
    doubleListIndicatorQ[cont].add(doubleListIndicatorQ[cont].last + 1);
    // doubleListQuestion.add([
    //   Row(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: [
    //       const Icon(Icons.question_answer, color: Colors.purple, size: 25),
    //       const SizedBox(
    //         width: 15,
    //       ),
    //       Expanded(
    //           child: TextFormField(
    //             controller: questController,
    //             keyboardType: TextInputType.text,
    //             decoration: InputDecoration(
    //                 isDense: true,
    //                 border: const OutlineInputBorder(),
    //                 labelText: 'Pregunta',
    //                 labelStyle: TextStyle(
    //                   color: AppColors.labelTextTematicaColor,
    //                 ),
    //                 enabledBorder: OutlineInputBorder(
    //                     borderSide: BorderSide(
    //                       color: AppColors.borderTematicaColor,
    //                     )),
    //                 focusedBorder: OutlineInputBorder(
    //                     borderSide: BorderSide(
    //                       color: AppColors.borderFocusedTematicaColor,
    //                     ))),
    //             style: TextStyle(color: AppColors.textTematicaColor),
    //           )
    //       ),
    //       IconButton(
    //           onPressed: () {
    //             //eliminated = true;
    //             indicatorQ -= 1;
    //             if (questController.text.isNotEmpty && alt1Controller.text.isNotEmpty &&
    //                 alt2Controller.text.isNotEmpty && alt3Controller.text.isNotEmpty &&
    //                 alt4Controller.text.isNotEmpty) {
    //               setState(() {
    //                 print("TAMBIEN ENTROO");
    //                 //widgetQuestion.removeRange((indicatorQ)*6, (indicatorQ)*6 + 6);
    //                 doubleListQuestion.removeAt(indicatorQ);
    //               });
    //             } else {
    //               ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //                 content: Text("Agregar la pregunta y sus alternativas para eliminar"),
    //               ));
    //             }
    //           },
    //           icon: Icon(Icons.delete, color: Colors.red)
    //       ),
    //     ],
    //   ),
    //   const SizedBox(
    //     height: 10,
    //   ),
    //   Row(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: [
    //       const Icon(Icons.circle_outlined, color: Colors.purple, size: 25),
    //       const SizedBox(
    //         width: 15,
    //       ),
    //       Expanded(
    //           child: TextFormField(
    //             controller: alt1Controller,
    //             keyboardType: TextInputType.text,
    //             decoration: InputDecoration(
    //                 isDense: true,
    //                 border: const OutlineInputBorder(),
    //                 labelText: 'Alternativa 1',
    //                 labelStyle: TextStyle(
    //                   color: AppColors.labelTextTematicaColor,
    //                 ),
    //                 enabledBorder: OutlineInputBorder(
    //                     borderSide: BorderSide(
    //                       color: AppColors.borderTematicaColor,
    //                     )),
    //                 focusedBorder: OutlineInputBorder(
    //                     borderSide: BorderSide(
    //                       color: AppColors.borderFocusedTematicaColor,
    //                     ))),
    //             style: TextStyle(color: AppColors.textTematicaColor),
    //           )
    //       ),
    //     ],
    //   ),
    //   const SizedBox(
    //     height: 10,
    //   ),
    //   Row(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: [
    //       const Icon(Icons.circle_outlined, color: Colors.purple, size: 25),
    //       const SizedBox(
    //         width: 15,
    //       ),
    //       Expanded(
    //           child: TextFormField(
    //             controller: alt2Controller,
    //             keyboardType: TextInputType.text,
    //             decoration: InputDecoration(
    //                 isDense: true,
    //                 border: const OutlineInputBorder(),
    //                 labelText: 'Alternativa 2',
    //                 labelStyle: TextStyle(
    //                   color: AppColors.labelTextTematicaColor,
    //                 ),
    //                 enabledBorder: OutlineInputBorder(
    //                     borderSide: BorderSide(
    //                       color: AppColors.borderTematicaColor,
    //                     )),
    //                 focusedBorder: OutlineInputBorder(
    //                     borderSide: BorderSide(
    //                       color: AppColors.borderFocusedTematicaColor,
    //                     ))),
    //             style: TextStyle(color: AppColors.textTematicaColor),
    //           )
    //       ),
    //     ],
    //   ),
    //   const SizedBox(
    //     height: 10,
    //   ),
    //   Row(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: [
    //       const Icon(Icons.circle_outlined, color: Colors.purple, size: 25),
    //       const SizedBox(
    //         width: 15,
    //       ),
    //       Expanded(
    //           child: TextFormField(
    //             controller: alt3Controller,
    //             keyboardType: TextInputType.text,
    //             decoration: InputDecoration(
    //                 isDense: true,
    //                 border: const OutlineInputBorder(),
    //                 labelText: 'Alternativa 3',
    //                 labelStyle: TextStyle(
    //                   color: AppColors.labelTextTematicaColor,
    //                 ),
    //                 enabledBorder: OutlineInputBorder(
    //                     borderSide: BorderSide(
    //                       color: AppColors.borderTematicaColor,
    //                     )),
    //                 focusedBorder: OutlineInputBorder(
    //                     borderSide: BorderSide(
    //                       color: AppColors.borderFocusedTematicaColor,
    //                     ))),
    //             style: TextStyle(color: AppColors.textTematicaColor),
    //           )
    //       ),
    //     ],
    //   ),
    //   const SizedBox(
    //     height: 10,
    //   ),
    //   Row(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: [
    //       const Icon(Icons.circle_outlined, color: Colors.purple, size: 25),
    //       const SizedBox(
    //         width: 15,
    //       ),
    //       Expanded(
    //           child: TextFormField(
    //             controller: alt4Controller,
    //             keyboardType: TextInputType.text,
    //             decoration: InputDecoration(
    //                 isDense: true,
    //                 border: const OutlineInputBorder(),
    //                 labelText: 'Alternativa 4',
    //                 labelStyle: TextStyle(
    //                   color: AppColors.labelTextTematicaColor,
    //                 ),
    //                 enabledBorder: OutlineInputBorder(
    //                     borderSide: BorderSide(
    //                       color: AppColors.borderTematicaColor,
    //                     )),
    //                 focusedBorder: OutlineInputBorder(
    //                     borderSide: BorderSide(
    //                       color: AppColors.borderFocusedTematicaColor,
    //                     ))),
    //             style: TextStyle(color: AppColors.textTematicaColor),
    //           )
    //       ),
    //     ],
    //   ),
    //   const SizedBox(
    //     height: 10,
    //   ),
    //   Row(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: [
    //       const Icon(Icons.question_answer_outlined, color: Colors.purple, size: 25),
    //       const SizedBox(
    //         width: 15,
    //       ),
    //       Expanded(
    //           child: TextFormField(
    //             controller: ansController,
    //             keyboardType: TextInputType.number,
    //             decoration: InputDecoration(
    //                 isDense: true,
    //                 border: const OutlineInputBorder(),
    //                 labelText: 'RESPUESTA  = 1, 2, 3 o 4',
    //                 labelStyle: TextStyle(
    //                   color: AppColors.labelTextTematicaColor,
    //                 ),
    //                 enabledBorder: OutlineInputBorder(
    //                     borderSide: BorderSide(
    //                       color: AppColors.borderTematicaColor,
    //                     )),
    //                 focusedBorder: OutlineInputBorder(
    //                     borderSide: BorderSide(
    //                       color: AppColors.borderFocusedTematicaColor,
    //                     ))),
    //             style: TextStyle(color: AppColors.textTematicaColor),
    //           )
    //       ),
    //     ],
    //   ),
    //   const SizedBox(
    //     height: 10,
    //   ),
    // ]);

    print("DOUBLEIQ" + doubleListQuestion[cont].length.toString());
    doubleListQuestion[cont].add(Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.question_answer, color: Colors.purple, size: 25),
        const SizedBox(
          width: 15,
        ),
        Expanded(
            child: TextFormField(
              controller: questController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  isDense: true,
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
              //listIndicatorQ[cont] -= 1;
              doubleListIndicatorQ[cont].add(doubleListIndicatorQ[cont].last - 1);
              if (questController.text.isNotEmpty && alt1Controller.text.isNotEmpty &&
                  alt2Controller.text.isNotEmpty && alt3Controller.text.isNotEmpty &&
                  alt4Controller.text.isNotEmpty) {
                setState(() {
                  print("TAMBIEN ENTROO");
                  //widgetQuestion.removeRange((indicatorQ)*6, (indicatorQ)*6 + 6);
                  //doubleListQuestion[cont].removeRange(listIndicatorQ[cont], listIndicatorQ[cont] + 7);
                  doubleListQuestion[cont].removeRange(doubleListIndicatorQ[cont].last, doubleListIndicatorQ[cont].last + 7);
                  deleteQuestion(idsQuestions[cont].last.toString());
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
    ));
    doubleListQuestion[cont].add(Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.circle_outlined, color: Colors.purple, size: 25),
        const SizedBox(
          width: 15,
        ),
        Expanded(
            child: TextFormField(
              controller: alt1Controller,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  isDense: true,
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
    ));
    doubleListQuestion[cont].add(Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.circle_outlined, color: Colors.purple, size: 25),
        const SizedBox(
          width: 15,
        ),
        Expanded(
            child: TextFormField(
              controller: alt2Controller,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  isDense: true,
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
    ));
    doubleListQuestion[cont].add(Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.circle_outlined, color: Colors.purple, size: 25),
        const SizedBox(
          width: 15,
        ),
        Expanded(
            child: TextFormField(
              controller: alt3Controller,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  isDense: true,
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
    ));
    doubleListQuestion[cont].add(Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.circle_outlined, color: Colors.purple, size: 25),
        const SizedBox(
          width: 15,
        ),
        Expanded(
            child: TextFormField(
              controller: alt4Controller,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  isDense: true,
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
    ));
    doubleListQuestion[cont].add(Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.question_answer_outlined, color: Colors.purple, size: 25),
        const SizedBox(
          width: 15,
        ),
        Expanded(
            child: TextFormField(
              controller: ansController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  isDense: true,
                  border: const OutlineInputBorder(),
                  labelText: 'RESPUESTA  = 1, 2, 3 o 4',
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
    ));
    doubleListQuestion[cont].add(const SizedBox(
      height: 10,
    ));

    setState(() {
      doubleListQuestion;
    });

    // doubleListQuestion[cont].addAll([
    //   Row(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: [
    //       const Icon(Icons.question_answer, color: Colors.purple, size: 25),
    //       const SizedBox(
    //         width: 15,
    //       ),
    //       Expanded(
    //           child: TextFormField(
    //             controller: questController,
    //             keyboardType: TextInputType.text,
    //             decoration: InputDecoration(
    //                 isDense: true,
    //                 border: const OutlineInputBorder(),
    //                 labelText: 'Pregunta',
    //                 labelStyle: TextStyle(
    //                   color: AppColors.labelTextTematicaColor,
    //                 ),
    //                 enabledBorder: OutlineInputBorder(
    //                     borderSide: BorderSide(
    //                       color: AppColors.borderTematicaColor,
    //                     )),
    //                 focusedBorder: OutlineInputBorder(
    //                     borderSide: BorderSide(
    //                       color: AppColors.borderFocusedTematicaColor,
    //                     ))),
    //             style: TextStyle(color: AppColors.textTematicaColor),
    //           )
    //       ),
    //       IconButton(
    //           onPressed: () {
    //             //eliminated = true;
    //             indicatorQ -= 1;
    //             if (questController.text.isNotEmpty && alt1Controller.text.isNotEmpty &&
    //                 alt2Controller.text.isNotEmpty && alt3Controller.text.isNotEmpty &&
    //                 alt4Controller.text.isNotEmpty) {
    //               setState(() {
    //                 print("TAMBIEN ENTROO");
    //                 //widgetQuestion.removeRange((indicatorQ)*6, (indicatorQ)*6 + 6);
    //                 doubleListQuestion.removeAt(indicatorQ);
    //               });
    //             } else {
    //               ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //                 content: Text("Agregar la pregunta y sus alternativas para eliminar"),
    //               ));
    //             }
    //           },
    //           icon: Icon(Icons.delete, color: Colors.red)
    //       ),
    //     ],
    //   ),
    //   const SizedBox(
    //     height: 10,
    //   ),
    //   Row(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: [
    //       const Icon(Icons.circle_outlined, color: Colors.purple, size: 25),
    //       const SizedBox(
    //         width: 15,
    //       ),
    //       Expanded(
    //           child: TextFormField(
    //             controller: alt1Controller,
    //             keyboardType: TextInputType.text,
    //             decoration: InputDecoration(
    //                 isDense: true,
    //                 border: const OutlineInputBorder(),
    //                 labelText: 'Alternativa 1',
    //                 labelStyle: TextStyle(
    //                   color: AppColors.labelTextTematicaColor,
    //                 ),
    //                 enabledBorder: OutlineInputBorder(
    //                     borderSide: BorderSide(
    //                       color: AppColors.borderTematicaColor,
    //                     )),
    //                 focusedBorder: OutlineInputBorder(
    //                     borderSide: BorderSide(
    //                       color: AppColors.borderFocusedTematicaColor,
    //                     ))),
    //             style: TextStyle(color: AppColors.textTematicaColor),
    //           )
    //       ),
    //     ],
    //   ),
    //   const SizedBox(
    //     height: 10,
    //   ),
    //   Row(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: [
    //       const Icon(Icons.circle_outlined, color: Colors.purple, size: 25),
    //       const SizedBox(
    //         width: 15,
    //       ),
    //       Expanded(
    //           child: TextFormField(
    //             controller: alt2Controller,
    //             keyboardType: TextInputType.text,
    //             decoration: InputDecoration(
    //                 isDense: true,
    //                 border: const OutlineInputBorder(),
    //                 labelText: 'Alternativa 2',
    //                 labelStyle: TextStyle(
    //                   color: AppColors.labelTextTematicaColor,
    //                 ),
    //                 enabledBorder: OutlineInputBorder(
    //                     borderSide: BorderSide(
    //                       color: AppColors.borderTematicaColor,
    //                     )),
    //                 focusedBorder: OutlineInputBorder(
    //                     borderSide: BorderSide(
    //                       color: AppColors.borderFocusedTematicaColor,
    //                     ))),
    //             style: TextStyle(color: AppColors.textTematicaColor),
    //           )
    //       ),
    //     ],
    //   ),
    //   const SizedBox(
    //     height: 10,
    //   ),
    //   Row(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: [
    //       const Icon(Icons.circle_outlined, color: Colors.purple, size: 25),
    //       const SizedBox(
    //         width: 15,
    //       ),
    //       Expanded(
    //           child: TextFormField(
    //             controller: alt3Controller,
    //             keyboardType: TextInputType.text,
    //             decoration: InputDecoration(
    //                 isDense: true,
    //                 border: const OutlineInputBorder(),
    //                 labelText: 'Alternativa 3',
    //                 labelStyle: TextStyle(
    //                   color: AppColors.labelTextTematicaColor,
    //                 ),
    //                 enabledBorder: OutlineInputBorder(
    //                     borderSide: BorderSide(
    //                       color: AppColors.borderTematicaColor,
    //                     )),
    //                 focusedBorder: OutlineInputBorder(
    //                     borderSide: BorderSide(
    //                       color: AppColors.borderFocusedTematicaColor,
    //                     ))),
    //             style: TextStyle(color: AppColors.textTematicaColor),
    //           )
    //       ),
    //     ],
    //   ),
    //   const SizedBox(
    //     height: 10,
    //   ),
    //   Row(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: [
    //       const Icon(Icons.circle_outlined, color: Colors.purple, size: 25),
    //       const SizedBox(
    //         width: 15,
    //       ),
    //       Expanded(
    //           child: TextFormField(
    //             controller: alt4Controller,
    //             keyboardType: TextInputType.text,
    //             decoration: InputDecoration(
    //                 isDense: true,
    //                 border: const OutlineInputBorder(),
    //                 labelText: 'Alternativa 4',
    //                 labelStyle: TextStyle(
    //                   color: AppColors.labelTextTematicaColor,
    //                 ),
    //                 enabledBorder: OutlineInputBorder(
    //                     borderSide: BorderSide(
    //                       color: AppColors.borderTematicaColor,
    //                     )),
    //                 focusedBorder: OutlineInputBorder(
    //                     borderSide: BorderSide(
    //                       color: AppColors.borderFocusedTematicaColor,
    //                     ))),
    //             style: TextStyle(color: AppColors.textTematicaColor),
    //           )
    //       ),
    //     ],
    //   ),
    //   const SizedBox(
    //     height: 10,
    //   ),
    //   Row(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: [
    //       const Icon(Icons.question_answer_outlined, color: Colors.purple, size: 25),
    //       const SizedBox(
    //         width: 15,
    //       ),
    //       Expanded(
    //           child: TextFormField(
    //             controller: ansController,
    //             keyboardType: TextInputType.number,
    //             decoration: InputDecoration(
    //                 isDense: true,
    //                 border: const OutlineInputBorder(),
    //                 labelText: 'RESPUESTA  = 1, 2, 3 o 4',
    //                 labelStyle: TextStyle(
    //                   color: AppColors.labelTextTematicaColor,
    //                 ),
    //                 enabledBorder: OutlineInputBorder(
    //                     borderSide: BorderSide(
    //                       color: AppColors.borderTematicaColor,
    //                     )),
    //                 focusedBorder: OutlineInputBorder(
    //                     borderSide: BorderSide(
    //                       color: AppColors.borderFocusedTematicaColor,
    //                     ))),
    //             style: TextStyle(color: AppColors.textTematicaColor),
    //           )
    //       ),
    //     ],
    //   ),
    //   const SizedBox(
    //     height: 10,
    //   ),
    // ]);
    print("DOUBLEIA" + doubleListQuestion[cont].length.toString());

  }
  
  saveExam(String idThematicUnit, String idContent, String nExamen) {
    var params = {
      "data": {
        "idThematicUnit": idThematicUnit,
        "idContent": idContent,
        "nExamen": nExamen,
      }
    };

    rest.RestProvider().callMethod("/exc/se", params).then((res) {
      print("Successful: ${res.statusCode}");
      var enc = jsonEncode(res.data);
      var dat = jsonDecode(enc);
      //ThematicUnitModel t = res.data;
      //print("AQUI"+ t.idThematicUnit.toString());
      var idE = dat["data"]["idExamen"];
      print("IDEXAMEN" + idE.toString());
      idsExams.add(idE);
    }).catchError((err) {
      print("Failed: ${ err }");
    });
  }

  saveQuestion(String quest, String alt1, String alt2, String alt3, String alt4, String ans, String idEx, int index) {
    var params = {
      "data": {
        "label": quest,
        "alternative1": alt1,
        "alternative2": alt2,
        "alternative3": alt3,
        "alternative4": alt4,
        "answer": ans,
        "idExamen": idEx
      }
    };

    rest.RestProvider().callMethod("/qc/sq", params).then((res) {
      print("Successful: ${res.statusCode}");
      var enc = jsonEncode(res.data);
      var dat = jsonDecode(enc);
      var idQ = dat["data"]["idQuestion"];
      idsQuestions[index].add(idQ);
      print("IDEXAMEN" + idQ.toString());
    }).catchError((err) {
      print("Failed: ${ err }");
    });
  }

  deleteQuestion(String id) {
    var params = {
      "data": {
        "idQuestion": id,
      }
    };

    rest.RestProvider().callMethod("/qc/del", params).then((res) {
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
        //automaticallyImplyLeading: false,
        title: Text('AGREGAR UN CURSO'),
        centerTitle: true,
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
                            continued1();
                          } else if (_currentStep == 1) {
                            print("indi" + idsVideos.toString());
                            continued2();
                            idsVideos.forEach((key, value) {
                              saveExam(idThematic.toString(), key.toString(), value);
                            });
                            for (int i = 0; i<idsVideos.length;i++) {
                              idsQuestions.add([0]);
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
                                showDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        contentPadding: EdgeInsets.all(0),
                                        content: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              for (int i = 0; i < idsVideos.length; i++)
                                                InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    //listQuestionController;
                                                    doubleListQuestionController;
                                                  });
                                                  print("ENTRA INKWELL");
                                                  print("INDICATOT ${doubleListIndicatorQ[i]}");
                                                  print("INDICATOT ${doubleListQuestionController[i].length}");

                                                  if (doubleListIndicatorQ[i].last >= 0 && doubleListQuestionController[i].last.text.isNotEmpty && doubleListAlternative1Controller[i].last.text.isNotEmpty &&
                                                      doubleListAlternative2Controller[i].last.text.isNotEmpty && doubleListAlternative3Controller[i].last.text.isNotEmpty &&
                                                      doubleListAlternative4Controller[i].last.text.isNotEmpty && doubleListAnswerController[i].last.text.isNotEmpty) {
                                                    print("ANADIR QUESTION");
                                                    print(doubleListAlternative1Controller[i].lastWhere((element) => element.text.isNotEmpty).text);
                                                    saveQuestion(doubleListQuestionController[i].lastWhere((element) => element.text.isNotEmpty).text,
                                                        doubleListAlternative1Controller[i].lastWhere((element) => element.text.isNotEmpty).text,
                                                        doubleListAlternative2Controller[i].lastWhere((element) => element.text.isNotEmpty).text,
                                                        doubleListAlternative3Controller[i].lastWhere((element) => element.text.isNotEmpty).text,
                                                        doubleListAlternative4Controller[i].lastWhere((element) => element.text.isNotEmpty).text,
                                                        doubleListAnswerController[i].lastWhere((element) => element.text.isNotEmpty).text,
                                                        idsExams[i].toString(), i);
                                                    //saveQuestion(listAlternative1Controller.last.text, listAlternative2Controller.last.text, listAlternative3Controller.last.text, listAlternative4Controller.last.text, listAnswerController.last.text, idsExams[i].toString());
                                                    doubleListQuestionController[i].add(TextEditingController());
                                                    doubleListAlternative1Controller[i].add(TextEditingController());
                                                    doubleListAlternative2Controller[i].add(TextEditingController());
                                                    doubleListAlternative3Controller[i].add(TextEditingController());
                                                    doubleListAlternative4Controller[i].add(TextEditingController());
                                                    doubleListAnswerController[i].add(TextEditingController());
                                                    addQuestion(doubleListQuestionController[i].last, doubleListAlternative1Controller[i].last, doubleListAlternative2Controller[i].last,
                                                        doubleListAlternative3Controller[i].last, doubleListAlternative4Controller[i].last, doubleListAnswerController[i].last, i);
                                                    print("FILTRO VIDEO" + _contentsV.length.toString());
                                                    print("sas" + doubleListAnswerController[i].length.toString());
                                                    setState(() {
                                                      //widgetQuestion;
                                                      doubleListQuestion;
                                                    });
                                                  } else {
                                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                      content: Text("Completar todos los campos para agregar una pregunta"),
                                                    ));
                                                  }

                                                  // if (listIndicatorQ[i] >= 0 && listQuestionController[i].text.isNotEmpty && listAlternative1Controller[i].text.isNotEmpty &&
                                                  // listAlternative2Controller[i].text.isNotEmpty && listAlternative3Controller[i].text.isNotEmpty &&
                                                  // listAlternative4Controller[i].text.isNotEmpty && listAnswerController[i].text.isNotEmpty) {
                                                  //   print("ANADIR QUESTION");
                                                  //   print(listAlternative1Controller.lastWhere((element) => element.text.isNotEmpty).text);
                                                  //   saveQuestion(listAlternative1Controller.lastWhere((element) => element.text.isNotEmpty).text,
                                                  //       listAlternative2Controller.lastWhere((element) => element.text.isNotEmpty).text,
                                                  //       listAlternative3Controller.lastWhere((element) => element.text.isNotEmpty).text,
                                                  //       listAlternative4Controller.lastWhere((element) => element.text.isNotEmpty).text,
                                                  //       listAnswerController.lastWhere((element) => element.text.isNotEmpty).text,
                                                  //       idsExams[i].toString());
                                                  //   //saveQuestion(listAlternative1Controller.last.text, listAlternative2Controller.last.text, listAlternative3Controller.last.text, listAlternative4Controller.last.text, listAnswerController.last.text, idsExams[i].toString());
                                                  //   listQuestionController.add(TextEditingController());
                                                  //   listAlternative1Controller.add(TextEditingController());
                                                  //   listAlternative2Controller.add(TextEditingController());
                                                  //   listAlternative3Controller.add(TextEditingController());
                                                  //   listAlternative4Controller.add(TextEditingController());
                                                  //   listAnswerController.add(TextEditingController());
                                                  //   addQuestion(listQuestionController.last, listAlternative1Controller.last, listAlternative2Controller.last, listAlternative3Controller.last, listAlternative4Controller.last, listAnswerController.last, i);
                                                  //   print("FILTRO VIDEO" + _contentsV.length.toString());
                                                  //   print(listAnswerController.length.toString());
                                                  //   setState(() {
                                                  //     //widgetQuestion;
                                                  //     doubleListQuestion;
                                                  //   });
                                                  // } else {
                                                  //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                  //     content: Text("Completar todos los campos para agregar una pregunta"),
                                                  //   ));
                                                  // }
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(20),
                                                  decoration: const BoxDecoration(
                                                      border: Border(bottom: BorderSide(width: 1, color: Colors.grey))
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text('Video ${i+1}', style: TextStyle(fontSize: 16, color: Color(0xff2E3E5C), fontWeight: FontWeight.bold)),
                                                      ),
                                                      Icon(Icons.add_box, color: Colors.green)
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                );
                                
                                // if (indicatorQ >= 0 && questionController.text.isNotEmpty && alternative1Controller.text.isNotEmpty
                                // && alternative2Controller.text.isNotEmpty && alternative3Controller.text.isNotEmpty
                                // && alternative4Controller.text.isNotEmpty && answerController.text.isNotEmpty) {
                                //   addQuestion(TextEditingController(), TextEditingController(), TextEditingController(), TextEditingController(), TextEditingController(), TextEditingController());
                                //   print("FILTRO VIDEO" + _contentsV.length.toString());
                                //   setState(() {
                                //     //widgetQuestion;
                                //     doubleListQuestion;
                                //   });
                                // } else {
                                //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                //     content: Text("Completar todos los campos para agregar una pregunta"),
                                //   ));
                                // }

                              },
                              icon: const Icon(Icons.add_box, color: Colors.green),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 30,
                      ),
                      //for (int i = 0; i < idsVideos.length; i++)
                      // SizedBox(
                      //   height: 400,
                      //   child: GridView.count(
                      //       childAspectRatio: 0.85,
                      //       crossAxisSpacing: 5,
                      //       mainAxisSpacing: 5,
                      //       crossAxisCount: 1,
                      //       children: List.generate(doubleListQuestion.length, (index) {
                      //           return SingleChildScrollView (
                      //           child: Column(
                      //             children: [
                      //               Text('Video ${index + 1}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 24)),
                      //               const SizedBox(height: 10),
                      //               Column(
                      //                 children: List.generate(doubleListQuestion[index].length, (aux) {
                      //                   return Container(
                      //                     child: doubleListQuestion[index][aux],
                      //                   );
                      //                 }),
                      //               )
                      //             ]
                      //           )
                      //         );
                      //       })
                      //       // children: List.generate(widgetQuestion.length, (index) {
                      //       //   return Container (
                      //       //     child: widgetQuestion[index],
                      //       //   );
                      //       // })
                      //   ),
                      // ),

                      for (int i = 0; i < idsVideos.length; i++)
                        SizedBox(
                        height: 350,
                        child: GridView.count(
                            childAspectRatio: 8,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                            crossAxisCount: 1,
                            children: List.generate(doubleListQuestion[i].length, (aux) {
                              return Container(
                                child: doubleListQuestion[i][aux],
                              );
                            }),
                        ),
                      ),

                      Text(idsVideos.toString() + "TODOS" + doubleListQuestion[0].length.toString()),
                      //show(),

                      // SizedBox(
                      //   height: 400,
                      //   child: GridView.count(
                      //       childAspectRatio: 0.85,
                      //       crossAxisSpacing: 5,
                      //       mainAxisSpacing: 5,
                      //       crossAxisCount: 1,
                      //       children: [
                      //         Text('Video ${1}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 24)),
                      //         const SizedBox(height: 10),
                      //         Column(
                      //           children: List.generate(doubleListQuestion[0].length, (aux) {
                      //             return Container(
                      //               child: doubleListQuestion[0][aux],
                      //             );
                      //           }),
                      //         )
                      //       ]
                      //     // List.generate(doubleListQuestion.length, (index) {
                      //     //   return SingleChildScrollView (
                      //     //       child: Column(
                      //     //           children: [
                      //     //             Text('Video ${index + 1}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 24)),
                      //     //             const SizedBox(height: 10),
                      //     //             Column(
                      //     //               children: List.generate(doubleListQuestion[index].length, (aux) {
                      //     //                 return Container(
                      //     //                   child: doubleListQuestion[index][aux],
                      //     //                 );
                      //     //               }),
                      //     //             )
                      //     //           ]
                      //     //       )
                      //     //   );
                      //     // })
                      //   ),
                      // ),
                      //
                      // SizedBox(
                      //   height: 400,
                      //   child: GridView.count(
                      //       childAspectRatio: 0.85,
                      //       crossAxisSpacing: 5,
                      //       mainAxisSpacing: 5,
                      //       crossAxisCount: 1,
                      //       children: [
                      //         Text('Video ${2}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 24)),
                      //         const SizedBox(height: 10),
                      //         Column(
                      //           children: List.generate(doubleListQuestion[1].length, (aux) {
                      //             return Container(
                      //               child: doubleListQuestion[1][aux],
                      //             );
                      //           }),
                      //         )
                      //       ]
                      //     // List.generate(doubleListQuestion.length, (index) {
                      //     //   return SingleChildScrollView (
                      //     //       child: Column(
                      //     //           children: [
                      //     //             Text('Video ${index + 1}', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 24)),
                      //     //             const SizedBox(height: 10),
                      //     //             Column(
                      //     //               children: List.generate(doubleListQuestion[index].length, (aux) {
                      //     //                 return Container(
                      //     //                   child: doubleListQuestion[index][aux],
                      //     //                 );
                      //     //               }),
                      //     //             )
                      //     //           ]
                      //     //       )
                      //     //   );
                      //     // })
                      //   ),
                      // ),

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
    int idCat = int.parse(dropdownValue);
    print("hola" + idCat.toString());
    print("hola" + nivelController.text);
    if (nivelController.text.isNotEmpty && minCalificationController.text.isNotEmpty && starRateController.text.isNotEmpty
    && nTimeController.text.isNotEmpty && nBagdeController.text.isNotEmpty) {
      saveThematic(nameThematicController.text, idCat, descriptionController.text, portraitController.text, int.parse(nivelController.text), int.parse(minCalificationController.text), int.parse(starRateController.text), int.parse(nTimeController.text), int.parse(nBagdeController.text));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Completar todos los campos para continuar"),
      ));
    }

    // _currentStep < 3 ?
    // setState(() => _currentStep += 1): null;
    // setState(() {
    //   _currentStep += 1;
    // });
     print('HOLa');
  }

  continued2(){

    doubleListIndicatorQ.clear();
    doubleListQuestionController.clear();
    doubleListAlternative1Controller.clear();
    doubleListAlternative2Controller.clear();
    doubleListAlternative3Controller.clear();
    doubleListAlternative4Controller.clear();
    doubleListAnswerController.clear();
    doubleListQuestion.clear();

    idsQuestions.clear();

    print("length" + idsVideos.length.toString());
    for (int i = 0; i < idsVideos.length; i++) {
      doubleListIndicatorQ.add([0]);
      idsQuestions.add([0]);
      doubleListQuestionController.add([TextEditingController()]);
      doubleListAlternative1Controller.add([TextEditingController()]);
      doubleListAlternative2Controller.add([TextEditingController()]);
      doubleListAlternative3Controller.add([TextEditingController()]);
      doubleListAlternative4Controller.add([TextEditingController()]);
      doubleListAnswerController.add([TextEditingController()]);
      print("doubkeList");
      print("ENTRADL" + doubleListQuestion.length.toString());
      doubleListQuestion.add([Center(child: Text("VIDEO ${i+1}", style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 24)))]);
      doubleListQuestion[i].add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.question_answer, color: Colors.purple, size: 25),
          const SizedBox(
            width: 15,
          ),
          Expanded(
              child: TextFormField(
                controller: doubleListQuestionController[i][0],
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    isDense: true,
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
                if (doubleListQuestionController[i].first.text.isNotEmpty && doubleListAlternative1Controller[i].first.text.isNotEmpty &&
                    doubleListAlternative2Controller[i].first.text.isNotEmpty && doubleListAlternative3Controller[i].first.text.isNotEmpty &&
                    doubleListAlternative4Controller[i].first.text.isNotEmpty) {
                  //listIndicatorQ[i] -= 1;
                  doubleListIndicatorQ[i].add(doubleListIndicatorQ[i].last - 1);
                  setState(() {
                    print("ENTROO");
                    //widgetQuestion.removeRange(0, 6);
                    print(doubleListQuestion[i].length);
                    doubleListQuestion[i].removeRange(1,7);
                    deleteQuestion(idsQuestions[i].last.toString());
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Agregar la pregunta y sus alternativas para eliminar"),
                  ));
                }

                // if (listQuestionController.first.text.isNotEmpty && listAlternative1Controller.first.text.isNotEmpty &&
                //     listAlternative2Controller.first.text.isNotEmpty && listAlternative3Controller.first.text.isNotEmpty &&
                //     listAlternative4Controller.first.text.isNotEmpty) {
                //   //listIndicatorQ[i] -= 1;
                //   doubleListIndicatorQ[i].add(doubleListIndicatorQ[i].last - 1);
                //   setState(() {
                //     print("ENTROO");
                //     //widgetQuestion.removeRange(0, 6);
                //     print(doubleListQuestion[i].length);
                //     doubleListQuestion[i].removeRange(1,7);
                //   });
                // } else {
                //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                //     content: Text("Agregar la pregunta y sus alternativas para eliminar"),
                //   ));
                // }
              },
              icon: Icon(Icons.delete, color: Colors.red)
          ),
        ],
      ));
      doubleListQuestion[i].add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.circle_outlined, color: Colors.purple, size: 25),
          const SizedBox(
            width: 15,
          ),
          Expanded(
              child: TextFormField(
                controller: doubleListAlternative1Controller[i][0],
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    isDense: true,
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
      ));
      doubleListQuestion[i].add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.circle_outlined, color: Colors.purple, size: 25),
          const SizedBox(
            width: 15,
          ),
          Expanded(
              child: TextFormField(
                controller: doubleListAlternative2Controller[i][0],
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    isDense: true,
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
      ));
      doubleListQuestion[i].add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.circle_outlined, color: Colors.purple, size: 25),
          const SizedBox(
            width: 15,
          ),
          Expanded(
              child: TextFormField(
                controller: doubleListAlternative3Controller[i][0],
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    isDense: true,
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
      ));
      doubleListQuestion[i].add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.circle_outlined, color: Colors.purple, size: 25),
          const SizedBox(
            width: 15,
          ),
          Expanded(
              child: TextFormField(
                controller: doubleListAlternative4Controller[i][0],
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    isDense: true,
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
      ));
      doubleListQuestion[i].add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.question_answer_outlined, color: Colors.purple, size: 25),
          const SizedBox(
            width: 15,
          ),
          Expanded(
              child: TextFormField(
                controller: doubleListAnswerController[i][0],
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    isDense: true,
                    border: const OutlineInputBorder(),
                    labelText: 'RESPUESTA  = 1, 2, 3 o 4',
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
      ));
      doubleListQuestion[i].add(const SizedBox(
        height: 10,
      ));
    }
    _currentStep < 3 ?
    setState(() => _currentStep += 1): null;
    print('QUE TAL THEMTIC + ' + idThematic.toString());
  }

  continued3(){
    _currentStep < 3 ?
    setState(() => _currentStep += 0): null;
    // setState(() {
    //   _currentStep += 1;
    // });
    thematicData.status = 0;
    Navigator.pushNamed(context, Routes.actionsMyCourses);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Se agrego correctamente"),
    ));
     print('HOLAAA');
  }

  cancel1(){
    _currentStep > 0 ?
    setState(() => _currentStep -= 0) : null;
    Navigator.pushNamed(context, Routes.actionsMyCourses);
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

