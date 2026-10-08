import 'package:doorce_panel/common/view_elements/button.dart';
import 'package:doorce_panel/common/view_elements/parameterized_list_view/filter_dialog.dart';
import 'package:doorce_panel/common/view_elements/parameterized_list_view/page_state.dart';
import 'package:doorce_panel/common/view_elements/parameterized_list_view/parameterized_list_view.dart';
import 'package:doorce_panel/common/view_elements/style.dart';
import 'package:doorce_panel/common/view_elements/text.dart';
import 'package:doorce_panel/dtos/dataset.dart';
import 'package:doorce_panel/modules/metadata_mgmt/view/controllers/c_open_series_window.dart';
import 'package:doorce_panel/modules/metadata_mgmt/view/viewmodel/m_open_series_window.dart';
import 'package:flutter/material.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';

class VOpenSeriesWindow extends StatefulWidget {
  final MOpenSeriesWindow model;
  final COpenSeriesWindow controller;

  const VOpenSeriesWindow(
    this.controller,
    this.model, {
    super.key,
  });

  @override
  State<VOpenSeriesWindow> createState() => _VOpenSeriesWindowState();
}

class _VOpenSeriesWindowState extends State<VOpenSeriesWindow> {
  late final ParameterizedListController<XDataset> _datasetController;

  void refresh() {
    setState(() {
    });
  }

  void setFilters(ParameterizedListController controller) async {
    QueryParams? result = await showFilterDialog(context, controller.filterSet,
      controller.queryParams);
    if (result != null) {
      controller.setParams(result);
      refresh();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Runs only once
    _datasetController =
        widget.model.setController(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 12, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBreadcrumb(context),
          _seriesContentPage(context),
        ],
      ),
    );
  }

  Widget _buildBreadcrumb(BuildContext context) {
    return Row(
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => widget.controller.homeSelected(context),
            child: DoorText(
              AppLocalizations.of(context)!.mainMenu,
              DoorTextStyle.breadcrumbActive,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Icon(Icons.chevron_right, color: DoorColor.grey),
        ),
        Flexible(
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () =>
                  widget.controller.showCataloguesSelected(context, ""),
              child: DoorText(
                AppLocalizations.of(context)!.cataloguing,
                DoorTextStyle.breadcrumbActive,
              ),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Icon(Icons.chevron_right, color: DoorColor.grey),
        ),
        Flexible(
          child: DoorText(
            widget.model.getSeriesTitle(context),
            DoorTextStyle.breadcrumb,
          ),
        ),
      ],
    );
  }

  Widget _seriesContentPage(BuildContext context) {
    return Expanded(
      child: Column(
        spacing: 12,
        children: [
          Row(
            children: [
              const Spacer(),
              DoorSimpleButtonIcon(
                AppLocalizations.of(context)!.addNewDataset,
                Icons.add_circle_outlined,
                () => widget.controller.upsertDatasetSelected(context, ""),
              ),
              DoorSimpleButtonIcon(
                AppLocalizations.of(context)!.filter,
                _datasetController.areFiltersApplied() ? Icons.filter_alt : Icons.filter_alt_outlined,
                () {
                  setFilters(_datasetController);
                }),
              const SizedBox(width: 50),
            ],
          ),
          Expanded(
            child: ParameterizedListView<XDataset>(
              controller: _datasetController,
              itemBuilder: (context, dataset, index) {

                final rightButtons = Center(
                  child: DoorButtonColumn([
                    (
                      AppLocalizations.of(context)!.editDataset,
                      Icons.edit,
                      () => widget.controller
                          .upsertDatasetSelected(context, dataset.identifier),
                      widget.model.isDatasetEditable(dataset),
                    ),
                  ]),
                );

                return Column(
                  children: [
                    Row(
                      spacing: 12,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 100,
                          height: 100,
                          child:
                              widget.model.getDatasetResourceIcon(dataset) == null
                                  ? Image.asset("images/dataset.png")
                                  : Image.memory(
                                      widget.model
                                          .getDatasetResourceIcon(dataset)!,
                                    ),
                        ),
                        Expanded(
                          child: Column(
                            spacing: 5,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                                  DoorText(
                                    widget.model.getDatasetResourceTitle(
                                        context, dataset),
                                    DoorTextStyle.main,
                                  ),
                                  DoorText(
                                    widget.model
                                        .getDatasetResourceDescription(
                                            context, dataset),
                                    DoorTextStyle.emph,
                                  ),
                                  DoorText(
                                    widget.model.getDatasetResourceParams(
                                        context, dataset),
                                    DoorTextStyle.norm,
                                  ),
                                ] +
                                widget.model
                                    .getDatasetResourceSeries(context, dataset)
                                    .map(
                                      (m) => Chip(
                                        backgroundColor:
                                            DoorColor.lightEmph,
                                        side: const BorderSide(
                                          color: DoorColor.darkEmph,
                                        ),
                                        elevation: 4,
                                        label: DoorText(
                                          m,
                                          DoorTextStyle.emph,
                                        ),
                                      ),
                                    )
                                    .toList(),
                          ),
                        ),
                        rightButtons,
                      ],
                    ),
                    const Divider(),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class VOpenSeriesWindowFactory {
  const VOpenSeriesWindowFactory();

  VOpenSeriesWindow get(model) =>
      VOpenSeriesWindow(COpenSeriesWindow(model), model);
}