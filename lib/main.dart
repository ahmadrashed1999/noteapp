import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/auth/login.dart';
import 'app/auth/signup.dart';
import 'app/home.dart';
import 'app/notes/add.dart';
import 'app/notes/edit.dart';

late SharedPreferences prefs;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.red,
        ),
      ),
      debugShowCheckedModeBanner: false,
      title: 'notes app',
      initialRoute: prefs.getString('id') == null ? '/' : 'home',
      routes: {
        '/': (context) => Login(),
        'signup': (context) => SignUp(),
        'home': (context) => Home(),
        'add': (context) => AddNote(),
      },
    );
  }
}
