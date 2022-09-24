import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lexp/core/res/color.dart';
import 'package:lexp/core/routes/routes.dart';
import 'package:lexp/models/category.dart';
import 'package:lexp/models/content.dart';
import 'package:lexp/models/exam.dart';
import 'package:lexp/models/question.dart';
import 'package:lexp/models/thematic_unit.dart';
import 'package:lexp/services/rest_provider.dart' as rest;
import 'package:lexp/services/shared_service.dart' as shared;

class UpdateMyCourseScreen extends StatefulWidget {
  const UpdateMyCourseScreen({Key? key}) : super(key: key);

  @override
  State<UpdateMyCourseScreen> createState() => _UpdateMyCourseScreenState();
}

class _UpdateMyCourseScreenState extends State<UpdateMyCourseScreen> {

  final TextEditingController idOrNameController = TextEditingController();

  late List<ThematicUnitModel> _thematics;
  Map<int, String> filtrados = {};
  Map<int, String> saveFilter = {};
  late final Future _future;

  final TextEditingController nameThematicController = TextEditingController();
  final TextEditingController descriptionThematicController = TextEditingController();
  final TextEditingController portraitThematicController = TextEditingController();
  final TextEditingController nivelThematicController = TextEditingController();
  final TextEditingController minCalificationThematicController = TextEditingController();
  final TextEditingController starRateThematicController = TextEditingController();
  final TextEditingController nTimeThematicController = TextEditingController();
  final TextEditingController nBadgeThematicController = TextEditingController();

  late Map<int, int> mapThematic= {};

  late String categoryIdDropDownValue = "1";
  late final Future _futureAllCategories;
  late final List<CategoryModel> _categories;
 List<String> idsCategories = [];

 late Map<int, ThematicUnitModel> dicThematic = {};
 late ThematicUnitModel thematicToUpdate;
 List<ContentModel> listContentVToUpdate = [];
 List<ContentModel> listContentIToUpdate = [];

 late List<Widget> listWidgetVToUpdate = [];
 late List<Widget> listWidgetIToUpdate = [];
 late final List<TextEditingController> listLinkContentControllerV = [];
 late final List<TextEditingController> listNameContentControllerV = [];
 late final List<TextEditingController> listPositionContentControllerV = [];
 late final List<TextEditingController> listLinkContentControllerI = [];
 late final List<TextEditingController> listNameContentControllerI = [];
 late final List<TextEditingController> listPositionContentControllerI = [];

  List<ExamModel> listExamToUpdate = [];

  late List<List<Widget>> doubleListQuestion = [[]];
  late List<List<TextEditingController>> doubleListQuestionController = [[]];
  late List<List<TextEditingController>> doubleListAlternative1Controller = [[]];
  late List<List<TextEditingController>> doubleListAlternative2Controller = [[]];
  late List<List<TextEditingController>> doubleListAlternative3Controller = [[]];
  late List<List<TextEditingController>> doubleListAlternative4Controller = [[]];
  late List<List<TextEditingController>> doubleListAnswerController = [[]];
  late List<List<int>> doubleListIdQ = [[]];
  late List<List<int>> doubleListIdE = [[]];

  int contToUpdate = 0;
  int questionsCont = 0;

  List<QuestionModel> listQuestions = [];
  Map<int, String> listNameExam = {};

  final PageController _controller = PageController(initialPage: 0);

  int _currentStep = 0;
  StepperType stepperType = StepperType.horizontal;

