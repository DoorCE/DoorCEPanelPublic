import 'package:doorce_panel/common/types/editor_roles.dart';
import 'package:doorce_panel/common/view_elements/button.dart';
import 'package:doorce_panel/common/view_elements/door_dropdown.dart';
import 'package:doorce_panel/common/view_elements/editor_selector.dart';
import 'package:doorce_panel/common/view_elements/style.dart';
import 'package:doorce_panel/common/view_elements/text.dart';
import 'package:doorce_panel/dtos/data_schema.dart';
import 'package:doorce_panel/common/types/dataset_type.dart';
import 'package:doorce_panel/common/view_elements/snack_message.dart';
import 'package:doorce_panel/modules/schema_mgmt/view/controllers/c_upsert_schema_series_window.dart';
import 'package:doorce_panel/modules/schema_mgmt/view/viewmodel/m_upsert_schema_series_window.dart';

import 'package:flutter/material.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';

class VUpsertSchemaSeriesWindow extends StatefulWidget {
  final MUpsertSchemaSeriesWindow _model;
  final CUpsertSchemaSeriesWindow _cUpsertSchemaSeriesWindow;
  const VUpsertSchemaSeriesWindow(
      GlobalKey? key, this._cUpsertSchemaSeriesWindow, this._model)
      : super(key: key);

  @override
  State<VUpsertSchemaSeriesWindow> createState() =>
      VUpsertSchemaSeriesWindowState();
}

