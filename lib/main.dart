import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:librarybookissue/mainscreen.dart';
import 'package:librarybookissue/auth/Authenticate.dart';
import 'package:librarybookissue/models/helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light));
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isuserloggedin = false;

  @override
  void initState() {
    getloggedinstate();
    super.initState();
  }

  getloggedinstate() async {
    return await HelperMethod.getuserloggedinsharedpreference().then((value) {
      if(value!=null) {
        setState(() {
          isuserloggedin = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Online Library Book issue',
        home: isuserloggedin ? const MainScreen() : const Authenticate());
  }
}
