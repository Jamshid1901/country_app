import 'package:flutter/material.dart';

import '../repository/main_repository.dart';

class TranslatePage extends StatefulWidget {
  const TranslatePage({Key? key}) : super(key: key);

  @override
  State<TranslatePage> createState() => _TranslatePageState();
}

class _TranslatePageState extends State<TranslatePage> {
  TextEditingController title = TextEditingController();
  TextEditingController lan = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Send Grid"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextFormField(
              controller: title,
              decoration: const InputDecoration(labelText: "Text :"),
            ),
            TextFormField(
              controller: lan,
              decoration: const InputDecoration(labelText: "lan :"),
            ),
            ElevatedButton(
                onPressed: () async {
                  dynamic res = await MainRepository.translate(
                      text: title.text, lan: lan.text);

                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(res),
                    duration: const Duration(seconds: 30),
                  ));
                },
                child: const Text("Send"))
          ],
        ),
      ),
    );
  }
}
