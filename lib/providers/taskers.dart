import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import '../helpers/methods.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class Tasker with ChangeNotifier {
  List<dynamic> _taskers = [];

  List<dynamic> get taskers {
    return _taskers;
  }

  Future<void> getTaskers() async {
    const url = '${BaseURL.url}/user/get-taskers';
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

    final responsedata = response.data;
    _taskers = responsedata['data'];
  }
}
