import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/profilemodel.dart';
import '../models/usermodel.dart';

class AppSession extends ChangeNotifier {
  static final AppSession _instance = AppSession._internal();
  factory AppSession() => _instance;
  AppSession._internal();

  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _instance._loadFromPrefs();
  }

  static void reset() {
    _prefs.clear();
    _instance._clearAll();
    _instance.notifyListeners();
  }



  // ------------------------------
  // STORED FIELDS
  // ------------------------------
  String _userId = "";
  String _email = "";
  String _firstname = "";
  String _lastname = "";
  String _phone = "";
  String _address = "";
  String _userType = "";
  String _vehicleType = "";
  String _profileImage = "";
  String _deviceToken = "";
  String _lat = "";
  String _long = "";
  String _countryCode = "";
  String _phoneCode = "";
  String _licenceFront = "";
  String _licenceBack = "";
  String _vehicleReg = "";
  String _licencePlate = "";
  String _socialType = "";
  String _socialId = "";
  String _emailCheck = "";
  String _notification = "";
  String _withHelper = "";
  String _aideName = "";
  String _aideEmail = "";
  String _aideProfile = "";
  String _aidePhone = "";
  String _aidePhoneCode = "";
  String _helpAideStatus = "";
  String _currency = "GBP"; // default Pound


  bool _isLoggedIn = false;

  // Getters
  String get userId => _userId;
  String get email => _email;
  String get currency => _currency;
  String get firstname => _firstname;
  String get lastname => _lastname;
  String get phone => _phone;
  String get address => _address;
  String get userType => _userType;
  String get vehicleType => _vehicleType;
  String get profileImage => _profileImage;
  String get deviceToken => _deviceToken;
  String get lat => _lat;
  String get long => _long;
  String get licenceFront => _licenceFront;
  String get licenceBack => _licenceBack;
  String get vehicleReg => _vehicleReg;
  String get licencePlate => _licencePlate;
  String get socialType => _socialType;
  String get socialId => _socialId;
  String get emailCheck => _emailCheck;
  String get notification => _notification;
  String get withHelper => _withHelper;
  String get countryCode => _countryCode;
  String get phoneCode => _phoneCode;
  String get aideName => _aideName;
  String get aideEmail => _aideEmail;
  String get aideProfile => _aideProfile;
  String get aidePhone => _aidePhone;
  String get aidePhoneCode => _aidePhoneCode;
  String get helpAideStatus => _helpAideStatus;

  bool get isLoggedIn => _isLoggedIn;

  // ------------------------------
  // LOAD FROM PREFS
  // ------------------------------
  void _loadFromPrefs() {
    _currency = _prefs.getString("currency") ?? "GBP";
    _userId = _prefs.getString("userId") ?? "";
    _email = _prefs.getString("email") ?? "";
    _firstname = _prefs.getString("firstname") ?? "";
    _lastname = _prefs.getString("lastname") ?? "";
    _phone = _prefs.getString("phone") ?? "";
    _address = _prefs.getString("address") ?? "";
    _userType = _prefs.getString("userType") ?? "";
    _vehicleType = _prefs.getString("vehicleType") ?? "";
    _profileImage = _prefs.getString("profileImage") ?? "";
    _deviceToken = _prefs.getString("deviceToken") ?? "";
    _lat = _prefs.getString("lat") ?? "";
    _long = _prefs.getString("long") ?? "";
    _countryCode = _prefs.getString("countryCode") ?? "";
    _phoneCode = _prefs.getString("phoneCode") ?? "";
    _licenceFront = _prefs.getString("licenceFront") ?? "";
    _licenceBack = _prefs.getString("licenceBack") ?? "";
    _vehicleReg = _prefs.getString("vehicleReg") ?? "";
    _licencePlate = _prefs.getString("licencePlate") ?? "";
    _socialType = _prefs.getString("socialType") ?? "";
    _socialId = _prefs.getString("socialId") ?? "";
    _emailCheck = _prefs.getString("emailCheck") ?? "";
    _notification = _prefs.getString("notification") ?? "";
    _withHelper = _prefs.getString("withHelper") ?? "";
    _aideName = _prefs.getString("aideName") ?? "";
    _aideEmail = _prefs.getString("aideEmail") ?? "";
    _aideProfile = _prefs.getString("aideProfile") ?? "";
    _aidePhone = _prefs.getString("aidePhone") ?? "";
    _aidePhoneCode = _prefs.getString("aidePhoneCode") ?? "";
    _helpAideStatus = _prefs.getString("helpAideStatus") ?? "";

    _isLoggedIn = _prefs.getBool("isLoggedIn") ?? false;

    notifyListeners();
  }

  set deviceToken(String value) {
    _deviceToken = value;

    // save in secure storage
    _secureStorage.write(key: 'deviceToken', value: value);

    // save in shared prefs (fast access)
    _prefs.setString("deviceToken", value);

    notifyListeners();
  }


  Future<void> setCurrency(String value) async {
    _currency = value;
    await _prefs.setString("currency", value);
    notifyListeners();
  }
  // ------------------------------
  // SAVE FULL USER MODEL
  // ------------------------------

  Future<void> saveUser(LoginModel model) async {
    if (model.data == null) return;

    final d = model.data!;

    // 1) Update in-memory fields
    _userId = d.userId ?? "";
    _email = d.email ?? "";
    _firstname = d.firstname ?? "";
    _lastname = d.lastname ?? "";
    _phone = d.phone ?? "";
    _address = d.address ?? "";
    _userType = d.userType ?? "";
    _vehicleType = d.vehicleType ?? "";
    _profileImage = d.profileImage ?? "";
    _deviceToken = d.deviceToken ?? "";
    _lat = d.latitude ?? "";
    _long = d.longitude ?? "";
    _countryCode = d.countryCode ?? "";
    _phoneCode = d.phoneCode ?? "";
    _licenceFront = d.licenceImageFront ?? "";
    _licenceBack = d.licenceImageBack ?? "";
    _vehicleReg = d.vehicleRegNo ?? "";
    _licencePlate = d.licencePlateNo ?? "";
    _socialType = d.socialType ?? "";
    _socialId = d.socialId ?? "";
    _emailCheck = d.emailcheck ?? "";
    _notification = d.notification ?? "";
    _withHelper = d.withHelper ?? "";
    _aideName = d.aideName ?? "";
    _aideEmail = d.aideEmail ?? "";
    _aideProfile = d.aideProfile ?? "";
    _aidePhone = d.aidePhone ?? "";
    _aidePhoneCode = d.aidePhoneCode ?? "";
    _helpAideStatus = d.helpAideStatus ?? "";
    _isLoggedIn = true;

    // 2) Persist to SharedPreferences (await these to be safe)
    await _prefs.setString("userId", _userId);
    await _prefs.setString("email", _email);
    await _prefs.setString("firstname", _firstname);
    await _prefs.setString("lastname", _lastname);
    await _prefs.setString("phone", _phone);
    await _prefs.setString("address", _address);
    await _prefs.setString("userType", _userType);
    await _prefs.setString("vehicleType", _vehicleType);
    await _prefs.setString("profileImage", _profileImage);
    await _prefs.setString("deviceToken", _deviceToken);
    await _prefs.setString("lat", _lat);
    await _prefs.setString("long", _long);
    await _prefs.setString("countryCode", _countryCode);
    await _prefs.setString("phoneCode", _phoneCode);
    await _prefs.setString("licenceFront", _licenceFront);
    await _prefs.setString("licenceBack", _licenceBack);
    await _prefs.setString("vehicleReg", _vehicleReg);
    await _prefs.setString("licencePlate", _licencePlate);
    await _prefs.setString("socialType", _socialType);
    await _prefs.setString("socialId", _socialId);
    await _prefs.setString("emailCheck", _emailCheck);
    await _prefs.setString("notification", _notification);
    await _prefs.setString("withHelper", _withHelper);
    await _prefs.setString("aideName", _aideName);
    await _prefs.setString("aideEmail", _aideEmail);
    await _prefs.setString("aideProfile", _aideProfile);
    await _prefs.setString("aidePhone", _aidePhone);
    await _prefs.setString("aidePhoneCode", _aidePhoneCode);
    await _prefs.setString("helpAideStatus", _helpAideStatus);

    await _prefs.setString("userJson", jsonEncode(model.toJson()));
    await _prefs.setBool("isLoggedIn", true);

    // 3) notify listeners so UI / prints read latest
    notifyListeners();
  }

  Future<void> updateUserFromProfile(ProfileModel model) async {
    if (model.data == null) return;

    final d = model.data!;

    _firstname = d.firstname ?? "";
    _lastname  = d.lastname ?? "";
    _phone     = d.phone ?? "";
    _address   = d.address ?? "";
    _vehicleType = d.vehicleType ?? "";
    _profileImage = d.profileImage ?? "";

    await _prefs.setString("firstname", _firstname);
    await _prefs.setString("lastname", _lastname);
    await _prefs.setString("phone", _phone);
    await _prefs.setString("address", _address);
    await _prefs.setString("vehicleType", _vehicleType);
    await _prefs.setString("profileImage", _profileImage);

    notifyListeners();  // 🔥 VERY IMPORTANT
  }

  Future<void> logout() async {
    await _prefs.clear();
    _clearAll();
  }



  // ------------------------------
  // GET FULL MODEL
  // ------------------------------
  LoginModel? get userModel {
    final jsonStr = _prefs.getString("userJson");
    if (jsonStr == null) return null;

    return LoginModel.fromJson(jsonDecode(jsonStr));
  }

  // ------------------------------

  void _clearAll() {
    _currency = "GBP";
    _deviceToken = "";
    _userId = "";
    _email = "";
    _firstname = "";
    _lastname = "";
    _phone = "";
    _address = "";
    _userType = "";
    _vehicleType = "";
    _profileImage = "";
    _deviceToken = "";
    _lat = "";
    _long = "";
    _countryCode = "";
    _phoneCode = "";
    _licenceFront = "";
    _licenceBack = "";
    _vehicleReg = "";
    _licencePlate = "";
    _socialType = "";
    _socialId = "";
    _emailCheck = "";
    _notification = "";
    _withHelper = "";
    _aideName = "";
    _aideEmail = "";
    _aideProfile = "";
    _aidePhone = "";
    _aidePhoneCode = "";
    _helpAideStatus = "";
    _isLoggedIn = false;

    notifyListeners();
  }
}
