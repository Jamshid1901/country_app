import 'package:shared_preferences/shared_preferences.dart';

abstract class LocalStore {
  LocalStore._();

  static Future setCountry(String country) async {
    SharedPreferences store = await SharedPreferences.getInstance();
    List<String> list = [];
    list = (store.getStringList("country") ?? []).toList(growable: true);
    Set<String> newSet = list.toSet();
    newSet.add(country.toUpperCase());
    store.setStringList("country", newSet.toList());
  }

  static Future<List<String>> getCountry() async {
    SharedPreferences store = await SharedPreferences.getInstance();
    return store.getStringList("country") ?? [];
  }

  static Future<void> removeCountry(int index) async {
    SharedPreferences store = await SharedPreferences.getInstance();
    List<String> newList = store.getStringList("country") ?? [];
    newList.removeAt(index);
    store.setStringList("country", newList);
  }

  static Future<void> removeAll() async {
    SharedPreferences store = await SharedPreferences.getInstance();
    store.remove("country");
  }
}