class VUpsertSchemaSeriesWindowState extends State<VUpsertSchemaSeriesWindow> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController identifierController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    identifierController.dispose();
    super.dispose();
  }

  void refresh() {
    setState(() {
      // Refresh the state of the widget
    });
  }

  void _updateIdentifier() {
    var model = widget._model;
    setState(() {
      if (model.isInsert) {
        identifierController.text =
            model.createSeriesIdentifier(titleController.text);
        widget._model.series.identifier =
            identifierController.text; // TODO - this is a temporary fix
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    widget._model.checkAndUpdateIsInsert();

    if (!widget._model.isInsert) {
      titleController.text = widget._model.series.title;
      descriptionController.text = widget._model.series.description;
      identifierController.text = widget._model.series.identifier;
    } else {
      widget._model.setCurrentAgentAsEditor();
    }
  }

  @override
  Widget build(BuildContext context) {
    String title = widget._model.isInsert
        ? AppLocalizations.of(context)!.addNewSeries
        : AppLocalizations.of(context)!.editSeries;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBreadcrumb(title),
              //const SizedBox(height: 24),
              DoorText(title, DoorTextStyle.titleBlack),
              //const SizedBox(height: 24),
              Card(
                margin: const EdgeInsets.only(bottom: 32),
                elevation: 2,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildMainDetailsSection(),
                      _buildEditorsSection()
                    ],
                  ),
                ),
              ),
              _buildFooterButtons()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBreadcrumb(String title) {
    return Row(
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () =>
                widget._cUpsertSchemaSeriesWindow.homeSelected(context),
            child: DoorText(AppLocalizations.of(context)!.mainMenu,
                DoorTextStyle.breadcrumbActive),
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
            onTap: () => widget._cUpsertSchemaSeriesWindow
                .showSchemaManagementSelected(context),
            child: DoorText(AppLocalizations.of(context)!.schemaManagement,
                DoorTextStyle.breadcrumbActive),
          ),
        )),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Icon(Icons.chevron_right, color: DoorColor.grey),
        ),
        Flexible(child: DoorText(title, DoorTextStyle.breadcrumb)),
      ],
    );
  }

  Widget _buildMainDetailsSection() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    DoorText("${AppLocalizations.of(context)!.titleField} *",
                        DoorTextStyle.label),
                    const SizedBox(height: 8),
                    DoorTextFormField(
                      controller: titleController,
                      enabled: widget._model.isMetadataEditable(),
                      onChanged: (value) {
                        setState(() {
                          widget._model.series.title = value;
                          _updateIdentifier();
                        });
                      },
                      validator: (value) => (value == null || value.isEmpty)
                          ? AppLocalizations.of(context)!.fieldRequired
                          : null,
                    ),
                    const SizedBox(height: 20),

                    // Identifier
                    DoorText("${AppLocalizations.of(context)!.identifier} *",
                        DoorTextStyle.label),
                    const SizedBox(height: 8),
                    DoorTextFormField(
                      controller: identifierController,
                      validator: (value) => (value == null || value.isEmpty)
                          ? AppLocalizations.of(context)!.fieldRequired
                          : null,
                      enabled: false,
                    ),
                    const SizedBox(height: 20),

                    // Description
                    DoorText("${AppLocalizations.of(context)!.description} *",
                        DoorTextStyle.label),
                    const SizedBox(height: 8),
                    DoorTextFormField(
                      controller: descriptionController,
                      enabled: widget._model.isMetadataEditable(),
                      onChanged: (value) {
                        setState(() {
                          widget._model.series.description = value;
                        });
                      },
                      validator: (value) => (value == null || value.isEmpty)
                          ? AppLocalizations.of(context)!.fieldRequired
                          : null,
                      rows: 2,
                    ),
                    const SizedBox(height: 20),

                    // Dataset Type
                    DoorText("${AppLocalizations.of(context)!.type} *",
                        DoorTextStyle.label),
                    const SizedBox(height: 8),
                    DoorMultiDropdown<DatasetType>(
                      enabled: widget._model.isMetadataEditable(),
                      items: widget._model.getDatasetTypeOptions(context),
                      onSelectionChange: (values) {
                        setState(() {
                          widget._model.series.type =
                              values.map((e) => e.index).toList();
                        });
                      },
                      validator: (values) => (values == null || values.isEmpty)
                          ? AppLocalizations.of(context)!.fieldRequired
                          : null,
                    ),
                    const SizedBox(height: 20),

                    // Current Schema
                    DoorText(AppLocalizations.of(context)!.currentSchema,
                        DoorTextStyle.label),
                    const SizedBox(height: 8),
                    DoorMultiDropdown<XDataSchema>(
                      enabled: widget._model.isMetadataEditable(),
                      items: widget._model.getSchemaOptions(context),
                      singleSelect: true,
                      onSelectionChange: (values) => setState(() {
                        widget._model.series.currentSchemaUri =
                            values.firstOrNull?.identifier ?? null;
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEditorsSection() {
    return Column(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DoorText(
              AppLocalizations.of(context)!.editors,
              DoorTextStyle.titleBlack,
            ),
            const Spacer(),
          ],
        ),
        EditorRoleAssignmentWidget(
          isEditable: widget._model.isEditorsEditable(),
          availableEditors: widget._model.getAvailableAgents(),
          availableRoles: [
            EditorRole.MetadataEditor,
            EditorRole.OwnershipEditor
          ],
          assignments: widget._model.getRoleAssignments(),
          isAdmin: widget._model.isUserDataAdmin(),
          onEditorsChanged: (values) {
            setState(() {
              widget._model.updateEditorUris(values);
              widget._model.updateRoles(values);
            });
          },
          onRolesChanged: (values) {
            setState(() {
              widget._model.updateRoles(values);
            });
          },
        ),
      ],
    );
  }

  Widget _buildFooterButtons() {
    return Center(
        child: Row(
            spacing: 12,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
          SizedBox(
              width: 196,
              height: 48,
              child: DoorButtonLoading(
                AppLocalizations.of(context)!.save,
                () async {
                  if (_formKey.currentState!.validate()) {
                    await widget._cUpsertSchemaSeriesWindow
                        .saveSelected(context);
                  } else {
                    SnackMessage().show(context, true,
                        text: AppLocalizations.of(context)!.formError);
                  }
                },
                enabled: !widget._model.isPreview,
              )),
          SizedBox(
            width: 196,
            height: 48,
            child: DoorButtonLoading(
              AppLocalizations.of(context)!.cancel,
              () async {
                await widget._cUpsertSchemaSeriesWindow.cancelSelected(context);
              },
            ),
          ),
        ]));
  }
}

class VUpsertSchemaSeriesWindowFactory {
  const VUpsertSchemaSeriesWindowFactory();
  VUpsertSchemaSeriesWindow get(key, model) {
    return VUpsertSchemaSeriesWindow(
        key, new CUpsertSchemaSeriesWindow(model), model);
  }
}
