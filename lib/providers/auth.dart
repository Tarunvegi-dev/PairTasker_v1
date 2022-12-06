import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token = '';
  String _username = '';
  String _userid = '';

  bool get isAuth {
    return _token != '';
  }

  bool get isSignUpCompleted {
    return _username != '';
  }

  String get token {
    if (_token != '') {
      return _token;
    }
    return '';
  }

  Future<bool> checkisSignUpCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    if(!prefs.containsKey('username')){
      return false;
    }
    final username = prefs.getString('username');
    _username = username!;
    notifyListeners();
    return true;
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('token')) {
      return false;
    }
    final token = prefs.getString('token');
    _token = token!;
    notifyListeners();
    checkisSignUpCompleted();
    return true;
  }

  Future<void> logout() async {
    _token = '';
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<http.Response> signup(
      String email, String password, bool isTermsAgreed) async {
    final url = Uri.parse(
      'http://node-express-env.eba-p9xtnay4.ap-south-1.elasticbeanstalk.com/api/auth/register',
    );
    final response = await http.post(
      url,
      body: {
        'email': email,
        'password': password,
        'tremsAgreed': isTermsAgreed.toString(),
      },
    );
    return response;
  }

  Future<http.Response> verifyotp(String email, String otp) async {
    final url = Uri.parse(
      'http://node-express-env.eba-p9xtnay4.ap-south-1.elasticbeanstalk.com/api/auth/verify-otp',
    );

    final response = await http.post(
      url,
      body: {'email': email, 'otp': otp},
    );

    final responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      _token = responseData['token'];
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('token', responseData['token']);
    }
    return response;
  }

  Future<Response> updateUserDetails(FormData userdata) async {
    const url =
        'http://node-express-env.eba-p9xtnay4.ap-south-1.elasticbeanstalk.com/api/user/update-user';

    final response = await Dio().patch(
      url,
      data: userdata,
      options: Options(
        validateStatus: (_) => true,
        contentType: "multipart/form-data",
        headers: {
          "Content-Type": "multipart/form-data",
          'token': _token,
        },
      ),
    );

    final responseData = response.data;
    if (response.statusCode == 200) {
      _username = responseData['data']['username'];
      _userid = responseData['data']['id'];
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('username', responseData['data']['username']);
      prefs.setString('userid', responseData['data']['id']);
    }

    return response;
  }
}
