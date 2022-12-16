import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import '../helpers/methods.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class Tasker with ChangeNotifier {
  List<dynamic> _taskers = [];
  List<dynamic> _wishlist = [];

  List<dynamic> get taskers {
    return _taskers;
  }

  List<dynamic> get wishlist {
    return _wishlist;
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
    if (responsedata['message'] != 'No taskers found') {
      _taskers = responsedata['data'];
    } else {
      _taskers = [];
    }
  }

  Future<void> getWishlist() async {
    const url = '${BaseURL.url}/user/get-my-wishlist';
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
    _wishlist = responsedata['data'];
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
