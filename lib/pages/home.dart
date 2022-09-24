import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gravatar/flutter_gravatar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:lexp/models/task.dart';
import 'package:lexp/pages/administrator.dart';
import 'package:lexp/pages/badge_shop.dart';
import 'package:lexp/pages/explore.dart';
import 'package:lexp/pages/help.dart';
import 'package:lexp/pages/my_notes.dart';
import 'package:lexp/pages/my_t_units.dart';
import 'package:lexp/services/shared_service.dart' as shared_service;
import 'package:lexp/widgets/gradient_text.dart';
import 'package:lexp/widgets/task.dart';
import 'package:sizer/sizer.dart';
import 'package:lexp/core/res/color.dart';
import 'package:lexp/core/routes/routes.dart';
import 'package:lexp/widgets/block_menu.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // control the drawer
  late Future _userFetchDevice;
  final List<TaskModel> _tasksList = [
    TaskModel(from: DateTime(2022, 03, 16, 10, 00), to: DateTime(2022, 03, 16, 15, 00), taskName: "Finanzas comerciales"),
    TaskModel(from: DateTime(2022, 03, 16, 4, 00), to: DateTime(2022, 03, 16, 5, 00), taskName: "Clase de Hipoteca"),
  ];

  @override
  void initState() {
    _userFetchDevice = shared_service.SharedService().getUser("user");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerProfile(userFetchDevice: _userFetchDevice),
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
                _key.currentState!.openDrawer();
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
                _onGoingHeader(),
                const SizedBox(
                  height: 15,
                ),
                buildGrid(),
                const SizedBox(
                  height: 25,
                ),
                Column(
                  children: _tasksList
                      .map(
                        (e) => TaskWidget(
                          taskModel: e,
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Center _onGoingHeader() {
    return Center(
      child: GradientText(
        "Finance Free",
        gradient: LinearGradient(
          colors: [
            AppColors.customPink,
            Colors.cyan,
          ],
        ),
        style: TextStyle(color: AppColors.enProgresoColor, fontWeight: FontWeight.bold, fontSize: 30, fontFamily: "Finance", shadows: const [
          Shadow(
            blurRadius: 7.0,
            color: Colors.black,
            offset: Offset(1, 2),
          ),
        ]),
      ),
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
              _userFetchDevice.then((value) => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyThematicsScreen(
                            user: value,
                          ))));
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
              _userFetchDevice.then((value) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ExploreScreen(
                      user: value,
                    ),
                  ),
                );
              });
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
            onTap: () {
              _userFetchDevice.then((value) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyNotesScreen(
                      user: value,
                    ),
                  ),
                );
              });
            },
            blockTittle: "Bloc de notas",
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
            onTap: () {
              _userFetchDevice.then((value) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BadgeShopScreen(
                      user: value,
                    ),
                  ),
                );
              });
            },
          ),
        ),
      ],
    );
  }
}

class DrawerProfile extends StatelessWidget {
  const DrawerProfile({
    Key? key,
    required Future userFetchDevice,
  })  : _userFetchDevice = userFetchDevice,
        super(key: key);

  final Future _userFetchDevice;

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
                        future: _userFetchDevice,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            Gravatar gravatar = Gravatar(snapshot.data!.email);
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
                      Navigator.pop(context);
                      _userFetchDevice.then((value) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HelpScreen(
                              user: value,
                            ),
                          ),
                        );
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          // FutureBuilder(
          //   future: _userFetchDevice,
          //   builder: (context, snapshot) {
          //     if (snapshot.hasData) {
          //       return Container(
          //         color: AppColors.drawerColor,
          //         child: snapshot.data!.type == 0
          //             ? ListTile(
          //                 title: Text('Administrador',
          //                     style: TextStyle(
          //                       fontWeight: FontWeight.bold,
          //                       fontSize: 16,
          //                       color: AppColors.customPurple,
          //                     )),
          //                 trailing: Icon(
          //                   Icons.admin_panel_settings,
          //                   color: AppColors.customPurple,
          //                 ),
          //                 onTap: () {
          //                   Navigator.pop(context);
          //                   Navigator.push(
          //                       context,
          //                       MaterialPageRoute(
          //                         builder: ((context) => const AdministratorScreen()),
          //                       ));
          //                 },
          //               )
          //             : const SizedBox(
          //                 height: 0,
          //               ),
          //       );
          //     } else {
          //       return SpinKitFadingCube(
          //         color: AppColors.customPurple,
          //         size: 69.0,
          //       );
          //     }
          //   },
          // ),

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
              subtitle: const CloseSessionIcon(),
            ),
          )
        ],
      ),
    );
  }
}

class CloseSessionIcon extends StatelessWidget {
  const CloseSessionIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
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
                      content: Text("¿Estás seguro de que quieres cerrar sesión?", style: TextStyle(color: AppColors.dialogContentColor)),
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
            });
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
