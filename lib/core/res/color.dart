import 'package:flutter/material.dart';

class AppColors {
  static bool isDarkMode = false;

  static Map<int, Color> colorCustomPink = {
    50: const Color.fromRGBO(225, 1, 239, 1),
    100: const Color.fromRGBO(225, 1, 239, 0.9),
    200: const Color.fromRGBO(225, 1, 239, 0.8),
    300: const Color.fromRGBO(225, 1, 239, 0.7),
    400: const Color.fromRGBO(225, 1, 239, 0.6),
    500: const Color.fromRGBO(225, 1, 239, 0.5),
    600: const Color.fromRGBO(225, 1, 239, 0.4),
    700: const Color.fromRGBO(225, 1, 239, 0.3),
    800: const Color.fromRGBO(225, 1, 239, 0.2),
    900: const Color.fromRGBO(225, 1, 239, 0.1),
  };

  static Map<int, Color> colorCustomCyan = {
    50: const Color.fromRGBO(0, 255, 255, 1),
    100: const Color.fromRGBO(0, 255, 255, 0.9),
    200: const Color.fromRGBO(0, 255, 255, 0.8),
    300: const Color.fromRGBO(0, 255, 255, 0.7),
    400: const Color.fromRGBO(0, 255, 255, 0.6),
    500: const Color.fromRGBO(0, 255, 255, 0.5),
    600: const Color.fromRGBO(0, 255, 255, 0.4),
    700: const Color.fromRGBO(0, 255, 255, 0.3),
    800: const Color.fromRGBO(0, 255, 255, 0.2),
    900: const Color.fromRGBO(0, 255, 255, 0.1),
  };

  static Map<int, Color> colorCustomPurple = {
    50: const Color.fromRGBO(142, 81, 236, 1),
    100: const Color.fromRGBO(142, 81, 236, 0.9),
    200: const Color.fromRGBO(142, 81, 236, 0.8),
    300: const Color.fromRGBO(142, 81, 236, 0.7),
    400: const Color.fromRGBO(142, 81, 236, 0.6),
    500: const Color.fromRGBO(142, 81, 236, 0.5),
    600: const Color.fromRGBO(142, 81, 236, 0.4),
    700: const Color.fromRGBO(142, 81, 236, 0.3),
    800: const Color.fromRGBO(142, 81, 236, 0.2),
    900: const Color.fromRGBO(142, 81, 236, 0.1),
  };

  static Map<int, Color> colorCustomCyanPink = {
    50: const Color.fromRGBO(29, 245, 232, 1),
    100: const Color.fromRGBO(50, 218, 233, 1),
    200: const Color.fromRGBO(72, 191, 234, 1),
    300: const Color.fromRGBO(93, 164, 234, 1),
    400: const Color.fromRGBO(115, 137, 235, 1),
    500: const Color.fromRGBO(136, 109, 236, 1),
    600: const Color.fromRGBO(158, 82, 237, 1),
    700: const Color.fromRGBO(179, 55, 237, 1),
    800: const Color.fromRGBO(201, 28, 238, 1),
    900: const Color.fromRGBO(222, 1, 239, 1),
  };

  static Map<int, Color> colorCustomPinkCyan = {
    50: const Color.fromRGBO(222, 1, 239, 1),
    100: const Color.fromRGBO(201, 28, 238, 1),
    200: const Color.fromRGBO(179, 55, 237, 1),
    300: const Color.fromRGBO(158, 82, 237, 1),
    400: const Color.fromRGBO(136, 109, 236, 1),
    500: const Color.fromRGBO(115, 137, 235, 1),
    600: const Color.fromRGBO(93, 164, 234, 1),
    700: const Color.fromRGBO(72, 191, 234, 1),
    800: const Color.fromRGBO(50, 218, 233, 1),
    900: const Color.fromRGBO(29, 245, 232, 1),
  };

