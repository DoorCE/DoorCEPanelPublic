import 'package:doorce_panel/common/types/filter_modes.dart';
import 'package:doorce_panel/common/view_elements/door_dropdown.dart';
import 'package:doorce_panel/common/view_elements/parameterized_list_view/page_state.dart';
import 'package:doorce_panel/common/view_elements/style.dart';
import 'package:doorce_panel/common/view_elements/text.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class FilterOption {
  final String label;
  final dynamic value;
  FilterOption({required this.label, required this.value});
}

// TODO - extend stateful widget?
abstract class FilterDefinition<TModel, TValue extends Object> {
  final String fieldName;
  final String label;
  final dynamic Function(TModel model) filterTarget; // object field value to be filtered

  FilterDefinition({
    required this.fieldName,
    required this.label,
    required this.filterTarget,
  });

  Widget buildWidget(QueryParams params);

  bool apply(TModel model, QueryParams params);
}

class EnumFilter<TModel, TValue extends Object> implements FilterDefinition<TModel, TValue> {
  final String fieldName;
  final String label;
  final List<FilterOption> filterOptions;
  final dynamic Function (TModel model) filterTarget; // object field value to be filtered
  final bool modeOptionsEnabled;

  EnumFilter({
    required this.fieldName,
    required this.label,
    required this.filterOptions,
    required this.filterTarget,
    this.modeOptionsEnabled = false,
  });

  List<DropdownItem<TValue>> _buildDropdownItems(QueryParams params) {
    return filterOptions.map((v) 
      => DropdownItem<TValue>(
        label: v.label, 
        value: v.value as TValue,
        selected: params.filters[fieldName]?.value.contains(v.value) ?? false, //whether this option is selected in the filter pop-up
        )).toList();
  }

  List<DropdownItem<EnumFilterMode>> _buildFilterModeItems(
    BuildContext context,
    QueryParams params,
  ) {
    final selectedMode = params.filters[fieldName]?.mode ?? EnumFilterMode.or;

    return EnumFilterMode.values.map(
      (mode) => DropdownItem(
        label: mode.getText(context),
        value: mode,
        selected: mode.index == selectedMode.index,
      ),
    ).toList();
  }

  @override
  Widget buildWidget(QueryParams params) {
    final MultiSelectController<TValue> controller =
      MultiSelectController<TValue>();
    
    //EnumFilterMode? mode = params.filters[fieldName]?.mode ?? EnumFilterMode.or;

    return StatefulBuilder(
      builder: (context, setState) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            Flexible(
              flex: 1,
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                DoorText(label, DoorTextStyle.label),
                Row(
                    children: [
                    SizedBox(
                      width: 140,
                      child:
                      DoorMultiDropdown<EnumFilterMode>(
                        key: ValueKey(params.filters[fieldName]?.mode),
                        enabled: modeOptionsEnabled,
                        items: _buildFilterModeItems(context, params),
                        singleSelect: true,
                        onSelectionChange: (selectedOption) {
                          setState (() {
                            var mode = selectedOption.isNotEmpty ? selectedOption.first : null;
                            params.filters[fieldName] = (params.filters[fieldName] ?? const FilterState())
                              .copyWith(value: params.filters[fieldName]?.value ?? [], mode: mode);
                          });
                        },
                        validator: (selectedOption) {
                          if (controller.selectedItems.length > 0 && (selectedOption == null || selectedOption.isEmpty)) {
                            return AppLocalizations.of(context)!.fieldRequired;
                          }
                          return null;
                        },
                      ),),
                      SizedBox(width: 8,),
                      Expanded(child: 
                      DoorMultiDropdown<TValue>(
                        controller: controller,
                        items: _buildDropdownItems(params),
                        onSelectionChange: (selectedValues) {
                          setState(() {
                            params.filters[fieldName] =
                              (params.filters[fieldName] ?? const FilterState()).copyWith(value: selectedValues);
                          });
                        },
                      )),
                    ],
                  ),
                SizedBox(height: 12)
              ],
            ))
          ]
        );
      }
    );
  }

  @override
  bool apply(
    TModel item,
    QueryParams params,
  ) {
    final state = params.filters[fieldName];

    final List<dynamic>? query = state?.value ?? null;
    final mode = state?.mode ?? EnumFilterMode.or;

    if (query == null || query.isEmpty) {
      return true;
    }

    var fieldValue = filterTarget(item);
    if (fieldValue == null) return false;

    if (fieldValue is List) {
      if (mode == EnumFilterMode.and) {
        return query.every((v) => fieldValue.contains(v));
      }

      return fieldValue.any((v) => query.contains(v));
    }

    return query.contains(fieldValue);

    // TODO - toLowerCase?
  }
}

class BoolFilter<TModel, TValue extends Object> implements FilterDefinition<TModel, TValue> {
  final String fieldName;
  final String label;
  final Object? Function(TModel model) filterTarget; // object field value to be filtered

  BoolFilter({
    required this.fieldName,
    required this.label,
    required this.filterTarget,
  });

  @override
  Widget buildWidget(QueryParams params) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DoorText(label, DoorTextStyle.label),
            Checkbox(
              tristate: true,
              activeColor: DoorColor.darkEmph,
              value: params.filters[fieldName]?.value,
              onChanged: (value) {
                  setState(() {
                    params.filters[fieldName] = (params.filters[fieldName] ?? const FilterState()).copyWith(value: value);
                  });
                },
            ),
          ],
        );
      }
    );
  }

  @override
  bool apply(TModel item, QueryParams params) {
    final bool? query = params.filters[fieldName]?.value ?? null;

    if (query == null) {
      return true;
    }

    var fieldValue = filterTarget(item);

    return query == fieldValue;
  }
}

class FilterSet<T> {
  final List<FilterDefinition> filters;

  FilterSet(this.filters);

  bool apply(T item, QueryParams params) {
    return filters.every(
      (filter) => filter.apply(item, params),
    );
  }
}