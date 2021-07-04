import 'package:armotaleadmin/widgets&helpers/helpers/helperClasses.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Future<bool> saveIntroBool(bool checkOnboarding) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   prefs.setBool('checkOnboarding', checkOnboarding);
//   return checkOnboarding;
// }

Future<bool> getIsOnline() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.getBool('isLoggedIn') == null) {
    await prefs.setBool('isLoggedIn', false);
  }
  return prefs.getBool('isLoggedIn');
}

Future setIsOnline(bool isFirstTime) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('isLoggedIn', isFirstTime);
}

Future saveGraphValuesList(List graphVals) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setStringList(HelperClass.graphValues, graphVals);
}

Future<List<int>> getGraphValuesList(List<String> values) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> original =  prefs.getStringList(HelperClass.graphValues);
  
}
