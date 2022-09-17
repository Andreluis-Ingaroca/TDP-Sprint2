import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lexp/models/category.dart';
import 'package:lexp/services/rest_provider.dart' as rest;
import 'package:lexp/services/shared_service.dart' as shared;
import '../core/res/color.dart';
import '../core/routes/routes.dart';
import '../widgets/block_menu.dart';

class ActionsMyCategoriesScreen extends StatefulWidget {
  const ActionsMyCategoriesScreen({Key? key}) : super(key: key);

  @override
  State<ActionsMyCategoriesScreen> createState() => _ActionsMyCategoriesScreenState();
}

class _ActionsMyCategoriesScreenState extends State<ActionsMyCategoriesScreen> {

  late List<CategoryModel> categories = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    categories;
  }

  void updateCategories() {
    setState(() {
      categories;
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
              Text("MIS CATEGORIAS", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24, color: AppColors.textActionsCoursesColor), textAlign: TextAlign.center),
              const SizedBox(
                height: 15,
              ),
              FutureBuilder(
                  future: rest.RestProvider().callMethod("/cc/lac"),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      categories = shared.SharedService()
                          .getCategories(snapshot.data);
                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            DataTable(
                              columns: const [
                                DataColumn(label: Text("ID"), numeric: true),
                                DataColumn(label: Text("Nombre")),
                                //DataColumn(label: Text("")),
                              ],
                              rows: categories.map((category) => DataRow(
                                  cells: [
                                    DataCell(Text(category.idCategory.toString())),
                                    DataCell(Text(category.categoryName)),
                                    //DataCell(IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () { }))
                                  ]
                              )).toList(),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  }),
              const SizedBox(
                height: 15,
              ),
              buildGrid(),
            ],
          ),
        ),
      ),
    );
  }

  StaggeredGrid buildGrid() {
    return StaggeredGrid.count(
      crossAxisCount: 1,
      mainAxisSpacing: 15,
      crossAxisSpacing: 15,
      children: [
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 0.4,
          child: BlockMenuContainer(
            color: AppColors.addActionColor,
            icon: Icons.bookmark_add,
            isSmall: true,
            //blockSubLabel: "10 Páginas",
            blockTittle: "Agregar",
            onTap: () {
              Navigator.pushNamed(context, Routes.addMyCategory);
            },
          ),
        ),
        // StaggeredGridTile.count(
        //   crossAxisCellCount: 1,
        //   mainAxisCellCount: 0.4,
        //   child: BlockMenuContainer(
        //     color: AppColors.updateActionColor,
        //     isSmall: true,
        //     icon: Icons.bookmark_border,
        //     onTap: () {
        //       //Navigator.pushNamed(context, Routes.todaysTask);
        //     },
        //     blockTittle: "Modificar", //sugerencias primero
        //     //blockSubLabel: "Modificar",
        //   ),
        // ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 0.4,
          child: BlockMenuContainer(
            color: AppColors.deleteActionColor,
            isSmall: true,
            icon: Icons.bookmark_remove,
            //blockSubLabel: "9 Insignias",
            blockTittle: "Eliminar",
            onTap: () {
              Navigator.pushNamed(context, Routes.deleteMyCategory);
            },
          ),
        ),
      ],
    );
  }

}
