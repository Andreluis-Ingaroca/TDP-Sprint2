import 'package:flutter/material.dart';
import 'package:lexp/core/res/color.dart';
import 'package:lexp/core/routes/routes.dart';
import 'package:lexp/models/thematic_unit.dart';
import 'package:lexp/services/rest_provider.dart' as rest;
import 'package:lexp/services/shared_service.dart' as shared;

class DeleteMyCourseScreen extends StatefulWidget {
  const DeleteMyCourseScreen({Key? key}) : super(key: key);

  @override
  State<DeleteMyCourseScreen> createState() => _DeleteMyCourseScreenState();
}

class _DeleteMyCourseScreenState extends State<DeleteMyCourseScreen> {

  final TextEditingController idOrNameController = TextEditingController();

  late List<ThematicUnitModel> _thematics;
  Map<int, String> filtrados = {};
  Map<int, String> saveFilter = {};
  late final Future _future;


  @override
  void initState() {
    _future = rest.RestProvider().callMethod("/tuc/fat");
    _future.then((value) => {
      _thematics = shared.SharedService().getTUnits(value),
      for (ThematicUnitModel t in _thematics) {
        filtrados[t.idThematicUnit] = t.thematicUnitName,
      },
    });

    // TODO: implement initState
    super.initState();
  }

  Future filter(String nameOrId) async {
    filtrados.forEach((key, value) {
      if (value.toLowerCase().contains(nameOrId.toLowerCase()) || key.toString() == nameOrId) {
        saveFilter[key] = value;
      }
    });
    print(saveFilter);
  }

  deleteThematic(String idThematic) async {
    var params = {
      "data": {
        "idThematicUnit": idThematic,
      }
    };

    rest.RestProvider().callMethod("/tuc/del", params).then((res) {
      print("Successful: ${res.statusCode}");
      setState((){

      });
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

      body: Builder(builder: (context) {
        return SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(child: Text("ELIMINAR UN CURSO", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24, color: AppColors.textActionsCoursesColor))),
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
                          leading: IconButton(icon: Icon(Icons.delete_forever, color: AppColors.deleteActionColor),
                              onPressed: () {
                                deleteThematic(key.toString());
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text("Se elimino correctamente la categoría: ${saveFilter[key]}"),
                                ));
                                saveFilter.remove(key);
                                setState(() {
                                  saveFilter;
                                });
                                Navigator.pushNamed(context, Routes.actionsMyCourses);
                              }),
                        );
                      }).toList(),
                    ),
                  )
                // FutureBuilder(
                //     future: _future,
                //     builder: (context, snapshot) {
                //       if (snapshot.hasData) {
                //         return ListView.builder(
                //           itemCount: saveFilter.length,
                //           itemBuilder: (context, index) {
                //             var data = saveFilter[index];
                //             return ListTile(
                //               title: Text(data!),
                //             );
                //           },
                //         );
                //       } else {
                //         return const CircularProgressIndicator();
                //       }
                //     }
                // ),
                // SizedBox(
                //   width: double.infinity,
                //   child: ElevatedButton(
                //     onPressed: () {
                //       saveCategory(nombreCategoriaController.text);
                //       Navigator.pushNamed(context, Routes.actionsMyCategories);
                //     },
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: AppColors.customPurple,
                //       shadowColor: AppColors.customPurple,
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(8.0),
                //       ),
                //     ),
                //     child: const Text('Crear',
                //         style:
                //         TextStyle(color: Colors.white, fontSize: 20)),
                //   ),
                // ),

              ],
            ),
          ),
        );
      }),
    );
  }
}
