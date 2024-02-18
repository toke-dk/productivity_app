import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class UserData {
  String nickName;
  String? firstName;
  String? lastName;

  UserData({required this.nickName, this.firstName, this.lastName});

  String toJsonString() {
    Map<String, dynamic> data = {
      'nickName': nickName.toString(),
      'firstName': firstName != null ? firstName.toString() : null,
      'lastName': lastName != null ? lastName.toString() : null,
    };
    return jsonEncode(data);
  }

  factory UserData.fromJsonString(Map<String, dynamic> map) {
    return UserData(
      nickName: map["nickName"].toString(),
      firstName: map["firstName"] != null ? map["firstName"].toString() : null,
      lastName: map["lastName"] != null ? map["lastName"].toString() : null,
    );
  }
}

class UserDataStorage {
  static const String _keyUser = "user";

  static Future<void> saveUserData(UserData userData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUser, "${userData.toJsonString()}");
  }

  static Future<UserData?> get getUserData async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString(_keyUser) == null) return null;
    return UserData.fromJsonString(jsonDecode(prefs.getString(_keyUser)!));
  }
}
