import 'package:doorce_panel/dtos/catalogued_resource.dart';

class XDataResource extends XCataloguedResource {
  List<String> geographicalCoverage = List<String>.empty(growable: true);
  String? frequency;
  List<(DateTime start, DateTime end)> temporalCoverage =
      List<(DateTime, DateTime)>.empty(growable: true);
  DateTime? releaseDate;

  XDataResource();
  XDataResource.forInsert() : super.forInsert();

  @override
  void fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    geographicalCoverage =
        List<String>.from(json['geographicalCoverage'] ?? []);
    frequency = json['frequency'] ?? "";
    temporalCoverage = (json['temporalCoverage'] as List<dynamic>?)
            ?.where((item) =>
                item is Map<String, dynamic> &&
                (item['item1'] != null || item['item2'] != null))
            .map((item) {
          final start =
              item['item1'] != null ? DateTime.parse(item['item1']) : null;
          final end = item['item2'] != null ? DateTime.parse(item['item2']) : null;
          return (start ?? DateTime(0), end ?? DateTime(0));
        }).toList() ??
        [];
    releaseDate = json['releaseDate'] != null
        ? DateTime.parse(json['releaseDate'])
        : null;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'geographicalCoverage': geographicalCoverage,
      'frequency': frequency,
      'temporalCoverage': temporalCoverage
          .map((item) => {'item1': item.$1.toIso8601String(), 'item2': item.$2.toIso8601String()})
          .toList(),
      'releaseDate': releaseDate?.toIso8601String(),
    };
  }
}