  static Map<int, Color> colorCustomGrey = {
    50: const Color.fromRGBO(250, 250, 250, 1),
    100: const Color.fromRGBO(245, 245, 245, 1),
    200: const Color.fromRGBO(238, 238, 238, 1),
    300: const Color.fromRGBO(224, 224, 224, 1),
    400: const Color.fromRGBO(189, 189, 189, 1),
    500: const Color.fromRGBO(158, 158, 158, 1),
    600: const Color.fromRGBO(117, 117, 117, 1),
    700: const Color.fromRGBO(97, 97, 97, 1),
    800: const Color.fromRGBO(66, 66, 66, 1),
    900: const Color.fromRGBO(33, 33, 33, 1),
  };

  // static Map<int, Color> colorCustomBlueGrey = {
  //   50: const Color.fromRGBO(236, 239, 241, 1),
  //   100: const Color.fromRGBO(207, 216, 220, 1),
  //   200: const Color.fromRGBO(176, 190, 197, 1),
  //   300: const Color.fromRGBO(144, 164, 174, 1),
  //   400: const Color.fromRGBO(120, 144, 156, 1),
  //   500: const Color.fromRGBO(96, 125, 139, 1),
  //   600: const Color.fromRGBO(84, 110, 122, 1),
  //   700: const Color.fromRGBO(69, 90, 100, 1),
  //   800: const Color.fromRGBO(55, 71, 79, 1),
  //   900: const Color.fromRGBO(38, 50, 56, 1),
  // };

  static Map<int, Color> colorCustomBlueGrey = {
    50: const Color.fromRGBO(33, 33, 33, 1),
    100: const Color.fromRGBO(66, 66, 66, 1),
    200: const Color.fromRGBO(97, 97, 97, 1),
    300: const Color.fromRGBO(55, 71, 79, 1),
    400: const Color.fromRGBO(38, 50, 56, 1),
    500: const Color.fromRGBO(69, 90, 100, 1),
    600: const Color.fromRGBO(117, 117, 117, 1),
    700: const Color.fromRGBO(97, 97, 97, 1),
    800: const Color.fromRGBO(66, 66, 66, 1),
    900: const Color.fromRGBO(33, 33, 33, 1),
  };

  static MaterialColor customPink = MaterialColor(0xFFE101EF, colorCustomPink);
  static MaterialColor customCyan = MaterialColor(0xFF00FFFF, colorCustomCyan);
  static MaterialColor customPurple = MaterialColor(0xFF8E51EC, colorCustomPurple);
  static MaterialColor customCyanPink = MaterialColor(0xFF1DF5E8, colorCustomCyanPink);
  static MaterialColor customPinkCyan = MaterialColor(0xFFDE01EF, colorCustomPinkCyan);
  static MaterialColor customGrey = MaterialColor(0xFF787878, colorCustomGrey);
  static MaterialColor customGreyBlueGrey = MaterialColor(0xFF616161, colorCustomBlueGrey);
  
  static LinearGradient get iniciarGradient => isDarkMode ? getLinearGradient(customPurple) : getLinearGradient(customPinkCyan);
  static LinearGradient get registerGradient => isDarkMode ? getLinearGradient(customPurple) : getLinearGradient(customCyanPink);

  static Color get primaryColor => const Color.fromARGB(255, 205, 15, 239);
  static Color get secondaryColor => const Color.fromARGB(255, 53, 239, 232);

  static Color get bienvenidoColor => isDarkMode ? Colors.white : Colors.black;
  static Color get bienvenidoContentColor => isDarkMode ? Colors.white70 : Colors.black54;
  static Color get borderEmailColor => isDarkMode ? Colors.white70 : Colors.grey;
  static Color get borderFocusedEmailColor => isDarkMode ? Colors.white : Colors.black87;
  static Color get textEmailColor => isDarkMode ? Colors.white : Colors.black;
  static Color get labelTextEmailColor => isDarkMode ? Colors.white70 : Colors.grey[500]!;
  static Color get borderPasswordColor => isDarkMode ? Colors.white70 : Colors.grey;
  static Color get borderFocusedPasswordColor => isDarkMode ? Colors.white : Colors.black87;
  static Color get textPasswordColor => isDarkMode ? Colors.white : Colors.black;
  static Color get labelTextPasswordColor => isDarkMode ? Colors.white70 : Colors.grey[500]!;
  static Color get contentRegisterColor => isDarkMode ? Colors.white70 : Colors.black87;
  static Color get registerColor => isDarkMode ? Colors.white : Colors.cyan;
  static Color get iniciarSesionColor => isDarkMode ? Colors.white : Colors.deepPurple;

