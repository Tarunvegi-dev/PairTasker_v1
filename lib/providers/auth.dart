import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pairtasker/providers/tasker.dart';
import 'package:pairtasker/providers/user.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/methods.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Auth with ChangeNotifier {
  String _token = '';
  String _username = '';
  bool _isTasker = false;
  bool _unreadNotifications = false;
  bool _unreadRequests = false;
  bool _unreadTasks = false;

  bool get isAuth {
    return _token != '';
  }

  bool get isSignUpCompleted {
    return _username != '';
  }

  bool get isTasker {
    return _isTasker;
  }

  String get token {
    if (_token != '') {
      return _token;
    }
    return '';
  }

  bool get unreadNotifications {
    return _unreadNotifications;
  }

  bool get unreadRequests {
    return _unreadRequests;
  }

  bool get unreadTasks {
    return _unreadTasks;
  }

  Future<void> updateUnread(String type, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    if (type == 'notifications') {
      prefs.remove('unread-notifications');
      prefs.setString('unread-notifcations', jsonEncode(value));
      _unreadNotifications = value;
      notifyListeners();
    }
    if (type == 'requests') {
      prefs.remove('unread-requests');
      prefs.setString('unread-requests', jsonEncode(value));
      _unreadRequests = value;
      notifyListeners();
    }
    if (type == 'tasks') {
      prefs.remove('unread-tasks');
      prefs.setString('unread-tasks', jsonEncode(value));
      _unreadTasks = value;
      notifyListeners();
    }
  }

  Future<void> checkUnread() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    if (prefs.containsKey('unread-notifications')) {
      final notifcationsPref = prefs.getString('unread-notifications');
      _unreadNotifications = jsonDecode(notifcationsPref!) as bool;
      notifyListeners();
    }
    if (prefs.containsKey('unread-requests')) {
      final requestsPref = prefs.getString('unread-requests');
      _unreadRequests = jsonDecode(requestsPref!) as bool;
      notifyListeners();
    }
    if (prefs.containsKey('unread-tasks')) {
      final tasksPref = prefs.getString('unread-tasks');
      _unreadTasks = jsonDecode(tasksPref!) as bool;
      notifyListeners();
    }
  }

  Future<bool> checkIsTasker() async {
    final prefs = await SharedPreferences.getInstance();
    final userPref = prefs.getString('userdata');
    Map<String, dynamic> userdata =
        jsonDecode(userPref!) as Map<String, dynamic>;
    _isTasker = userdata['isTasker'] ?? false;
    notifyListeners();
    return userdata['isTasker'];
  }

  Future<Response> updateIsTasker() async {
    const url = '${BaseURL.url}/user/switch-mode';
    final response = await Dio().get(
      url,
      options: Options(
        validateStatus: (_) => true,
        headers: {
          'token': _token,
        },
      ),
    );
    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      final userPref = prefs.getString('userdata');
      Map<String, dynamic> userdata =
          jsonDecode(userPref!) as Map<String, dynamic>;
      userdata['isTasker'] = !userdata['isTasker'];
      _isTasker = !_isTasker;
      prefs.setString('userdata', jsonEncode(userdata));
      notifyListeners();
    }

    return response;
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
    checkIsTasker();
    checkUnread();
    return true;
  }

  Future<void> logout(BuildContext context) async {
    _token = '';
    _username = '';
    _isTasker = false;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  Future<Response> getUserData(BuildContext context) async {
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
      _isTasker = response.data['isTasker'];
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('userdata', jsonEncode(responseData));
      if (response.data['isTasker'] == true) {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacementNamed('/tasker-dashboard');
      } else {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacementNamed('/home');
      }
    }
    return response;
  }

  Future<Response> signIn(
      String email, String password, BuildContext context) async {
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
      // ignore: use_build_context_synchronously
      getUserData(context);
      updateFcmToken();
      updateGeoLocation();
      // ignore: use_build_context_synchronously
      Provider.of<User>(context, listen: false).getWishlist();
      // ignore: use_build_context_synchronously
      Provider.of<User>(context, listen: false).getMyRequests();
      // ignore: use_build_context_synchronously
      Provider.of<Tasker>(context, listen: false).getMyTasks();
    }

    return response;
  }

  Future<Response> forgotPassword(String email) async {
    const url = '${BaseURL.url}/auth/forgot-password';
    final response = await Dio().post(
      url,
      data: {
        'email': email.trim().toLowerCase(),
      },
      options: Options(
        validateStatus: (_) => true,
      ),
    );
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

  Future<Response> verifyotp(
      String email, String otp, BuildContext context) async {
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
      prefs.setString('token', responseData['token']);
      // ignore: use_build_context_synchronously
      getUserData(context);
      updateFcmToken();
      updateGeoLocation();
      // ignore: use_build_context_synchronously
      Provider.of<User>(context, listen: false).getWishlist();
      // ignore: use_build_context_synchronously
      Provider.of<User>(context, listen: false).getMyRequests();
      // ignore: use_build_context_synchronously
      Provider.of<Tasker>(context, listen: false).getMyTasks();
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
    final prefs = await SharedPreferences.getInstance();
    if (response.statusCode == 200) {
      if (!prefs.containsKey('userdata')) {
        _username = responseData['data']['username'];
        notifyListeners();
        prefs.setString('userdata', jsonEncode(responseData['data']));
      } else {
        final userPref = prefs.getString('userdata');
        Map<String, dynamic> userdataPref =
            jsonDecode(userPref!) as Map<String, dynamic>;
        Map<String, dynamic> updatedUserDataPref = responseData['data'];
        Map<String, dynamic> updatedUserData = {
          ...userdataPref,
          'username': updatedUserDataPref.containsKey('username')
              ? updatedUserDataPref['username']
              : userdataPref['username'],
          'displayName': updatedUserDataPref.containsKey('displayName')
              ? updatedUserDataPref['displayName']
              : userdataPref['displayName'],
          'mobileNumber': updatedUserDataPref.containsKey('mobileNumber')
              ? updatedUserDataPref['mobileNumber']
              : userdataPref['mobileNumber'],
          'dob': updatedUserDataPref.containsKey('dob')
              ? updatedUserDataPref['dob']
              : userdataPref['dob'],
          'gender': updatedUserDataPref.containsKey('gender')
              ? updatedUserDataPref['gender']
              : userdataPref['gender'],
          if (responseData['data']['profilePicture'] != null)
            'profilePicture': responseData['data']['profilePicture'],
        };
        prefs.setString('userdata', jsonEncode(updatedUserData));
      }
    }

    return response;
  }

  Future<Response> updateFcmToken() async {
    final fbm = FirebaseMessaging.instance;
    fbm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    final deviceId = await FirebaseMessaging.instance.getToken();
    FormData formData = FormData.fromMap({"deviceId": deviceId});
    const url = '${BaseURL.url}/user/update-user';
    final response = await Dio().patch(
      url,
      data: formData,
      options: Options(
        validateStatus: (_) => true,
        contentType: "multipart/form-data",
        headers: {
          "Content-Type": "multipart/form-data",
          'token': _token,
        },
      ),
    );
    return response;
  }

  Future<void> updateGeoLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    final prefs = await SharedPreferences.getInstance();
    final location = {
      "latitude": position.latitude,
      "longitude": position.longitude
    };
    prefs.setString('location', jsonEncode(location));
    final address = await getAddressFromLatLong(position);
    prefs.setString('address', address);
  }

  Future<String> getAddressFromLatLong(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];
    return '${place.locality}, ${place.administrativeArea}';
  }

  Future<Response> createTasker(List<dynamic> workingCategories) async {
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
      userdata['isTasker'] = true;
      userdata['tasker'] = responseData['data'];
      prefs.setString('userdata', jsonEncode(userdata));
      _isTasker = true;
      notifyListeners();
    }
    return response;
  }

  Future<Response> updateTasker(Map<String, dynamic> taskerdata) async {
    const url = '${BaseURL.url}/tasker/update-tasker';
    final response = await Dio().patch(
      url,
      data: taskerdata,
      options: Options(
        validateStatus: (_) => true,
        headers: {
          'token': _token,
        },
      ),
    );
    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      final userPref = prefs.getString('userdata');
      Map<String, dynamic> userdata =
          jsonDecode(userPref!) as Map<String, dynamic>;
      if (taskerdata['workingCategories'] != null) {
        userdata['tasker']['workingCategories'] =
            taskerdata['workingCategories'];
      }
      if (taskerdata['bio'] != null) {
        userdata['tasker']['bio'] = taskerdata['bio'];
      }
      prefs.setString('userdata', jsonEncode(userdata));
    }
    return response;
  }

  Future<Response> deleteTaskerAccount() async {
    const url = '${BaseURL.url}/user/tasker-account';
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await Dio().delete(
      url,
      options: Options(
        validateStatus: (_) => true,
        headers: {
          'token': token,
        },
      ),
    );
    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      final userPref = prefs.getString('userdata');
      Map<String, dynamic> userdata =
          jsonDecode(userPref!) as Map<String, dynamic>;
      userdata['isTasker'] = false;
      prefs.setString('userdata', jsonEncode(userdata));
      _isTasker = false;
      notifyListeners();
    }
    return response;
  }

  Future<Response> fetchWorkingCategories() async {
    const url = '${BaseURL.url}/admin/list-categories';
    final response = await Dio().get(
      url,
      options: Options(
        validateStatus: (_) => true,
        contentType: "multipart/form-data",
        headers: {
          "Content-Type": "multipart/form-data",
          'token': _token,
        },
      ),
    );
    return response;
  }

  Future<String> uploadImage(File imageFile) async {
    const url = '${BaseURL.url}/upload-chat-images';
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(
        imageFile.path,
      )
    });
    final response = await Dio().post(
      url,
      data: formData,
      options: Options(
        validateStatus: (_) => true,
        contentType: "multipart/form-data",
        headers: {
          "Content-Type": "multipart/form-data",
          'token': _token,
        },
      ),
    );

    if (response.statusCode == 200) {
      return response.data['url'];
    }
    return '';
  }
}
