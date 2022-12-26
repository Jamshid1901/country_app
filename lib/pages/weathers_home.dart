import 'package:flutter/material.dart';
import 'package:weather/model/weather_model.dart';
import 'package:weather/widgets/hourItem.dart';

import '../repository/get_information.dart';

class WeathersHome extends StatefulWidget {
  const WeathersHome({Key? key}) : super(key: key);

  @override
  State<WeathersHome> createState() => _WeathersHomeState();
}

class _WeathersHomeState extends State<WeathersHome> {
  Future<WeatherModel> getWeatherInfo() async {
    final data =
        await GetInformationRepository.getInformationWeather(name: "Moscow");
    return WeatherModel.fromJson(data);
  }

  bool checkHour(int index, WeatherModel? snapshot) {
    return int.tryParse((snapshot
                    ?.forecast?.forecastday?.first.hour?[index].time ??
                "")
            .substring(
                (snapshot?.forecast?.forecastday?.first.hour?[index].time ?? "")
                        .indexOf(":") -
                    2,
                (snapshot?.forecast?.forecastday?.first.hour?[index].time ?? "")
                    .indexOf(":"))) ==
        TimeOfDay.now().hour;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather"),
      ),
      body: FutureBuilder(
        future: getWeatherInfo(),
        builder: (BuildContext context, AsyncSnapshot<WeatherModel> snapshot) {
          return snapshot.hasData
              ? Column(
                  children: [
                    Center(
                      child: Text(snapshot.data?.location?.name ?? ""),
                    ),
                    Center(
                      child:
                          Text((snapshot.data?.current?.tempC ?? 0).toString()),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Text("Mostly Clear"),
                        ),
                        Image.network("https:${snapshot.data?.current?.condition?.icon ?? ""}"),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Text(
                                  "H:${snapshot.data?.forecast?.forecastday?.first.day?.maxtempC ?? 0}"),
                            ),
                            const SizedBox(
                              width: 32,
                            ),
                            Center(
                              child: Text(
                                  "L:${snapshot.data?.forecast?.forecastday?.last.day?.maxtempC ?? 0}"),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 200,
                          child: ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 16),
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data?.forecast?.forecastday
                                      ?.first.hour?.length ??
                                  0,
                              itemBuilder: (context, index) {
                                return HourItem(
                                  isActive: checkHour(index, snapshot.data),
                                  title: snapshot.data?.forecast?.forecastday
                                      ?.first.hour?[index].time,
                                  temp: snapshot.data?.forecast?.forecastday
                                      ?.first.hour?[index].tempC,
                                  image: snapshot.data?.forecast?.forecastday
                                    ?.first.hour?[index].condition?.icon,
                                );
                              }),
                        )
                      ],
                    ),
                  ],
                )
              : const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
