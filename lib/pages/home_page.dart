
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:url_launcher/url_launcher_string.dart';
import 'package:weather/model/university_model.dart';
import 'package:weather/pages/add_country.dart';
import 'package:weather/repository/get_information.dart';

class HomePage extends StatefulWidget {
  final String country;

  const HomePage({Key? key, this.country = "Uzbekistan"}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GetInformationRepository api = GetInformationRepository();
  List<University> listOfUniversity = [];
  bool isLoading = true;

  Future<void> getInformation() async {
    isLoading = true;
    setState(() {});
    dynamic data = api.getInformation(name: widget.country);

    data.forEach((element) {
      listOfUniversity.add(University.fromJson(element));
    });
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    getInformation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Universities of ${widget.country}"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              itemCount: listOfUniversity.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(top: 16),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      color: Colors.lightBlue),
                  child: Column(
                    children: [
                      Text(
                        listOfUniversity[index].name.toString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      TextButton(
                          onPressed: () async {
                            final launchUri = Uri.parse(
                              listOfUniversity[index].webPages?.first ?? "",
                            );
                            await url_launcher.launchUrl(
                              launchUri,
                              mode: LaunchMode.externalApplication,
                            );
                          },
                          child: Text(
                            listOfUniversity[index].webPages?.first ?? "",
                            style: const TextStyle(color: Colors.white),
                          )),
                      const SizedBox(
                        height: 32,
                      ),
                      TextButton(
                          onPressed: () async {
                            final Uri launchUri =
                                Uri(scheme: 'sms', path: '+998995375611');
                            await url_launcher.launchUrl(launchUri);
                          },
                          child: const Text(
                            "number",
                            style: TextStyle(color: Colors.white),
                          ))
                    ],
                  ),
                );
              }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => AddCountry()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
