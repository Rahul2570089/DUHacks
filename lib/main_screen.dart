import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:librarybookissue/databsae/database.dart';
import 'package:librarybookissue/drawer.dart';
import 'package:librarybookissue/models/article.dart';
import 'package:http/http.dart' as http;
import 'package:librarybookissue/models/helper.dart';
import 'package:marquee/marquee.dart';
import 'dart:convert';
import 'package:librarybookissue/models/constants.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool show = false;
  TextEditingController c = TextEditingController();
  DataBaseMethods dataBaseMethods = DataBaseMethods();
  List? mapresponse;
  List<Article> list = [];
  List<Article> list2 = [];
  List<Article> l = [];
  List<String> b = [];
  int? count;
  QuerySnapshot? querySnapshot, querySnapshot1;

  Future<List<Article>> apicall() async {
    http.Response response;
    response = await http
        .get(Uri.parse("https://rahul2570089.github.io/jsonAPI/DU_Hacks.json"));
    if (response.statusCode == 200) {
      if (mounted) {
        setState(() {
          mapresponse = json.decode(response.body);
          var resp = mapresponse as List;
          list = resp.map((json) => Article.fromJson(json)).toList();
        });
      }
    }
    return list;
  }

  Future<List<Article>> getuserdata() async {
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
    return ListView.builder(
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
                        "${books[position].department!} Sem-${books[position].sem}"
                            .toUpperCase(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      )),
                  onTap: () async {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Center(
                              child: Text(
                                'Issue this book ?',
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
                                          if (count! < 3) {
                                            Map<String, String> m = {
                                              "BooksList":
                                                  books[position].name!,
                                              "Department":
                                                  books[position].department!,
                                              "Semester": books[position].sem!,
                                              "Count": books[position].count!
                                            };
                                            dataBaseMethods.addData(
                                                Constants.name!, m, books[position].name!);
                                            Fluttertoast.showToast(
                                                msg: "Book added to your collection");
                                            count = await dataBaseMethods
                                                .getlength(Constants.name!);
                                            await dataBaseMethods.getBookCount(
                                                books[position].name!);
                                          } else if (count == 3 &&
                                              // ignore: iterable_contains_unrelated_type
                                              !l.contains(
                                                  books[position].name)) {
                                            Fluttertoast.showToast(
                                                msg: "Limit Reached");
                                            // ignore: iterable_contains_unrelated_type
                                          } else if (l.contains(
                                                  books[position].name) &&
                                              count != 3) {
                                            Fluttertoast.showToast(
                                                msg: "Book already issued");
                                          } else {
                                            Fluttertoast.showToast(
                                                msg:
                                                    "Book already issued and limit reached");
                                          }
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
        });
  }

  @override
  void initState() {
    getuserinfo();
    getuserdata();
    super.initState();
  }

  getuserinfo() async {
    Constants.name = (await HelperMethod.getidloggedinsharedpreference());
    count = await dataBaseMethods.getlength(Constants.name!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawer(),
      appBar: AppBar(
        title: const Text('Issue Book'),
        backgroundColor: const Color.fromARGB(255, 141, 193, 245),
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
            child: TextField(
              style: const TextStyle(fontSize: 18),
              onChanged: ((value) => {
                    setState(() {
                      list2 = list
                          .where((element) => element.name!.contains(value))
                          .toList();
                      list2 += list
                          .where(
                              (element) => element.department!.contains(value))
                          .toList();
                      list2 += list
                          .where((element) => element.sem!.contains(value))
                          .toList();
                      show = true;
                    })
                  }),
              controller: c,
              decoration: const InputDecoration(
                hintText: "Enter Book name",
                hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
                border: InputBorder.none,
              ),
            ),
          ),
          const Divider(
            thickness: 0.6,
            color: Colors.black,
          ),
          Expanded(
            child: !show
                ? FutureBuilder<List<Article>>(
                    future: apicall(),
                    builder: (context, snapshot) {
                      return snapshot.data != null
                          ? listview(snapshot.data!)
                          : const Center(
                              child: CircularProgressIndicator(
                            ));
                    })
                : listview(list2),
          ),
        ],
      ),
    );
  }
}
