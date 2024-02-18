import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class UserData {
  String nickName;
  String? firstName;
  String? lastName;

  UserData({required this.nickName, this.firstName, this.lastName});

  String toJsonString() {
    Map<String, dynamic> data = {
      'nickName': nickName.toString(),
      'firstName': firstName.toString(),
      'lastName': lastName.toString(),
    };
    return jsonEncode(data);
  }

  factory UserData.fromJsonString(Map<String, dynamic> map) {
    return UserData(
      nickName: map["nickName"].toString(),
      firstName: map["firstName"].toString(),
      lastName: map["lastName"].toString(),
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
    print(prefs.getString(_keyUser));
    return UserData.fromJsonString(jsonDecode(prefs.getString(_keyUser)!));
  }
}
