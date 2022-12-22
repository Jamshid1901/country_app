class University {
  final String alphaTwoCode;
  final int name;
  final List<String>? webPages;
  final String country;

  University(
      {required this.alphaTwoCode,
      required this.name,
      required this.webPages,
      required this.country});

  factory University.fromJson(Map data) {
    List<String> pages = [];
    data["web_pages"].forEach((element) {
      pages.add(element);
    });
    return University(
        alphaTwoCode: data["alpha_two_code"],
        name: data["name"],
        webPages: pages,
        country: data["country"]);
  }
}
