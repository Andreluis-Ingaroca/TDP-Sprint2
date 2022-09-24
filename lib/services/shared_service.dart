import 'package:dio/dio.dart';
import 'package:lexp/models/book.dart';
import 'package:lexp/models/category.dart';
import 'package:lexp/models/content.dart';
import 'package:lexp/models/notes.dart';
import 'package:lexp/models/thematic_unit.dart';
import 'package:lexp/models/ticket.dart';
import 'package:lexp/models/user.dart';
import 'package:lexp/models/user_book.dart';
import 'package:lexp/models/user_unity.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedService {
  final Future<SharedPreferences> _storage = SharedPreferences.getInstance();

  SharedService();

  Future<bool> setKey(String key, String value) async {
    final SharedPreferences prefs = await _storage;
    return prefs.setString(key, value);
  }

  Future<String?> getKey(String key) async {
    final SharedPreferences prefs = await _storage;
    return prefs.getString(key);
  }

  Future<bool> setBoolKey(String key, bool value) async {
    final SharedPreferences prefs = await _storage;
    return prefs.setBool(key, value);
  }

  Future<bool?> getBoolKey(String key) async {
    final SharedPreferences prefs = await _storage;
    return prefs.getBool(key);
  }

  Future<bool> remove(String key) async {
    final SharedPreferences prefs = await _storage;
    return prefs.remove(key);
  }

  Future<bool> clear() async {
    final SharedPreferences prefs = await _storage;
    prefs.clear();
    return prefs.setString("onBoard", "true");
  }

  Future<bool> saveUser(String key, UserModel user) async {
    final SharedPreferences prefs = await _storage;
    var json = jsonEncode(user);
    return prefs.setString(key, json);
  }

  Future<UserModel?> getUser(String key) async {
    final SharedPreferences prefs = await _storage;
    var json = prefs.getString(key);
    if (json != null) {
      return UserModel.fromJson(jsonDecode(json));
    } else {
      return null;
    }
  }

  List<CategoryModel> getCategories(Response<dynamic>? data) {
    List<CategoryModel> categories = [];
    if (data!.data != null) {
      for (var item in data.data["data"]) {
        categories.add(CategoryModel.fromJson(item));
      }
    }
    return categories;
  }

  List<ThematicUnitModel> getTUnits(Response<dynamic>? data) {
    List<ThematicUnitModel> tUnits = [];
    if (data!.data != null) {
      for (var item in data.data["data"]) {
        tUnits.add(ThematicUnitModel.fromJson(item));
      }
    }
    return tUnits;
  }

  List<UserBookModel> getBuyedBooks(Response<dynamic>? data) {
    List<UserBookModel> buyBooks = [];
    if (data!.data != null) {
      for (var item in data.data["data"]) {
        buyBooks.add(UserBookModel.fromJson(item));
      }
    }
    return buyBooks;
  }

  List<BookModel> getBooks(Response<dynamic>? data) {
    List<BookModel> buyBooks = [];
    if (data!.data != null) {
      for (var item in data.data["data"]) {
        buyBooks.add(BookModel.fromJson(item));
      }
    }
    return buyBooks;
  }

  List<UserUnityModel> getEnrolls(Response<dynamic>? data) {
    List<UserUnityModel> enrolls = [];
    if (data!.data != null) {
      for (var item in data.data["data"]) {
        enrolls.add(UserUnityModel.fromJson(item));
      }
    }
    return enrolls;
  }

  List<NotesModel> getNotes(Response<dynamic>? data) {
    List<NotesModel> notes = [];
    if (data!.data != null) {
      for (var item in data.data["data"]) {
        notes.add(NotesModel.fromJson(item));
      }
    }
    return notes;
  }

  List<TicketModel> getTickets(Response<dynamic>? data) {
    List<TicketModel> tickets = [];
    if (data!.data != null) {
      for (var item in data.data["data"]) {
        tickets.add(TicketModel.fromJson(item));
      }
    }
    return tickets;
  }

  List<ContentModel> getContents(Response<dynamic>? data) {
    List<ContentModel> contents = [];
    if (data!.data != null) {
      for (var item in data.data["data"]) {
        contents.add(ContentModel.fromJson(item));
      }
    }
    return contents;
  }

  Future<bool> logout() async {
    final SharedPreferences prefs = await _storage;
    prefs.remove("sessionKey");
    return prefs.remove("user");
  }

  Future<bool> containsKey(String key) async {
    final SharedPreferences prefs = await _storage;
    return prefs.containsKey(key);
  }

  Future<String> getInitialRoute() async {
    final SharedPreferences prefs = await _storage;
    if (prefs.containsKey("onBoard")) {
      if (prefs.containsKey("sessionKey")) {
        return "/home";
      } else {
        return "/login";
      }
    } else {
      return "/";
    }
  }

  /// Saves the position time of the video to the shared preferences
  Future<bool> setVidPosition(String videoID, Duration currentDuration) async {
    final SharedPreferences prefs = await _storage;
    return prefs.setString(videoID, currentDuration.toString());
  }

  /// Gets the position time of the video from the shared preferences
  Future<Duration?> getVidPosition(String videoID) async {
    final SharedPreferences prefs = await _storage;
    var duration = prefs.getString(videoID);
    if (duration != null) {
      return parseDuration(duration);
    } else {
      return null;
    }
  }

  String sanitize(String text) {
    text = text.replaceAll(RegExp(r"[áàäâã]"), "a");
    text = text.replaceAll(RegExp(r"[éèëê]"), "e");
    text = text.replaceAll(RegExp(r"[íìïî]"), "i");
    text = text.replaceAll(RegExp(r"[óòöôõ]"), "o");
    text = text.replaceAll(RegExp(r"[úùüû]"), "u");

    return text;
  }

  String getIGN(String username, int id) {
    // use only the first word
    var ign = username.split(" ")[0];
    // remove accents
    ign = sanitize(ign);
    // remove special characters
    ign = ign.replaceAll(RegExp(r"[^a-zA-ZñÑ]"), "");
    // remove double characters
    ign = ign.replaceAll(RegExp(r"(.)\1+"), r"$1");

    return "$ign#$id";
  }

  String? validateStrongPassword(String password) {
    // minimum 8 characters
    if (password.length < 8) {
      return "La contraseña debe tener al menos 8 caracteres";
    }
    // at least one uppercase letter
    if (!RegExp(r"[A-Z]").hasMatch(password)) {
      return "La contraseña debe tener al menos una letra mayúscula";
    }
    // at least one lowercase letter
    if (!RegExp(r"[a-z]").hasMatch(password)) {
      return "La contraseña debe tener al menos una letra minúscula";
    }
    // at least one number
    if (!RegExp(r"[0-9]").hasMatch(password)) {
      return "La contraseña debe tener al menos un número";
    }
    /* // at least one special character
    if (!RegExp(r"[!@#\$&*~]").hasMatch(password)) {
      return "La contraseña debe tener al menos un caracter especial";
    } */
    return null;
  }

  String? validateNames(String names) {
    // minimum 3 characters
    if (names.length < 3) {
      return "El nombre debe tener al menos 3 caracteres";
    }
    // maximum 30 characters
    if (names.length > 30) {
      return "El nombre debe tener máximo 30 caracteres";
    }
    // only letters
    if (!RegExp(r"^[a-zA-ZñÑ ]+$").hasMatch(names)) {
      return "El nombre solo puede contener letras";
    }
    return null;
  }

  Duration parseDuration(String s) {
    int hours = 0;
    int minutes = 0;
    int micros;
    List<String> parts = s.split(':');
    if (parts.length > 2) {
      hours = int.parse(parts[parts.length - 3]);
    }
    if (parts.length > 1) {
      minutes = int.parse(parts[parts.length - 2]);
    }
    micros = (double.parse(parts[parts.length - 1]) * 1000000).round();
    return Duration(hours: hours, minutes: minutes, microseconds: micros);
  }
}
