import 'dart:async';

import 'package:Shop/models/httpexception.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String _token;
  DateTime _expireDateToken;
  String _userId;
    Timer _authTimer;


  String get userid {
    return _userId;
  }

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expireDateToken != null &&
        _expireDateToken.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> signUp(String email, String password) async {
    return _authunticated(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authunticated(email, password, 'signInWithPassword');
  }

  Future<void> _authunticated(
      String email, String password, String urlSegment) async {
    try {
      final url =
          'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyBk7DUuZsvHokXL2QTmX1X_3I4g58rp8DA';

      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      print(json.decode(response.body));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }

      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expireDateToken = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': userid,
        'expiredDate': _expireDateToken.toIso8601String()
      });
      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> logOut() async {
    _token = null;
    _userId = null;
    _expireDateToken = null;
 if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    // prefs.remove('userData');
    prefs.clear();  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData = json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiredDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expireDateToken = expiryDate;
    notifyListeners();
    return true;
  }
}
