import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lexp/core/res/app.dart';
import 'package:lexp/core/res/color.dart';
import 'package:lexp/models/ticket.dart';
import 'package:lexp/models/user.dart';
import 'package:intl/intl.dart';
import 'package:lexp/services/rest_provider.dart' as rest;
import 'package:lexp/services/shared_service.dart' as shared;
import 'package:lexp/widgets/gradient_text.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({Key? key, required this.user}) : super(key: key);

  final UserModel user;

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final formKey = GlobalKey<FormState>();
  late List<TicketModel> _tickets;
  late final Future _getMyTickets;
  String auxDescription = "";
  int auxCateg = 0;

  @override
  void initState() {
    var params = {
      "data": {"idUser": widget.user.idUser}
    };
    _getMyTickets = rest.RestProvider().callMethod("/tc/gatbu", params);
    _getMyTickets.then((value) {
      _tickets = shared.SharedService().getTickets(value);
    });
    super.initState();
  }

  void _sendCommand() {
    final form = formKey.currentState;

    if (form!.validate()) {
      form.save();
      _saveCommand();
    }
  }

  _saveCommand() {
    var params = {
      "data": {"idUser": widget.user.idUser, "description": auxDescription, "categoryType": auxCateg}
    };
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.322),
      builder: (BuildContext context) {
        return SpinKitFadingCube(
          color: AppColors.customPurple,
          size: 69.0,
        );
      },
    );

    rest.RestProvider().callMethod("/tc/st", params).then((value) {
      Navigator.pop(context);
      const snackBar = SnackBar(
        content: Text('Ticket enviado!'),
        backgroundColor: Colors.green,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }, onError: (error) {
      Navigator.pop(context);
      const snackBar = SnackBar(
        content: Text('Error al enviar ticket!'),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: FutureBuilder(
            future: _getMyTickets,
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
                return Scaffold(
                    appBar: AppBar(
                      bottom: TabBar(
                        tabs: [
                          Tab(
                            child: Text("Ayuda", style: TextStyle(color: AppColors.customPurple)),
                          ),
                          Tab(
                            child: Text("Mis tickets", style: TextStyle(color: AppColors.customPurple)),
                          ),
                        ],
                      ),
                      title: GradientText(
                        "Ayuda",
                        gradient: AppColors.textGradient,
                      ),
                    ),
                    body: TabBarView(children: [
                      _helpFormBuilder(),
                      SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: FutureBuilder(
                                future: _getMyTickets,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        children: [
                                          DataTable(
                                            columns: const [
                                              DataColumn(label: Text("Categoria")),
                                              DataColumn(label: Text("Fecha")),
                                              DataColumn(label: Text("Estado")),
                                              DataColumn(label: Text("Ticket #")),
                                            ],
                                            rows: _tickets
                                                .map((tickets) => DataRow(cells: [
                                                      DataCell(Text(AppConstants.categoriaAyuda[tickets.categoryType]!)),
                                                      DataCell(Text(DateFormat('dd/MM/yyyy').format(tickets.fecReg!))),
                                                      DataCell(Text(AppConstants.estadoAyuda[tickets.status!]!)),
                                                      DataCell(Text(tickets.idTicket.toString())),
                                                      //DataCell(IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () { }))
                                                    ]))
                                                .toList(),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    return const CircularProgressIndicator();
                                  }
                                })),
                      )
                    ]));
              } else {
                return Center(
                    child: Container(
                        color: AppColors.drawerColor,
                        child: SpinKitFadingCube(
                          color: AppColors.customPurple,
                          size: 42.0,
                        )));
              }
            }));
  }

  Widget _helpFormBuilder() {
    return SingleChildScrollView(
        child: Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              "¿En qué podemos ayudarte?",
              style: TextStyle(
                color: AppColors.customPurple,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Categoría",
              ),
              items: AppConstants.categoriaAyuda.keys.map((key) {
                return DropdownMenuItem<String>(
                  value: key.toString(),
                  child: Text(AppConstants.categoriaAyuda[key]!),
                );
              }).toList(),
              onChanged: (value) {
                auxCateg = int.parse(value.toString());
              },
              validator: (value) {
                if (value == null) {
                  return "Seleccione una categoría";
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Descripción",
              ),
              maxLines: 5,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese una descripción';
                }
                return null;
              },
              onSaved: (value) {
                auxDescription = value!;
              },
              keyboardType: TextInputType.multiline,
            ),
            const SizedBox(height: 20),
            SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.customPurple,
                    shadowColor: AppColors.customPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () {
                    _sendCommand();
                  },
                  child: const Text("Enviar"),
                )),
          ],
        ),
      ),
    ));
  }
}