  static Color get ingresarDatosColor => isDarkMode ? Colors.white : Colors.black;
  static Color get ingresarContentColor => isDarkMode ? Colors.white70 : Colors.black54;
  static Color get borderNameRegisterColor => isDarkMode ? Colors.white70 : Colors.grey;
  static Color get borderFocusedNameRegisterColor => isDarkMode ? Colors.white : Colors.black87;
  static Color get textNameRegisterColor => isDarkMode ? Colors.white : Colors.black;
  static Color get labelTextNameRegisterColor => isDarkMode ? Colors.white70 : Colors.grey[500]!;
  static Color get borderEmailRegisterColor => isDarkMode ? Colors.white70 : Colors.grey;
  static Color get borderFocusedEmailRegisterColor => isDarkMode ? Colors.white : Colors.black87;
  static Color get textEmailRegisterColor => isDarkMode ? Colors.white : Colors.black;
  static Color get labelTextEmailRegisterColor => isDarkMode ? Colors.white70 : Colors.grey[500]!;
  static Color get borderPasswordRegisterColor => isDarkMode ? Colors.white70 : Colors.grey;
  static Color get borderFocusedPasswordRegisterColor => isDarkMode ? Colors.white : Colors.black87;
  static Color get textPasswordRegisterColor => isDarkMode ? Colors.white : Colors.black;
  static Color get labelTextPasswordRegisterColor => isDarkMode ? Colors.white70 : Colors.grey[500]!;
  static Color get borderConfirmPasswordRegisterColor => isDarkMode ? Colors.white70 : Colors.grey;
  static Color get borderFocusedConfirmPasswordRegisterColor => isDarkMode ? Colors.white : Colors.black87;
  static Color get textConfirmPasswordRegisterColor => isDarkMode ? Colors.white : Colors.black;
  static Color get labelTextConfirmPasswordRegisterColor => isDarkMode ? Colors.white70 : Colors.grey[500]!;

  static MaterialColor get primarySwatch => Colors.purple;
  static Color get accentColor => isDarkMode ? primaryColor : Colors.grey[600]!;
  static Color get bgColor => isDarkMode ? Colors.black : Colors.grey[50]!;
  static Color get degradedImage1Color => isDarkMode ? const Color.fromARGB(255, 180, 185, 175) : primaryColor;
  static Color get degradedImage2Color => isDarkMode ? const Color.fromARGB(255, 140, 135, 145) : secondaryColor;
  static Color get degradedImage3Color => isDarkMode ? const Color.fromARGB(255, 240, 225, 217) : secondaryColor;
  static Color get arrowForwardColor => isDarkMode ? Colors.purple : Colors.white;
  static Color get configuracionesColor => isDarkMode ? Colors.white70 : Colors.blueGrey[700]!;
  static Color get notificacionesColor => isDarkMode ? Colors.white70 : Colors.blueGrey[700]!;
  static Color get ayudaColor => isDarkMode ? Colors.white70 : Colors.blueGrey[700]!;
  static Color get cerrarSesionColor => isDarkMode ? Colors.white : Colors.grey;
  static Color get iconCerrarColor => isDarkMode ? Colors.white70 : Colors.black45;
  static Color get dialogCerrarColor => isDarkMode ? Colors.white : Colors.black;
  static Color get dialogContentColor => isDarkMode ? Colors.white70 : Colors.black;
  static Color get buttomCancelarColor => isDarkMode ? Colors.purple : Colors.indigo;
  static Color get buttomAceptarColor => isDarkMode ? Colors.purple : Colors.indigo;
  static Color get dialogColor => isDarkMode ? Colors.black : Colors.white;

