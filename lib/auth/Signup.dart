// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:librarybookissue/mainscreen.dart';
import 'package:librarybookissue/auth/auth.dart';
import 'package:librarybookissue/databsae/database.dart';
import 'package:librarybookissue/models/helper.dart';
import 'package:librarybookissue/models/constants.dart';

class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final check = GlobalKey<FormState>();
  TextEditingController emailTextEditer = TextEditingController();
  TextEditingController passwordEditer = TextEditingController();
  bool loading = false;
  final AuthMethod authmethod = AuthMethod();
  DataBaseMethods dataBaseMethods = DataBaseMethods();

  InputDecoration textdecoration(String hint) {
    return InputDecoration(
      fillColor: Colors.white,
        filled: true,
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black),
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
          color: Colors.green,
        )),
        focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
          color: Color.fromARGB(255, 49, 128, 223),
        )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Create Account",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: const Color.fromARGB(255, 187, 219, 250),
        elevation: 0.0,
        centerTitle: true,
      ),
      backgroundColor: const Color.fromARGB(255, 187, 219, 250),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Form(
                        key: check,
                        child: Container(
                          height: 460,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(235, 255, 255, 255),
                            borderRadius: BorderRadius.all(Radius.circular(20.0)),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromARGB(255, 28, 93, 146),
                                blurRadius: 5
                              )
                            ]
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 35, 8, 8),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(20))
                                    ),
                                    child: TextFormField(
                                      validator: (val) {
                                        return val!.isEmpty
                                            ? "Please enter university email ID"
                                            : null;
                                      },
                                      controller: emailTextEditer,
                                      decoration: textdecoration("University Email ID"),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                                  child: TextFormField(
                                    validator: (val) {
                                      return val!.isEmpty
                                          ? "Please enter the password"
                                          : null;
                                    },
                                    controller: passwordEditer,
                                    obscureText: true,
                                    decoration: textdecoration("Password"),
                                  ),
                                ),
                                const SizedBox(
                                  height: 18,
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(20, 38, 20, 13),
                                  child: SizedBox(
                                    height: 50,
                                    width: MediaQuery.of(context).size.width,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        if (check.currentState!.validate()) {
                                          Map<String, String> userMap = {
                                            "Email": emailTextEditer.text,
                                          };
                                          HelperMethod.saveidloggedinsharedpreference(
                                              emailTextEditer.text);
                                          setState(() {
                                            loading = true;
                                          });
                                          authmethod
                                              .signupwithemailpassword(
                                                  emailTextEditer.text,
                                                  passwordEditer.text)
                                              .then((value) {
                                                constants.name = emailTextEditer.text;
                                            dataBaseMethods.userinfo(constants.name ,userMap);
                                            HelperMethod
                                                .saveuserloggedinsharedpreference(true);
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const MainScreen()));
                                          });
                                        }
                                      },
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(const Color.fromARGB(255, 49, 128, 223)),
                                          shadowColor: MaterialStateProperty.all(
                                              Colors.transparent),
                                          elevation: MaterialStateProperty.all(0),
                                          shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20)))),
                                      child: const Text(
                                        "Sign up",
                                        style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                const Text("Already Registered? Sign In below", style: TextStyle(fontSize: 15),),
                                const SizedBox(
                                  height: 13,
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                                  child: SizedBox(
                                    height: 50,
                                    width: MediaQuery.of(context).size.width,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        widget.toggle();
                                      },
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(const Color.fromARGB(255, 49, 128, 223)),
                                          shadowColor: MaterialStateProperty.all(
                                              Colors.transparent),
                                          elevation: MaterialStateProperty.all(0),
                                          shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20)))),
                                      child: const Text(
                                        "Sign In",
                                        style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
