import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../core/res/color.dart';
import '../core/routes/routes.dart';
import '../widgets/block_menu.dart';

class AdministratorScreen extends StatefulWidget {
  const AdministratorScreen({Key? key}) : super(key: key);

  @override
  State<AdministratorScreen> createState() => _AdministratorScreenState();
}

class _AdministratorScreenState extends State<AdministratorScreen> {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
          mainAxisCellCount: 0.40,
          child: BlockMenuContainer(
            color: AppColors.misCategoriasColor,
            icon: Icons.category,
            isSmall: true,
            //blockSubLabel: "10 Páginas",
            blockTittle: "Mis categorias",
            onTap: () {
              Navigator.pushNamed(context, Routes.actionsMyCategories);
            },
          ),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 0.40,
          child: BlockMenuContainer(
            color: AppColors.misCursosColor,
            icon: Icons.menu_book_outlined,
            isSmall: true,
            //blockSubLabel: "10 Páginas",
            blockTittle: "Mis cursos",
            onTap: () {
              Navigator.pushNamed(context, Routes.actionsMyCourses);
            },
          ),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 0.40,
          child: BlockMenuContainer(
            color: AppColors.ticketColor,
            isSmall: true,
            icon: Icons.airplane_ticket,
            onTap: () {
              //Navigator.pushNamed(context, Routes.todaysTask);
            },
            blockTittle: "Tickets", //sugerencias primero
            //blockSubLabel: "Encuentra tickets",
          ),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 0.40,
          child: BlockMenuContainer(
            color: AppColors.insigniasColor,
            isSmall: true,
            icon: Icons.emoji_events,
            //blockSubLabel: "9 Insignias",
            blockTittle: "Insignias",
          ),
        ),
      ],
    );
  }

}