  static MaterialColor get searchColor => isDarkMode ? Colors.purple : Colors.pink;

  static Color get continuarAprendiendoColor => isDarkMode ? Colors.white : Colors.blueGrey[900]!;
  static Color get fechaColor => isDarkMode ? Colors.white : Colors.grey[600]!;
  static Color get enProgresoColor => isDarkMode ? Colors.white : Colors.blueGrey[900]!;
  static Color get addCircleColor => isDarkMode ? Colors.purple : Color.fromARGB(255, 134, 92, 236);
  static Color get verTodoColor => isDarkMode ? Colors.white : Color.fromARGB(255, 205, 15, 239);
  static Color get creditoHipotecarioColor => isDarkMode ? Colors.black : Colors.blueGrey[700]!;
  static Color get containerCreditoColor => isDarkMode ? Colors.grey[100]! : Colors.white;
  static Color get tiempoColor => isDarkMode ? Colors.grey[900]! : Colors.grey[600]!;
  static Color get timeLapseColor => isDarkMode ? Colors.grey[900]! : Colors.purple[300]!;
  static Color get completadoColor => isDarkMode ? Colors.white : Colors.purple;
  static Color get containerCompletadoColor => isDarkMode ? Colors.grey[700]! : Colors.purple[50]!;
  static Color get currencyExchangeColor => isDarkMode ? Colors.grey[900]! : Colors.orange;
  static Color get drawerColor => isDarkMode ? Colors.black87 : Colors.white;

  static MaterialColor customMisCursos = MaterialColor(0xFF8B008B, colorCustomBlueGrey);
  static MaterialColor get misCursosColor => isDarkMode ? customMisCursos : Colors.pink;
  static MaterialColor customExplorar = MaterialColor(0xFF4B0082, colorCustomBlueGrey);
  static MaterialColor get explorarColor => isDarkMode ? customExplorar: Colors.cyan;
  static MaterialColor customInsignias = MaterialColor(0xFF800080, colorCustomBlueGrey);
  static MaterialColor get insigniasColor => isDarkMode ? customInsignias : Colors.purple;
  static MaterialColor customBloc = MaterialColor(0xFF9932CC, colorCustomBlueGrey);
  static MaterialColor get blocDeNotasColor => isDarkMode ? customBloc : Colors.blue;
  //static MaterialColor get ExplorarColor => isDarkMode ? Colors.grey : Colors.pink;

  static ThemeData get getTheme => ThemeData(
        primaryColor: primaryColor,
        primarySwatch: primarySwatch,
        appBarTheme: AppBarTheme(
          backgroundColor: bgColor,
          iconTheme: IconThemeData(
            color: Colors.grey[500],
          ),
          elevation: 0,
          foregroundColor: Colors.grey[600],
        ),
        colorScheme: const ColorScheme.light(),
        backgroundColor: bgColor,
        textTheme: TextTheme(
          displayMedium: TextStyle(
            color: Colors.blueGrey[800],
            fontWeight: FontWeight.w800,
            fontSize: 28,
          ),
          displaySmall: TextStyle(
            color: Colors.blueGrey[800],
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
          labelMedium: TextStyle(
            color: Colors.grey[600],
            fontWeight: FontWeight.w600,
          ),
        ),
        scaffoldBackgroundColor: bgColor,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.transparent,
        ),
      );

  static LinearGradient getLinearGradient(MaterialColor color) {
    return LinearGradient(
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
      colors: [
        color[300]!,
        color[200]!,
        color[100]!,
      ],
      stops: const [
        0.4,
        0.7,
        0.9,
      ],
    );
  }

  static LinearGradient getDarkLinearGradient(MaterialColor color) {
    return LinearGradient(
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
      colors: [
        color[400]!,
        color[300]!,
        color[200]!,
      ],
      stops: const [
        0.4,
        0.6,
        1,
      ],
    );
  }
}
