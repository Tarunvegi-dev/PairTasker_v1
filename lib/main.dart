import 'package:flutter/material.dart';
import 'screens/screens.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PairTasker',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        '/': (context) => const InitialScreen(),
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
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
