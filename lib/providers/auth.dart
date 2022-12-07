import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
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
    if (prefs.containsKey('username')) {
      final username = prefs.getString('username');
      _username = username!;
      notifyListeners();
      return true;
    } else {
      const url = '${BaseURL.url}/user/get-user';
      final response = await Dio().get(
        url,
        options: Options(
          validateStatus: (_) => true,
          headers: {
            'token': _token,
          },
        ),
      );
      final responseData = response.data;
      if (response.statusCode == 200 && responseData['username'] != null) {
        _username = responseData['username'];
        notifyListeners();
        prefs.setString('username', responseData['username']);
        return true;
      }
    }
    return false;
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

  Future<Response> signIn(String email, String password) async {
    const url = '${BaseURL.url}/auth/login';

    final response = await Dio().post(
      url,
      data: {
        'email': email.trim().toLowerCase(),
        'password': password,
      },
      options: Options(
        validateStatus: (_) => true,
      ),
    );

    final responseData = response.data;
    if (response.statusCode == 200) {
      _token = responseData['token'];
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('token', responseData['token']);
    }

    return response;
  }

  Future<Response> signup(
    String email,
    String password,
    bool isTermsAgreed,
  ) async {
    const url = '${BaseURL.url}/auth/register';

    final response = await Dio().post(
      url,
      data: {
        'email': email.trim().toLowerCase(),
        'password': password,
        'tremsAgreed': isTermsAgreed.toString(),
      },
      options: Options(
        validateStatus: (_) => true,
      ),
    );
    return response;
  }

  Future<Response> verifyotp(String email, String otp) async {
    const url = '${BaseURL.url}/auth/verify-otp';

    final response = await Dio().post(
      url,
      data: {'email': email, 'otp': otp},
      options: Options(
        validateStatus: (_) => true,
      ),
    );

    final responseData = response.data;
    if (response.statusCode == 200) {
      _token = responseData['token'];
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('token', responseData['token']);
    }
    return response;
  }

  Future<Response> updateUserDetails(FormData userdata) async {
    const url = '${BaseURL.url}/user/update-user';

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

class BaseURL {
  static const url =
      'http://node-express-env.eba-p9xtnay4.ap-south-1.elasticbeanstalk.com/api';
}
