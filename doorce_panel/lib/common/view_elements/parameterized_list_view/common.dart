import 'package:doorce_panel/common/view_elements/parameterized_list_view/filter_definitions.dart';

class FilteringCommon {

  static List<FilterOption>? generateFilterOptionsFromMap (Map<String, dynamic> map) { // k is value, v is label
    map.removeWhere((k,v) => k.isEmpty);

    if (map.isEmpty) {
      return null;
    }

    return map.entries.map((entry) 
      => FilterOption(
        label: (entry.value == null || entry.value.isEmpty) ? entry.key : entry.value,
        value: entry.key)).toList();
  }

  static List<FilterOption>? generateFilterOptionsFromIterable(Iterable<String> iterable) {
    iterable = iterable.where((element) => element.isNotEmpty);

    if (iterable.isEmpty) {
      return null;
    }

    return iterable.map((element) 
      => FilterOption(
        label: element, 
        value: element)).toList();
  }
}