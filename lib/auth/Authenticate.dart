import 'package:flutter/material.dart';
import 'package:librarybookissue/auth/sign_in.dart';
import 'package:librarybookissue/auth/sign_up.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({ Key? key }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool signin = true;
  void toggleview() {
    setState(() {
      signin = !signin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return signin ? SignIn(toggleview) : SignUp(toggleview);
  }
}