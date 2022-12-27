import 'package:flutter/material.dart';
import 'package:weather/pages/home_page.dart';
import 'package:weather/pages/weathers_home.dart';
import 'package:weather/repository/get_information.dart';
import 'package:weather/store/store.dart';

class AddCountry extends StatefulWidget {
  const AddCountry({Key? key}) : super(key: key);

  @override
  State<AddCountry> createState() => _AddCountryState();
}

class _AddCountryState extends State<AddCountry> {
  TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Country"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: TextFormField(
            controller: textEditingController,
            decoration: InputDecoration(labelText: "Country"),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var data = await GetInformationRepository.getInformationWeather(
              name: textEditingController.text);
          if (data["error"] == null) {
            LocalStore.setCountry(textEditingController.text);
            // ignore: use_build_context_synchronously
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) => const WeathersHome(),
                ),
                (route) => false);
          } else {
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  data["error"].toString(),
                ),
              ),
            );
          }
        },
        child: Icon(Icons.edit),
      ),
    );
  }
}
