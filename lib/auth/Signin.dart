import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:librarybookissue/Mainscreen.dart';
import 'package:librarybookissue/auth/auth.dart';
import 'package:librarybookissue/databsae/Database.dart';
import 'package:librarybookissue/models/Helper.dart';
import 'package:librarybookissue/models/constants.dart';

class SignIn extends StatefulWidget {
  final Function toggle;
  const SignIn(this.toggle, {Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool loading = false;
  final check = GlobalKey<FormState>();
  TextEditingController emailTextEditer = TextEditingController();
  TextEditingController passwordEditer = TextEditingController();
  QuerySnapshot? snapshot;
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
          "Log In",
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
                                            ? "Please enter the university email ID"
                                            : null;
                                      },
                                      controller: emailTextEditer,
                                      decoration:
                                          textdecoration("University Email ID"),
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
                                GestureDetector(
                                    onTap: () {
                                      if (emailTextEditer.text.isNotEmpty) {
                                        AuthMethod()
                                            .resetpassword(emailTextEditer.text);
                                        Fluttertoast.showToast(msg: "Email sent");
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: "Please enter email");
                                      }
                                    },
                                    child: const Text(
                                      "Forgot Password?",
                                      style: TextStyle(
                                          decoration: TextDecoration.underline),
                                    )),
                                const SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(20, 1, 20, 13),
                                  child: SizedBox(
                                    height: 50,
                                    width: MediaQuery.of(context).size.width,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        if (check.currentState!.validate()) {
                                          setState(() {
                                            loading = true;
                                          });
                                          dataBaseMethods
                                              .getUserbyemail(emailTextEditer.text)
                                              .then((value) {
                                            snapshot = value;
                                          });
                  
                                          authmethod
                                              .signinwithemailpassword(
                                                  emailTextEditer.text,
                                                  passwordEditer.text)
                                              .then((value) async {
                                            if (value != null) {
                                              constants.name = emailTextEditer.text;
                                              HelperMethod
                                                  .saveuserloggedinsharedpreference(
                                                      true);
                                              HelperMethod.saveidloggedinsharedpreference(emailTextEditer.text);
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const MainScreen()));
                                            } else {
                                              setState(() {
                                                loading=false;
                                              });
                                            }
                                          });
                                        } else {
                                          setState(() {
                                            loading = false;
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
                                        "Sign in",
                                        style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                const Text("Don't have account? Register below", style: TextStyle(fontSize: 15),),
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
                                        "Sign up",
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
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
