import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/UserModel.dart';

class AppSession extends ChangeNotifier {
  static final AppSession _instance = AppSession._internal();
  factory AppSession() => _instance;

  AppSession._internal();

  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _instance._loadFromPrefs();
  }

  static void reset() {
    _prefs.clear();
    _instance._clearAllFields();
    _instance.notifyListeners(); // ✅ Correct usage
  }

  // Reactive fields
  String _userId = '';
  String get userId => _userId;
  set userId(String value) {
    _userId = value;
    _prefs.setString('userId', value);
    notifyListeners();
  }

  String _deviceToken = '';
  String get deviceToken => _deviceToken;
  set deviceToken(String value) {
    _deviceToken = value;
    _prefs.setString('deviceToken', value);
    notifyListeners();
  }

  String _email = '';
  String get email => _email;
  set email(String value) {
    _email = value;
    _prefs.setString('email', value);
    notifyListeners();
  }

  String _username = '';
  String get username => _username;
  set username(String value) {
    _username = value;
    _prefs.setString('username', value);
    notifyListeners();
  }

  String _lat = '';
  String get lat => _lat;
  set latitude(String value) {
    _lat = value;
    _prefs.setString('latitude', value);
    notifyListeners();
  }

  String _long = '';
  String get long => _long;
  set longitude(String value) {
    _long = value;
    _prefs.setString('longitude', value);
    notifyListeners();
  }

  String _firstName = '';
  String get firstName => _firstName;
  set firstName(String value) {
    _firstName = value;
    _prefs.setString('firstName', value);
    notifyListeners();
  }

  String _lastName = '';
  String get lastName => _lastName;
  set lastName(String value) {
    _lastName = value;
    _prefs.setString('lastName', value);
    notifyListeners();
  }

  String _contact = '';
  String get contact => _contact;
  set contact(String value) {
    _contact = value;
    _prefs.setString('contact', value);
    notifyListeners();
  }

  String _image = '';
  String get image => _image;
  set image(String value) {
    _image = value;
    _prefs.setString('image', value);
    notifyListeners();
  }

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;
  set isLoggedIn(bool value) {
    _isLoggedIn = value;
    _prefs.setBool('isLoggedIn', value);
    notifyListeners();
  }

  // Load from SharedPreferences
  void _loadFromPrefs() {
    _userId = _prefs.getString('userId') ?? '';
    _deviceToken = _prefs.getString('deviceToken') ?? '';
    _email = _prefs.getString('email') ?? '';
    _username = _prefs.getString('username') ?? '';
    _lat = _prefs.getString('latitude') ?? '';
    _long = _prefs.getString('longitude') ?? '';
    _firstName = _prefs.getString('firstName') ?? '';
    _lastName = _prefs.getString('lastName') ?? '';
    _contact = _prefs.getString('contact') ?? '';
    _image = _prefs.getString('image') ?? '';
    _isLoggedIn = _prefs.getBool('isLoggedIn') ?? false;
    notifyListeners();
  }

  // Clear all fields and notify
  void _clearAllFields() {
    _userId = '';
    _deviceToken = '';
    _email = '';
    _username = '';
    _lat = '';
    _long = '';
    _firstName = '';
    _lastName = '';
    _contact = '';
    _image = '';
    _isLoggedIn = false;
    notifyListeners();
  }

  // Save full user model
  Future<void> saveUser(UserModel user) async {
    userId = user.userId ?? '';
    email = user.email ?? '';
    contact = user.contact ?? '';
    username = user.username ?? '';
    isLoggedIn = true;
    await _prefs.setString('userJson', jsonEncode(user.toJson()));
  }

  // Load user model (optional)
  UserModel? get userModel {
    final jsonString = _prefs.getString('userJson');
    if (jsonString != null) {
      final jsonMap = jsonDecode(jsonString);
      return UserModel.fromJson(jsonMap);
    }
    return null;
  }

  // Logout
  Future<void> logout() async {
    await _prefs.clear();
    _clearAllFields();
  }
}