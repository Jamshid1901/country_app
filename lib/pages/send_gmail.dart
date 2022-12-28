import 'package:flutter/material.dart';
import 'package:weather/repository/main_repository.dart';

import '../model/send_mail_model.dart';

class SendGmailPage extends StatefulWidget {
  const SendGmailPage({Key? key}) : super(key: key);

  @override
  State<SendGmailPage> createState() => _SendGmailPageState();
}

class _SendGmailPageState extends State<SendGmailPage> {
  TextEditingController toEmail = TextEditingController();
  TextEditingController fromEmail = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController desc = TextEditingController();

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
              controller: toEmail,
              decoration: const InputDecoration(labelText: "Kimga yuborish :"),
            ),
            TextFormField(
              controller: fromEmail,
              decoration: const InputDecoration(labelText: "Kimdan yuborish :"),
            ),
            TextFormField(
              controller: title,
              decoration: const InputDecoration(labelText: "Mavzu :"),
            ),
            TextFormField(
              controller: desc,
              decoration: const InputDecoration(labelText: "Describtion :"),
            ),
            ElevatedButton(
                onPressed: () async {
                  SendSimpleModel data = SendSimpleModel(
                      fromEmail: fromEmail.text,
                      toEmail: toEmail.text,
                      title: title.text,
                      desc: desc.text);
                  int status = await MainRepository.sendGmail(model: data);

                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(status.toString())));
                },
                child: const Text("Send"))
          ],
        ),
      ),
    );
  }
}
