import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import '../helpers/methods.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class User with ChangeNotifier {
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
    if (responsedata['message'] != 'No taskers found') {
      _taskers = responsedata['data'];
      notifyListeners();
    } else {
      _taskers = [];
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> getMyRequests({bool active = false}) async {
    var url = '${BaseURL.url}/user/get-my-requests';
    if (active) {
      url += '/active';
    }
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

    if (active) {
      final requestsPref = prefs.getString('requests');
      Map<String, dynamic> requestsdata =
          jsonDecode(requestsPref!) as Map<String, dynamic>;
      requestsdata['active'] = responsedata['data'];
      prefs.setString('requests', jsonEncode(requestsdata));
      return requestsdata;
    }

    if (response.statusCode == 200 && responsedata['status'] != false) {
      prefs.setString('requests', jsonEncode(responsedata['data']));
    }

    return responsedata;
  }

  Future<Response> sendNewRequest(List<dynamic> taskers, String message) async {
    const url = '${BaseURL.url}/user/send-request';
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await Dio().post(
      url,
      data: {
        'taskers': taskers,
        'message': message,
      },
      options: Options(
        validateStatus: (_) => true,
        headers: {
          'token': token,
        },
      ),
    );
    getMyRequests(active: true);

    return response;
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
    if (response.statusCode == 200 && responsedata['status'] != false) {
      prefs.setString('wishlist', jsonEncode(responsedata['data']));
    } else {
      prefs.setString('wishlist', jsonEncode([]));
    }
  }

  Future<Response> manageWishlist(String taskerId, bool save) async {
    const url = '${BaseURL.url}/user/add-to-wishlist';
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await Dio().patch(
      url,
      data: {
        "taskerId": taskerId,
        "save": save,
      },
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
      var wishlist = userdata['wishlist'] as List<dynamic>;
      if (save) {
        wishlist.add(taskerId);
      } else {
        wishlist.remove(taskerId);
      }
      userdata['wishlist'] = wishlist;
      prefs.setString('userdata', jsonEncode(userdata));
      getWishlist();
    }

    return response;
  }
}
