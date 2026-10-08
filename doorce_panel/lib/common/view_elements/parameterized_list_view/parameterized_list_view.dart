import 'package:doorce_panel/common/view_elements/parameterized_list_view/filter_definitions.dart';
import 'package:doorce_panel/common/view_elements/parameterized_list_view/page_state.dart';
import 'package:doorce_panel/common/view_elements/style.dart';
import 'package:doorce_panel/common/view_elements/text.dart';
import 'package:doorce_panel/dtos/identifiable_element.dart';
import 'package:doorce_panel/dtos/user_account.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class ParameterizedListView<T> extends StatefulWidget {
  final ParameterizedListController<T> controller;
  final Widget Function(BuildContext, T, int) itemBuilder;
  final String? customNoItemsHint;

  const ParameterizedListView({
    super.key,
    required this.controller,
    required this.itemBuilder,
    this.customNoItemsHint
  });

  @override
  State<ParameterizedListView<T>> createState() =>
      _ParameterizedListViewState<T>();
}

class _ParameterizedListViewState<T>
    extends State<ParameterizedListView<T>> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController =
        TextEditingController(text: widget.controller.query);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final controller = widget.controller;
        final items = controller.currentItems;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                controller: _searchController,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: AppLocalizations.of(context)!.search,
                  border: const OutlineInputBorder(),
                  suffixIcon: controller.query.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            controller.setQuery('');
                          },
                        )
                      : null,
                ),
                onSubmitted: controller.setQuery,
              ),
            ),

            Expanded(
              child: items.isEmpty
                  ? Center(
                      child: Text(widget.customNoItemsHint ?? AppLocalizations.of(context)!.noItemsFound),
                    )
                  : ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (ctx, i) =>
                          widget.itemBuilder(ctx, items[i], i),
                    ),
            ),

            _PaginationBar(controller: controller),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class ParameterizedListController<T> extends ChangeNotifier {
  List<T> querySet;
  int pageSize;
  int currentPage = 0;
  FilterSet<T> filterSet;

  String query = '';
  QueryParams queryParams;

  late List<T> _filtered;

  static const int defaultPageSize = 25;

  ParameterizedListController({required this.querySet, required this.filterSet, required this.queryParams, this.pageSize = defaultPageSize}) {
    _filtered = List<T>.from(querySet);
  }

  bool _isSearchMatch(T item, String searchQuery) {
    
    List<String> queryTargets;
    if (item is XIdentifiableElement) {
      queryTargets = item.getSearchableFields();
    } else if (item is XUserAccount) {
      queryTargets = item.getSearchableFields();
    } else {
      throw Exception("Unsupported type: $T");
    }

    final query = searchQuery.trim().toLowerCase();

    if (query.isEmpty) {
      return true;
    }

    return queryTargets.map((e) => e.toLowerCase()).any((e) => e.contains(query));
  }

  bool _isFilterMatch(T item) {
    return filterSet.filters.every((filter) => filter.apply(item, queryParams));
  }

  void _apply() {
    _filtered = querySet.where((item) => _isSearchMatch(item, query) && _isFilterMatch(item)).toList();
    if (currentPage >= totalPages) currentPage = (totalPages - 1).clamp(0, totalPages);
    notifyListeners();
  }

  bool areFiltersApplied() {
  return queryParams.filters.isNotEmpty &&
    !queryParams.filters.values.every((v) =>
      v.value == null ||
      (v.value is String && v.value.isEmpty) ||
      (v.value is Iterable && v.value.isEmpty) ||
      (v.value is Map && v.value.isEmpty)
    );
}
  void setQuery(String q) {
    query = q.trim();
    currentPage = 0;
    _apply();
  }

  /// Update the underlying data and re-filter
  void updateQuerySet(List<T> newQuerySet) {
    querySet = newQuerySet;
    _apply();
  }

  void clearFilters() {
    setParams(QueryParams(filters: {}));
  }

  void setParams(QueryParams params) {
    queryParams = params;
    currentPage = params.page;
    _apply();
    Logger.root.fine("[ParameterizedListController<$T> setParams]: Applied query params: ${params.toJson()}");
    Logger.root.fine("areFiltersApplied: ${areFiltersApplied()}");
    Logger.root.fine("[ParameterizedListController<$T> setParams]: Current items: ${currentItems}");
  }

  int get totalItems => _filtered.length;
  int get totalPages => (totalItems / pageSize).ceil().clamp(1, 999999);
  List<T> get currentItems {
    final start = currentPage * pageSize;
    return _filtered.skip(start).take(pageSize).toList();
  }

  void nextPage() {
    if (currentPage < totalPages - 1) {
      currentPage++;
      notifyListeners();
    }
  }

  void prevPage() {
    if (currentPage > 0) {
      currentPage--;
      notifyListeners();
    }
  }

  void jumpToPage(int p) {
    currentPage = p.clamp(0, totalPages - 1);
    notifyListeners();
  }

  void refresh() => _apply();
}

class _PaginationBar extends StatelessWidget {
  final ParameterizedListController controller;

  const _PaginationBar({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final current = controller.currentPage;
    final totalPages = controller.totalPages;

    final visiblePages = _visiblePages(
      controller.currentPage,
      controller.totalPages,
    );

    return Container(
      padding: const EdgeInsets.all(12),
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 4,
        children: [
          DoorText(
            "${AppLocalizations.of(context)!.showing} "
            "${controller.totalItems == 0 ? 0 : current * controller.pageSize + 1}"
            "-"
            "${current * controller.pageSize + controller.currentItems.length}"
            " ${AppLocalizations.of(context)!.outOf} ${controller.totalItems}",
            DoorTextStyle.norm
          ),

          const SizedBox(width: 16),

          IconButton(
            icon: const Icon(Icons.first_page),
            onPressed:
                current > 0 ? () => controller.jumpToPage(0) : null,
          ),

          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: current > 0 ? controller.prevPage : null,
          ),

          for (final page in visiblePages)
            FilledButton.tonal(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(DoorColor.lightEmph)
              ),
              onPressed: page == controller.currentPage
                  ? null
                  : () => controller.jumpToPage(page),
              child: Text('${page + 1}'),
            ),

          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: current < totalPages - 1
                ? controller.nextPage
                : null,
          ),

          IconButton(
            icon: const Icon(Icons.last_page),
            onPressed: current < totalPages - 1
                ? () => controller.jumpToPage(totalPages - 1)
                : null,
          ),
        ],
      ),
    );
  }
}

List<int> _visiblePages(int currentPage, int totalPages) {
  if (totalPages <= 3) {
    return List.generate(totalPages, (i) => i);
  }

  if (currentPage <= 1) {
    return [0, 1, 2];
  }

  if (currentPage >= totalPages - 2) {
    return [
      totalPages - 3,
      totalPages - 2,
      totalPages - 1,
    ];
  }

  return [
    currentPage - 1,
    currentPage,
    currentPage + 1,
  ];
}