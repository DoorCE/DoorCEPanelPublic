import 'package:doorce_panel/common/types/dataset_status.dart';
import 'package:doorce_panel/common/view_elements/button.dart';
import 'package:doorce_panel/common/view_elements/parameterized_list_view/filter_dialog.dart';
import 'package:doorce_panel/common/view_elements/parameterized_list_view/page_state.dart';
import 'package:doorce_panel/common/view_elements/parameterized_list_view/parameterized_list_view.dart';
import 'package:doorce_panel/common/view_elements/style.dart';
import 'package:doorce_panel/common/view_elements/text.dart';
import 'package:doorce_panel/dtos/catalogue.dart';
import 'package:doorce_panel/dtos/dataset.dart';
import 'package:doorce_panel/dtos/dataset_series.dart';
import 'package:doorce_panel/dtos/dataset_service.dart';
import 'package:doorce_panel/modules/metadata_mgmt/view/controllers/c_catalogues_window.dart';
import 'package:doorce_panel/modules/metadata_mgmt/view/viewmodel/m_catalogues_window.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class VCataloguesWindow extends StatefulWidget {
  final MCataloguesWindow _model;
  final CCataloguesWindow _cCataloguesWindow;
  const VCataloguesWindow(GlobalKey? key, this._cCataloguesWindow, this._model)
      : super(key: key);
  
  @override
  State<VCataloguesWindow> createState() => VCataloguesWindowState();
}

