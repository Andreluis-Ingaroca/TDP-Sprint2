import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lexp/core/res/app.dart';
import 'package:lexp/core/res/color.dart';
import 'package:lexp/models/thematic_unit.dart';
import 'package:lexp/models/user.dart';
import 'package:lexp/models/user_unity.dart';
import 'package:lexp/pages/page.dart';
import 'package:lexp/widgets/gradient_text.dart';
import 'package:lexp/services/rest_provider.dart' as rest;

class ThematicUnitScreen extends StatefulWidget {
  const ThematicUnitScreen({Key? key, required this.tUnit, required this.user}) : super(key: key);

  final ThematicUnitModel tUnit;
  final UserModel user;

  @override
  State<StatefulWidget> createState() {
    return _ThematicUnitScreenState();
  }
}

class _ThematicUnitScreenState extends State<ThematicUnitScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GradientText(
          widget.tUnit.thematicUnitName,
          gradient: AppColors.textGradient,
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Column(
      children: <Widget>[
        Expanded(
            child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          children: [
            CachedNetworkImage(
              imageUrl: widget.tUnit.portrait,
              placeholder: (context, url) => SpinKitFadingCube(
                color: AppColors.customPurple,
                size: 30,
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            Center(
              child: Text(
                widget.tUnit.thematicUnitName,
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            AppConstants.space,
            const Text("Información:",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                )),
            Padding(padding: const EdgeInsets.all(11), child: Center(child: Text(widget.tUnit.description))),
            Row(
              children: [
                const Text("Duración:",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
                Text(" ${widget.tUnit.nTime} min."),
              ],
            ),
            AppConstants.space,
            const Text("Calificación del curso:",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                )),
            AppConstants.space,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.tUnit.thematicUnitName),
                AppConstants.spacew,
                Text(widget.tUnit.starRate.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    )),
                Icon(Icons.star, color: Colors.orange[300], size: 16),
              ],
            ),
          ],
        )),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 8.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: widget.tUnit.status == 1 ? () => {_submitCommand()} : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.customPurple,
                disabledBackgroundColor: Colors.grey,
                shadowColor: AppColors.customPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text(widget.tUnit.status == 1 ? 'Comenzar' : 'Proximamente', style: const TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ),
        ),
      ],
    );
  }

  void _submitCommand() {
    //TODO: check if the user has already started the unit
    var params = {
      "data": {
        "idThematicUnit": widget.tUnit.idThematicUnit,
        "idUser": widget.user.idUser,
        "finalCalification": null,
        "advQtty": 0,
        "badgeName": "IDK" //XXX: Change this
      }
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

    rest.RestProvider().callMethod("/uuc/sue", params).then((value) {
      Navigator.pop(context);
      UserUnityModel? enrollment;
      try {
        enrollment = UserUnityModel.fromJson(value.data["data"]);
      } catch (e) {
        const snackBar = SnackBar(
          content: Text("Error al obtener la información del curso"),
          backgroundColor: Colors.red,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PageScreen(userUnity: enrollment!, user: widget.user),
        ),
      );
    }, onError: (error) {
      Navigator.pop(context);
      SnackBar snackBar = SnackBar(
        content: Text("Error al matricularse: $error"),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }
}
