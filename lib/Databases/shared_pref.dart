import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

String email = "";

class SharedPref {
  String password = "";
  bool isLoggedIn = false;

  Future<void> setSharedPrefData(Map<String, dynamic> obj) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    log("Shared Preference is Set");

    await sp.setString("email", obj["email"]);
    await sp.setString("password", obj["password"]);
    await sp.setBool("isLoggedIn", obj["isLoggedIn"]);
  }

  Future<void> getSharedPrefData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    log("In get Shared Pref");
    email = sp.getString("email") ?? "";
    password = sp.getString("password") ?? "";
    isLoggedIn = sp.getBool("isLoggedIn") ?? false;
    log(email);
    log(password);
  }

  Future<void> clearSharedPref() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.clear();
  }
}
