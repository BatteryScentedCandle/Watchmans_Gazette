// ignore_for_file: constant_identifier_names

class SearchFilter {
  String? search;
  List<bool> sdgFilters;

  SearchFilter({required this.search, required this.sdgFilters});

  bool isDefault() {
    return noSDG() && search == null;
  }

  bool noSDG() {
    bool hasOne = false;
    for (var on in sdgFilters) {
      if (on) {
        hasOne = true;
      }
    }
    return !hasOne;
  }
}

List<String> searchToKeywords(String search) {
  if (search.isEmpty) return [];
  return search.toLowerCase().trim().split(" ");
}
