import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather/pages/send_gmail.dart';

import '../model/send_mail_model.dart';

abstract class MainRepository {
  MainRepository._();

  static getInformation({required String name}) async {
    try {
      final url =
      Uri.parse("http://universities.hipolabs.com/search?country=$name");
      final res = await http.get(url);
      dynamic data = jsonDecode(res.body);

      return data;
    } catch (e) {
      print(e);
    }
  }

  static getInformationWeather({required String name}) async {
    try {
      final url = Uri.parse(
          "https://api.weatherapi.com/v1/forecast.json?key=0aafe5ca2dc742cb8d7125331222212&q=$name");
      final res = await http.get(url);
      dynamic data = jsonDecode(res.body);

      return data;
    } catch (e) {
      print(e);
    }
  }

  static sendGmail({required SendSimpleModel model}) async {
    try {
      final url =
      Uri.parse("https://rapidprod-sendgrid-v1.p.rapidapi.com/mail/send");
      final res = await http.post(url, headers: {
        'content-type': 'application/json',
        'X-RapidAPI-Key': 'd0d8ce2366mshc56ba24b96eb6b2p14f78ejsnf51c79860e5a',
        'X-RapidAPI-Host': 'rapidprod-sendgrid-v1.p.rapidapi.com'
      },
          body: jsonEncode(model.toJson())
      );

      return res.statusCode;

    } catch (e) {
      print(e);
    }
  }
}
