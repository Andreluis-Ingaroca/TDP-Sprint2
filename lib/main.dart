import 'package:flutter/material.dart';
import 'package:lexp/services/shared_service.dart' as shared;
import 'package:sizer/sizer.dart';
import 'package:lexp/core/res/color.dart';
import 'package:lexp/core/routes/routes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  shared.SharedService().getInitialRoute().then((value) {
    runApp(MyApp(initialRouted: value)); //TODO Splash Screen
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.initialRouted}) : super(key: key);
  final String initialRouted;
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          SfGlobalLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('es'),
        ],
        locale: const Locale('es'),
        title: 'LXP',
        debugShowCheckedModeBanner: false,
        theme: AppColors.getTheme,
        initialRoute: initialRouted,
        onGenerateRoute: RouterGenerator.generateRoutes,
      );
    });
  }
}
