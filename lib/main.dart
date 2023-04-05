import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pairtasker/providers/chat.dart';
import 'package:pairtasker/providers/user.dart';
import 'package:pairtasker/providers/tasker.dart';
import 'package:pairtasker/screens/privacy_policy.dart';
import 'package:pairtasker/screens/select_community/select_community_screen.dart';
import 'helpers/methods.dart';
import 'screens/screens.dart';
import 'providers/auth.dart';
import 'screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  importance: Importance.high,
  playSound: true,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  if (message.data['type'] == 'task-completion') {
    getMyRequests();
  }
  if (message.data['type'] == 'task-cancellation' ||
      message.data['type'] == 'tasker-terminated') {
    getMyTasks();
  }
  if (message.data['type'] != 'task') {
    updateMessages(
      message.data,
      message.data['taskId'],
    );
  }
}

Future<Map<String, dynamic>> getMyRequests() async {
  var url = '${BaseURL.url}/user/get-my-requests';
  final prefs = await SharedPreferences.getInstance();
  await prefs.reload();
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
    await prefs.reload();
    prefs.setString('requests', jsonEncode(responsedata['data']));
  }

  return responsedata;
}

Future<Map<String, dynamic>> getMyTasks() async {
  var url = '${BaseURL.url}/tasker/get-my-tasks';
  final prefs = await SharedPreferences.getInstance();
  await prefs.reload();
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
    prefs.setString('tasks', jsonEncode(responsedata['data']));
  }

  return responsedata;
}

Future<void> updateChats(String taskId, String type) async {
  var url = '${BaseURL.url}/task/get-$type-details';
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  final response = await Dio().post(
    url,
    data: {
      "taskId": taskId,
      "chats": true,
    },
    options: Options(
      validateStatus: (_) => true,
      headers: {
        'token': token,
      },
    ),
  );

  if (response.statusCode == 200) {
    List<dynamic> chatsData = [];
    chatsData = response.data['data']['chats'];
    prefs.setString(taskId, jsonEncode(chatsData));
  }
}

