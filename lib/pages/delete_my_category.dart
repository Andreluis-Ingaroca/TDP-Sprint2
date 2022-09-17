import 'package:flutter/material.dart';
import 'package:lexp/core/res/color.dart';
import 'package:lexp/core/routes/routes.dart';
import 'package:lexp/models/category.dart';
import 'package:lexp/services/rest_provider.dart' as rest;
import 'package:lexp/services/shared_service.dart' as shared;

class DeleteMyCategoryScreen extends StatefulWidget {
  const DeleteMyCategoryScreen({Key? key}) : super(key: key);

  @override
  State<DeleteMyCategoryScreen> createState() => _DeleteMyCategoryScreenState();
}

class _DeleteMyCategoryScreenState extends State<DeleteMyCategoryScreen> {

  final TextEditingController idOrNameController = TextEditingController();

  late List<CategoryModel> _categories;
  late final Future _future;
  List<String> idsCategories = [];
  List<String> namesCategories = [];
  Map<int, String> filtrados = {};
  Map<int, String> saveFilter = {};


  @override
  void initState() {
    _future = rest.RestProvider().callMethod("/cc/lac");
    _future.then((value) => {
      _categories = shared.SharedService().getCategories(value),
      for (CategoryModel c in _categories) {
        // idsCategories.add(c.idCategory.toString()),
        // namesCategories.add(c.categoryName),
        filtrados[c.idCategory] = c.categoryName,
        //dropdownValue = _categories[0].idCategory.toString(),
        //dropdownValue = idsCategories.first,
      },
      //print("CATGEORUA  "+ _categories.length.toString())
    });

    // TODO: implement initState
    super.initState();
    // dropdownValue = "1";
    // idsCategories;
  }

  Future filter(String nameOrId) async {
    filtrados.forEach((key, value) { 
      if (value.toLowerCase().contains(nameOrId.toLowerCase()) || key.toString() == nameOrId) {
        saveFilter[key] = value;
      }
    });
    print(saveFilter);
  }

