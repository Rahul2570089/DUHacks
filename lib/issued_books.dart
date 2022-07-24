import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:librarybookissue/databsae/database.dart';
import 'package:librarybookissue/models/constants.dart';
import 'package:librarybookissue/models/helper.dart';
import 'package:marquee/marquee.dart';

import 'models/article.dart';

// ignore: must_be_immutable
class IssuedBooks extends StatefulWidget {
  const IssuedBooks({Key? key}) : super(key: key);

  @override
  State<IssuedBooks> createState() => _IssuedBooksState();
}

class _IssuedBooksState extends State<IssuedBooks> {
  Stream? snap;
  DataBaseMethods dataBaseMethods = DataBaseMethods();
  QuerySnapshot? querySnapshot;

  @override
  void initState() {
    getuserinfo();
    super.initState();
  }

  Future<List<Article>> getuserinfo() async {
    List<Article> l = [];
    Constants.name = (await HelperMethod.getidloggedinsharedpreference());
    querySnapshot = (await FirebaseFirestore.instance
        .collection("UserData")
        .doc(Constants.name)
        .collection("Books")
        .get());
    for (var element in querySnapshot!.docs) {
      if (mounted) {
        setState(() {
          l.add(Article(
              name: element['BooksList'],
              department: element['Department'],
              sem: element['Semester'],
              count: element['Count']));
        });
      }
    }
    return l;
  }

  Widget listview(List<Article> books) {
    return books.isNotEmpty
        ? ListView.builder(
            itemCount: books.length,
            itemBuilder: (context, position) {
              return SizedBox(
                height: 80,
                child: Card(
                  shadowColor: const Color.fromARGB(255, 141, 193, 245),
                  elevation: 4,
                  child: Center(
                    child: ListTile(
                      title: SizedBox(
                        height: 50,
                        width: 90,
                        child: Row(
                          children: [
                            Expanded(
                              child: Marquee(
                                text: books[position].name! == ''
                                    ? '  Name Unavailable  '
                                    : "  ${books[position].name!}  ",
                                style: TextStyle(
                                  fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                    color: books[position].name! == ''
                                        ? Colors.red
                                        : Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                      leading: Padding(
                          padding: const EdgeInsets.only(right: 80.0),
                          child: Text(
                            "${books[position].department!} Sem-${books[position].sem}".toUpperCase(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18
                            ),
                          )),
                      onTap: () {
                        showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Center(
                              child: Text(
                                'Cancel your Issued book ?',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            actions: [
                              Center(
                                child: ButtonBar(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ElevatedButton(
                                        onPressed: () async {
                                          dataBaseMethods.getBookCountInc(books[position].name!);
                                          dataBaseMethods.removedata(Constants.name!, books[position].name!);
                                          Fluttertoast.showToast(msg: "Book removed from your collection");
                                          // ignore: use_build_context_synchronously
                                          Navigator.pop(context); 
                                        },
                                        child: const Text("Yes")),
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Cancel"))
                                  ],
                                ),
                              )
                            ],
                          );
                        });
                      },
                    ),
                  ),
                ),
              );
            })
        : const Center(
            child: Text('No issued books'),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Issued Books'),
          backgroundColor: const Color.fromARGB(255, 141, 193, 245),
          elevation: 0,
        ),
        body: FutureBuilder<List<Article>>(
          future: getuserinfo(),
          builder: (context, snapshot) {
            return snapshot.hasData
                ? listview(snapshot.data!)
                : const Center(child: CircularProgressIndicator());
          },
        ));
  }
}
