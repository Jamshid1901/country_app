import 'package:flutter/material.dart';
import 'package:weather/pages/home_page.dart';

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
        onPressed: () {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => HomePage(
                  country: textEditingController.text,
                ),
              ),
              (route) => false);
        },
        child: Icon(Icons.edit),
      ),
    );
  }
}
