import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/Models/Providers/http_exception.dart';
import 'package:shop/keys/apikey.dart' as api;
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token;
  String _userId;
  DateTime _expiryDate;
  Timer authTimer;
  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> authenticate(
      String email, String password, String segment) async {
    var url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$segment?key=${api.key} ';
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpExecption(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData['expiresIn']),
        ),
      );
      autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expiryDate': _expiryDate.toIso8601String(),
        },
      );
      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    return authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return authenticate(email, password, 'signInWithPassword');
  }
  Future<bool> tryAutologin() async{
    final prefs=await SharedPreferences.getInstance();
    if(!prefs.containsKey('userData')){
      return false;
    }
    final extracteduserData=json.decode(prefs.getString('userData')) as Map<String,Object>;
    final expiryDate=DateTime.parse(extracteduserData['expiryDate']);
    if(expiryDate.isBefore(DateTime.now())){
      return false;
    }
    _token=extracteduserData['token'];
    _userId=extracteduserData['userid'];
    _expiryDate=expiryDate;
    notifyListeners();
    autoLogout();
    return true;
  }

  Future<void> logout() async{
    _userId = null;
    _token = null;
    _expiryDate = null;
    if (authTimer != null) {
      authTimer.cancel();
      authTimer = null;
    }
    notifyListeners();
    final prefs=await SharedPreferences.getInstance();
    prefs.clear();
  }

  void autoLogout() {
    if (authTimer != null) {
      authTimer.cancel();
    }
    final timeExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    authTimer = Timer(Duration(seconds:timeExpiry), logout);
  }
}
