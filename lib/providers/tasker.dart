import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import '../helpers/methods.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class Tasker extends ChangeNotifier {
  List<dynamic> _notifications = [];

  List<dynamic> get notifications {
    return _notifications;
  }

  Future<void> getNotifications() async {
    const url = '${BaseURL.url}/user/get-notifications';
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
      _notifications = response.data['data'];
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> getMyTasks({bool active = false}) async {
    var url = '${BaseURL.url}/tasker/get-my-tasks';
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
      final tasksPref = prefs.getString('tasks');
      Map<String, dynamic> tasksData =
          jsonDecode(tasksPref!) as Map<String, dynamic>;
      tasksData['active'] = responsedata['data'];
      prefs.setString('tasks', jsonEncode(tasksData));
      return tasksData;
    }

    if (response.statusCode == 200 && responsedata['status'] != false) {
      prefs.setString('tasks', jsonEncode(responsedata['data']));
    }

    return responsedata;
  }

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

  Future<Response> getTaskerMetrics() async {
    var url = '${BaseURL.url}/tasker/get-metrics';
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

  Future<List<dynamic>> getTaskerReviews(String taskerId) async {
    var url = '${BaseURL.url}/tasker/get-reviews';
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await Dio().post(
      url,
      data: {"taskerId": taskerId},
      options: Options(
        validateStatus: (_) => true,
        headers: {
          'token': token,
        },
      ),
    );

    final responsedata = response.data;

    if (response.statusCode == 200 && responsedata['status'] != false) {
      return responsedata['data'];
    } else {
      return [];
    }
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

  Future<Response> acceptRequest(String taskId, bool accept) async {
    var url = '${BaseURL.url}/tasker/request?accept=$accept';
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await Dio().post(
      url,
      data: {
        "taskId": taskId,
      },
      options: Options(
        validateStatus: (_) => true,
        headers: {
          'token': token,
        },
      ),
    );
    if (response.statusCode == 200) {
      _notifications
          .removeWhere((notification) => notification['taskId'] == taskId);
      notifyListeners();
    }

    getMyTasks(active: true);

    return response;
  }

  Future<Response> terminateTask(taskId) async {
    const url = '${BaseURL.url}/tasker/terminate-from-task';
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await Dio().post(
      url,
      data: {
        "taskId": taskId,
      },
      options: Options(
        validateStatus: (_) => true,
        headers: {
          'token': token,
        },
      ),
    );
    return response;
  }

  Future<Response> completeTask(taskId) async {
    const url = '${BaseURL.url}/tasker/ask-to-complete';
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await Dio().post(
      url,
      data: {
        "taskId": taskId,
      },
      options: Options(
        validateStatus: (_) => true,
        headers: {
          'token': token,
        },
      ),
    );
    return response;
  }

  Future<Response> verifyTaskOTP(String taskId, String otp) async {
    const url = '${BaseURL.url}/tasker/task-completed';
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await Dio().post(
      url,
      data: {
        "taskId": taskId,
        "otp": otp,
      },
      options: Options(
        validateStatus: (_) => true,
        headers: {
          'token': token,
        },
      ),
    );
    return response;
  }
}
