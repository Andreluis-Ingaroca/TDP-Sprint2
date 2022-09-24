import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lexp/core/res/color.dart';
import 'package:lexp/models/notes.dart';
import 'package:lexp/models/user.dart';
import 'package:lexp/models/user_unity.dart';
import 'package:lexp/pages/note_list.dart';
import 'package:lexp/widgets/gradient_text.dart';
import 'package:lexp/services/rest_provider.dart' as rest;
import 'package:lexp/services/shared_service.dart' as shared;

class MyNotesScreen extends StatefulWidget {
  const MyNotesScreen({super.key, required this.user});

  final UserModel user;

  @override
  State<StatefulWidget> createState() {
    return _MyNotesScreenState();
  }
}

class _MyNotesScreenState extends State<MyNotesScreen> {
  late final Future _future;
  late final Future _getTUnits;
  late final Future _getNotes;
  late List<UserUnityModel> _myTUnits;
  late final List<NotesModel> _myNotes;

  @override
  void initState() {
    var params = {
      "data": {"idUser": widget.user.idUser}
    };
    _getTUnits = rest.RestProvider().callMethod("/uuc/gabu", params);
    _getTUnits.then((value) => _myTUnits = shared.SharedService().getEnrolls(value));
    _getNotes = rest.RestProvider().callMethod("/nc/gabiu", params);
    _getNotes.then((value) => {_myNotes = shared.SharedService().getNotes(value)});
    _future = Future.wait([_getTUnits, _getNotes]);
    _future.then((value) => {
          _myTUnits = _myTUnits.where((element) => _myNotes.any((note) => note.idUxU == element.idUxU)).toList(),
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GradientText(
          "Mis notas",
          gradient: AppColors.textGradient,
        ),
      ),
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            if (snapshot.error.toString().contains("SocketException")) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.wifi_off,
                      size: 100,
                      color: AppColors.customPurple,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "No hay conexión con el servidor",
                      style: TextStyle(
                        color: AppColors.customPurple,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error,
                      size: 100,
                      color: AppColors.customPurple,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Ha ocurrido un error inesperado",
                      style: TextStyle(
                        color: AppColors.customPurple,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              );
            }
          }
          if (snapshot.hasData) {
            return _buildBody(context);
          } else {
            return Center(
                child: Container(
                    color: AppColors.drawerColor,
                    child: SpinKitFadingCube(
                      color: AppColors.customPurple,
                      size: 42.0,
                    )));
          }
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Stack(
      children: [
        GridView.builder(
            itemCount: _myTUnits.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.6),
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                  padding: EdgeInsets.only(
                      top: index % 2 == 0 ? 10 : 10,
                      right: index % 2 == 0 ? 5 : 20,
                      left: index % 2 == 1 ? 5 : 20,
                      bottom: index % 2 == 1 ? 10 : 10),
                  child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NoteListScreen(
                              user: widget.user,
                              notes: _myNotes.where((element) => element.idUxU == _myTUnits[index].idUxU).toList(),
                              tittle: _myTUnits[index].thematicUnit!.thematicUnitName,
                            ),
                          ),
                        );
                      },
                      child: Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                  AppColors.degradedImage1Color,
                                  const Color.fromARGB(255, 4, 201, 194),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 5, offset: const Offset(0, 5))]),
                          child: Column(
                            children: [
                              Expanded(
                                  child: Stack(
                                children: [
                                  ClipRRect(
                                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                                      child: CachedNetworkImage(
                                        imageUrl: _myTUnits[index].thematicUnit!.portrait,
                                        placeholder: (context, url) => SpinKitFadingCube(
                                          color: AppColors.customPurple,
                                          size: 30,
                                        ),
                                        errorWidget: (context, url, error) => const Icon(Icons.error),
                                      )),
                                  //number of notes
                                  Positioned(
                                    bottom: 10,
                                    left: 15,
                                    child: Text("${_myNotes.where((element) => element.idUxU == _myTUnits[index].idUxU).length} notas",
                                        style: const TextStyle(color: Colors.white, fontSize: 16)),
                                  ),
                                ],
                              )),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _myTUnits[index].thematicUnit!.thematicUnitName,
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ))));
            }),
      ],
    );
  }
}
