import 'package:doorce_panel/common/view_elements/button.dart';
import 'package:doorce_panel/common/view_elements/parameterized_list_view/filter_dialog.dart';
import 'package:doorce_panel/common/view_elements/parameterized_list_view/page_state.dart';
import 'package:doorce_panel/common/view_elements/parameterized_list_view/parameterized_list_view.dart';
import 'package:doorce_panel/common/view_elements/style.dart';
import 'package:doorce_panel/common/view_elements/text.dart';
import 'package:doorce_panel/dtos/app.dart';
import 'package:doorce_panel/dtos/app_template.dart';
import 'package:doorce_panel/dtos/data_schema.dart';
import 'package:doorce_panel/dtos/schema_series.dart';
import 'package:doorce_panel/modules/schema_mgmt/view/controllers/c_schema_management_window.dart';
import 'package:doorce_panel/modules/schema_mgmt/view/viewmodel/m_schema_management_window.dart';

import 'package:flutter/material.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';

class VSchemaManagementWindow extends StatefulWidget {
  final MSchemaManagementWindow _model;
  final CSchemaManagementWindow _cSchemaManagementWindow;
  const VSchemaManagementWindow(GlobalKey? key, this._cSchemaManagementWindow, this._model)
      : super(key: key);

  @override
  State<VSchemaManagementWindow> createState() => VSchemaManagementWindowState();
}