  @override
  void initState() {
    _future = rest.RestProvider().callMethod("/tuc/fat");
    _future.then((value) => {
      _thematics = shared.SharedService().getTUnits(value),
      for (ThematicUnitModel t in _thematics) {
        mapThematic[t.idThematicUnit] = t.idCategory,
        filtrados[t.idThematicUnit] = t.thematicUnitName,
        dicThematic[t.idThematicUnit] = t,
      },
    });

    _futureAllCategories = rest.RestProvider().callMethod("/cc/lac");
    _futureAllCategories.then((value) => {
      _categories = shared.SharedService().getCategories(value),
      for (CategoryModel c in _categories) {
        idsCategories.add(c.idCategory.toString()),
        //idsCategories[c.idCategory] = c.categoryName,
        //categoryIdDropDownValue = idsCategories.first,
      },
    });

    // TODO: implement initState
    super.initState();
    listWidgetVToUpdate.add(Text("HOLA"));

    doubleListQuestion.add([
      Text("Hola"),
      Text("Hola"),
      Text("Hola"),
      Text("Hola"),
      Text("Hola"),
    ]);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future filter(String nameOrId) async {
    filtrados.forEach((key, value) {
      if (value.toLowerCase().contains(nameOrId.toLowerCase()) || key.toString() == nameOrId) {
        saveFilter[key] = value;
      }
    });
    print(saveFilter);
  }

  updateThematic(String idThematicUnit, String nameThematic, int idCategory, String description, String portrait, int nivel, int minCalification, int starRate, int nTime, int nBadge) async {
    print("SAVE THEMATIC");
    if (nameThematic.isNotEmpty && description.isNotEmpty && portrait.isNotEmpty && idCategory.toString().isNotEmpty
        && nivel.toString().isNotEmpty && minCalification.toString().isNotEmpty && starRate.toString().isNotEmpty
        && nTime.toString().isNotEmpty && nBadge.toString().isNotEmpty) {
      var params = {
        "data": {
          "idThematicUnit": idThematicUnit,
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
      
      }).catchError((err) {
        print("Failed: ${ err }");
      });
    } else {
      print("Completar los campos requeridos");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Completar todos los campos para continuar"),
      ));
    }
  }

  updateContent(String idThematicUnit) async {
    print("SAVE CONTENT");
    var params = {
      "data": {
        "idThematicUnit": idThematicUnit,
      }
    };

    rest.RestProvider().callMethod("/cntc/fabtui", params).then((res) {
      print("Successful: ${res.statusCode}");
      var enc = jsonEncode(res.data);
      var dat = jsonDecode(enc);
      List<dynamic> listDynamic = dat["data"];
      print("UPDATE ${listDynamic.length}");
      for (int i = 0; i < listDynamic.length; i++) {
        if (listDynamic[i]["listOfExamen"] == null) {
          listContentIToUpdate.add(ContentModel(listDynamic[i]["status"], listDynamic[i]["contentName"],
              listDynamic[i]["posicion"], listDynamic[i]["multimedia"],
              idContent: listDynamic[i]["idContent"], idThematicUnit: listDynamic[i]["idThematicUnit"]));
          //print(listDynamic[i]["listOfExamen"].toString() + "RPTA1");
        } else {
          listContentVToUpdate.add(ContentModel(listDynamic[i]["status"], listDynamic[i]["contentName"],
              listDynamic[i]["posicion"], listDynamic[i]["multimedia"],
              idContent: listDynamic[i]["idContent"], idThematicUnit: listDynamic[i]["idThematicUnit"]));
          //print(listDynamic[i]["listOfExamen"].toString() + "RPTA2");
        }
      }
      if (listContentVToUpdate.isNotEmpty) {
        for (int i = 0; i < listContentVToUpdate.length; i++) {
          listLinkContentControllerV.add(TextEditingController());
          listNameContentControllerV.add(TextEditingController());
          listPositionContentControllerV.add(TextEditingController());
          listLinkContentControllerV.last.text =
              listContentVToUpdate[i].multimedia;
          listNameContentControllerV.last.text =
              listContentVToUpdate[i].contentName;
          listPositionContentControllerV.last.text =
              listContentVToUpdate[i].posicion.toString();

          listWidgetVToUpdate.addAll([
            TextFormField(
              controller: listLinkContentControllerV.last,
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
              controller: listNameContentControllerV.last,
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
              controller: listPositionContentControllerV.last,
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
                  deleteContent(listContentVToUpdate[i].idContent.toString());
                  listWidgetVToUpdate.removeLast();
                  listWidgetVToUpdate.removeLast();
                  listWidgetVToUpdate.removeLast();
                  listWidgetVToUpdate.removeLast();

                  listContentVToUpdate.removeLast();

                  listLinkContentControllerV.removeLast();
                  listNameContentControllerV.removeLast();
                  listPositionContentControllerV.removeLast();

                  setState(() {
                    listWidgetVToUpdate;
                    listContentVToUpdate;
                    listLinkContentControllerV;
                    listNameContentControllerV;
                    listPositionContentControllerV;
                  });

                  // if (.text.isNotEmpty && positionContentControllerV.text.isNotEmpty && nameContentControllerV.text.isNotEmpty) {
                  //   filterContentV;
                  //   setState(() {
                  //     filterV(linkContentControllerV.text, positionContentControllerV.text, nameContentControllerV.text);
                  //     linkContentControllerV.text = "";
                  //     positionContentControllerV.text = "";
                  //     nameContentControllerV.text = "";
                  //     widgetV.removeLast();
                  //     widgetV.removeLast();
                  //     widgetV.removeLast();
                  //     widgetV.removeLast();
                  //     filterContentV;
                  //   });
                  // } else {
                  //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  //     content: Text("Agrega la fila para eliminar"),
                  //   ));
                  // }
                },
              ),
            )
          ]);
        }
        setState(() {
          listWidgetVToUpdate;
          listWidgetIToUpdate;
        });
      }

      if (listContentIToUpdate.isNotEmpty) {
        for (int i = 0; i < listContentIToUpdate.length; i++) {
          listLinkContentControllerI.add(TextEditingController());
          listNameContentControllerI.add(TextEditingController());
          listPositionContentControllerI.add(TextEditingController());
          listLinkContentControllerI.last.text =
              listContentIToUpdate[i].multimedia;
          listNameContentControllerI.last.text =
              listContentIToUpdate[i].contentName;
          listPositionContentControllerI.last.text =
              listContentIToUpdate[i].posicion.toString();

          listWidgetIToUpdate.addAll([
            TextFormField(
              controller: listLinkContentControllerI.last,
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
              controller: listNameContentControllerI.last,
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
              controller: listPositionContentControllerI.last,
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
                  deleteContent(listContentIToUpdate[i].idContent.toString());
                  listWidgetIToUpdate.removeLast();
                  listWidgetIToUpdate.removeLast();
                  listWidgetIToUpdate.removeLast();
                  listWidgetIToUpdate.removeLast();

                  listContentIToUpdate.removeLast();

                  listLinkContentControllerI.removeLast();
                  listNameContentControllerI.removeLast();
                  listPositionContentControllerI.removeLast();

                  setState(() {
                    listContentIToUpdate;
                    listWidgetIToUpdate;
                    listLinkContentControllerI;
                    listNameContentControllerI;
                    listPositionContentControllerI;
                  });
                  // if (.text.isNotEmpty && positionContentControllerV.text.isNotEmpty && nameContentControllerV.text.isNotEmpty) {
                  //   filterContentV;
                  //   setState(() {
                  //     filterV(linkContentControllerV.text, positionContentControllerV.text, nameContentControllerV.text);
                  //     linkContentControllerV.text = "";
                  //     positionContentControllerV.text = "";
                  //     nameContentControllerV.text = "";
                  //     widgetV.removeLast();
                  //     widgetV.removeLast();
                  //     widgetV.removeLast();
                  //     widgetV.removeLast();
                  //     filterContentV;
                  //   });
                  // } else {
                  //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  //     content: Text("Agrega la fila para eliminar"),
                  //   ));
                  // }
                },
              ),
            )
          ]);
        }
        setState(() {
          listWidgetVToUpdate;
          listWidgetIToUpdate;
        });
      }

      setState(() {
        listWidgetVToUpdate;
        listWidgetIToUpdate;
      });

      print("CONTENTV $listContentVToUpdate");
      print("CONTENTI $listContentIToUpdate");
      print("LISTWIDGET$listWidgetVToUpdate");

    }).catchError((err) {
      print("Failed: ${ err }");
    });

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
      print("Successful CONTENT V: ${res.statusCode}");
      var enc = jsonEncode(res.data);
      var dat = jsonDecode(enc);
      print("aqui");
      var id = dat["data"]["idContent"];
      var name = dat["data"]["contentName"];
      print("$id  $name");
      saveExam(thematicToUpdate.idThematicUnit.toString(), dat["data"]["idContent"].toString(), dat["data"]["contentName"]);
      setState(() {
        listExamToUpdate;
      });
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

  saveContentWithId(int idContent, String contentName, int idThematicUnit, String posicion, String multimedia) {

    var params = {
      "data": {
        "idContent": idContent,
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

  addRowV(TextEditingController linkAddContentController, TextEditingController nameAddContentController, TextEditingController positionAddContentController) {
    print("START    ERROR" );
    listWidgetVToUpdate.addAll([
      TextFormField(
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
      ),
      TextFormField(
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
      ),
      TextFormField(
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
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 25),
        child: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          iconSize: 25,
          onPressed: () {
            if (linkAddContentController.text.isNotEmpty && positionAddContentController.text.isNotEmpty && nameAddContentController.text.isNotEmpty) {
              listWidgetVToUpdate.removeLast();
              listWidgetVToUpdate.removeLast();
              listWidgetVToUpdate.removeLast();
              listWidgetVToUpdate.removeLast();

              listLinkContentControllerV.removeLast();
              listNameContentControllerV.removeLast();
              listPositionContentControllerV.removeLast();

            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Agrega la fila para eliminar"),
              ));
            }
            setState(() {
              listWidgetVToUpdate;
            });
          },
        ),
      )
    ]);
    print("END     ERROR");

    setState(() {
      listWidgetVToUpdate;
    });
  }

  addRowI(TextEditingController linkAddContentController, TextEditingController nameAddContentController, TextEditingController positionAddContentController) {

    listWidgetIToUpdate.addAll([
      TextFormField(
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
      ),
      TextFormField(
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
      ),
      TextFormField(
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
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 25),
        child: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          iconSize: 25,
          onPressed: () {
            if (linkAddContentController.text.isNotEmpty && positionAddContentController.text.isNotEmpty && nameAddContentController.text.isNotEmpty) {
              listWidgetIToUpdate.removeLast();
              listWidgetIToUpdate.removeLast();
              listWidgetIToUpdate.removeLast();
              listWidgetIToUpdate.removeLast();

              listLinkContentControllerI.removeLast();
              listNameContentControllerI.removeLast();
              listPositionContentControllerI.removeLast();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Agrega la fila para eliminar"),
              ));
            }
            setState(() {
              listWidgetIToUpdate;
            });
          },
        ),
      )
    ]);

    setState(() {
      listWidgetIToUpdate;
    });
  }

  deleteContent(String idContent) {
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

  getExam(String idContent) {
    var params = {
      "data": {
        "idContent": idContent
      }
    };

    rest.RestProvider().callMethod("/exc/fe", params).then((res) {
      print("Successful: ${res.statusCode}");
      var enc = jsonEncode(res.data);
      var dat = jsonDecode(enc);
      ExamModel exam = ExamModel.fromJson(res.data["data"]) ;
      //print("EXAMEN $exam");
      contToUpdate = 0;
      getQuestions(exam.idExamen.toString());
      print("QUESTIONS $listQuestions");
      listExamToUpdate.add(exam);
      setState(() {
        listExamToUpdate;
        listQuestions;
      });
    }).catchError((err) {
      print("Failed: ${ err }");
    });
  }

  getQuestions(String idExam) {
    var params = {
      "data": {
        "idExamen": idExam
      }
    };

    rest.RestProvider().callMethod("/qc/lqbe", params).then((res) {
      contToUpdate += 1;
      print("Successful: ${res.statusCode}");
      var enc = jsonEncode(res.data);
      var dat = jsonDecode(enc);

      //QuestionModel question = QuestionModel.fromJson(res.data);
      print("FALLO${dat["data"].length}");
      for (int i = 0; i < dat["data"].length; i++) {
        listQuestions.add(QuestionModel(dat["data"][i]["status"], dat["data"][i]["label"],
            dat["data"][i]["alternative1"], dat["data"][i]["alternative2"], dat["data"][i]["alternative3"],
            dat["data"][i]["alternative4"], dat["data"][i]["answer"], idQuestion: dat["data"][i]["idQuestion"], idExamen: dat["data"][i]["idExamen"]));
        print("DATAA ${dat["data"][i]["idQuestion"]} ${dat["data"][i]["idExamen"]} s ${dat["data"][i]["examen"]["idContent"]}");
        //print("LENGGG " + listNameContentControllerV.toString());

      }

      if (dat["data"].length - listContentVToUpdate.length > 0) {
        print("SI ENTRRA");
      }

      print("LISTTOTAL ${listNameContentControllerV.length} $contToUpdate");
      var cont = 0;
      var cont2 = 0;
      for (int i = 0; i < dat["data"].length; i++) {
        for (int j = 0; j < listContentVToUpdate.length; j++) {
          if (dat["data"][i]["examen"]["idContent"].toString() == listContentVToUpdate[j].idContent.toString()) {
            var aux = contToUpdate;
            print("CONTUPDATE" + contToUpdate.toString());
            if (cont == 0) {
              cont = cont + 1;
              cont2 = cont2 + 1;
              print("AAS"+ (aux-1).toString());
              doubleListQuestionController.add([TextEditingController()]);
              doubleListAlternative1Controller.add([TextEditingController()]);
              doubleListAlternative2Controller.add([TextEditingController()]);
              doubleListAlternative3Controller.add([TextEditingController()]);
              doubleListAlternative4Controller.add([TextEditingController()]);
              doubleListAnswerController.add([TextEditingController()]);
              print("BIEN " + dat["data"][i]["idQuestion"].toString());
              print("BIEvvN " + dat["data"][i]["idExamen"].toString());
              doubleListIdQ.add([dat["data"][i]["idQuestion"]]);
              // print("MAL");
              doubleListIdE.add([dat["data"][i]["idExamen"]]);
              // print("BM");

              doubleListQuestionController[contToUpdate - 1].first.text = dat["data"][i]["label"];
              doubleListAlternative1Controller[contToUpdate - 1].first.text = dat["data"][i]["alternative1"];
              doubleListAlternative2Controller[contToUpdate - 1].first.text = dat["data"][i]["alternative2"];
              doubleListAlternative3Controller[contToUpdate - 1].first.text = dat["data"][i]["alternative3"];
              doubleListAlternative4Controller[contToUpdate - 1].first.text = dat["data"][i]["alternative4"];
              doubleListAnswerController[contToUpdate - 1].first.text = dat["data"][i]["answer"].toString();

              listNameExam[aux-1] = dat["data"][i]["examen"]["nExamen"];

              doubleListQuestion.add([
                Center(child: Text("VIDEO ${dat["data"][i]["examen"]["nExamen"]}", style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 24))),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.question_answer, color: Colors.purple, size: 25),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                        child: TextFormField(
                          controller: doubleListQuestionController[contToUpdate-1].last,
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
                          print("hello");
                          print(doubleListAnswerController[aux-1][0].text + "LASTA");

                          print("BORRAR1" + doubleListQuestion[aux - 1].length.toString() + "  "+(aux - 1).toString());
                          if (listQuestions.isNotEmpty) {
                            for (int i = 0; i < listQuestions.length; i++) {
                              if (listQuestions[i].idExamen.toString() ==
                                  dat["data"][i]["examen"]["idExamen"]
                                      .toString()) {
                                listQuestions.removeAt(i);
                              }
                            }
                          }
                          doubleListQuestion[aux - 1].removeRange(1, 8);
                          doubleListQuestionController[aux-1].removeAt(0);
                          doubleListAlternative1Controller[aux-1].removeAt(0);
                          doubleListAlternative2Controller[aux-1].removeAt(0);
                          doubleListAlternative3Controller[aux-1].removeAt(0);
                          doubleListAlternative4Controller[aux-1].removeAt(0);
                          doubleListAnswerController[aux-1].removeAt(0);

                          setState(() {
                            doubleListQuestion;
                            listQuestions;
                            doubleListQuestionController;
                            doubleListAlternative1Controller;
                            doubleListAlternative2Controller;
                            doubleListAlternative3Controller;
                            doubleListAlternative4Controller;
                            doubleListAnswerController;
                          });
                        },
                        icon: Icon(Icons.delete, color: Colors.red)
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.circle_outlined, color: Colors.purple, size: 25),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                        child: TextFormField(
                          controller: doubleListAlternative1Controller[contToUpdate-1].last,
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
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.circle_outlined, color: Colors.purple, size: 25),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                        child: TextFormField(
                          controller: doubleListAlternative2Controller[contToUpdate-1].last,
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
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.circle_outlined, color: Colors.purple, size: 25),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                        child: TextFormField(
                          controller: doubleListAlternative3Controller[contToUpdate-1].last,
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
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.circle_outlined, color: Colors.purple, size: 25),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                        child: TextFormField(
                          controller: doubleListAlternative4Controller[contToUpdate-1].last,
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
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.question_answer_outlined, color: Colors.purple, size: 25),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                        child: TextFormField(
                          controller: doubleListAnswerController[contToUpdate-1].last,
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
                ),
                const SizedBox(
                  height: 10,
                )
              ]);
              print("AASS"+ (contToUpdate-1).toString());

            } else {
              cont2 = cont2 + 1;
              print("ENTRA ELSE E" + (contToUpdate - 1).toString());
              doubleListQuestionController[contToUpdate - 1].add(TextEditingController());
              doubleListAlternative1Controller[contToUpdate - 1].add(TextEditingController());
              doubleListAlternative2Controller[contToUpdate - 1].add(TextEditingController());
              doubleListAlternative3Controller[contToUpdate - 1].add(TextEditingController());
              doubleListAlternative4Controller[contToUpdate - 1].add(TextEditingController());
              doubleListAnswerController[contToUpdate - 1].add(TextEditingController());
              doubleListIdQ[contToUpdate - 1].add(dat["data"][i]["idQuestion"]);
              doubleListIdE[contToUpdate - 1].add(dat["data"][i]["idExamen"]);


              doubleListQuestionController[contToUpdate - 1].last.text = dat["data"][i]["label"];
              doubleListAlternative1Controller[contToUpdate - 1].last.text = dat["data"][i]["alternative1"];
              doubleListAlternative2Controller[contToUpdate - 1].last.text = dat["data"][i]["alternative2"];
              doubleListAlternative3Controller[contToUpdate - 1].last.text = dat["data"][i]["alternative3"];
              doubleListAlternative4Controller[contToUpdate - 1].last.text = dat["data"][i]["alternative4"];
              doubleListAnswerController[contToUpdate - 1].last.text = dat["data"][i]["answer"].toString();
              print("ENTRA ELSE EM" + (aux - 1).toString());
              doubleListQuestion[contToUpdate - 1].add(Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.question_answer, color: Colors.purple, size: 25),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                      child: TextFormField(
                        controller: doubleListQuestionController[contToUpdate-1].last,
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

                        if (listQuestions.isNotEmpty) {
                          for (int i = 0; i < listQuestions.length; i++) {
                            if (listQuestions[i].idExamen.toString() ==
                                dat["data"][i]["examen"]["idExamen"]
                                    .toString()) {
                              listQuestions.removeAt(i);
                            }
                          }
                        }
                        doubleListQuestion[aux -1].removeLast();
                        doubleListQuestion[aux -1].removeLast();
                        doubleListQuestion[aux -1].removeLast();
                        doubleListQuestion[aux -1].removeLast();
                        doubleListQuestion[aux -1].removeLast();
                        doubleListQuestion[aux -1].removeLast();
                        doubleListQuestion[aux -1].removeLast();

                        doubleListQuestionController[aux-1].removeLast();
                        doubleListAlternative1Controller[aux-1].removeLast();
                        doubleListAlternative2Controller[aux-1].removeLast();
                        doubleListAlternative3Controller[aux-1].removeLast();
                        doubleListAlternative4Controller[aux-1].removeLast();
                        doubleListAnswerController[aux-1].removeLast();

                        // doubleListQuestionController.removeLast();
                        // doubleListAlternative1Controller.removeLast();
                        // doubleListAlternative2Controller.removeLast();
                        // doubleListAlternative3Controller.removeLast();
                        // doubleListAlternative4Controller.removeLast();
                        // doubleListAnswerController.removeLast();


                        // print("BORRAR" + doubleListQuestion[contToUpdate - 1].length.toString() + "  "+(contToUpdate - 1).toString());
                        // doubleListQuestion[contToUpdate - 1].removeRange(doubleListQuestion[contToUpdate - 1].length-7, doubleListQuestion[contToUpdate - 1].length);
                        //
                        setState(() {
                          doubleListQuestion;
                          listQuestions;
                          doubleListQuestionController;
                          doubleListAlternative1Controller;
                          doubleListAlternative2Controller;
                          doubleListAlternative3Controller;
                          doubleListAlternative4Controller;
                          doubleListAnswerController;
                        });
                      },
                      icon: Icon(Icons.delete, color: Colors.red)
                  ),
                ],
              ));
              doubleListQuestion[contToUpdate - 1].add(Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.circle_outlined, color: Colors.purple, size: 25),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                      child: TextFormField(
                        controller: doubleListAlternative1Controller[contToUpdate-1].last,
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
              doubleListQuestion[contToUpdate - 1].add(Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.circle_outlined, color: Colors.purple, size: 25),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                      child: TextFormField(
                        controller: doubleListAlternative2Controller[contToUpdate-1].last,
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
              doubleListQuestion[contToUpdate - 1].add(Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.circle_outlined, color: Colors.purple, size: 25),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                      child: TextFormField(
                        controller: doubleListAlternative3Controller[contToUpdate-1].last,
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
              doubleListQuestion[contToUpdate - 1].add(Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.circle_outlined, color: Colors.purple, size: 25),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                      child: TextFormField(
                        controller: doubleListAlternative4Controller[contToUpdate-1].last,
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
              doubleListQuestion[contToUpdate - 1].add(Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.question_answer_outlined, color: Colors.purple, size: 25),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                      child: TextFormField(
                        controller: doubleListAnswerController[contToUpdate-1].last,
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
              doubleListQuestion[contToUpdate - 1].add(const SizedBox(
                height: 10,
              ));

              print("ENTRA ELSE F" + (contToUpdate - 1).toString());

            }
          }
        }
      }

      setState(() {
        listNameExam;
        listQuestions;
        listExamToUpdate;
        doubleListQuestion;
      });
    }).catchError((err) {
      print("Failed: ${ err }");
    });
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
      ExamModel exam = ExamModel.fromJson(res.data["data"]);
      listExamToUpdate.add(exam);
      setState(() {
        listExamToUpdate;
      });
    }).catchError((err) {
      print("Failed: ${ err }");
    });
  }

  addQuestion(TextEditingController questController, TextEditingController alt1Controller, TextEditingController alt2Controller, TextEditingController alt3Controller, TextEditingController alt4Controller, TextEditingController ansController, int cont) {

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
              if (questController.text.isNotEmpty && alt1Controller.text.isNotEmpty &&
                  alt2Controller.text.isNotEmpty && alt3Controller.text.isNotEmpty &&
                  alt4Controller.text.isNotEmpty) {
                setState(() {
                  print("TAMBIEN ENTROO");
                  //widgetQuestion.removeRange((indicatorQ)*6, (indicatorQ)*6 + 6);
                  //doubleListQuestion[cont].removeRange(listIndicatorQ[cont], listIndicatorQ[cont] + 7);
                  doubleListQuestion[cont].removeLast();
                  doubleListQuestion[cont].removeLast();
                  doubleListQuestion[cont].removeLast();
                  doubleListQuestion[cont].removeLast();
                  doubleListQuestion[cont].removeLast();
                  doubleListQuestion[cont].removeLast();
                  doubleListQuestion[cont].removeLast();


                  //deleteQuestion(idsQuestions[cont].last.toString());
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
      doubleListQuestionController;
      doubleListAlternative1Controller;
      doubleListAlternative2Controller;
      doubleListAlternative3Controller;
      doubleListAlternative4Controller;
      doubleListAnswerController;
    });
    print("DOUBLEIA" + doubleListQuestion[cont].length.toString());

  }

  updateQuestion(String idQuestion, String quest, String alt1, String alt2, String alt3, String alt4, String ans, String idEx) {
    var params = {
      "data": {
        "idQuestion": idQuestion,
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
    }).catchError((err) {
      print("Failed: ${ err }");
    });
  }

  // saveAndGet() {
  //   if  (listContentVToUpdate.isNotEmpty){
  //     for (int i = 0; i < listContentVToUpdate.length; i++) {
  //       saveContentWithId(listContentVToUpdate[i].idContent, listNameContentControllerV[i].text,
  //           thematicToUpdate.idThematicUnit, listPositionContentControllerV[i].text, listLinkContentControllerV[i].text);
  //
  //       getExam(listContentVToUpdate[i].idContent.toString());
  //     }
  //   }
  //   if  (listContentIToUpdate.isNotEmpty){
  //     for (int i = 0; i < listContentIToUpdate.length; i++) {
  //       print("Id${listNameContentControllerI[i].text} ${listContentIToUpdate[i].idContent} ${thematicToUpdate.idThematicUnit}");
  //       saveContentWithId(listContentIToUpdate[i].idContent, listNameContentControllerI[i].text,
  //           thematicToUpdate.idThematicUnit, listPositionContentControllerI[i].text, listLinkContentControllerI[i].text);
  //     }
  //   }
  //   if  (listLinkContentControllerV.length - listContentVToUpdate.length > 0){
  //     for (int i = 0; i < (listLinkContentControllerV.length - listContentVToUpdate.length); i++) {
  //       saveContentV(listNameContentControllerV[i + listContentVToUpdate.length].text, thematicToUpdate.idThematicUnit,
  //           listPositionContentControllerV[i + listContentVToUpdate.length].text, listLinkContentControllerV[i + listContentVToUpdate.length].text);
  //
  //     }
  //   }
  //   if  (listLinkContentControllerI.length - listContentIToUpdate.length > 0){
  //     for (int i = 0; i < (listLinkContentControllerI.length - listContentIToUpdate.length); i++) {
  //       saveContentI(listNameContentControllerI[i + listContentIToUpdate.length].text, thematicToUpdate.idThematicUnit,
  //           listPositionContentControllerI[i + listContentIToUpdate.length].text, listLinkContentControllerI[i + listContentIToUpdate.length].text);
  //     }
  //   }
  //
  //   setState(() {
  //     listContentVToUpdate;
  //     listContentIToUpdate;
  //     listQuestions;
  //   });
  // }

  // addWidget() {
  //   if (listQuestions.isNotEmpty) {
  //     for (int i = 0; i < listQuestions.length; i++) {
  //       print("LISTSS  ${listQuestions[i]}");
  //     }
  //   } else {
  //     print("ADDWIDGET");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return PageView(
      scrollDirection: Axis.horizontal,
      controller: _controller,
      children: [

        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
          ),
          body:  Builder(builder: (context) {
            return SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(child: Text("ACTUALIZAR UN CURSO", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24, color: AppColors.textActionsCoursesColor))),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      controller: idOrNameController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: 'Id o nombre del curso',
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
                      height: 15,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          saveFilter.clear();
                          print(idOrNameController.text);
                          setState(() {
                            idOrNameController;
                          });
                          filter(idOrNameController.text);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.customPurple,
                          shadowColor: AppColors.customPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text('BUSCAR',
                            style:
                            TextStyle(color: Colors.white, fontSize: 20)),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),

                    if (saveFilter.isNotEmpty)
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.all(15),
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.borderCategoriaColor),
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Column(
                          children: saveFilter.keys.map((key) {
                            return ListTile(
                              title: Text("$key   ${saveFilter[key]!}"),
                              leading: IconButton(icon: Icon(Icons.update, color: AppColors.updateActionColor),
                                  onPressed: () {
                                    if (_controller.hasClients) {
                                      categoryIdDropDownValue = mapThematic[key].toString();
                                      thematicToUpdate = dicThematic[key]!;

                                      nameThematicController.text = thematicToUpdate.thematicUnitName;
                                      descriptionThematicController.text = thematicToUpdate.description;
                                      portraitThematicController.text = thematicToUpdate.portrait;
                                      nivelThematicController.text = thematicToUpdate.nivel.toString();
                                      minCalificationThematicController.text = thematicToUpdate.minCalification.toString();
                                      starRateThematicController.text = thematicToUpdate.starRate.toString();
                                      nTimeThematicController.text = thematicToUpdate.nTime.toString();
                                      nBadgeThematicController.text = thematicToUpdate.nBadge.toString();

                                      _controller.animateToPage(
                                        1,
                                        duration: const Duration(milliseconds: 800),
                                        curve: Curves.easeInOut,
                                      );
                                    }
                                    setState(() {
                                      saveFilter;
                                    });
                                    //Navigator.pushNamed(context, Routes.actionsMyCourses);
                                  }),
                            );
                          }).toList(),
                        ),
                      )
                  ],
                ),
              ),
            );
          }),
        ),

        Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text('ACTUALIZAR UN CURSO'),
            centerTitle: true,
            backgroundColor: Colors.transparent,
          ),
          body:  Container(
            child: Column(
              children: [
                Expanded(
                  child: Stepper(
                    type: stepperType,
                    physics: ScrollPhysics(),
                    currentStep: _currentStep,
                    onStepTapped: (step) => tapped(step),
                    //onStepContinue:  continued,
                    //onStepCancel: cancel,
                    controlsBuilder: (context, _) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          TextButton(
                            onPressed: () {
                              if (_currentStep == 0) {
                                continued1();
                                updateThematic(thematicToUpdate.idThematicUnit.toString(), nameThematicController.text, int.parse(categoryIdDropDownValue), descriptionThematicController.text,
                                    portraitThematicController.text, int.parse(nivelThematicController.text), int.parse(minCalificationThematicController.text),
                                    int.parse(starRateThematicController.text), int.parse(nTimeThematicController.text), int.parse(nBadgeThematicController.text));

                                updateContent(thematicToUpdate.idThematicUnit.toString());
                                print("HOLA1");
                                listWidgetVToUpdate.clear();
                              } else if (_currentStep == 1) {

                                print("HOLA2");
                                doubleListQuestion.clear();
                                doubleListQuestionController.clear();
                                doubleListAlternative1Controller.clear();
                                doubleListAlternative2Controller.clear();
                                doubleListAlternative3Controller.clear();
                                doubleListAlternative4Controller.clear();
                                doubleListAnswerController.clear();
                                doubleListIdQ.clear();
                                doubleListIdE.clear();
                                print("HOLA3");

                                if  (listContentVToUpdate.isNotEmpty){
                                  for (int i = 0; i < listContentVToUpdate.length; i++) {
                                    saveContentWithId(listContentVToUpdate[i].idContent, listNameContentControllerV[i].text,
                                        thematicToUpdate.idThematicUnit, listPositionContentControllerV[i].text, listLinkContentControllerV[i].text);

                                    getExam(listContentVToUpdate[i].idContent.toString());
                                  }
                                }

                                if  (listContentIToUpdate.isNotEmpty){
                                  for (int i = 0; i < listContentIToUpdate.length; i++) {
                                    print("Id${listNameContentControllerI[i].text} ${listContentIToUpdate[i].idContent} ${thematicToUpdate.idThematicUnit}");
                                    saveContentWithId(listContentIToUpdate[i].idContent, listNameContentControllerI[i].text,
                                        thematicToUpdate.idThematicUnit, listPositionContentControllerI[i].text, listLinkContentControllerI[i].text);
                                  }
                                }

                                if  (listLinkContentControllerV.length - listContentVToUpdate.length > 0){
                                  for (int i = 0; i < (listLinkContentControllerV.length - listContentVToUpdate.length); i++) {
                                    saveContentV(listNameContentControllerV[i + listContentVToUpdate.length].text, thematicToUpdate.idThematicUnit,
                                        listPositionContentControllerV[i + listContentVToUpdate.length].text, listLinkContentControllerV[i + listContentVToUpdate.length].text);

                                  }
                                }

                                if  (listLinkContentControllerI.length - listContentIToUpdate.length > 0){
                                  for (int i = 0; i < (listLinkContentControllerI.length - listContentIToUpdate.length); i++) {
                                    saveContentI(listNameContentControllerI[i + listContentIToUpdate.length].text, thematicToUpdate.idThematicUnit,
                                        listPositionContentControllerI[i + listContentIToUpdate.length].text, listLinkContentControllerI[i + listContentIToUpdate.length].text);
                                  }
                                }

                                setState(() {
                                  listContentVToUpdate;
                                  listContentIToUpdate;
                                  listQuestions;
                                });

                                continued2();

                                // for (int i = 0; i < listNameContentControllerV.length; i++) {
                                //   doubleListQuestion.add([
                                //     Center(child: Text("VIDEO ${i+1}", style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 24))),
                                //     Row(
                                //       mainAxisAlignment: MainAxisAlignment.center,
                                //       children: [
                                //         const Icon(Icons.question_answer, color: Colors.purple, size: 25),
                                //         const SizedBox(
                                //           width: 15,
                                //         ),
                                //         Expanded(
                                //             child: TextFormField(
                                //               controller: doubleListQuestionController[i][0],
                                //               keyboardType: TextInputType.text,
                                //               decoration: InputDecoration(
                                //                   isDense: true,
                                //                   border: const OutlineInputBorder(),
                                //                   labelText: 'Pregunta',
                                //                   labelStyle: TextStyle(
                                //                     color: AppColors.labelTextTematicaColor,
                                //                   ),
                                //                   enabledBorder: OutlineInputBorder(
                                //                       borderSide: BorderSide(
                                //                         color: AppColors.borderTematicaColor,
                                //                       )),
                                //                   focusedBorder: OutlineInputBorder(
                                //                       borderSide: BorderSide(
                                //                         color: AppColors.borderFocusedTematicaColor,
                                //                       ))),
                                //               style: TextStyle(color: AppColors.textTematicaColor),
                                //             )
                                //         ),
                                //         IconButton(
                                //             onPressed: () {
                                //               if (doubleListQuestionController[i].first.text.isNotEmpty && doubleListAlternative1Controller[i].first.text.isNotEmpty &&
                                //                   doubleListAlternative2Controller[i].first.text.isNotEmpty && doubleListAlternative3Controller[i].first.text.isNotEmpty &&
                                //                   doubleListAlternative4Controller[i].first.text.isNotEmpty) {
                                //                 //listIndicatorQ[i] -= 1;
                                //                 doubleListIndicatorQ[i].add(doubleListIndicatorQ[i].last - 1);
                                //                 setState(() {
                                //                   print("ENTROO");
                                //                   //widgetQuestion.removeRange(0, 6);
                                //                   print(doubleListQuestion[i].length);
                                //                   doubleListQuestion[i].removeRange(1,7);
                                //                   deleteQuestion(idsQuestions[i].last.toString());
                                //                 });
                                //               } else {
                                //                 ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                //                   content: Text("Agregar la pregunta y sus alternativas para eliminar"),
                                //                 ));
                                //               }
                                //             },
                                //             icon: Icon(Icons.delete, color: Colors.red)
                                //         ),
                                //       ],
                                //     ),
                                //     Row(
                                //       mainAxisAlignment: MainAxisAlignment.center,
                                //       children: [
                                //         const Icon(Icons.circle_outlined, color: Colors.purple, size: 25),
                                //         const SizedBox(
                                //           width: 15,
                                //         ),
                                //         Expanded(
                                //             child: TextFormField(
                                //               controller: doubleListAlternative1Controller[i][0],
                                //               keyboardType: TextInputType.text,
                                //               decoration: InputDecoration(
                                //                   isDense: true,
                                //                   border: const OutlineInputBorder(),
                                //                   labelText: 'Alternativa 1',
                                //                   labelStyle: TextStyle(
                                //                     color: AppColors.labelTextTematicaColor,
                                //                   ),
                                //                   enabledBorder: OutlineInputBorder(
                                //                       borderSide: BorderSide(
                                //                         color: AppColors.borderTematicaColor,
                                //                       )),
                                //                   focusedBorder: OutlineInputBorder(
                                //                       borderSide: BorderSide(
                                //                         color: AppColors.borderFocusedTematicaColor,
                                //                       ))),
                                //               style: TextStyle(color: AppColors.textTematicaColor),
                                //             )
                                //         ),
                                //       ],
                                //     ),
                                //     Row(
                                //       mainAxisAlignment: MainAxisAlignment.center,
                                //       children: [
                                //         const Icon(Icons.circle_outlined, color: Colors.purple, size: 25),
                                //         const SizedBox(
                                //           width: 15,
                                //         ),
                                //         Expanded(
                                //             child: TextFormField(
                                //               controller: doubleListAlternative2Controller[i][0],
                                //               keyboardType: TextInputType.text,
                                //               decoration: InputDecoration(
                                //                   isDense: true,
                                //                   border: const OutlineInputBorder(),
                                //                   labelText: 'Alternativa 2',
                                //                   labelStyle: TextStyle(
                                //                     color: AppColors.labelTextTematicaColor,
                                //                   ),
                                //                   enabledBorder: OutlineInputBorder(
                                //                       borderSide: BorderSide(
                                //                         color: AppColors.borderTematicaColor,
                                //                       )),
                                //                   focusedBorder: OutlineInputBorder(
                                //                       borderSide: BorderSide(
                                //                         color: AppColors.borderFocusedTematicaColor,
                                //                       ))),
                                //               style: TextStyle(color: AppColors.textTematicaColor),
                                //             )
                                //         ),
                                //       ],
                                //     ),
                                //     Row(
                                //       mainAxisAlignment: MainAxisAlignment.center,
                                //       children: [
                                //         const Icon(Icons.circle_outlined, color: Colors.purple, size: 25),
                                //         const SizedBox(
                                //           width: 15,
                                //         ),
                                //         Expanded(
                                //             child: TextFormField(
                                //               controller: doubleListAlternative3Controller[i][0],
                                //               keyboardType: TextInputType.text,
                                //               decoration: InputDecoration(
                                //                   isDense: true,
                                //                   border: const OutlineInputBorder(),
                                //                   labelText: 'Alternativa 3',
                                //                   labelStyle: TextStyle(
                                //                     color: AppColors.labelTextTematicaColor,
                                //                   ),
                                //                   enabledBorder: OutlineInputBorder(
                                //                       borderSide: BorderSide(
                                //                         color: AppColors.borderTematicaColor,
                                //                       )),
                                //                   focusedBorder: OutlineInputBorder(
                                //                       borderSide: BorderSide(
                                //                         color: AppColors.borderFocusedTematicaColor,
                                //                       ))),
                                //               style: TextStyle(color: AppColors.textTematicaColor),
                                //             )
                                //         ),
                                //       ],
                                //     ),
                                //     Row(
                                //       mainAxisAlignment: MainAxisAlignment.center,
                                //       children: [
                                //         const Icon(Icons.circle_outlined, color: Colors.purple, size: 25),
                                //         const SizedBox(
                                //           width: 15,
                                //         ),
                                //         Expanded(
                                //             child: TextFormField(
                                //               controller: doubleListAlternative4Controller[i][0],
                                //               keyboardType: TextInputType.text,
                                //               decoration: InputDecoration(
                                //                   isDense: true,
                                //                   border: const OutlineInputBorder(),
                                //                   labelText: 'Alternativa 4',
                                //                   labelStyle: TextStyle(
                                //                     color: AppColors.labelTextTematicaColor,
                                //                   ),
                                //                   enabledBorder: OutlineInputBorder(
                                //                       borderSide: BorderSide(
                                //                         color: AppColors.borderTematicaColor,
                                //                       )),
                                //                   focusedBorder: OutlineInputBorder(
                                //                       borderSide: BorderSide(
                                //                         color: AppColors.borderFocusedTematicaColor,
                                //                       ))),
                                //               style: TextStyle(color: AppColors.textTematicaColor),
                                //             )
                                //         ),
                                //       ],
                                //     ),
                                //     Row(
                                //       mainAxisAlignment: MainAxisAlignment.center,
                                //       children: [
                                //         const Icon(Icons.question_answer_outlined, color: Colors.purple, size: 25),
                                //         const SizedBox(
                                //           width: 15,
                                //         ),
                                //         Expanded(
                                //             child: TextFormField(
                                //               controller: doubleListAnswerController[i][0],
                                //               keyboardType: TextInputType.number,
                                //               decoration: InputDecoration(
                                //                   isDense: true,
                                //                   border: const OutlineInputBorder(),
                                //                   labelText: 'RESPUESTA  = 1, 2, 3 o 4',
                                //                   labelStyle: TextStyle(
                                //                     color: AppColors.labelTextTematicaColor,
                                //                   ),
                                //                   enabledBorder: OutlineInputBorder(
                                //                       borderSide: BorderSide(
                                //                         color: AppColors.borderTematicaColor,
                                //                       )),
                                //                   focusedBorder: OutlineInputBorder(
                                //                       borderSide: BorderSide(
                                //                         color: AppColors.borderFocusedTematicaColor,
                                //                       ))),
                                //               style: TextStyle(color: AppColors.textTematicaColor),
                                //             )
                                //         ),
                                //       ],
                                //     ),
                                //     const SizedBox(
                                //       height: 10,
                                //     ),
                                //   ]);
                                // }

                              } else {

                                if (listQuestions.isNotEmpty && doubleListQuestionController.isNotEmpty && doubleListIdE.isNotEmpty
                                && doubleListIdQ.isNotEmpty && doubleListAlternative1Controller.isNotEmpty && doubleListAlternative2Controller.isNotEmpty
                                && doubleListAlternative3Controller.isNotEmpty && doubleListAlternative4Controller.isNotEmpty && doubleListAnswerController.isNotEmpty) {
                                  for (int i = 0; i < doubleListQuestionController.length; i++) {
                                    for (int j = 0; j < doubleListQuestionController[i].length; j++) {
                                      int x = doubleListIdQ[i].length;
                                      print("XJ "+ x.toString() + j.toString());
                                      if (x > j) {
                                        print("AAA");
                                      updateQuestion(doubleListIdQ[i][j].toString(), doubleListQuestionController[i][j].text,
                                          doubleListAlternative1Controller[i][j].text, doubleListAlternative2Controller[i][j].text,
                                          doubleListAlternative3Controller[i][j].text, doubleListAlternative4Controller[i][j].text,
                                          doubleListAnswerController[i][j].text, doubleListIdE[i][j].toString());
                                      } else {
                                        print("FFF");
                                        saveQuestion(doubleListQuestionController[i][j].text,
                                            doubleListAlternative1Controller[i][j].text, doubleListAlternative2Controller[i][j].text,
                                            doubleListAlternative3Controller[i][j].text, doubleListAlternative4Controller[i][j].text,
                                            doubleListAnswerController[i][j].text, doubleListIdE[i][0].toString(), i);
                                      }
                                    }
                                  }
                                }


                                continued3();
                                Navigator.pushNamed(context, Routes.actionsMyCourses);
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
                              controller: descriptionThematicController,
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
                              controller: portraitThematicController,
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
                                    controller: nivelThematicController,
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
                                            value: categoryIdDropDownValue,
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
                                              // This is called when the user selects an item.
                                              setState(() {
                                                categoryIdDropDownValue = value!;
                                                print("ID CATEGORY $categoryIdDropDownValue");
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
                                    controller: minCalificationThematicController,
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
                                    controller: starRateThematicController,
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
                                    controller: nTimeThematicController,
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
                                    controller: nBadgeThematicController,
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
                                        listLinkContentControllerV.add(TextEditingController());
                                        listNameContentControllerV.add(TextEditingController());
                                        listPositionContentControllerV.add(TextEditingController());
                                        print("HYYY " + listLinkContentControllerV.toString());

                                        addRowV(listLinkContentControllerV.last, listNameContentControllerV.last, listPositionContentControllerV.last);
                                      },
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(
                                height: 5,
                              ),

                              // SizedBox(
                              //   height: 200,
                              //   child: GridView.count(
                              //       crossAxisSpacing: 5,
                              //       mainAxisSpacing: 5,
                              //       crossAxisCount: 4,
                              //       children: List.generate(listWidgetVToUpdate.length, (index) {
                              //         return Container (
                              //           child: listWidgetVToUpdate[index],
                              //         );
                              //       })
                              //   ),
                              // ),

                              listWidgetVToUpdate.isNotEmpty ? SizedBox(
                                height: 200,
                                child: GridView.count(
                                    crossAxisSpacing: 5,
                                    mainAxisSpacing: 5,
                                    crossAxisCount: 4,
                                    children: List.generate(listWidgetVToUpdate.length, (aux) {
                                      return Container (
                                        child: listWidgetVToUpdate[aux],
                                      );
                                    })
                                ),
                              ) : Container(height: 200),

                              const SizedBox(
                                height: 10,
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
                                        listLinkContentControllerI.add(TextEditingController());
                                        listNameContentControllerI.add(TextEditingController());
                                        listPositionContentControllerI.add(TextEditingController());
                                        print("HYYaaY " + listLinkContentControllerI.toString());

                                        addRowI(listLinkContentControllerI.last, listNameContentControllerI.last, listPositionContentControllerI.last);
                                      },
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(
                                height: 5,
                              ),

                              if (listWidgetIToUpdate.isNotEmpty)
                                SizedBox(
                                  height: 200,
                                  child: GridView.count(
                                      crossAxisSpacing: 5,
                                      mainAxisSpacing: 5,
                                      crossAxisCount: 4,
                                      children: List.generate(listWidgetIToUpdate.length, (index) {
                                        return Container (
                                          child: listWidgetIToUpdate[index],
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
                            if (doubleListAnswerController.isNotEmpty)
                              for (int i = 0; i < doubleListAnswerController.length; i++)
                                Text("QUEST + $i  ${ doubleListAnswerController[i].length }"),


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
                                                  for (int i = 0; i < doubleListQuestion.length; i++)
                                                    InkWell(
                                                      onTap: () {

                                                        if (doubleListQuestionController[i].last.text.isNotEmpty && doubleListAlternative1Controller[i].last.text.isNotEmpty &&
                                                            doubleListAlternative2Controller[i].last.text.isNotEmpty && doubleListAlternative3Controller[i].last.text.isNotEmpty &&
                                                            doubleListAlternative4Controller[i].last.text.isNotEmpty && doubleListAnswerController[i].last.text.isNotEmpty) {
                                                          // print("ANADIR QUESTION");
                                                          // print(doubleListAlternative1Controller[i].lastWhere((element) => element.text.isNotEmpty).text);
                                                          // saveQuestion(doubleListQuestionController[i].lastWhere((element) => element.text.isNotEmpty).text,
                                                          //     doubleListAlternative1Controller[i].lastWhere((element) => element.text.isNotEmpty).text,
                                                          //     doubleListAlternative2Controller[i].lastWhere((element) => element.text.isNotEmpty).text,
                                                          //     doubleListAlternative3Controller[i].lastWhere((element) => element.text.isNotEmpty).text,
                                                          //     doubleListAlternative4Controller[i].lastWhere((element) => element.text.isNotEmpty).text,
                                                          //     doubleListAnswerController[i].lastWhere((element) => element.text.isNotEmpty).text,
                                                          //     idsExams[i].toString(), i);
                                                          doubleListQuestionController[i].add(TextEditingController());
                                                          doubleListAlternative1Controller[i].add(TextEditingController());
                                                          doubleListAlternative2Controller[i].add(TextEditingController());
                                                          doubleListAlternative3Controller[i].add(TextEditingController());
                                                          doubleListAlternative4Controller[i].add(TextEditingController());
                                                          doubleListAnswerController[i].add(TextEditingController());
                                                          addQuestion(doubleListQuestionController[i].last, doubleListAlternative1Controller[i].last, doubleListAlternative2Controller[i].last,
                                                              doubleListAlternative3Controller[i].last, doubleListAlternative4Controller[i].last, doubleListAnswerController[i].last, i);
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
                                                              child: Text('Video ${listNameExam[i]}', style: TextStyle(fontSize: 16, color: Color(0xff2E3E5C), fontWeight: FontWeight.bold)),
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
                                  },
                                  icon: const Icon(Icons.add_box, color: Colors.green),
                                ),
                              ],
                            ),

                            const SizedBox(
                              height: 30,
                            ),

                            if (doubleListQuestion.isNotEmpty)
                              for (int i = 0; i < listNameContentControllerV.length; i++)
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
          ),
        ),
      ],
    );
  }

  tapped(int step){
    setState(() => _currentStep = step);
  }

  continued1(){
    _currentStep < 3 ?
    setState(() => _currentStep += 1): null;
  }

  continued2(){
    _currentStep < 3 ?
    setState(() => _currentStep += 1): null;
  }

  continued3(){
    _currentStep < 3 ?
    setState(() => _currentStep += 0): null;
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

  continued(){
    _currentStep < 2 ?
    setState(() => _currentStep += 1): null;
  }
  cancel(){
    _currentStep > 0 ?
    setState(() => _currentStep -= 1) : null;
  }
}


