import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import '../helpers/methods.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class Chat extends ChangeNotifier {
  List<dynamic> _messages = [];

  List<dynamic> get messages {
    return _messages;
  }

  Future<void> fetchMessages(taskId, screenType) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    if (prefs.containsKey(taskId)) {
      final chatPref = prefs.getString(taskId);
      List<dynamic> chatsData = jsonDecode(chatPref!) as List<dynamic>;
      _messages = chatsData;
      notifyListeners();
    } else {
      if (screenType == 'user') {
        final response = await getRequestDetails(taskId, chats: true);
        if (response.statusCode == 200) {
          List<dynamic> chatsData = [];
          chatsData = response.data['data']['chats'];
          prefs.setString(taskId, jsonEncode(chatsData));
          _messages = chatsData;
          notifyListeners();
        }
      } else {
        final response = await getTaskDetails(taskId, chats: true);
        if (response.statusCode == 200) {
          List<dynamic> chatsData = [];
          chatsData = response.data['data']['chats'];
          prefs.setString(taskId, jsonEncode(chatsData));
          _messages = chatsData;
          notifyListeners();
        }
      }
    }
  }

  Future<void> updateMessages(
    String taskId,
    Map<String, dynamic> message, {
    bool isRecieve = false,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(taskId)) {
      final chatPref = prefs.getString(taskId);
      List<dynamic> chatsData = jsonDecode(chatPref!) as List<dynamic>;
      chatsData.add(message);
      _messages = chatsData;
      if (isRecieve) {
        return;
      }
      prefs.remove(taskId);
      prefs.setString(taskId, jsonEncode(chatsData));
      notifyListeners();
    } else {
      List<dynamic> chatsData = [];
      chatsData.add(message);
      _messages = chatsData;
      if (isRecieve) {
        return;
      }
      prefs.setString(taskId, jsonEncode(chatsData));
      notifyListeners();
    }
  }

  Future<Response> getRequestDetails(String taskId,
      {bool chats = false}) async {
    const url = '${BaseURL.url}/user/get-task-details';
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await Dio().post(
      url,
      data: {
        "taskId": taskId,
        "chats": chats,
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

  Future<Response> getTaskDetails(String taskId, {bool chats = false}) async {
    const url = '${BaseURL.url}/tasker/get-task-details';

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await Dio().post(
      url,
      data: {
        "taskId": taskId,
        "chats": chats,
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

  Future<Response> reportChat(on, by, complaint) async {
    const url = '${BaseURL.url}/report';

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await Dio().post(
      url,
      data: {
        "on": on,
        "by": by,
        "complaint": complaint
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
