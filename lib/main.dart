import 'package:flutter/material.dart';
import 'package:pairtasker/providers/taskers.dart';
import 'screens/screens.dart';
import 'providers/auth.dart';
import 'screens/splash_screen.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
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
            '/taskerform': (context) => const TaskerDetails(),
          },
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
