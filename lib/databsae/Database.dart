import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DataBaseMethods {

  getUserbyemail(String email) async {
   return await FirebaseFirestore.instance.collection("User")
    .where("Email", isEqualTo: email)
    .get();
  }

  userinfo(String? name ,userMap) {
    FirebaseFirestore.instance.collection("User").doc(name).set(userMap).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
    });
  }

  getlength(String email) async {
    var v = await FirebaseFirestore.instance.collection("UserData").doc(email).collection("Books").get();
    return v.docs.length;
  }

  getBookCount(String name) async {
    int x=0;
    await FirebaseFirestore.instance.collection("BooksCount").doc(name).get().then((value) {
        x=value['Count'];
        x--; 
    });
    Map<String,int> data = {
      "Count": x
    };
    FirebaseFirestore.instance.collection("BooksCount").doc(name).update(data);
  }

  getBookCountInc(String name) async {
    int x=0;
    await FirebaseFirestore.instance.collection("BooksCount").doc(name).get().then((value) {
        x=value['Count'];
        x++; 
    });
    Map<String,int> data = {
      "Count": x
    };
    FirebaseFirestore.instance.collection("BooksCount").doc(name).update(data);
  }



  addData(String uid ,data, String name) {
    FirebaseFirestore.instance.collection("UserData").doc(uid).collection("Books").doc(name).set(data, SetOptions(merge: true)).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
    });
  }

  removedata(String email,String name) async {
    // await FirebaseFirestore.instance.collection("UserData").doc(email).collection("Books").where("BooksList", isEqualTo: name).get().then((value) {
    // FirebaseFirestore.instance.collection("UserData").doc(email).collection("Books").doc(value.toString()).delete();
  // });
    FirebaseFirestore.instance.collection("UserData").doc(email).collection("Books").doc(name).delete();
  }

}