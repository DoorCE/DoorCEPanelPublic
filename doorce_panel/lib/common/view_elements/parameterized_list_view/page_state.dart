import 'package:doorce_panel/common/types/filter_modes.dart';
import 'package:doorce_panel/dtos/app.dart';
import 'package:doorce_panel/dtos/app_template.dart';
import 'package:doorce_panel/dtos/catalogue.dart';
import 'package:doorce_panel/dtos/data_schema.dart';
import 'package:doorce_panel/dtos/dataset.dart';
import 'package:doorce_panel/dtos/dataset_series.dart';
import 'package:doorce_panel/dtos/dataset_service.dart';
import 'package:doorce_panel/dtos/organization.dart';
import 'package:doorce_panel/dtos/person.dart';
import 'package:doorce_panel/dtos/schema_series.dart';
import 'package:doorce_panel/dtos/user_account.dart';
import 'package:flutter/foundation.dart';

// Immutable class to be stored in navigation
class PageState {
  final Map<Type, QueryParams> queryParams; // unmodifiable

  PageState(Map<Type, QueryParams> params)
      : queryParams = Map.unmodifiable(Map<Type, QueryParams>.from(params));

  PageState.metadata()
      : this.fromTypes([XCatalogue, XDataset, XDatasetSeries, XDatasetService]);
  PageState.agents()
      : this.fromTypes([XPerson, XUserAccount, XOrganization]);
  PageState.data()
      : this.fromTypes([XDataset, XDatasetSeries]);
  PageState.schemas()
      : this.fromTypes([XDataSchema, XSchemaSeries, XApp, XAppTemplate]);

  PageState.fromTypes(List<Type> types)
      : queryParams = Map.unmodifiable({
          for (final t in types) t: QueryParams(filters: {}),
        });

  QueryParams? getByType<T>() => queryParams[T];

  // helper to produce an updated PageState with a new QueryParams for a type
  PageState withUpdated(Type type, QueryParams params) {
    final newMap = Map<Type, QueryParams>.from(queryParams);
    newMap[type] = params;
    return PageState(newMap);
  }

  PageState copy() => PageState(Map<Type, QueryParams>.from(queryParams));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PageState) return false;
    if (queryParams.length != other.queryParams.length) return false;
    for (final entry in queryParams.entries) {
      final otherVal = other.queryParams[entry.key];
      if (otherVal == null || entry.value != otherVal) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hashAll(queryParams.entries.map((e) => Object.hash(e.key, e.value)));
}

// TODO - Immutable class to avoid accidental changes to state in navigation
class QueryParams {
  final int page;
  final String? searchQuery;
  final Map<String, FilterState> filters;

  QueryParams.draft({
    required this.filters,
    this.page = 0,
    this.searchQuery,
  });

  QueryParams({
    required Map<String, FilterState> filters,
    this.page = 0,
    this.searchQuery,
  }) : filters = _deepUnmodifiable(filters);

  // make lists/maps inside filters unmodifiable, then freeze the map
  static Map<String, FilterState> _deepUnmodifiable(Map<String, FilterState> src) {
    final out = <String, dynamic>{};
    src.forEach((k, v) {
      if (v.value is List) {
        out[k] = FilterState(mode:v.mode, value:List.unmodifiable(v.value));
      } else if (v.value is Map<String, dynamic>) {
        out[k] = FilterState(mode: v.mode, value: Map.unmodifiable(v.value));
      } else {
        out[k] = FilterState(mode: v.mode, value: v.value);
      }
    });
    return Map.unmodifiable(out);
  }

  QueryParams copyWith({
    int? page,
    String? searchQuery,
    Map<String, FilterState>? filters,
    }) {
      return QueryParams(
        page: page ?? this.page,
        searchQuery: searchQuery ?? this.searchQuery,
        filters: filters ?? this.filters,
      );
  }

  QueryParams copy() => copyWith();

  Map<String, dynamic> toJson() => {
    'page': page,
    'searchQuery': searchQuery,
    'filters': filters.map(
      (k, v) => MapEntry(k, {
        'value': v.value,
        'mode': v.mode.name,
      }),
    ),
  };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! QueryParams) return false;

    return page == other.page &&
        searchQuery == other.searchQuery &&
        mapEquals(filters, other.filters);
  }

  @override
  int get hashCode =>
      Object.hash(
        page,
        searchQuery,
        Object.hashAll(
          filters.entries.map((e) => Object.hash(e.key, e.value)),
        ),
      );
}

class FilterState {
  final dynamic value;
  final EnumFilterMode mode;

  const FilterState({
    this.value,
    this.mode = EnumFilterMode.or,
  });

  FilterState copyWith({
    dynamic value,
    EnumFilterMode? mode,
  }) {
    return FilterState(
      value: value ?? this.value,
      mode: mode ?? this.mode,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! FilterState) return false;

    final a = value;
    final b = other.value;

    final valuesEqual = switch ((a, b)) {
      (Iterable _, Iterable _) => listEquals(a.toList(), b.toList()),
      _ => a == b,
    };

    return valuesEqual && mode == other.mode;
  }

  @override
  int get hashCode =>
      Object.hash(
        mode,
        value is Iterable
            ? Object.hashAll((value as Iterable))
            : value,
      );
}