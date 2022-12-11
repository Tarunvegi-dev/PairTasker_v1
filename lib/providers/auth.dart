import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/methods.dart';

class Auth with ChangeNotifier {
  String _token = '';
  String _username = '';

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
    if (!prefs.containsKey('userdata')) {
      return false;
    }
    final userPref = prefs.getString('userdata');
    Map<String, dynamic> userdata =
        jsonDecode(userPref!) as Map<String, dynamic>;
    _username = userdata['username'];
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

  Future<void> logout(BuildContext context) async {
    _token = '';
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  Future<void> getUserData() async {
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
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('userdata', jsonEncode(responseData));
    }
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
      getUserData();
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
        'termsAgreed': isTermsAgreed.toString(),
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
      data: {'email': email.trim().toLowerCase(), 'otp': otp},
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
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('userdata', jsonEncode(responseData['data']));
    }

    return response;
  }

  Future<Response> createTasker(List<String> workingCategories) async {
    const url = '${BaseURL.url}/tasker/create-tasker';
    final response = await Dio().post(
      url,
      data: {
        'workingCategories': workingCategories,
      },
      options: Options(
        validateStatus: (_) => true,
        headers: {
          'token': _token,
        },
      ),
    );

    final responseData = response.data;
    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      final userPref = prefs.getString('userdata');
      Map<String, dynamic> userdata =
          jsonDecode(userPref!) as Map<String, dynamic>;
      userdata['tasker'] = responseData['data'];
      prefs.setString('userdata', jsonEncode(userdata));
    }

    return response;
  }
}


