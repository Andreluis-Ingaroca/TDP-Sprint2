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

class ModifyMyCourseScreen extends StatefulWidget {
  const ModifyMyCourseScreen({Key? key}) : super(key: key);

  @override
  State<ModifyMyCourseScreen> createState() => _ModifyMyCourseScreenState();
}

class _ModifyMyCourseScreenState extends State<ModifyMyCourseScreen> {

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

  int contToUpdate = 0;

  List<QuestionModel> listQuestions = [];

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

  addRowV(TextEditingController linkAddContentController, TextEditingController nameAddContentController, TextEditingController positionAddContentController) {
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
                                  // updateThematic(thematicToUpdate.idThematicUnit.toString(), nameThematicController.text, int.parse(categoryIdDropDownValue), descriptionThematicController.text,
                                  //     portraitThematicController.text, int.parse(nivelThematicController.text), int.parse(minCalificationThematicController.text),
                                  //     int.parse(starRateThematicController.text), int.parse(nTimeThematicController.text), int.parse(nBadgeThematicController.text));
                                  //
                                  // updateContent(thematicToUpdate.idThematicUnit.toString());
                                  print("HOLA1");
                                  listWidgetVToUpdate.clear();
                                } else if (_currentStep == 1) {

                                  // print("HOLA2");
                                  // doubleListQuestion.clear();
                                  // doubleListQuestionController.clear();
                                  // doubleListAlternative1Controller.clear();
                                  // doubleListAlternative2Controller.clear();
                                  // doubleListAlternative3Controller.clear();
                                  // doubleListAlternative4Controller.clear();
                                  // doubleListAnswerController.clear();
                                  // print("HOLA3");
                                  //
                                  // if  (listContentVToUpdate.isNotEmpty){
                                  //   for (int i = 0; i < listContentVToUpdate.length; i++) {
                                  //     saveContentWithId(listContentVToUpdate[i].idContent, listNameContentControllerV[i].text,
                                  //         thematicToUpdate.idThematicUnit, listPositionContentControllerV[i].text, listLinkContentControllerV[i].text);
                                  //
                                  //     //getExam(listContentVToUpdate[i].idContent.toString());
                                  //   }
                                  // }
                                  // if  (listContentIToUpdate.isNotEmpty){
                                  //   for (int i = 0; i < listContentIToUpdate.length; i++) {
                                  //     print("Id${listNameContentControllerI[i].text} ${listContentIToUpdate[i].idContent} ${thematicToUpdate.idThematicUnit}");
                                  //     saveContentWithId(listContentIToUpdate[i].idContent, listNameContentControllerI[i].text,
                                  //         thematicToUpdate.idThematicUnit, listPositionContentControllerI[i].text, listLinkContentControllerI[i].text);
                                  //   }
                                  // }
                                  // if  (listLinkContentControllerV.length - listContentVToUpdate.length > 0){
                                  //   for (int i = 0; i < (listLinkContentControllerV.length - listContentVToUpdate.length); i++) {
                                  //     saveContentV(listNameContentControllerV[i + listContentVToUpdate.length].text, thematicToUpdate.idThematicUnit,
                                  //         listPositionContentControllerV[i + listContentVToUpdate.length].text, listLinkContentControllerV[i + listContentVToUpdate.length].text);
                                  //
                                  //   }
                                  // }
                                  // if  (listLinkContentControllerI.length - listContentIToUpdate.length > 0){
                                  //   for (int i = 0; i < (listLinkContentControllerI.length - listContentIToUpdate.length); i++) {
                                  //     saveContentI(listNameContentControllerI[i + listContentIToUpdate.length].text, thematicToUpdate.idThematicUnit,
                                  //         listPositionContentControllerI[i + listContentIToUpdate.length].text, listLinkContentControllerI[i + listContentIToUpdate.length].text);
                                  //   }
                                  // }
                                  //
                                  // setState(() {
                                  //   listContentVToUpdate;
                                  //   listContentIToUpdate;
                                  //   listQuestions;
                                  // });

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
                                //
                                // Text("${listWidgetVToUpdate.length} JAJJA"),
                                //
                                // const SizedBox(
                                //   height: 5,
                                // ),
                                //
                                // // SizedBox(
                                // //   height: 200,
                                // //   child: GridView.count(
                                // //       crossAxisSpacing: 5,
                                // //       mainAxisSpacing: 5,
                                // //       crossAxisCount: 4,
                                // //       children: List.generate(listWidgetVToUpdate.length, (index) {
                                // //         return Container (
                                // //           child: listWidgetVToUpdate[index],
                                // //         );
                                // //       })
                                // //   ),
                                // // ),
                                //
                                // // listWidgetVToUpdate.isNotEmpty ? SizedBox(
                                // //   height: 200,
                                // //   child: GridView.count(
                                // //       crossAxisSpacing: 5,
                                // //       mainAxisSpacing: 5,
                                // //       crossAxisCount: 4,
                                // //       children: List.generate(listWidgetVToUpdate.length, (aux) {
                                // //         return Container (
                                // //           child: listWidgetVToUpdate[aux],
                                // //         );
                                // //       })
                                // //   ),
                                // // ) : Container(height: 200),
                                //
                                // const SizedBox(
                                //   height: 10,
                                // ),
                                //
                                // const Text("Imagenes", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20)),
                                //
                                // const SizedBox(
                                //   height: 30,
                                // ),
                                //
                                // SizedBox(
                                //   width: MediaQuery.of(context).size.width,
                                //   child: Row(
                                //     mainAxisAlignment: MainAxisAlignment.center,
                                //     children: [
                                //       Text("Enlace", style: TextStyle(color: AppColors.textCategoriaColor, fontWeight: FontWeight.w900)),
                                //       SizedBox(
                                //         width: MediaQuery.of(context).size.width*0.1,
                                //       ),
                                //       Text("Nombre", style: TextStyle(color: AppColors.textCategoriaColor, fontWeight: FontWeight.w900)),
                                //       SizedBox(
                                //         width: MediaQuery.of(context).size.width*0.1,
                                //       ),
                                //       Text("Posicion", style: TextStyle(color: AppColors.textCategoriaColor, fontWeight: FontWeight.w900)),
                                //       SizedBox(
                                //         width: MediaQuery.of(context).size.width*0.1,
                                //       ),
                                //       IconButton(
                                //         icon: const Icon(Icons.add, color: Colors.green),
                                //         iconSize: 20,
                                //         onPressed: () {
                                //           listLinkContentControllerI.add(TextEditingController());
                                //           listNameContentControllerI.add(TextEditingController());
                                //           listPositionContentControllerI.add(TextEditingController());
                                //           print("HYYaaY " + listLinkContentControllerI.toString());
                                //
                                //           //addRowI(listLinkContentControllerI.last, listNameContentControllerI.last, listPositionContentControllerI.last);
                                //         },
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                //
                                // const SizedBox(
                                //   height: 5,
                                // ),
                                //
                                // if (listWidgetIToUpdate.isNotEmpty)
                                //   SizedBox(
                                //     height: 200,
                                //     child: GridView.count(
                                //         crossAxisSpacing: 5,
                                //         mainAxisSpacing: 5,
                                //         crossAxisCount: 4,
                                //         children: List.generate(listWidgetIToUpdate.length, (index) {
                                //           return Container (
                                //             child: listWidgetIToUpdate[index],
                                //           );
                                //         })
                                //     ),
                                //   ),

                              ],
                            ),
                          ),
                          isActive: _currentStep >= 0,
                          state: _currentStep >= 1 ?
                          StepState.complete : StepState.disabled,
                        ),
                        // Step(
                        //   title: const Text('Contenido'),
                        //   content: SingleChildScrollView(
                        //     scrollDirection: Axis.vertical,
                        //     child: Column(
                        //       children: <Widget>[
                        //         const Text("Videos", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20)),
                        //
                        //         const SizedBox(
                        //           height: 30,
                        //         ),
                        //
                        //         SizedBox(
                        //           width: MediaQuery.of(context).size.width,
                        //           child: Row(
                        //             mainAxisAlignment: MainAxisAlignment.center,
                        //             children: [
                        //               Text("Enlace", style: TextStyle(color: AppColors.textCategoriaColor, fontWeight: FontWeight.w900)),
                        //               SizedBox(
                        //                 width: MediaQuery.of(context).size.width*0.1,
                        //               ),
                        //               Text("Nombre", style: TextStyle(color: AppColors.textCategoriaColor, fontWeight: FontWeight.w900)),
                        //               SizedBox(
                        //                 width: MediaQuery.of(context).size.width*0.1,
                        //               ),
                        //               Text("Posicion", style: TextStyle(color: AppColors.textCategoriaColor, fontWeight: FontWeight.w900)),
                        //               SizedBox(
                        //                 width: MediaQuery.of(context).size.width*0.1,
                        //               ),
                        //               IconButton(
                        //                 icon: const Icon(Icons.add, color: Colors.green),
                        //                 iconSize: 20,
                        //                 onPressed: () {
                        //                   listLinkContentControllerV.add(TextEditingController());
                        //                   listNameContentControllerV.add(TextEditingController());
                        //                   listPositionContentControllerV.add(TextEditingController());
                        //
                        //                   addRowV(listLinkContentControllerV.last, listNameContentControllerV.last, listPositionContentControllerV.last);
                        //
                        //                 },
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //
                        //         const SizedBox(
                        //           height: 5,
                        //         ),
                        //
                        //         if (listWidgetVToUpdate.isNotEmpty)
                        //           SizedBox(
                        //           height: 200,
                        //           child: GridView.count(
                        //               crossAxisSpacing: 5,
                        //               mainAxisSpacing: 5,
                        //               crossAxisCount: 4,
                        //               children: List.generate(listWidgetVToUpdate.length, (index) {
                        //                 return Container (
                        //                   child: listWidgetVToUpdate[index],
                        //                 );
                        //               })
                        //           ),
                        //         ),
                        //
                        //         const SizedBox(
                        //           height: 5,
                        //         ),
                        //
                        //         const Text("Imagenes", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20)),
                        //
                        //         const SizedBox(
                        //           height: 30,
                        //         ),
                        //
                        //         SizedBox(
                        //           width: MediaQuery.of(context).size.width,
                        //           child: Row(
                        //             mainAxisAlignment: MainAxisAlignment.center,
                        //             children: [
                        //               Text("Enlace", style: TextStyle(color: AppColors.textCategoriaColor, fontWeight: FontWeight.w900)),
                        //               SizedBox(
                        //                 width: MediaQuery.of(context).size.width*0.1,
                        //               ),
                        //               Text("Nombre", style: TextStyle(color: AppColors.textCategoriaColor, fontWeight: FontWeight.w900)),
                        //               SizedBox(
                        //                 width: MediaQuery.of(context).size.width*0.1,
                        //               ),
                        //               Text("Posicion", style: TextStyle(color: AppColors.textCategoriaColor, fontWeight: FontWeight.w900)),
                        //               SizedBox(
                        //                 width: MediaQuery.of(context).size.width*0.1,
                        //               ),
                        //               IconButton(
                        //                 icon: const Icon(Icons.add, color: Colors.green),
                        //                 iconSize: 20,
                        //                 onPressed: () {
                        //                   listLinkContentControllerI.add(TextEditingController());
                        //                   listNameContentControllerI.add(TextEditingController());
                        //                   listPositionContentControllerI.add(TextEditingController());
                        //
                        //                   addRowI(listLinkContentControllerI.last, listNameContentControllerI.last, listPositionContentControllerI.last);
                        //                 },
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //
                        //         const SizedBox(
                        //           height: 5,
                        //         ),
                        //
                        //         if (listWidgetIToUpdate.isNotEmpty)
                        //           SizedBox(
                        //             height: 200,
                        //             child: GridView.count(
                        //                 crossAxisSpacing: 5,
                        //                 mainAxisSpacing: 5,
                        //                 crossAxisCount: 4,
                        //                 children: List.generate(listWidgetIToUpdate.length, (index) {
                        //                   return Container (
                        //                     child: listWidgetIToUpdate[index],
                        //                   );
                        //                 })
                        //             ),
                        //           ),
                        //
                        //       ],
                        //     ),
                        //   ),
                        //   isActive: _currentStep >= 0,
                        //   state: _currentStep >= 1 ?
                        //   StepState.complete : StepState.disabled,
                        // ),
                        Step(
                          title: new Text('Preguntas'),
                          content: Column(
                            children: <Widget>[
                              for (int i = 0; i < listExamToUpdate.length; i++)
                                Text("EXAM + ${ listExamToUpdate[i].idExamen }"),


                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("QUESTIONARIO", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24)),
                                  IconButton(
                                    onPressed: () {
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
        ]
    );
  }

  tapped(int step){
    setState(() => _currentStep = step);
  }

  continued1(){
    _currentStep < 3 ?
    setState(() => _currentStep += 1): null;
    // _currentStep < 3 ?
    // setState(() => _currentStep += 1): null;
    // setState(() {
    //   _currentStep += 1;
    // });
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
