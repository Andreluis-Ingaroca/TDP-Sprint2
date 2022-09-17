import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lexp/core/res/app.dart';
import 'package:lexp/core/res/color.dart';
import 'package:lexp/core/routes/routes.dart';
import 'package:lexp/models/user.dart';
import 'package:lexp/services/shared_service.dart' as shared;
import 'package:lexp/services/rest_provider.dart' as rest;
import 'package:lexp/widgets/gradient_text.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RegisterScreenState();
  }
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  final passkey = GlobalKey<FormFieldState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  String _name = "";
  String _email = "";
  String _password = "";

  void _submitCommand() {
    final form = formKey.currentState;

    if (form!.validate()) {
      form.save();
      _registerCommand();
    }
  }

  void _registerCommand() {
    var params = {
      "data": {
        "username": _name,
        "email": _email,
        "timeQtty": 0,
        "preferences": 0,
        "pw": _password,
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
    rest.RestProvider().callMethod("/uc/su", params).then((userFetch) {
      Navigator.pop(context);
      var user = UserModel.fromJson(userFetch.data["data"]);
      shared.SharedService().saveUser("user", user);
      Navigator.pushNamedAndRemoveUntil(
          context, Routes.preferences, (_) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: GradientText(
            'Registrarse',
            gradient: AppColors.registerGradient,
          ),
        ),
        key: scaffoldKey,
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Align(
                  alignment: const Alignment(0, -1 / 3),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const SizedBox(height: 40),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.17,
                        child: Opacity(
                            opacity: 0.9,
                            child: SvgPicture.asset(AppConstants.logoSvg)),
                      ),
                      const SizedBox(height: 40),
                      Text(
                        'Ingresa tus datos',
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.ingresarDatosColor),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'para crear tu cuenta',
                        style: TextStyle(color: AppColors.ingresarContentColor),
                      ),
                      const SizedBox(height: 40),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Nombres y apellidos',
                            labelStyle: TextStyle(
                              color: AppColors.labelTextNameRegisterColor,
                            ),
                            border: const OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                              color: AppColors.borderNameRegisterColor,
                            )),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                              color: AppColors.borderFocusedNameRegisterColor,
                            ))),
                        style:
                            TextStyle(color: AppColors.textNameRegisterColor),
                        validator: (val) {
                          return shared.SharedService().validateNames(val!);
                        },
                        onSaved: (val) => _name = val!.trim(),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(
                              color: AppColors.labelTextEmailRegisterColor,
                            ),
                            border: const OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                              color: AppColors.borderEmailRegisterColor,
                            )),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                              color: AppColors.borderFocusedEmailRegisterColor,
                            ))),
                        style:
                            TextStyle(color: AppColors.textEmailRegisterColor),
                        validator: (val) {
                          return !EmailValidator.validate(val!.trim()) &&
                                  val.length < 150
                              ? 'Correo electrónico inválido'
                              : null;
                        },
                        onSaved: (val) => _email = val!.toLowerCase().trim(),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Contraseña',
                            labelStyle: TextStyle(
                              color: AppColors.labelTextPasswordRegisterColor,
                            ),
                            border: const OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                              color: AppColors.borderPasswordRegisterColor,
                            )),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                              color:
                                  AppColors.borderFocusedPasswordRegisterColor,
                            ))),
                        style: TextStyle(
                            color: AppColors.textPasswordRegisterColor),
                        validator: (val) {
                          _password = val!;
                          return shared.SharedService()
                              .validateStrongPassword(val);
                        },
                        onSaved: (val) => _password = val!,
                        obscureText: true,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Confirmar contraseña',
                            labelStyle: TextStyle(
                              color: AppColors
                                  .labelTextConfirmPasswordRegisterColor,
                            ),
                            border: const OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                              color:
                                  AppColors.borderConfirmPasswordRegisterColor,
                            )),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                              color: AppColors
                                  .borderFocusedConfirmPasswordRegisterColor,
                            ))),
                        style: TextStyle(
                            color: AppColors.textConfirmPasswordRegisterColor),
                        validator: (val) {
                          return val != passkey.currentState!.value
                              ? 'Las contraseñas no coinciden'
                              : null;
                        },
                        obscureText: true,
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _submitCommand,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.customPurple,
                              shadowColor: AppColors.customPurple,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: const Text(
                              'Registrarse',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          )),
                      const SizedBox(height: 8),
                      TextButton(
                        child: Text('Iniciar sesión',
                            style: TextStyle(
                                color: AppColors.iniciarSesionColor,
                                fontWeight: FontWeight.w900)),
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed("/login");
                        },
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              )),
        ));
  }
}
