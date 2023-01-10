import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:pairtasker/providers/user.dart';
import 'package:pairtasker/providers/tasker.dart';
import 'screens/screens.dart';
import 'providers/auth.dart';
import 'screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // final fbm = FirebaseMessaging.instance;
    // fbm.requestPermission(
    //   alert: true,
    //   announcement: false,
    //   badge: true,
    //   carPlay: false,
    //   criticalAlert: false,
    //   provisional: false,
    //   sound: true,
    // );
    // FirebaseMessaging.instance.getToken().then((value) => print(value));
    // FirebaseMessaging.onBackgroundMessage(_firebaseMessaging);
    super.initState();
  }

  // Future<void> _firebaseMessaging(RemoteMessage message) async {
  //   print(message);
  // }

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
        )
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
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
            '/chatscreen': (context) => const ChatScreen('user'),
            '/searchscreen': (context) => const SearchScreen(),
            '/mytaskerprofile': (context) => const MyTaskerProfile(),
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
