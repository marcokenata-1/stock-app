class SearchHit {
  final String name;
  final String image;

  SearchHit.fromJson(json)
      : name = json['name'],
        image = json['image'];
}
