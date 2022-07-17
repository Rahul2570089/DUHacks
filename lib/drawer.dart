import 'package:flutter/material.dart';
import 'package:librarybookissue/IssuedBooks.dart';
import 'package:librarybookissue/auth/Authenticate.dart';
import 'package:librarybookissue/auth/auth.dart';
import 'package:librarybookissue/models/Helper.dart';


// ignore: camel_case_types, must_be_immutable
class drawer extends StatelessWidget {
  AuthMethod authMethod = AuthMethod();

  drawer({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: const Color.fromARGB(255, 187, 219, 250),
        child: ListView(
          children: [
            const SizedBox(height: 44,),
            const Center(child: Text("Menu",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 35,color: Colors.black),)),
            const SizedBox(height: 200,),
            Lists(
                text: "Your issued books",
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(builder: ((context) => const IssuedBooks())));
                }
            ),
            const SizedBox(height: 19,),
            lists(
                text: "Log Out",
                onTap: () {
                  authMethod.signout();
                  HelperMethod.saveuserloggedinsharedpreference(false);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>const Authenticate()));
                }
            ),
            const SizedBox(height: 250,),
            const Divider(height: 1,thickness: 1,color: Colors.black,),
            Padding(
              padding: const EdgeInsets.only(top: 37),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("Developed by "),
                  Text("Focused dev.s", style: TextStyle(fontWeight: FontWeight.bold),)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget lists({required String text, String? svg, required VoidCallback onTap}) {
  return ListTile(
      title: Center(child: Text(text,style: const TextStyle(color: Colors.black,fontSize: 20),)),
      onTap: onTap,
  );
}

// ignore: non_constant_identifier_names
Widget Lists({required String text,IconData? icon,required VoidCallback onTap}) {
  return ListTile(
      title: Center(child: Text(text,style: const TextStyle(color: Colors.black, fontSize: 20),)),
      onTap: onTap,
  );
}

  
  