import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lexp/core/res/app.dart';
import 'package:lexp/core/res/color.dart';
import 'package:lexp/core/routes/routes.dart';
import 'package:lexp/models/user.dart';
import 'package:lexp/services/rest_provider.dart' as rest;
import 'package:lexp/services/shared_service.dart' as shared;
import 'package:lexp/widgets/gradient_text.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  String _email = "";
  String _password = "";

  void _submitCommand() {
    final form = formKey.currentState;

    if (form!.validate()) {
      form.save();

      // Email & password matched our validation rules
      // and are saved to _email and _password fields.
      _loginCommand();
    }
  }

  void _loginCommand() {
    var params = {
      "data": {
        "email": _email,
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

    rest.RestProvider().callMethod("/ac/lg", params).then((value) {
      Navigator.pop(context);
      var extracted = value.data;
      shared.SharedService().setKey("sessionKey", extracted["data"]["token"]);
      rest.RestProvider().callMethod("/uc/gube", params).then((userFetch) {
        var user = UserModel.fromJson(userFetch.data["data"]);
        shared.SharedService().saveUser("user", user);
        Navigator.pushNamedAndRemoveUntil(context, Routes.home, (_) => false);
      }, onError: (error) {
        SnackBar snackBar = SnackBar(
          content: Text('Error al recuperar el usuario $error'),
          backgroundColor: Colors.red,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    }, onError: (error) {
      Navigator.pop(context);
      if (error.toString().contains("Bad credentials")) {
        const snackBar = SnackBar(
          content: Text('Correo o contraseña incorrectos'),
          backgroundColor: Colors.red,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        final snackBar = SnackBar(
          content: Text('Fallo el incio de sesión $error'),
          backgroundColor: Colors.red,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          elevation: 0,
          title: GradientText(
            'Iniciar sesión',
            gradient: AppColors.iniciarGradient,
          ),
        ),
        body: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: SingleChildScrollView(
                child: Align(
                  alignment: const Alignment(0, -1 / 3),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 40),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.17,
                        child: Opacity(
                            opacity: 0.9,
                            child: SvgPicture.asset(AppConstants.logoSvg)),
                      ),
                      const SizedBox(height: 40),
                      Text(
                        'Bienvenido/a',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.bienvenidoColor),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Inicia sesión para continuar',
                        style: TextStyle(color: AppColors.bienvenidoContentColor),
                      ),
                      const SizedBox(height: 40),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        validator: (val) => !EmailValidator.validate(val!, true)
                            ? 'Correo electrónico inválido'
                            : null,
                        onSaved: (val) => _email = val!.toLowerCase(),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                          labelStyle: TextStyle(
                            color: AppColors.labelTextEmailColor,
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.borderEmailColor,
                              )
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.borderFocusedEmailColor,
                              )
                          )
                        ),
                        style: TextStyle(color: AppColors.textEmailColor),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        obscureText: true,
                        validator: (val) =>
                            val!.length < 4 ? 'Contraseña muy corta' : null,
                        onSaved: (val) => _password = val!,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Contraseña',
                          labelStyle: TextStyle(
                            color: AppColors.labelTextPasswordColor,
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.borderPasswordColor,
                              )
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.borderFocusedPasswordColor,
                              )
                          )
                        ),
                        style: TextStyle(color: AppColors.textPasswordColor),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            //Navigator.pushReplacementNamed(context, Routes.home);
                            _submitCommand();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.customPurple,
                            shadowColor: AppColors.customPurple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: const Text('Iniciar sesión',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16)),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('No tienes una cuenta?', style: TextStyle(color: AppColors.contentRegisterColor)),
                          const SizedBox(width: 4),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, Routes.register);
                            },
                            child: Text(
                              'Regístrate',
                              style: TextStyle(color: AppColors.registerColor, fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            )));
  }
}
