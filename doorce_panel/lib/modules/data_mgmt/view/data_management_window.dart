import 'package:doorce_panel/common/types/dataset_status.dart';
import 'package:doorce_panel/common/view_elements/button.dart';
import 'package:doorce_panel/common/view_elements/parameterized_list_view/filter_dialog.dart';
import 'package:doorce_panel/common/view_elements/parameterized_list_view/page_state.dart';
import 'package:doorce_panel/common/view_elements/parameterized_list_view/parameterized_list_view.dart';
import 'package:doorce_panel/common/view_elements/style.dart';
import 'package:doorce_panel/common/view_elements/text.dart';
import 'package:doorce_panel/dtos/dataset.dart';
import 'package:doorce_panel/dtos/dataset_series.dart';
import 'package:doorce_panel/modules/data_mgmt/view/controllers/c_data_management_window.dart';
import 'package:doorce_panel/modules/data_mgmt/view/viewmodel/m_data_management_window.dart';
import 'package:flutter/material.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';

class VDataManagementWindow extends StatefulWidget {
  final MDataManagementWindow _model;
  final CDataManagementWindow _cDataManagementWindow;
  const VDataManagementWindow(GlobalKey? key, this._cDataManagementWindow, this._model)
      : super(key: key);

  @override
  State<VDataManagementWindow> createState() => VDataManagementWindowState();
}

class VDataManagementWindowState extends State<VDataManagementWindow>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  late ParameterizedListController<XDataset> _datasetController;
  late ParameterizedListController<XDatasetSeries> _seriesController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void refresh() {
    setState(() {});
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
    // TODO - sync with page state in routing, now each controller has its local query params
    //widget._model.initPageState(context);

    _datasetController = widget._model.setController<XDataset>(context);
    _seriesController = widget._model.setController<XDatasetSeries>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 12, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBreadcrumb(context),
          const SizedBox(height: 25),
          TabBar(
            controller: _tabController,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blue,
            tabs: [
              Tab(text: AppLocalizations.of(context)!.datasets),
              Tab(text: AppLocalizations.of(context)!.datasetSeries),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                datasetsPage(context),
                datasetSeriesPage(context),
              ],
            ),
          ),
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
            onTap: () => widget._cDataManagementWindow.homeSelected(context),
            child: DoorText(AppLocalizations.of(context)!.mainMenu,
                DoorTextStyle.breadcrumbActive),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Icon(Icons.chevron_right, color: DoorColor.grey),
        ),
        DoorText(AppLocalizations.of(context)!.dataManagement,
            DoorTextStyle.breadcrumb),
      ],
    );
  }

  Widget datasetsPage(BuildContext context) {
    Widget rightButtons;

    return Column(
      spacing: 12,
      children: [
        Row(
          children: [
            const Spacer(),
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
                bool canPublishData = widget._model.canPublishData(dataset);
              rightButtons = Center(
                child: DoorButtonColumn([
                  (
                    AppLocalizations.of(context)!.openDataset,
                    Icons.remove_red_eye_sharp,
                    () => widget._cDataManagementWindow
                        .openDatasetContent(context, dataset.identifier),
                    true
                  ),
                  (
                    canPublishData ? AppLocalizations.of(context)!.publishData : AppLocalizations.of(context)!.publishMetadata,
                    Icons.publish,
                    () => widget._cDataManagementWindow.publishDatasetSelected(context, dataset),
                    widget._model.isDatasetUserMetadataEditor(dataset)
                  ),
                  (
                    AppLocalizations.of(context)!.unpublish,
                    Icons.unpublished,
                    () => widget._cDataManagementWindow
                        .unpublishDatasetSelected(context, dataset),
                    widget._model.isDatasetUserMetadataEditor(dataset)
                  ),
                ]),
              );
              return Column(
                children: [
                  Row(
                    spacing: 12,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    textDirection: TextDirection.ltr,
                    children: [
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: null == widget._model.getDatasetResourceIcon(dataset) ?
                            Image.asset("images/dataset.png") :
                            Image.memory(widget._model.getDatasetResourceIcon(dataset)!),
                      ),
                      Expanded(
                        child: Column(
                            spacing: 5,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              DoorText(
                                widget._model.getResourceTitle(context, dataset),
                                DoorTextStyle.main,
                              ),
                              DoorText(
                                widget._model.getDatasetAttributesSummary(context, dataset),
                                DoorTextStyle.emph,
                              ),
                              DoorText(
                                widget._model.getResourceDescription(context, dataset),
                                DoorTextStyle.norm,
                              )]
                              + widget._model.getDatasetSeriesTitles(context, dataset).map((m) => 
                              Chip(
                                backgroundColor: DoorColor.lightEmph,
                                side:
                                    const BorderSide(color: DoorColor.darkEmph),
                                elevation: 4,
                                label: DoorText(
                                  m,
                                  DoorTextStyle.emph,
                                ))
                              ).toList()
                          ),),
                          const Spacer(),
                      rightButtons,
                    ],
                  ),
                  const Divider(),
                ],
              );
            },
          ),
        )
      ],
    );
  }

  Widget datasetSeriesPage(BuildContext context) {
    Widget rightButtons;

    return Column(
      spacing: 12,
      children: [
        Row(
          children: [
            const Spacer(),
            DoorSimpleButtonIcon(
                AppLocalizations.of(context)!.filter,
                _seriesController.areFiltersApplied() ? Icons.filter_alt : Icons.filter_alt_outlined,
                () {
                  setFilters(_seriesController);
                }),
            const SizedBox(width: 50),
          ],
        ),
        Expanded(
        child: ParameterizedListView<XDatasetSeries>(
            controller: _seriesController,
            itemBuilder: (context, series, index) {

              rightButtons = Center(
                child: DoorButtonColumn([
                  (
                    AppLocalizations.of(context)!.openDatasetSeriesDetails,
                    Icons.remove_red_eye_sharp,
                    () => widget._cDataManagementWindow.openSeriesContent(context, series.identifier),
                    true
                  )
                ]),
              );

              return Column(
                children: [
                  Row(
                    spacing: 12,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    textDirection: TextDirection.ltr,
                    children: [
                      SizedBox(
                        width: 75,
                        height: 75,
                        child: null == widget._model.getSeriesResourceIcon(series) ?
                            Image.asset("images/data_series.png") :
                            Image.memory(widget._model.getSeriesResourceIcon(series)!),
                      ),
                        Column(
                          spacing: 5,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            DoorText(
                              widget._model.getResourceTitle(context, series),
                              DoorTextStyle.main,
                            ),
                            DoorText(
                              widget._model.getResourceDescription(context, series),
                              DoorTextStyle.emph,
                            ),
                          ],
                        ),
                      const Spacer(),
                      rightButtons,
                    ],
                  ),
                  const Divider(),
                ],
              );
            },
          ),
        )
      ],
    );
  }
}

class VDataManagementWindowFactory {
  const VDataManagementWindowFactory();
  VDataManagementWindow get(key, model) {
    return VDataManagementWindow(key, new CDataManagementWindow(model), model);
  }
}