class VSchemaManagementWindowState extends State<VSchemaManagementWindow>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String selectedResource = "schemas";

  late ParameterizedListController<XDataSchema> _schemaController;
  late ParameterizedListController<XSchemaSeries> _seriesController;
  late ParameterizedListController<XApp> _appController;
  late ParameterizedListController<XAppTemplate> _templateController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void refresh() {
    setState(() {
    // Sync controllers with updated model data
    _appController.updateQuerySet(widget._model.apps);
    _schemaController.updateQuerySet(widget._model.schemaResources);
    _seriesController.updateQuerySet(widget._model.seriesResources);
    _templateController.updateQuerySet(widget._model.appTemplates);
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
    // TODO - sync with page state in routing, now each controller has its local query params
    //widget._model.initPageState(context);

    _schemaController = widget._model.setController<XDataSchema>(context);
    _seriesController = widget._model.setController<XSchemaSeries>(context);
    _appController = widget._model.setController<XApp>(context);
    _templateController = widget._model.setController<XAppTemplate>(context);
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
              Tab(text: AppLocalizations.of(context)!.schemas),
              Tab(text: AppLocalizations.of(context)!.series),
              Tab(text: "${AppLocalizations.of(context)!.appTemplates} (beta)"),
              Tab(text: "${AppLocalizations.of(context)!.apps} (beta)"),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                schemasPage(context),
                seriesPage(context),
                templatePage(context),
                appPage(context)
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
            onTap: () => widget._cSchemaManagementWindow.homeSelected(context),
            child: DoorText(AppLocalizations.of(context)!.mainMenu,
                DoorTextStyle.breadcrumbActive),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Icon(Icons.chevron_right, color: DoorColor.grey),
        ),
        DoorText(AppLocalizations.of(context)!.schemaManagement,
            DoorTextStyle.breadcrumb),
      ],
    );
  }

  Widget schemasPage(BuildContext context) {
    Widget rightButtons;

    return Column(
      spacing: 12,
      children: [
        Row(
          children: [
            const Spacer(),
            DoorSimpleButtonIcon(
                  widget._model.isAnySeriesMetadataEditable() 
                    ? AppLocalizations.of(context)!.addSchema
                    : AppLocalizations.of(context)!.noSeriesPrivileges,
                  Icons.add_circle_outlined,
                  () => widget._cSchemaManagementWindow
                      .upsertSchemaSelected(context, ""),
                  enabled: widget._model.isAnySeriesMetadataEditable()),
            DoorSimpleButtonIcon(
                AppLocalizations.of(context)!.filter,
                _schemaController.areFiltersApplied() ? Icons.filter_alt : Icons.filter_alt_outlined,
                () {
                  setFilters(_schemaController);
                }),
            const SizedBox(width: 50),
          ],
        ),
        Expanded(
          child: ParameterizedListView<XDataSchema>(
              controller: _schemaController,
              itemBuilder: (context, schema, index) {

              rightButtons = Center(
                child: DoorButtonColumn([
                  (
                    AppLocalizations.of(context)!.openSchema, // TODO - 'preview'
                    Icons.remove_red_eye_sharp,
                    () => widget._cSchemaManagementWindow.previewSchemaSelected(context, schema.identifier),
                    true
                  ),
                  (
                    AppLocalizations.of(context)!.editSchema,
                    Icons.edit,
                    () => widget._cSchemaManagementWindow.upsertSchemaSelected(context, schema.identifier),
                    widget._model.isSchemaEditable(schema)
                  ),
                  (
                    AppLocalizations.of(context)!.deleteSchema,
                    Icons.delete,
                    () => widget._cSchemaManagementWindow
                        .deleteDataSchemaSelected(context, schema.identifier),
                    widget._model.isSchemaEditable(schema)
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
                        child: Image.asset("images/schema.png"),
                      ),
                      Expanded(
                        child: Column(
                            spacing: 5,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              DoorText(
                                schema.title,
                                DoorTextStyle.main,
                              ),
                              DoorText(
                                schema.description,
                                DoorTextStyle.emph,
                              ),
                              Chip(
                                backgroundColor: DoorColor.lightEmph,
                                side:
                                    const BorderSide(color: DoorColor.darkEmph),
                                elevation: 4,
                                label: DoorText(
                                  schema.seriesTitle ?? AppLocalizations.of(context)!.noSeries,
                                  DoorTextStyle.emph,
                                )
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

  Widget seriesPage(BuildContext context) {
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
              () => widget._cSchemaManagementWindow
                .upsertSchemaSeriesSelected(context, ""),
              enabled: widget._model.canAddSeries()),
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
          child: ParameterizedListView<XSchemaSeries>(
              controller: _seriesController,
              itemBuilder: (context, series, index) {

              rightButtons = Center(
                child: DoorButtonColumn([
                  (
                    AppLocalizations.of(context)!.previewSeries,
                    Icons.remove_red_eye_sharp,
                    () => widget._cSchemaManagementWindow.previewSchemaSeriesSelected(context, series.identifier),
                    true
                  ),
                  (
                    AppLocalizations.of(context)!.editSeries,
                    Icons.edit,
                    () => widget._cSchemaManagementWindow.upsertSchemaSeriesSelected(context, series.identifier),
                    widget._model.isSeriesEditable(series)
                  ),
                  (
                    AppLocalizations.of(context)!.deleteSchemaSeries,
                    Icons.delete,
                    () => widget._cSchemaManagementWindow
                        .deleteSchemaSeriesSelected(context, series.identifier),
                    widget._model.isSeriesDeletable(series)
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
                        width: 75,
                        height: 75,
                        child: Image.asset("images/schema_series.png"),
                      ),
                      Expanded(
                        child: Column(
                          spacing: 5,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            DoorText(
                              series.title,
                              DoorTextStyle.main,
                            ),
                            DoorText(
                              series.description,
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

  Widget appPage(BuildContext context) {
    Widget rightButtons;
    Widget rightToggles;

    return Column(
      spacing: 12,
      children: [
        Row(
          children: [
            const Spacer(),
            DoorSimpleButtonIcon(
              AppLocalizations.of(context)!.refreshAppStatuses,
              Icons.refresh, 
              () => widget._cSchemaManagementWindow.refreshAppStatuses(context)
            ),
            DoorSimpleButtonIcon(
                  AppLocalizations.of(context)!.addNewApp,
                  Icons.add_circle_outlined,
                  () => widget._cSchemaManagementWindow
                      .upsertAppSelected(context, ""),
                  enabled: widget._model.canUserInsertApps()),
            DoorSimpleButtonIcon(
                AppLocalizations.of(context)!.filter,
                _appController.areFiltersApplied() ? Icons.filter_alt : Icons.filter_alt_outlined,
                () {
                  setFilters(_appController);
                }),
            const SizedBox(width: 50),
          ],
        ),
        Expanded(
          child: ParameterizedListView<XApp>(
              controller: _appController,
              itemBuilder: (context, app, index) {

              rightButtons = Center(
                child: DoorButtonColumn([
                  (
                    AppLocalizations.of(context)!.showAppDetails, // TODO - change text to 'preview'
                    Icons.remove_red_eye_sharp,
                    () => widget._cSchemaManagementWindow.previewAppSelected(context, app.identifier),
                    true
                  ),
                  (
                    AppLocalizations.of(context)!.editApp,
                    Icons.edit,
                    () => widget._cSchemaManagementWindow.upsertAppSelected(context, app.identifier),
                    widget._model.isAppEditable(app)
                  ),
                  (
                    AppLocalizations.of(context)!.deployApp,
                    Icons.cloud_upload,
                    () => widget._cSchemaManagementWindow.deployAppSelected(context,app),
                    widget._model.isAppDeployable(app)
                  ),
                  (
                    AppLocalizations.of(context)!.deleteApp,
                    Icons.delete,
                    () => widget._cSchemaManagementWindow
                        .deleteAppSelected(context, app),
                    widget._model.isAppDeletable(app)
                  ),
                ]),
              );

              var isEnabledLabels = [AppLocalizations.of(context)!.enabled, AppLocalizations.of(context)!.disabled];
              var isVisibleLabels = [AppLocalizations.of(context)!.visible, AppLocalizations.of(context)!.hidden];

              rightToggles = Center(
                child: DoorToggleButtonColumn(
                  key: Key("app_toggle_buttons_${app.identifier}_${app.isEnabled}_${app.isVisible}"),
                  [
                    (
                      isEnabledLabels,
                      {app.isEnabled == true ? isEnabledLabels[0] : isEnabledLabels[1]},
                      (value) {
                        setState(() {
                          widget._cSchemaManagementWindow.updateAppFlagsSelected(context, app.identifier, value == isEnabledLabels[0], app.isVisible!);
                        });
                      },
                      widget._model.areAppFlagsEditable(app)
                    ),
                    (
                      isVisibleLabels,
                      {app.isVisible == true ? isVisibleLabels[0] : isVisibleLabels[1]},
                      (value) {
                        setState(() {
                          widget._cSchemaManagementWindow.updateAppFlagsSelected(context, app.identifier, app.isEnabled!, value == isVisibleLabels[0]);
                        });
                      },
                      widget._model.areAppFlagsEditable(app)
                    ),
                  ]
                )
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
                        child: Image.asset("images/schema_series.png"),
                      ),
                      Expanded(
                        child: Column(
                          spacing: 5,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            DoorText(
                              app.title,
                              DoorTextStyle.main,
                            ),
                            Chip(
                              backgroundColor: widget._model.getStatusColor(app.status).withOpacity(0.15),
                              side: BorderSide(color: widget._model.getStatusColor(app.status)),
                              elevation: 4,
                              label: DoorText(
                                app.status.getText(context),
                                DoorTextStyle.emph,
                              ),
                            ),
                            DoorText(
                                widget._model.getAppAttributesSummary(context, app),
                                DoorTextStyle.emph,
                              ),
                            DoorText(
                              app.description,
                              DoorTextStyle.norm,
                            ),
                          ],
                        ),
                      ),
                      rightToggles,
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

  Widget templatePage(BuildContext context) {
    Widget rightButtons;

    return Column(
      spacing: 12,
      children: [
        Row(
          children: [
            const Spacer(),
            DoorSimpleButtonIcon(
                  AppLocalizations.of(context)!.addNewTemplate,
                  Icons.add_circle_outlined,
                  () => widget._cSchemaManagementWindow
                      .upsertTemplateSelected(context, ""),
                  enabled: widget._model.canUserInsertTemplates()),
            DoorSimpleButtonIcon(
                AppLocalizations.of(context)!.filter,
                _templateController.areFiltersApplied() ? Icons.filter_alt : Icons.filter_alt_outlined,
                () {
                  setFilters(_templateController);
                }),
            const SizedBox(width: 50),
          ],
        ),
        Expanded(
          child: ParameterizedListView<XAppTemplate>(
              controller: _templateController,
              itemBuilder: (context, template, index) {
              rightButtons = Center(
                child: DoorButtonColumn([
                  (
                    AppLocalizations.of(context)!.openTemplate, // TODO - 'preview'
                    Icons.remove_red_eye_sharp,
                    () => widget._cSchemaManagementWindow.previewTemplateSelected(context, template.identifier),
                    true
                  ),
                  (
                    AppLocalizations.of(context)!.editTemplate,
                    Icons.edit,
                    () => widget._cSchemaManagementWindow.upsertTemplateSelected(context, template.identifier),
                    widget._model.isTemplateEditable(template)
                  ),
                  ( 
                    AppLocalizations.of(context)!.compileTemplate,
                    Icons.build,
                    () => widget._cSchemaManagementWindow.generateAppTemplateSelected(context, template),
                    widget._model.isTemplateGeneratable(template)
                  ),
                  (
                    AppLocalizations.of(context)!.deleteTemplate,
                    Icons.delete,
                    () => widget._cSchemaManagementWindow
                        .deleteTemplateSelected(context, template),
                    widget._model.isTemplateDeletable(template)
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
                        width: 75,
                        height: 75,
                        child: Image.asset("images/schema_series.png"),
                      ),
                      Expanded(
                        child: Column(
                          spacing: 5,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            DoorText(
                              template.title,
                              DoorTextStyle.main,
                            ),
                            DoorText(
                              template.description,
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

class VSchemaManagementWindowFactory {
  const VSchemaManagementWindowFactory();
  VSchemaManagementWindow get(key, model) =>
      VSchemaManagementWindow(key, new CSchemaManagementWindow(model), model);
}
