import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gravatar/flutter_gravatar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:lexp/services/shared_service.dart' as shared_service;
import 'package:sizer/sizer.dart';
import 'package:lexp/core/res/color.dart';
import 'package:lexp/core/routes/routes.dart';
import 'package:lexp/widgets/circle_gradient_icon.dart';
import 'package:lexp/widgets/block_menu.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // control the drawer
  Gravatar gravatar = Gravatar('example@email.com');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                color: AppColors.drawerColor,
                child: ListView(
                  padding: EdgeInsets.zero, //removes any padding
                  shrinkWrap: true,
                  children: <Widget>[
                    DrawerHeader(
                        padding: const EdgeInsets.fromLTRB(16, 28, 10, 8),
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topRight,
                          colors: [
                            AppColors.degradedImage1Color,
                            AppColors.degradedImage2Color,
                          ],
                        )),
                        child: FutureBuilder(
                          future: shared_service.SharedService().getUser("user"),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              gravatar = Gravatar(snapshot.data!.email);
                              CachedNetworkImageProvider chargedImage = CachedNetworkImageProvider(gravatar.imageUrl());
                              return ListTile(
                                  onTap: () => {
                                        //Navigator.pushNamed(context, Routes.profile)
                                        Navigator.pop(context)
                                      },
                                  leading: CircleAvatar(
                                    radius: 32,
                                    foregroundImage: chargedImage,
                                  ),
                                  title: Text(
                                    snapshot.data!.username,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                  subtitle: Text(
                                    shared_service.SharedService().getIGN(snapshot.data!.username, snapshot.data!.idUser),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                  trailing: InkWell(
                                    onTap: () {
                                      //Navigator.pushNamed(context, Routes.profile);
                                      Navigator.pop(context);
                                    },
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: AppColors.arrowForwardColor,
                                    ),
                                  ));
                            } else {
                              return SpinKitFadingCube(
                                color: AppColors.customPurple,
                                size: 69.0,
                              );
                            }
                          },
                        )),
                    ListTile(
                      title: Text('Configuraciones',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.optLabelColor,
                          )),
                      trailing: Icon(
                        Icons.settings,
                        color: AppColors.optLabelColor,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        // TODO: last page
                        Navigator.pushNamed(context, Routes.preferences);
                      },
                    ),
                    ListTile(
                      title: Text(
                        'Notificaciones', //recordatorio 5h fuera de app
                        //TODO: Push notifications //last page
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.optLabelColor,
                        ),
                      ),
                      trailing: Icon(
                        Icons.notifications,
                        color: AppColors.optLabelColor,
                      ),
                      onTap: () {
                        // TODO: last page
                        // ...
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: Text('Ayuda',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.optLabelColor,
                          )),
                      trailing: Icon(
                        Icons.help_outline,
                        color: AppColors.optLabelColor,
                      ),
                      onTap: () {
                        // Update the state of the app.
                        // ...
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: AppColors.drawerColor,
              child: ListTile(
                title: Text('Administrador',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.customPurple,
                    )),
                trailing: Icon(
                  Icons.admin_panel_settings,
                  color: AppColors.customPurple,
                ),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: last page
                  Navigator.pushNamed(context, Routes.administrator);
                },
              ),
            ),
            Container(
              color: AppColors.drawerColor,
              child: ListTile(
                title: Text("Cerrar sesión",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.cerrarSesionColor,
                      fontSize: 13,
                    )),
                subtitle: IconButton(
                    icon: const Icon(Icons.exit_to_app),
                    iconSize: 30,
                    color: AppColors.iconCerrarColor,
                    tooltip: "Cerrar sesión",
                    onPressed: () => {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Cerrar sesión"),
                                  backgroundColor: AppColors.dialogColor,
                                  content: Text("¿Estás seguro de que quieres cerrar sesión?",
                                      style: TextStyle(color: AppColors.dialogContentColor)),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text(
                                        "Cancelar",
                                        style: TextStyle(color: AppColors.buttomCancelarColor),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: Text("Aceptar", style: TextStyle(color: AppColors.buttomAceptarColor)),
                                      onPressed: () {
                                        shared_service.SharedService().logout();
                                        Navigator.pop(context);
                                        Navigator.pushNamedAndRemoveUntil(context, Routes.login, (_) => false);
                                      },
                                    ),
                                  ],
                                );
                              })
                        }),
              ),
            )
          ],
        ),
      ),
      key: _key,
      appBar: AppBar(
        title: Text(
          DateFormat.yMMMd().format(DateTime.now()),
          style: Theme.of(context)
              .textTheme
              .apply(bodyColor: AppColors.fechaColor, displayColor: AppColors.fechaColor)
              .bodySmall!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: InkWell(
              onTap: () {
                _key.currentState!.openDrawer(); //TODO: table admin //last page
              },
              customBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              child: const Icon(
                Icons.menu_rounded,
              ),
            ),
          ),
        ),
      ),
      extendBody: true,
      body: _buildBody(),
    );
  }

  Stack _buildBody() {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                _taskHeader(),
                const SizedBox(
                  height: 15,
                ),
                buildGrid(),
                const SizedBox(
                  height: 25,
                ),
                _onGoingHeader(),
                const SizedBox(
                  height: 10,
                ),
                const OnGoingTask(),
                const SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 30,
          right: 30,
          child: CircleGradientIcon(
            color: AppColors.searchColor,
            onTap: () {},
            size: 60,
            iconSize: 30,
            icon: Icons.search, //TODO: move to mis cursos, explorar, insignias
          ),
        )
      ],
    );
  }

  Row _onGoingHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "En progreso",
          style: TextStyle(
            color: AppColors.enProgresoColor,
            fontWeight: FontWeight.w700,
            fontSize: 22,
          ),
        ),
        const Spacer(),
        InkWell(
          onTap: () {},
          child: Text(
            "Ver todo",
            style: TextStyle(
              color: AppColors.verTodoColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        )
      ],
    );
  }

  Row _taskHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SelectableText(
          "Continuar aprendiendo",
          style: TextStyle(
            color: AppColors.continuarAprendiendoColor,
            fontWeight: FontWeight.w700,
            fontSize: 24,
          ),
          toolbarOptions: const ToolbarOptions(
            copy: true,
            selectAll: true,
          ),
        ),
        IconButton(onPressed: () {}, icon: Icon(Icons.add_circle_outline, color: AppColors.addCircleColor))
      ],
    );
  }

  StaggeredGrid buildGrid() {
    return StaggeredGrid.count(
      crossAxisCount: 2,
      mainAxisSpacing: 15,
      crossAxisSpacing: 15,
      children: [
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1.3,
          child: BlockMenuContainer(
            color: AppColors.misCursosColor,
            icon: Icons.menu_book_rounded,
            blockSubLabel: "10 Páginas",
            blockTittle: "Mis cursos",
            onTap: () {
              Navigator.pushNamed(context, Routes.page);
            },
          ),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: BlockMenuContainer(
            color: AppColors.explorarColor,
            isSmall: true,
            icon: Icons.zoom_in,
            onTap: () {
              Navigator.pushNamed(context, Routes.todaysTask);
            },
            blockTittle: "Explorar", //sugerencias primero
            blockSubLabel: "Encuentra cursos",
          ),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1.3,
          child: BlockMenuContainer(
            color: AppColors.blocDeNotasColor,
            icon: Icons.article,
            blockSubLabel: "2 Páginas",
            blockTittle: "Bloc de notas", //TODO: ver pagina 7 del PDF //ref
          ),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: BlockMenuContainer(
            color: AppColors.insigniasColor,
            isSmall: true,
            icon: Icons.emoji_events,
            blockSubLabel: "9 Insignias",
            blockTittle: "Insignias",
          ),
        ),
      ],
    );
  }
}

