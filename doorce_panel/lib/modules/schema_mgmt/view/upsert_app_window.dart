import 'package:doorce_panel/common/types/editor_roles.dart';
import 'package:doorce_panel/common/view_elements/resource_selector.dart';
import 'package:doorce_panel/common/view_elements/door_dropdown.dart';
import 'package:doorce_panel/common/view_elements/editor_selector.dart';
import 'package:doorce_panel/common/view_elements/snack_message.dart';
import 'package:doorce_panel/modules/schema_mgmt/view/controllers/c_upsert_app_window.dart';
import 'package:doorce_panel/modules/schema_mgmt/view/viewmodel/m_upsert_app_window.dart';
import 'package:flutter/material.dart';
import 'package:doorce_panel/common/view_elements/style.dart';
import 'package:doorce_panel/common/view_elements/text.dart';
import 'package:doorce_panel/common/view_elements/button.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';

class VUpsertAppWindow extends StatefulWidget {
  final MUpsertAppWindow _model;
  final CUpsertAppWindow _cUpsertAppWindow;
  const VUpsertAppWindow(GlobalKey? key, this._cUpsertAppWindow, this._model)
      : super(key: key);

  @override
  State<VUpsertAppWindow> createState() => VUpsertAppWindowState();
}

class VUpsertAppWindowState extends State<VUpsertAppWindow> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController identifierController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    identifierController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    widget._model.checkAndUpdateIsInsert();

    if (!widget._model.isInsert) {
      titleController.text = widget._model.app.title;
      identifierController.text = widget._model.app.identifier;
    } else {
      widget._model.setCurrentAgentAsEditor();
    }
  }

   void refresh() {
    setState(() {
      // Refresh the state of the widget
    });
  }

  void _updateIdentifier() {
    var model = widget._model;
    setState(() {
      if (model.isInsert){
        identifierController.text = model.createAppIdentifier(titleController.text);
        widget._model.app.identifier = identifierController.text; // TODO - this is a temporary fix
      }
    });
  }

  String _datasetKey() {
    return "datasets_${widget._model.datasets.length}_${widget._model.datasets.map((e) => e.identifier).join(",")}";
  }

   @override
  Widget build(BuildContext context) {
    String title = widget._model.isInsert ? AppLocalizations.of(context)!.createApp :
                                                AppLocalizations.of(context)!.editApp;
    
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
              DoorText(title, DoorTextStyle.titleBlack),
              _buildMetadataSection(),
              _buildDropdownSection(),
              _buildSourceDatasetSection(),
              _buildEditorsSection(),
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
            onTap: () => widget._cUpsertAppWindow.homeSelected(context),
            child: DoorText(AppLocalizations.of(context)!.mainMenu,
                DoorTextStyle.breadcrumbActive),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Icon(Icons.chevron_right, color: DoorColor.grey),
        ),
        Flexible(child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () =>
                widget._cUpsertAppWindow.showSchemaManagementSelected(context),
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

  Widget _buildMetadataSection() {
    return Column(
      spacing: 12,
      children: [
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DoorText(
              AppLocalizations.of(context)!.data,
              DoorTextStyle.titleBlack,
            ),
            const Spacer(),
          ],
        ),
        // ------------------------------ 1th ROW -------------------------------------
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            Flexible(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  DoorText("${AppLocalizations.of(context)!.titleField} *", DoorTextStyle.label),
                  DoorTextFormField(
                    enabled: widget._model.isMetadataEditable(),
                    controller: titleController,
                    onChanged: (v) {
                      setState(() {
                        widget._model.app.title = v;
                        _updateIdentifier();
                      });
                    },
                    validator: (v) => (v == null || v.isEmpty) ? AppLocalizations.of(context)!.fieldRequired : null,
                  ),
                ]
              )
            )
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 24,
          children: [
            Flexible(
              flex: 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  DoorText("${AppLocalizations.of(context)!.description} *", DoorTextStyle.label),
                  DoorTextFormField(
                    enabled: widget._model.isMetadataEditable(),
                    initialValue: widget._model.app.description,
                    rows: 2,
                    onChanged: (values) {
                      setState(() {
                        widget._model.app.description = values;
                      });
                    },
                    validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)!.fieldRequired;
                        }
                        return null;
                    })
                  ],
                ),
              ),
            Flexible(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  DoorText("${AppLocalizations.of(context)!.identifier} *",
                      DoorTextStyle.label),
                  DoorTextFormField(
                    controller: identifierController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.fieldRequired;
                      }
                      return null;
                    },
                    enabled: false,
                  ),
                ],
              ),
            ),
            Flexible(flex: 3, child: Container()),
          ],
        ),
      ],
    );
  }

  Widget _buildDropdownSection() {

    return Column(
      spacing: 12,
      children: [
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            Flexible(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 8,
                children: [
                  DoorText("${AppLocalizations.of(context)!.template} *",
                      DoorTextStyle.label),
                  DoorMultiDropdown<String>(
                    enabled: widget._model.canEditApp(),
                    singleSelect: true,
                    items: widget._model.getTemplateItems(), 
                    onSelectionChange: (values) {
                      setState(() {
                        widget._model.app.templateUri = values.firstOrNull ?? "";
                        widget._cUpsertAppWindow.schemaChanged(context);
                      });
                    },
                    validator: (items) {
                      if (null == items || items.isEmpty) {
                        return AppLocalizations.of(context)!.required;
                      }
                      return null;
                    },
                  )
                ]
              )
            )
          ],
        ),
        // ------------------------------ 3rd ROW -------------------------------------
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            Flexible(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  DoorText("${AppLocalizations.of(context)!.activeResource} *",
                      DoorTextStyle.label),
                  DoorMultiDropdown<String>(
                    key: Key(_datasetKey()),
                    enabled: widget._model.canEditApp(),
                    singleSelect: true,
                    items: widget._model.getActiveResourceItems(context),
                    onSelectionChange: (values) {
                      setState(() {
                        widget._model.app.activeResourceUri = values.firstOrNull ?? "";
                      });
                    },
                    validator: (items) {
                      if (null == items || items.isEmpty) {
                        return AppLocalizations.of(context)!.required;
                      } else if (widget._model.app.sourceResourceUris.contains(items.first.value)) {
                        return AppLocalizations.of(context)!.activeResourceCannotBeSourceResource;
                      }
                      return null;
                    },
                  )
                ]
              )
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSourceDatasetSection() {
    return Column(
      spacing: 12,
      children: [
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DoorText(
              "${AppLocalizations.of(context)!.sourceResources} *",
              DoorTextStyle.titleBlack,
            ),
            const Spacer(),
          ],
        ),
        Row(children: [
          Flexible(
            child: DoorMultiDropdown(
              key: Key("resources_${widget._model.newResources.length}_${widget._model.newResources.map((e) => e.sourceDatasetName).join(",")}_${_datasetKey()}"),
              enabled: widget._model.canEditApp(),
              items: widget._model.getSourceResourceItems(context),
              onSelectionChange: (values) {
                setState(() {
                  widget._model.handleResourceItemSelection(values);
                });
              },
              validator: (items) {
                if (null == items || items.isEmpty) {
                  return AppLocalizations.of(context)!.required;
                }
                return null;
              },
              )
            )
        ],),
        NewResourceSelector(
          enabled: widget._model.canEditApp(),
          agents: widget._model.agents,
          currentAgent: widget._model.currentAgent,
          catalogues: widget._model.catalogues,
          onResourceAdded: (selected) {
            setState(() {
              widget._model.newResources = selected;
            });
          },
          onCatalogueSelected: (selected) {
            setState(() {
              widget._model.selectedCatalogueUri = selected;
            });
          },) 
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
          availableEditors: widget._model.agents,
          availableRoles: [EditorRole.MetadataEditor, EditorRole.OwnershipEditor],
          assignments: widget._model.getRoleAssignments(),
          isAdmin: widget._model.isUserDataAdmin(),
          onEditorsChanged: 
          (values) {
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
                  await widget._cUpsertAppWindow.saveSelected(context);
                } else {
                  SnackMessage().show(context, true, text: AppLocalizations.of(context)!.formError);
                }
              },
              enabled: !widget._model.isPreview,
            ),
          ),
          SizedBox(
            width: 196,
            height: 48,
            child: DoorButtonLoading(
              AppLocalizations.of(context)!.cancel,
                  () async {
                await widget._cUpsertAppWindow.cancelSelected(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class VUpsertAppWindowFactory {
  const VUpsertAppWindowFactory();
  VUpsertAppWindow get(key, model) {
      return VUpsertAppWindow(key, new CUpsertAppWindow(model), model);
  }
}
