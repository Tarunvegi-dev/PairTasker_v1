import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import '../helpers/methods.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class Tasker extends ChangeNotifier {
  Future<Response> getTaskerDetails(id) async {
    var url = '${BaseURL.url}/tasker/get-tasker-details/$id';
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await Dio().get(
      url,
      options: Options(
        validateStatus: (_) => true,
        headers: {
          'token': token,
        },
      ),
    );

    return response;
  }

  Future<Response> setTaskerOnline(bool status) async {
    var url = '${BaseURL.url}/tasker/iam-online/$status';
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await Dio().get(
      url,
      options: Options(
        validateStatus: (_) => true,
        headers: {
          'token': token,
        },
      ),
    );

    if (response.statusCode == 200) {
      final userPref = prefs.getString('userdata');
      Map<String, dynamic> userdata =
          jsonDecode(userPref!) as Map<String, dynamic>;
      Map<String, dynamic> updatedUserData = {
        ...userdata,
        'tasker': {...userdata['tasker'], 'isOnline': status}
      };
      prefs.setString('userdata', jsonEncode(updatedUserData));
    }
    return response;
  }
}