class OnGoingTask extends StatelessWidget {
  const OnGoingTask({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(
        20,
      ),
      decoration: BoxDecoration(
        color: AppColors.containerCreditoColor,
        borderRadius: BorderRadius.circular(15),
      ),
      width: 100.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 60.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Credito hipotecario",
                  style: TextStyle(
                    color: AppColors.creditoHipotecarioColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Icon(
                      Icons.timelapse,
                      color: AppColors.timeLapseColor,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "5 - 10 min",
                      style: TextStyle(
                        color: AppColors.tiempoColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.containerCompletadoColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    "Completado - 80%",
                    style: TextStyle(
                      color: AppColors.completadoColor,
                    ),
                  ),
                )
              ],
            ),
          ),
          Icon(
            Icons.currency_exchange,
            size: 45,
            color: AppColors.currencyExchangeColor,
          )
        ],
      ),
    );
  }
}

class BottomNavClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);

    final firstControlPoint = Offset(size.width * 0.6, 0);
    final firstEndPoint = Offset(size.width * 0.58, 44);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    final secControlPoint = Offset(size.width * 0.55, 50);
    final secEndPoint = Offset(size.width * 0.5, 50);
    path.quadraticBezierTo(
      secControlPoint.dx,
      secControlPoint.dy,
      secEndPoint.dx,
      secEndPoint.dy,
    );

    /* path.lineTo(size.width * 0.45, 30);

    final lastControlPoint = Offset(size.width * 0.45, 20);
    final lastEndPoint = Offset(size.width * 0.2, 30);
    path.quadraticBezierTo(
      lastControlPoint.dx,
      lastControlPoint.dy,
      lastEndPoint.dx,
      lastEndPoint.dy,
    ); */

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
