// ignore_for_file: constant_identifier_names

class SearchFilter {
  String? search;
  List<bool> sdgFilters;

  SearchFilter({required this.search, required this.sdgFilters});
}

List<String> searchToKeywords(String search) {
  if(search.isEmpty) return [];
  return search.toLowerCase().trim().split(" ");
}
