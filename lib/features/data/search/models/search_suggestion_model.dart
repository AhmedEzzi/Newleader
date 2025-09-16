class SearchSuggestion {
  final int id;
  final String query;
  final int count;
  final String type;
  final String typeString;

  SearchSuggestion({
    required this.id,
    required this.query,
    required this.count,
    required this.type,
    required this.typeString,
  });

  factory SearchSuggestion.fromJson(Map<String, dynamic> json) {
    return SearchSuggestion(
      id: json['id'],
      query: json['query'],
      count: json['count'],
      type: json['type'],
      typeString: json['type_string'],
    );
  }
}