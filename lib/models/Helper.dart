import 'package:shared_preferences/shared_preferences.dart';

class HelperMethod {
  static String sharedpreferencesloggedin = "ISLOGGEDIN";
  static String sharedpreferenceid = "USERID";

  static Future<bool> saveuserloggedinsharedpreference(bool isuserloggedin) async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    return await pre.setBool(sharedpreferencesloggedin, isuserloggedin);
  }

  static Future<bool> saveidloggedinsharedpreference(String id) async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    return await pre.setString(sharedpreferenceid, id);
  }

  static Future<bool?> getuserloggedinsharedpreference() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    return pre.getBool(sharedpreferencesloggedin);
  }

  static Future<String?> getidloggedinsharedpreference() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    return pre.getString(sharedpreferenceid);
  }
}