  deleteCategory(String idCategory) async {
    var params = {
      "data": {
        "idCategory": idCategory,
      }
    };

    rest.RestProvider().callMethod("/cc/del", params).then((res) {
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
                Center(child: Text("ELIMINAR UNA CATEGORIA", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24, color: AppColors.textActionsCoursesColor))),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: idOrNameController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: 'Id o nombre de la categoría',
                      labelStyle: TextStyle(
                        color: AppColors.labelTextCategoriaColor,
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.borderCategoriaColor,
                          )),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.borderFocusedCategoriaColor,
                          ))),
                  style: TextStyle(color: AppColors.textCategoriaColor),
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
                            deleteCategory(key.toString());
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Se elimino correctamente la categoría: ${saveFilter[key]}"),
                            ));
                            saveFilter.remove(key);
                            setState(() {
                              saveFilter;
                            });
                            Navigator.pushNamed(context, Routes.actionsMyCategories);
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
      // body: SingleChildScrollView(
      //   child: Container(
      //     margin: const EdgeInsets.symmetric(
      //       horizontal: 15,
      //       vertical: 10,
      //     ),
      //     child: Column(
      //       crossAxisAlignment: CrossAxisAlignment.center,
      //       children: [
      //         Center(child: Text("ELIMINAR UNA CATEGORIA", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24, color: AppColors.textActionsCoursesColor))),
      //         const SizedBox(
      //           height: 30,
      //         ),
      //         // SizedBox(
      //         //   height: MediaQuery.of(context).size.height * 0.4,
      //         //   child: Opacity(
      //         //       opacity: 0.9,
      //         //       child: SvgPicture.asset(AppConstants.logoSvg)),
      //         // ),
      //         // const SizedBox(
      //         //   height: 30,
      //         // ),
      //         TextFormField(
      //           controller: idOrNameController,
      //           keyboardType: TextInputType.text,
      //           decoration: InputDecoration(
      //               border: const OutlineInputBorder(),
      //               labelText: 'Id o nombre de la categoría',
      //               labelStyle: TextStyle(
      //                 color: AppColors.labelTextCategoriaColor,
      //               ),
      //               enabledBorder: OutlineInputBorder(
      //                   borderSide: BorderSide(
      //                     color: AppColors.borderCategoriaColor,
      //                   )),
      //               focusedBorder: OutlineInputBorder(
      //                   borderSide: BorderSide(
      //                     color: AppColors.borderFocusedCategoriaColor,
      //                   ))),
      //           style: TextStyle(color: AppColors.textCategoriaColor),
      //         ),
      //         const SizedBox(
      //           height: 15,
      //         ),
      //         SizedBox(
      //           width: double.infinity,
      //           child: ElevatedButton(
      //             onPressed: () {
      //               print(idOrNameController.text);
      //               setState(() {
      //                 idOrNameController;
      //               });
      //             },
      //             style: ElevatedButton.styleFrom(
      //               backgroundColor: AppColors.customPurple,
      //               shadowColor: AppColors.customPurple,
      //               shape: RoundedRectangleBorder(
      //                 borderRadius: BorderRadius.circular(8.0),
      //               ),
      //             ),
      //             child: const Text('BUSCAR',
      //                 style:
      //                 TextStyle(color: Colors.white, fontSize: 20)),
      //           ),
      //         ),
      //
      //
      //         //if (idOrNameController.text.length >= 1)
      //         // FutureBuilder(
      //         //     future: rest.RestProvider().callMethod("/cc/lac"),
      //         //     builder: (context, snapshot) {
      //         //       if (snapshot.hasData) {
      //         //         categories = shared.SharedService()
      //         //             .getCategories(snapshot.data);
      //         //         // return ListView.builder(
      //         //         //     itemCount: categories.length,
      //         //         //     itemBuilder: (context, index) {
      //         //         //       var category = categories[index];
      //         //               return Padding(
      //         //                 padding: const EdgeInsets.all(10.0),
      //         //                 child: Column(
      //         //                   children: [
      //         //                     //Text('HOLA'),
      //         //                     //if ( category.categoryName.contains(idOrNameController.text) == true)
      //         //                     //Text('DATA ENTRANTE'),
      //         //                       DataTable(
      //         //                       columns: const [
      //         //                         DataColumn(label: Text("ID"), numeric: true),
      //         //                         DataColumn(label: Text("Nombre")),
      //         //                         //DataColumn(label: Text("")),
      //         //                       ],
      //         //                       rows: categories.map((category) => DataRow(
      //         //                           cells: [
      //         //                             DataCell(Text(category.idCategory.toString())),
      //         //                             DataCell(Text(category.categoryName)),
      //         //                             //DataCell(IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () { }))
      //         //                           ]
      //         //                       )).toList(),
      //         //                     ),
      //         //                     //if ( category.categoryName.contains(idOrNameController.text) == false)
      //         //                     //Text('NO HAY DATA'),
      //         //                   ],
      //         //                 ),
      //         //               );
      //         //         //    }
      //         //         //);
      //         //         //if (categories)
      //         //
      //         //       } else {
      //         //         return const CircularProgressIndicator();
      //         //       }
      //         //     }),
      //
      //         // SizedBox(
      //         //   width: double.infinity,
      //         //   child: ElevatedButton(
      //         //     onPressed: () {
      //         //       saveCategory(nombreCategoriaController.text);
      //         //       Navigator.pushNamed(context, Routes.actionsMyCategories);
      //         //     },
      //         //     style: ElevatedButton.styleFrom(
      //         //       backgroundColor: AppColors.customPurple,
      //         //       shadowColor: AppColors.customPurple,
      //         //       shape: RoundedRectangleBorder(
      //         //         borderRadius: BorderRadius.circular(8.0),
      //         //       ),
      //         //     ),
      //         //     child: const Text('Crear',
      //         //         style:
      //         //         TextStyle(color: Colors.white, fontSize: 20)),
      //         //   ),
      //         // ),
      //
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
