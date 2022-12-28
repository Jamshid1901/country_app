import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:osm_nominatim/osm_nominatim.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import 'package:weather/model/weather_model.dart';
import 'package:weather/pages/add_country.dart';
import 'package:weather/pages/map_page.dart';
import 'package:weather/store/store.dart';
import 'package:weather/widgets/hout_item.dart';
import 'package:weather/widgets/shimmer_item.dart';

import '../repository/main_repository.dart';

class WeathersHome extends StatefulWidget {
  const WeathersHome({
    Key? key,
  }) : super(key: key);

  @override
  State<WeathersHome> createState() => _WeathersHomeState();
}

class _WeathersHomeState extends State<WeathersHome>
    with TickerProviderStateMixin {
  RefreshController controller = RefreshController();
  late TabController tabController;
  List<WeatherModel> listOfWeather = [];
  bool isLoading = true;
  bool isCancelButton = false;
  double lat = 0;
  double lon = 0;
  List<String> listOfTab = [];

  Future<bool> _determinePosition() async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      } else if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        var a = await Geolocator.getCurrentPosition();
        final reverseSearchResult = await Nominatim.reverseSearch(
          lat: a.latitude,
          lon: a.longitude,
          addressDetails: true,
          extraTags: true,
          nameDetails: true,
        );
        print(reverseSearchResult.address?["state"]);
        await LocalStore.setCountry(reverseSearchResult.address?["state"]);
        return true;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    var a = await Geolocator.getCurrentPosition();
    lat = a.latitude;
    lon = a.longitude;
    final reverseSearchResult = await Nominatim.reverseSearch(
      lat: a.latitude,
      lon: a.longitude,
      addressDetails: true,
      extraTags: true,
      nameDetails: true,
    );
    print(reverseSearchResult.address?["state"]);
    await LocalStore.setCountry(reverseSearchResult.address?["state"]);
    return true;
  }

  Future<WeatherModel> getWeatherInfo(String country) async {
    final data =
        await MainRepository.getInformationWeather(name: country);
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
        int.tryParse((snapshot?.location?.localtime ?? "").substring(
            (snapshot?.location?.localtime ?? "").indexOf(":") - 2,
            (snapshot?.location?.localtime ?? "").indexOf(":")));
  }

  getLocalStore() async {
    isLoading = true;
    setState(() {});
    await _determinePosition();
    List<String> listOfStore = await LocalStore.getCountry();
    listOfTab.addAll(listOfStore);
    for (int i = 0; i < listOfTab.length; i++) {
      WeatherModel model = await getWeatherInfo(listOfTab[i]);
      listOfWeather.add(model);
    }
    tabController = TabController(length: listOfTab.length, vsync: this);
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    getLocalStore();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Scaffold(body: Center(child: CircularProgressIndicator()))
        : Scaffold(
            appBar: AppBar(
                title: const Text("Weather"),
                bottom: TabBar(
                  isScrollable: true,
                  controller: tabController,
                  tabs: [
                    ...listOfTab.map((e) => Tab(
                          child: GestureDetector(
                            onLongPress: () {
                              isCancelButton = !isCancelButton;
                              setState(() {});
                            },
                            child: Row(
                              children: [
                                Text(e),
                                isCancelButton
                                    ? IconButton(
                                        onPressed: () {
                                          listOfWeather
                                              .removeAt(listOfTab.indexOf(e));
                                          LocalStore.removeCountry(
                                              listOfTab.indexOf(e));
                                          listOfTab
                                              .removeAt(listOfTab.indexOf(e));
                                          tabController = TabController(
                                              length: listOfTab.length,
                                              vsync: this);

                                          setState(() {});
                                        },
                                        icon: const Icon(Icons.clear),
                                      )
                                    : const SizedBox.shrink()
                              ],
                            ),
                          ),
                        ))
                  ],
                )),
            body: SmartRefresher(
              controller: controller,
              enablePullDown: true,
              enablePullUp: false,
              onLoading: () {},
              onRefresh: () async {
                WeatherModel newModel =
                    await getWeatherInfo(listOfTab[tabController.index]);
                listOfWeather.removeAt(tabController.index);
                listOfWeather.insert(tabController.index, newModel);
                setState(() {});
                controller.refreshCompleted();
              },
              child: GestureDetector(
                onTap: () {
                  isCancelButton = false;
                  setState(() {});
                },
                child: TabBarView(
                  controller: tabController,
                  children: [
                    ...listOfWeather.map((weatherData) => Column(
                          children: [
                            const SizedBox(
                              height: 32,
                            ),
                            Column(
                              children: [
                                Center(
                                  child: Text(weatherData.location?.name ?? ""),
                                ),
                                Center(
                                  child:
                                      Text(weatherData.location?.country ?? ""),
                                ),
                                Center(
                                  child: Text(
                                      weatherData.location?.localtime ?? ""),
                                ),
                              ],
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
                                    child: Text(
                                        (weatherData.current?.tempC ?? 0)
                                            .toString()),
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
                                              highlightColor:
                                                  Colors.grey.shade100,
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
                                              highlightColor:
                                                  Colors.grey.shade100,
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
                                          ? 10
                                          : weatherData.forecast?.forecastday
                                                  ?.first.hour?.length ??
                                              0,
                                      itemBuilder: (context, index) {
                                        return isLoading
                                            ? const Padding(
                                                padding:
                                                    EdgeInsets.only(right: 24),
                                                child: ShimmerItem(
                                                    height: 100, width: 90),
                                              )
                                            : HourItem(
                                                isActive: checkHour(
                                                    index, weatherData),
                                                title: weatherData
                                                    .forecast
                                                    ?.forecastday
                                                    ?.first
                                                    .hour?[index]
                                                    .time,
                                                temp: weatherData
                                                    .forecast
                                                    ?.forecastday
                                                    ?.first
                                                    .hour?[index]
                                                    .tempC,
                                                image: weatherData
                                                    .forecast
                                                    ?.forecastday
                                                    ?.first
                                                    .hour?[index]
                                                    .condition
                                                    ?.icon,
                                              );
                                      }),
                                )
                              ],
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            ),
            floatingActionButton: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => MapPage(lat: lat, lon: lon)));
                  },
                  child: const Icon(Icons.map),
                ),
                const SizedBox(
                  width: 16,
                ),
                FloatingActionButton(
                  onPressed: () {
                    listOfWeather.clear();
                    listOfTab.clear();
                    LocalStore.removeAll();
                    tabController = TabController(length: 0, vsync: this);
                    setState(() {});
                  },
                  child: const Icon(Icons.delete),
                ),
                const SizedBox(
                  width: 16,
                ),
                FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const AddCountry()));
                  },
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          );
  }
}