class VCataloguesWindowState extends State<VCataloguesWindow>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late String selectedOption = "Catalogue";

  late ParameterizedListController<XCatalogue> _catController;
  late ParameterizedListController<XDataset> _datasetController;
  late ParameterizedListController<XDatasetSeries> _seriesController;
  late ParameterizedListController<XDatasetService> _serviceController;

  void refresh() {
    setState(() {
    // Sync controllers with updated model data
    _catController.updateQuerySet(widget._model.catalogResources as List<XCatalogue>);
    _datasetController.updateQuerySet(widget._model.datasetsResources as List<XDataset>);
    _seriesController.updateQuerySet(widget._model.seriesResources as List<XDatasetSeries>);
    _serviceController.updateQuerySet(widget._model.servicesResources as List<XDatasetService>);
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
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    if (widget._model.catalogResources.isEmpty) {
      selectedOption = "DataResources";
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // TODO - sync with page state in routing, now each controller has its local query params
    //widget._model.initPageState(context);

    _catController = widget._model.setController<XCatalogue>(context);
    _datasetController = widget._model.setController<XDataset>(context);
    _seriesController = widget._model.setController<XDatasetSeries>(context);
    _serviceController = widget._model.setController<XDatasetService>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 12, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBreadcrumb(context),
          _buildTransitionButtons(),
          if (selectedOption == "Catalogue")
            cataloguesPage(context)
          else
            dataResourcesPage(context),
        ],
      ),
    );
  }

  Widget _buildBreadcrumb(BuildContext context) {
    List<Widget> breadcrumbs = [
      MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => widget._cCataloguesWindow.homeSelected(context),
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
      MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () =>
              widget._cCataloguesWindow.showCataloguesSelected(context, ""),
          child: DoorText(AppLocalizations.of(context)!.mainCatalog,
              DoorTextStyle.breadcrumbActive),
        ),
      ),
    ];

    String? parentID = widget._model.getParentCatalogIdentifier();
    String? parentTitle = widget._model.getParentCatalogTitle(context);

    if (null != parentID && parentID.isNotEmpty) {
      breadcrumbs.add(const Padding(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Icon(Icons.chevron_right, color: DoorColor.grey),
      ));

      breadcrumbs.add(
        Flexible(child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => widget._cCataloguesWindow
                .showCataloguesSelected(context, parentID),
            child: DoorText(
              parentTitle,
              DoorTextStyle.breadcrumbActive,
            ),
          ),
        ),
      ));
    }
    breadcrumbs.add(const Padding(
      padding: EdgeInsets.symmetric(horizontal: 5),
      child: Icon(Icons.chevron_right, color: DoorColor.grey),
    ));

    breadcrumbs.add(Flexible(child: DoorText(
      widget._model.getCurrentCatalogTitle(context),
      DoorTextStyle.breadcrumb,
    )));

    return Row(children: breadcrumbs);
  }

  Widget _buildTransitionButtons() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DoorButtonCard(
            AppLocalizations.of(context)!.catalogue,
            () => {
              setState(() {
                selectedOption = "Catalogue";
              })
            },
            "left",
            selectedOption == "Catalogue", // isSelected
          ),
          DoorButtonCard(
              AppLocalizations.of(context)!.dataResources,
              () => {
                    setState(() {
                      selectedOption = "DataResources";
                    })
                  },
              "right",
              selectedOption == "DataResources" // isSelected
              ),
        ],
      ),
    );
  }

  Widget cataloguesPage(BuildContext context) {
    Widget rightButtons;

    return Expanded(
      child: Column(
        spacing: 12,
        children: [
          Row(
            children: [
              DoorText(
                AppLocalizations.of(context)!.catalogue,
                DoorTextStyle.titleBlack,
              ),
              const Spacer(),
              DoorSimpleButtonIcon(
                  AppLocalizations.of(context)!.addNewCatalogue,
                  Icons.add_circle_outlined,
                  () => widget._cCataloguesWindow
                      .upsertCatalogueSelected(context, "", widget._model.getParentCatalogIdentifier()),
                  enabled: widget._model.isUserMetadataEditor()),
              DoorSimpleButtonIcon(
                AppLocalizations.of(context)!.filter,
                _catController.areFiltersApplied() ? Icons.filter_alt : Icons.filter_alt_outlined,
                () {
                  setFilters(_catController);
                }),
              const SizedBox(width: 50),
            ],
          ),
          Expanded(
            child: ParameterizedListView<XCatalogue>(
              customNoItemsHint: AppLocalizations.of(context)!.noItemsFoundForCatalogues,
              controller: _catController,
              itemBuilder: (context, catalogue, index) {
                rightButtons = Center(
                  child: DoorButtonColumn([
                    (
                      AppLocalizations.of(context)!.openCatalog,
                      Icons.folder,
                      () => widget._cCataloguesWindow
                          .showCataloguesSelected(context, catalogue.identifier),
                      true
                    ),
                    (
                      AppLocalizations.of(context)!.previewCatalogue,
                      Icons.remove_red_eye_sharp,
                      () => widget._cCataloguesWindow
                          .previewCatalogueSelected(context, catalogue.identifier),
                      true
                    ),
                    (
                      AppLocalizations.of(context)!.editCatalog,
                      Icons.edit,
                      () => widget._cCataloguesWindow.upsertCatalogueSelected(context, catalogue.identifier),
                      widget._model.isCatalogueEditable(catalogue)
                    ),
                    (
                      AppLocalizations.of(context)!.deleteCatalog,
                      Icons.delete_forever,
                      () => widget._cCataloguesWindow
                          .deleteCatalogueSelected(context, catalogue.identifier),
                      widget._model.isCatalogueDeletable(catalogue)
                    )
                  ]),
                );
                // var prova = widget._model.getCat("doorce/root");
                return Column(
                  children: [
                    Row(
                      spacing: 12,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      textDirection: TextDirection.ltr,
                      children: [
                        SizedBox(
                          width: 100,
                          height: 100,
                          child: null == widget._model.getCatalogResourceIcon(catalogue) ?
                            Image.asset("images/catalogue.png") :
                            Image.memory(widget._model.getCatalogResourceIcon(catalogue)!)
                        ),
                        Expanded(
                          child: Column(
                            spacing: 12,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              DoorText(
                                widget._model.getResourceTitle(context, catalogue),
                                DoorTextStyle.main,
                              ),
                              DoorText(
                                widget._model.getResourceDescription(context, catalogue),
                                DoorTextStyle.norm,
                              ),
                            ],
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

  Widget dataResourcesPage(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          const SizedBox(height: 20),
          Row( children: [DoorText(
              AppLocalizations.of(context)!.dataResources,
              DoorTextStyle.titleBlack,
           )]),
          const SizedBox(height: 10),
          TabBar(
            controller: _tabController,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.blue,
            tabs: [
              Tab(text: AppLocalizations.of(context)!.datasets),
              Tab(text: AppLocalizations.of(context)!.datasetSeries),
              Tab(text: AppLocalizations.of(context)!.datasetServices),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                datasetsPage(context),
                datasetSeriesPage(context),
                datsetServicesPage(context),
              ],
            ),
          ),
        ],
      ),
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
                  AppLocalizations.of(context)!.addNewDataset,
                  Icons.add_circle_outlined,
                  () => widget._cCataloguesWindow
                    .upsertDatasetSelected(context, "", widget._model.getCurrentCatalogIdentifier()),
                  enabled: widget._model.isUserMetadataEditor()),
              DoorSimpleButtonIcon(AppLocalizations.of(context)!.filter,
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
                rightButtons = Center(
                  child: DoorButtonColumn([
                    (
                      AppLocalizations.of(context)!.previewDataset,
                      Icons.remove_red_eye_sharp,
                      () => widget._cCataloguesWindow.previewDatasetSelected(context, dataset.identifier),
                      true
                    ),
                    (
                      AppLocalizations.of(context)!.editDataset,
                      Icons.edit,
                      () => widget._cCataloguesWindow.upsertDatasetSelected(context, dataset.identifier),
                      widget._model.isDatasetEditable(dataset)
                    ),
                    (
                      AppLocalizations.of(context)!.publishMetadata,
                      Icons.publish,
                      () => widget._cCataloguesWindow.publishDatasetMetadataSelected(context, dataset),
                      widget._model.isDatasetPublishable(dataset)
                    ),
                    (
                      AppLocalizations.of(context)!.publishData,
                      Icons.publish,
                      () => widget._cCataloguesWindow.publishDatasetDataSelected(context, dataset),
                      widget._model.isDatasetPublishable(dataset) && dataset.status != DatasetStatus.independent
                    ),
                    (
                      AppLocalizations.of(context)!.unpublish,
                      Icons.unpublished,
                      () => widget._cCataloguesWindow.unpublishDatasetSelected(context, dataset),
                      widget._model.isDatasetPublishable(dataset)
                    ),
                    (
                      AppLocalizations.of(context)!.deleteDataset,
                      Icons.delete_forever,
                      () => widget._cCataloguesWindow.deleteDatasetSelected(context, dataset),
                      widget._model.isDatasetDeletable(dataset)
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
                          width: 100,
                          height: 100,
                          child: null == dataset.icon ?
                            Image.asset("images/dataset.png") :
                            Image.memory(dataset.icon!)
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
                              ),
                              Row(
                                spacing: 6,
                                children: widget._model.getDatasetSeriesTitles(context, dataset).map((m) => Flexible(child: Chip(
                                  backgroundColor: DoorColor.lightEmph,
                                  side:
                                    const BorderSide(color: DoorColor.darkEmph),
                                  elevation: 4,
                                  label: DoorText(
                                    m,
                                    DoorTextStyle.emph,
                                  )))
                                ).toList()
                              )
                              ]
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
                  AppLocalizations.of(context)!.addNewSeries,
                  Icons.add_circle_outlined,
                  () => widget._cCataloguesWindow
                    .upsertDatasetSeriesSelected(context, "", widget._model.getCurrentCatalogIdentifier()),
                  enabled: widget._model.isUserMetadataEditor(),),
              DoorSimpleButtonIcon(AppLocalizations.of(context)!.filter,
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
                      AppLocalizations.of(context)!.openSeries,
                      Icons.folder,
                      () => widget._cCataloguesWindow.openSeriesContent(context, series.identifier),
                      true
                    ),
                    (
                      AppLocalizations.of(context)!.previewSeries,
                      Icons.remove_red_eye_sharp,
                      () => widget._cCataloguesWindow.previewSeriesSelected(context, series.identifier),
                      true
                    ),
                    (
                      AppLocalizations.of(context)!.editSeries,
                      Icons.edit,
                      () => widget._cCataloguesWindow.upsertDatasetSeriesSelected(context, series.identifier),
                      widget._model.isSeriesEditable(series)
                    ),
                    (
                      AppLocalizations.of(context)!.deleteSeries,
                      Icons.delete_forever,
                      () => widget._cCataloguesWindow.deleteDatasetSeriesSelected(context, series.identifier),
                      widget._model.isSeriesDeletable(series)
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
                            Image.memory(widget._model.getSeriesResourceIcon(series)!)
                        ),
                        Expanded(
                          child: Column(
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
    );
  }

  Widget datsetServicesPage(BuildContext context) {
    Widget rightButtons;

    return Column(
        spacing: 12,
        children: [
          Row(
            children: [
              const Spacer(),
              DoorSimpleButtonIcon(
                  AppLocalizations.of(context)!.addNewService,
                  Icons.add_circle_outlined,
                  () => widget._cCataloguesWindow
                      .upsertDatasetServicesSelected(context, "", widget._model.getCurrentCatalogIdentifier()),
                  enabled: widget._model.isUserMetadataEditor(),),
              DoorSimpleButtonIcon(AppLocalizations.of(context)!.filter,
                _serviceController.areFiltersApplied() ? Icons.filter_alt : Icons.filter_alt_outlined,
                () {
                  setFilters(_serviceController);
                }),
              const SizedBox(width: 50),
            ],
          ),
          Expanded(
            child: ParameterizedListView<XDatasetService>(
              controller: _serviceController,
              itemBuilder: (context, service, index) {
                rightButtons = Center(
                  child: DoorButtonColumn([
                    (
                      AppLocalizations.of(context)!.openService,
                      Icons.folder,
                      () => widget._cCataloguesWindow.openServicesContent(context, service.identifier),
                      true
                    ),
                    (
                      AppLocalizations.of(context)!.previewService,
                      Icons.remove_red_eye_sharp,
                      () => widget._cCataloguesWindow.previewServiceSelected(context, service.identifier),
                      true
                    ),
                    (
                      AppLocalizations.of(context)!.editService,
                      Icons.edit,
                      () => widget._cCataloguesWindow.upsertDatasetServicesSelected(context, service.identifier),
                      widget._model.isServiceEditable(service)
                    ),
                    (
                      AppLocalizations.of(context)!.deleteService,
                      Icons.delete_forever,
                      () => widget._cCataloguesWindow.deleteDataServiceSelected(context, service.identifier),
                      widget._model.isServiceDeletable(service)
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
                          child: null == widget._model.getServicesResourceIcon(service) ?
                            Image.asset("images/service.png") :
                            Image.memory(widget._model.getServicesResourceIcon(service)!)
                        ),
                        Expanded(
                          child: Column(
                            spacing: 5,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              DoorText(
                                widget._model.getResourceTitle(context, service),
                                DoorTextStyle.main,
                              ),
                              DoorText(
                                widget._model.getResourceDescription(context, service),
                                DoorTextStyle.emph,
                              ),
                            ],
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
    );
  }
}

class VCataloguesWindowFactory {
  const VCataloguesWindowFactory();
  VCataloguesWindow get(key, model) {
    return VCataloguesWindow(key, new CCataloguesWindow(model), model);
  } 
}
