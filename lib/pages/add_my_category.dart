import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lexp/core/res/app.dart';
import 'package:lexp/core/res/color.dart';
import 'package:lexp/core/routes/routes.dart';
import 'package:lexp/pages/actions_my_categories.dart';
import 'package:lexp/services/rest_provider.dart' as rest;
import 'package:lexp/services/shared_service.dart' as shared;

class AddMyCategoryScreen extends StatefulWidget {
  const AddMyCategoryScreen({Key? key}) : super(key: key);

  @override
  State<AddMyCategoryScreen> createState() => _AddMyCategoryScreenState();
}

class _AddMyCategoryScreenState extends State<AddMyCategoryScreen> {

  final TextEditingController nombreCategoriaController = new TextEditingController();

  // void _categoryCommand() {
  //   var params = {
  //     "data": {
  //       "categoryName": nombreCategoriaController,
  //     }
  //   };
  //
  //   rest.RestProvider().callMethod("/cc/sc", params).then((value) {
  //     //Navigator.pop(context);
  //     var extracted = value.data;
  //     shared.SharedService().setKey("sessionKey", extracted["data"]["token"]);
  //     rest.RestProvider().callMethod("/uc/gube", params).then((userFetch) {
  //       var user = UserModel.fromJson(userFetch.data["data"]);
  //       shared.SharedService().saveUser("user", user);
  //       Navigator.pushNamedAndRemoveUntil(context, Routes.home, (_) => false);
  //     }, onError: (error) {
  //       SnackBar snackBar = SnackBar(
  //         content: Text('Error al recuperar el usuario $error'),
  //         backgroundColor: Colors.red,
  //       );
  //       ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //     });
  //   }, onError: (error) {
  //     Navigator.pop(context);
  //     if (error.toString().contains("Bad credentials")) {
  //       const snackBar = SnackBar(
  //         content: Text('Correo o contraseña incorrectos'),
  //         backgroundColor: Colors.red,
  //       );
  //       ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //     } else {
  //       final snackBar = SnackBar(
  //         content: Text('Fallo el incio de sesión $error'),
  //         backgroundColor: Colors.red,
  //       );
  //       ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //     }
  //   });
  // }

  saveCategory(String nameCategory) async {

    var params = {
        "data": {
          "categoryName": nameCategory,
      }
    };

    rest.RestProvider().callMethod("/cc/sc", params).then((res) {
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

      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(child: Text("CREAR UNA CATEGORIA", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24, color: AppColors.textActionsCoursesColor))),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                child: Opacity(
                    opacity: 0.9,
                    child: SvgPicture.asset(AppConstants.logoSvg)),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: nombreCategoriaController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Nombre de la categoría',
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
                    saveCategory(nombreCategoriaController.text);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Se creo correctamente la categoría: ${nombreCategoriaController.text}"),
                    ));
                    Navigator.pushNamed(context, Routes.actionsMyCategories);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.customPurple,
                    shadowColor: AppColors.customPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text('Crear',
                      style:
                      TextStyle(color: Colors.white, fontSize: 20)),
                ),
              ),

            ],
          ),
        ),
      ),

      // body: FutureBuilder(
      //     future: rest.RestProvider().callMethod("/cc/lac"),
      //     builder: (context, snapshot) {
      //       if (snapshot.hasData) {
      //         List<CategoryModel> categories =
      //         shared.SharedService()
      //             .getCategories(snapshot.data);
      //         // return ListView.builder(
      //         //     itemCount: categories.length,
      //         //     itemBuilder: (context, index) {
      //         //       var category = categories[index];
      //               return Padding(
      //                 padding: const EdgeInsets.all(10.0),
      //                 child: Column(
      //                   children: [
      //                     DataTable(
      //                         columns: const [
      //                           DataColumn(label: Text("Categoría ID"), numeric: true),
      //                           DataColumn(label: Text("Nombre Categoría")),
      //                         ],
      //                         rows: categories.map((category) => DataRow(
      //                           cells: [
      //                             DataCell(Text(category.idCategory.toString())),
      //                             DataCell(Text(category.categoryName)),
      //                           ]
      //                         )).toList(),
      //                     ),
      //                     //Center(child: Text("${category.idCategory} ${category.categoryName}")),
      //                   ],
      //                 ),
      //               );
      //         //    }
      //         //);
      //       } else {
      //         return const CircularProgressIndicator();
      //       }
      //     }),
    );
  }
}
