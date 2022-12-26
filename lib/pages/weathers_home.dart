import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import 'package:weather/model/weather_model.dart';
import 'package:weather/widgets/hout_item.dart';
import 'package:weather/widgets/shimmer_item.dart';

import '../repository/get_information.dart';

class WeathersHome extends StatefulWidget {
  const WeathersHome({Key? key}) : super(key: key);

  @override
  State<WeathersHome> createState() => _WeathersHomeState();
}

class _WeathersHomeState extends State<WeathersHome> {
  RefreshController controller = RefreshController();
  WeatherModel weatherData = WeatherModel();
  bool isLoading = true;

  Future<void> getWeatherInfo() async {
    isLoading = true;
    setState(() {});
    final data =
        await GetInformationRepository.getInformationWeather(name: "Moscow");
    weatherData = WeatherModel.fromJson(data);
    isLoading = false;
    setState(() {});
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
  void initState() {
    getWeatherInfo();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather"),
      ),
      body: SmartRefresher(
        controller: controller,
        enablePullDown: true,
        enablePullUp: false,
        onLoading: () {},
        onRefresh: () async {
          await getWeatherInfo();
          controller.refreshCompleted();
        },
        child: Column(
          children: [
            const SizedBox(
              height: 32,
            ),
            isLoading
                ? const ShimmerItem(
                    height: 20,
                    width: 48,
                  )
                : Center(
                    child: Text(weatherData.location?.name ?? ""),
                  ),
            const SizedBox(
              height: 24,
            ),
            isLoading
                ? const ShimmerItem(
                    height: 20,
                    width: 20,
                  )
                : Center(
                    child: Text((weatherData.current?.tempC ?? 0).toString()),
                  ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Center(
                  child: Text("Mostly Clear"),
                ),
                isLoading
                    ? const Center(
                      child: ShimmerItem(
                          height: 60,
                          width: 60,
                        ),
                    )
                    : Center(
                        child: Image.network(
                            "https:${weatherData.current?.condition?.icon ?? ""}")),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    isLoading
                        ? SizedBox(
                            width: 48.0,
                            height: 20.0,
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                              child: Container(
                                width: 50.0,
                                height: 20.0,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        : Center(
                            child: Text(
                                "H:${weatherData.forecast?.forecastday?.first.day?.maxtempC ?? 0}"),
                          ),
                    const SizedBox(
                      width: 32,
                    ),
                    isLoading
                        ? SizedBox(
                            width: 50.0,
                            height: 20.0,
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                              child: Container(
                                width: 50.0,
                                height: 20.0,
                                color: Colors.grey,
                              ),
                            ),
                          )
                        : Center(
                            child: Text(
                                "L:${weatherData.forecast?.forecastday?.last.day?.maxtempC ?? 0}"),
                          ),
                  ],
                ),
                SizedBox(
                        height: 200,
                        child: ListView.builder(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 16),
                            scrollDirection: Axis.horizontal,
                            itemCount: isLoading
                                ? 10 : weatherData.forecast?.forecastday?.first
                                    .hour?.length ??
                                0,
                            itemBuilder: (context, index) {
                              return isLoading
                                  ? Padding(
                                    padding: const EdgeInsets.only(right: 24),
                                    child: const ShimmerItem(height: 100, width: 90),
                                  )
                                  : HourItem(
                                isActive: checkHour(index, weatherData),
                                title: weatherData.forecast?.forecastday?.first
                                    .hour?[index].time,
                                temp: weatherData.forecast?.forecastday?.first
                                    .hour?[index].tempC,
                                image: weatherData.forecast?.forecastday?.first
                                    .hour?[index].condition?.icon,
                              );
                            }),
                      )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
