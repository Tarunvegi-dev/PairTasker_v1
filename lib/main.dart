import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:pairtasker/providers/chat.dart';
import 'package:pairtasker/providers/user.dart';
import 'package:pairtasker/providers/tasker.dart';
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

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  if (message.data['type'] == 'task-completion') {
    getMyRequests();
  }
  if (message.data['type'] == 'task-cancellation') {
    getMyTasks();
  }
  updateMessages(
    message.data,
    message.data['taskId'],
  );
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

void updateMessages(Map<String, dynamic> message, String taskId) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.reload();
  if (prefs.containsKey(taskId)) {
    final chatPref = prefs.getString(taskId);
    List<dynamic> chatsData = jsonDecode(chatPref!) as List<dynamic>;
    chatsData.add(message);
    await prefs.remove(taskId);
    prefs.setString(taskId, jsonEncode(chatsData));
  } else {
    List<dynamic> chatsData = [];
    chatsData.add(message);
    prefs.setString(taskId, jsonEncode(chatsData));
  }
  if (prefs.containsKey('unread-messages')) {
    final pendingPref = prefs.getString('unread-messages');
    Map<String, dynamic> pendingData =
        jsonDecode(pendingPref!) as Map<String, dynamic>;
    pendingData[taskId] = pendingData[taskId] + 1;
    prefs.setString('unread-messages', jsonEncode(pendingData));
  } else {
    Map<String, dynamic> pendingData = {};
    pendingData[taskId] = 1;
    prefs.setString('unread-messages', jsonEncode(pendingData));
  }
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
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification notification = message.notification!;
      AndroidNotification? android = message.notification?.android;
      if (message.data['type'] == 'task-completion') {
        getMyRequests();
      }
      if (message.data['type'] == 'task-cancellation') {
        getMyTasks();
      }
      updateMessages(
        message.data,
        message.data['taskId'],
      );
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
        final page = ChatScreen(
          screenType: message.data['screenType'] == 'user' ? 'tasker' : 'user',
          taskId: message.data['taskId'],
        );
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await navigatorKey.currentState!.push(MaterialPageRoute(
            builder: (context) => page,
          ));
        });
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
          home: auth.isAuth && auth.isSignUpCompleted
              ? const HomePage()
              : auth.isAuth && !auth.isSignUpCompleted
                  ? const UserFormScreen()
                  : FutureBuilder(
                      future: auth.tryAutoLogin(),
                      builder: (ctx, authResult) =>
                          authResult.connectionState == ConnectionState.waiting
                              ? const SplashScreen()
                              : const InitialScreen(),
                    ),
          routes: {
            '/login': (context) => const LoginScreen(),
            '/register': (context) => const RegisterScreen(),
            '/home': (context) => const HomePage(),
            '/userform': (context) => const UserFormScreen(),
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
            '/faq': (context) => const FAQ(),
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