void updateMessages(Map<String, dynamic> message, String taskId,
    {bool updateUnread = true}) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.reload();
  if (prefs.containsKey(taskId)) {
    final chatPref = prefs.getString(taskId);
    List<dynamic> chatsData = jsonDecode(chatPref!) as List<dynamic>;
    chatsData.add(message);
    await prefs.remove(taskId);
    prefs.setString(taskId, jsonEncode(chatsData));
  } else {
    if (message['screenType'] == 'user') {
      updateChats(taskId, 'task');
    } else {
      updateChats(taskId, 'request');
    }
  }
  if (updateUnread) {
    if (prefs.containsKey('unread-messages')) {
      final pendingPref = prefs.getString('unread-messages');
      Map<String, dynamic> pendingData =
          jsonDecode(pendingPref!) as Map<String, dynamic>;
      if (pendingData.containsKey(taskId)) {
        pendingData[taskId] = pendingData[taskId] + 1;
      } else {
        pendingData[taskId] = 1;
      }
      prefs.setString('unread-messages', jsonEncode(pendingData));
    } else {
      Map<String, dynamic> pendingData = {};
      pendingData[taskId] = 1;
      prefs.setString('unread-messages', jsonEncode(pendingData));
    }
  }
  if (message['type'] == 'message') {
    if (message['screenType'] == 'user') {
      prefs.setString('unread-tasks', jsonEncode(true));
    } else {
      prefs.setString('unread-requests', jsonEncode(true));
    }
  }
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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  updateGeoLocation();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    var androiInit =
        const AndroidInitializationSettings('@mipmap/ic_launcher'); //for logo
    var initSettings = InitializationSettings(android: androiInit);

    flutterLocalNotificationsPlugin.initialize(initSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) {
      final payload = jsonDecode(notificationResponse.payload as String);
      if (payload['type'] == 'task') {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await navigatorKey.currentState!.push(MaterialPageRoute(
            builder: (context) => const NotificationScreen(),
          ));
        });
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await navigatorKey.currentState!.pushNamed('/chatscreen', arguments: {
            "screenType": payload['screenType'] == 'user' ? 'tasker' : 'user',
            "taskId": payload['taskId'],
          });
        });
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification notification = message.notification!;
      AndroidNotification? android = message.notification?.android;
      String? currentPath;
      navigatorKey.currentState?.popUntil((route) {
        currentPath = route.settings.name;
        return true;
      });
      if (currentPath != '/chatscreen') {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              playSound: true,
              icon: '@drawable/notification_icon',
            ),
          ),
          payload: jsonEncode(message.data),
        );
      }
      if (message.data['type'] == 'task-completion') {
        getMyRequests();
      }
      if (message.data['type'] == 'task-cancellation' ||
          message.data['type'] == 'tasker-terminated') {
        getMyTasks();
      }
      if (message.data['type'] != 'task') {
        updateMessages(
          message.data,
          message.data['taskId'],
          updateUnread: currentPath != '/chatscreen',
        );
      }
      if (message.data['type'] == 'task') {
        final prefs = await SharedPreferences.getInstance();
        await prefs.reload();
        prefs.setString('unread-notifications', jsonEncode(true));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification!;
      AndroidNotification? android = message.notification?.android;
      if (message.data['type'] == 'task') {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await navigatorKey.currentState!.push(MaterialPageRoute(
            builder: (context) => const NotificationScreen(),
          ));
        });
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await navigatorKey.currentState!.pushNamed('/chatscreen', arguments: {
            "screenType":
                message.data['screenType'] == 'user' ? 'tasker' : 'user',
            "taskId": message.data['taskId'],
          });
        });
      }
    });

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        RemoteNotification? notification = message.notification;
        AndroidNotification? android = message.notification?.android;
        if (message.data['type'] == 'task') {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            await navigatorKey.currentState!.push(MaterialPageRoute(
              builder: (context) => const NotificationScreen(),
            ));
          });
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            await navigatorKey.currentState!
                .pushNamed('/chatscreen', arguments: {
              "screenType":
                  message.data['screenType'] == 'user' ? 'tasker' : 'user',
              "taskId": message.data['taskId'],
            });
          });
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => User(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Tasker(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Chat(),
        )
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          navigatorKey: navigatorKey,
          title: 'PairTasker',
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          home:
              auth.isAuth && auth.isSignUpCompleted && auth.isCommunitySelected
                  ? auth.isTasker
                      ? const TaskerDashboard()
                      : const HomePage()
                  : auth.isAuth &&
                          auth.isSignUpCompleted &&
                          !auth.isCommunitySelected
                      ? const SelectCommunityScreen()
                      : auth.isAuth &&
                              !auth.isSignUpCompleted &&
                              !auth.isCommunitySelected
                          ? const UserFormScreen()
                          : FutureBuilder(
                              future: auth.tryAutoLogin(),
                              builder: (ctx, authResult) =>
                                  authResult.connectionState ==
                                          ConnectionState.waiting
                                      ? const SplashScreen()
                                      : const InitialScreen(),
                            ),
          routes: {
            '/login': (context) => const LoginScreen(),
            '/register': (context) => const RegisterScreen(),
            '/home': (context) => const HomePage(),
            '/tasker-dashboard': (context) => const TaskerDashboard(),
            '/userform': (context) => const UserFormScreen(),
            '/select-community': (context) => const SelectCommunityScreen(),
            '/wishlist': (context) => const WishlistScreen(),
            '/notifications': (context) => const NotificationScreen(),
            '/myrequests': (context) => const MyRequests(),
            '/mytasks': (context) => const MyTasks(),
            '/taskerprofile': (context) => const TaskerProfile(),
            '/myprofile': (context) => const MyProfile(),
            '/chatscreen': (context) => const ChatScreen(),
            '/searchscreen': (context) => const SearchScreen(),
            '/mytaskerprofile': (context) => const MyTaskerProfile(),
            '/terms-and-conditions': (context) => const TermsAndConditions(),
            '/privacy-policy': (context) => const PrivacyPolicy(),
            '/faq': (context) => const FAQ(),
            '/loading': (context) => const LoadingScreen(),
            '/taskerform': (context) => const TaskerDetails(
                  workingCategories: [],
                  isUpdating: false,
                ),
          },
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
