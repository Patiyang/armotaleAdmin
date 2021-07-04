import 'package:armotaleadmin/views/auth/login.dart';
import 'package:armotaleadmin/views/home/homePage.dart';
import 'package:armotaleadmin/widgets&helpers/helpers/styling.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Armotale',
      theme: ThemeData(
        scaffoldBackgroundColor: grey[100],
        fontFamily: 'Nunito',
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => Login(),
        '/homePage': (context) => HomePage(),
      },
      // home: HomePage(),
    );
  }
}
