import 'package:doorce_panel/common/view_elements/button.dart';
import 'package:doorce_panel/common/view_elements/door_dropdown.dart';
import 'package:doorce_panel/common/view_elements/editor_selector.dart';
import 'package:doorce_panel/common/view_elements/style.dart';
import 'package:doorce_panel/common/view_elements/text.dart';
import 'package:doorce_panel/common/view_elements/snack_message.dart';
import 'package:doorce_panel/modules/metadata_mgmt/view/controllers/c_upsert_catalogue_window.dart';
import 'package:doorce_panel/modules/metadata_mgmt/view/viewmodel/m_upsert_catalogue_window.dart';
import 'package:flutter/material.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class VUpsertCatalogueWindow extends StatefulWidget {
  final CUpsertCatalogueWindow _cUpsertCatalogueWindow;
  final MUpsertCatalogueWindow _model;
  const VUpsertCatalogueWindow(GlobalKey? key, this._cUpsertCatalogueWindow, this._model)
      : super(key: key);

  @override
  State<VUpsertCatalogueWindow> createState() => VUpsertCatalogueWindowState();
}

class VUpsertCatalogueWindowState extends State<VUpsertCatalogueWindow> {
  final _formKey = GlobalKey<FormState>();

  String? selectedMetadataLanguageCode = "en"; //used as a key

  // Text Fields Controllers
  final TextEditingController titleController = TextEditingController();
  final TextEditingController identifierController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController contactContentsController = TextEditingController();
  final TextEditingController contactNameController = TextEditingController();

  // Dropdown Controllers
  final MultiSelectController<String> _metadataLanguageSelectController =
      MultiSelectController<String>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    identifierController.dispose();
    descriptionController.dispose();
    contactContentsController.dispose();
    contactNameController.dispose();
    _metadataLanguageSelectController.dispose();
    super.dispose();
  }

  void refresh() {
    setState(() {
      // Refresh the state of the widget
    });
  }

  void _dynamicallyUpdateIdentifier() {
    if (widget._model.isCatalogueTitlesEmpty()) {
      _updateIdentifier();
    }
  }

  void _updateIdentifier() {
    var model = widget._model;
    setState(() {
      if (model.isInsert){
        identifierController.text = model.createCatalogueIdentifier(titleController.text);
        widget._model.catalogue.identifier = identifierController.text; // TODO - this is a temporary fix
      }
    });
  }

  void updateTitleDescriptionOnLanguageChange() {
    setState(() {
      titleController.text = widget._model.catalogue.title[selectedMetadataLanguageCode] ?? "";
      descriptionController.text =
          widget._model.catalogue.description[selectedMetadataLanguageCode] ?? "";
    });
  }

  void _refreshAgentContactOptions() async {   
    await widget._cUpsertCatalogueWindow.contactSourcesChanged(context);
  }

  bool _validateContactFieldsBeforeAdding() {
    bool isNew = widget._model.isContactNew(contactNameController.text, contactContentsController.text);
    bool isNameNotEmpty = contactNameController.text.isNotEmpty;
    bool isContentsNotEmpty = contactContentsController.text.isNotEmpty;
    return isNew && isNameNotEmpty && isContentsNotEmpty;
  }

  String _contactsSelectKey() =>
    "${widget._model.catalogueAgentsContacts.map((e) => e.identifier).join("-")}"
    "${widget._model.newContacts.map((e) => e.identifier).join("-")}";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    widget._model.checkAndUpdateIsInsert();

    if (!widget._model.isInsert) {
      selectedMetadataLanguageCode ??= "en";
      titleController.text = widget._model.catalogue.title[selectedMetadataLanguageCode] ?? "";
      descriptionController.text = widget._model.catalogue.description[selectedMetadataLanguageCode] ?? "";
      identifierController.text = widget._model.catalogue.identifier;
    } else {
      titleController.addListener(_dynamicallyUpdateIdentifier);
      widget._model.setCurrentAgentAsEditor();
    }
    _refreshAgentContactOptions();
  }

  @override
  Widget build(BuildContext context) {
    String title = widget._model.isInsert ? AppLocalizations.of(context)!.addNewCatalogue :
                                                AppLocalizations.of(context)!.editCatalog;
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
              _buildMainDetailsSection(),
              _buildMetadataDetailsSection(),
              _buildCatalogueSection(),
              _buildEditorsSection(),
              _buildContactsSection(),
              _buildFooterButtons()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainDetailsSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: 2,
          child: SizedBox(
            width: 180,
            height: 180,
            child: Stack(
              children: [
                Container(
                  width: 165,
                  height: 165,
                  decoration: BoxDecoration(
                    border: Border.all(color: DoorColor.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: null == widget._model.catalogue.icon ?
                      const Icon(Icons.add_photo_alternate_outlined, size: 60,) :
                      Image.memory(widget._model.catalogue.icon!)
                  ),
                ),
                Positioned(
                  bottom: 5,
                  right: 5,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: DoorColor.black, width: 2),
                      color: DoorColor.reverse,
                    ),
                    child: DoorSimpleButtonIcon(
                      AppLocalizations.of(context)!.addIcon,
                      Icons.edit,
                      () {
                        widget._cUpsertCatalogueWindow.pickIconSelected(context);
                      },
                      enabled: widget._model.isMetadataEditable(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 75),
        Flexible(
          flex: 4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 12,
            children: [
              Row(
                spacing: 12,
                children: [
                  Flexible(
                    flex: 1,
                    child: DoorText( "${AppLocalizations.of(context)!.parentCatalog} *",
                        DoorTextStyle.center),
                  ),
                  Flexible(
                    flex: 8,
                    child: DoorMultiDropdown<String>(
                      enabled: widget._model.isMetadataEditable(),
                      singleSelect: true,
                      items: widget._model.getCatalogsOptions(context),
                      onSelectionChange: (values) {
                        setState(() {
                          widget._model.catalogue.parentID = values.first;
                        });
                      },
                      validator: (values) {
                        if (!widget._model.isUserDataAdmin()) {
                          return AppLocalizations.of(context)!.fieldRequired;
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBreadcrumb(String title) {
    return Row(
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => widget._cUpsertCatalogueWindow.homeSelected(context),
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
            onTap: () => widget._cUpsertCatalogueWindow
                .showCataloguesSelected(context, ""),
            child: DoorText(AppLocalizations.of(context)!.cataloguing,
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

  Widget _buildMetadataDetailsSection() {
    return Column(
      spacing: 12,
      children: [
        Row(
          children: [
            Flexible(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  Flexible(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 8,
                      children: [
                        DoorText(AppLocalizations.of(context)!.metadataLanguage,
                            DoorTextStyle.label),
                        DoorMultiDropdown<String>(
                          singleSelect: true,
                          items: widget._model.getMetadataLanguageOptions(selectedMetadataLanguageCode),
                          controller: _metadataLanguageSelectController,
                          onSelectionChange: (values) {
                            setState(() {
                              selectedMetadataLanguageCode =
                                  values.isNotEmpty ? values.first : null;
                              updateTitleDescriptionOnLanguageChange();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 7,
                    child: Column(
                      children: [
                        const SizedBox(height: 37),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: widget._model.catalogue.title.keys.map((lang) {
                            return InputChip(
                              isEnabled: widget._model.isMetadataEditable(),
                              backgroundColor: DoorColor.lightEmph,
                              side: const BorderSide(color: DoorColor.darkEmph),
                              label: Text(lang.toUpperCase()),
                              onPressed: () {
                                    setState(() {
                                      _metadataLanguageSelectController.clearAll();
                                      selectedMetadataLanguageCode = lang;
                                      _metadataLanguageSelectController.selectWhere((e) => e.value == lang);
                                    });
                                  },
                              onDeleted: () {
                                setState(() {
                                  widget._model.catalogue.description.remove(lang);
                                  widget._model.catalogue.title.remove(lang);
                                  updateTitleDescriptionOnLanguageChange();
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        // ------------------------------------- TITLE DESCRIPTION VERSION -------------------------------------
        Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
            color: DoorColor.lightEmph,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              spacing: 12,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    Flexible(
                      flex: 6,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 8,
                        children: [
                          DoorText("${AppLocalizations.of(context)!.titleField} *", DoorTextStyle.label),
                          DoorTextFormField(
                            controller: titleController, 
                            enabled: widget._model.isMetadataEditable(),
                            validator: (value) {
                              if (widget._model.isCatalogueTitlesEmpty()) {
                                return AppLocalizations.of(context)!.fieldRequired;
                              } else if (value!.isNotEmpty && value != widget._model.catalogue.title[selectedMetadataLanguageCode]) {
                                return AppLocalizations.of(context)!.unsavedChanges;
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
                          DoorText(
                              "${AppLocalizations.of(context)!.identifier} *",
                              DoorTextStyle.label),
                          DoorTextFormField(
                            controller: identifierController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppLocalizations.of(context)!
                                    .fieldRequired;
                              }
                              return null;
                            },
                            enabled: false,
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(),
                    ),
                  ],
                ),
                // ------------------------------------- 1st ROW -------------------------------------
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    Flexible(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 8,
                        children: [
                          DoorText("${AppLocalizations.of(context)!.description} *", DoorTextStyle.label),
                          DoorTextFormField(
                            controller: descriptionController, 
                            enabled: widget._model.isMetadataEditable(),
                            validator: (value) {
                              if (widget._model.isCatalogueDescriptionsEmpty()) {
                                return AppLocalizations.of(context)!.fieldRequired;
                              } else if (value!.isNotEmpty && value != widget._model.catalogue.description[selectedMetadataLanguageCode]) {
                                return AppLocalizations.of(context)!.unsavedChanges;
                              }
                              return null;
                            }, 
                            rows: 2
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                Center(
                  child: DoorButtonPlain(
                      enabled: widget._model.isMetadataEditable(),
                      AppLocalizations.of(context)!.addLanguage, () {
                    if (selectedMetadataLanguageCode != null &&
                        titleController.text.isNotEmpty &&
                        descriptionController.text.isNotEmpty) {
                      setState(() {
                        widget._model.catalogue.title[selectedMetadataLanguageCode!] =
                            titleController.text;
                        widget._model.catalogue.description[selectedMetadataLanguageCode!] =
                            descriptionController.text;
                      });
                      _updateIdentifier();
                    }
                  }),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCatalogueSection() {
    return Column(
      spacing: 12,
      children: [
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DoorText(
              AppLocalizations.of(context)!.catalog,
              DoorTextStyle.titleBlack,
            ),
            const Spacer(),
          ],
        ),
        // ------------------------------ 1th ROW -------------------------------------
        Row(
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  DoorText(AppLocalizations.of(context)!.responsiblePerson,
                      DoorTextStyle.label),
                  DoorMultiDropdown<String>(
                    enabled: widget._model.isMetadataEditable(),
                    singleSelect: true,
                    items: widget._model.getPeopleOptions(),
                    onSelectionChange: (values) {
                      widget._model.catalogue.responsiblePersonID = values.firstOrNull;
                      _refreshAgentContactOptions();
                    },
                    validator: (values) {
                      if (widget._model.areResponsibleAgentsNullOrEmpty() && !widget._model.isUserDataAdmin()) {
                        return AppLocalizations.of(context)!.respAgentNotAssigned;
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  DoorText(
                      AppLocalizations.of(context)!.responsibleOrganization,
                      DoorTextStyle.label),
                  DoorMultiDropdown<String>(
                    enabled: widget._model.isMetadataEditable(),
                    singleSelect: true,
                    items: widget._model.getOrganizationsOptions(),
                    onSelectionChange: (values) {
                      widget._model.catalogue.responsibleOrganisationID = values.firstOrNull;
                      _refreshAgentContactOptions();
                    },
                    validator: (values) {
                      if (widget._model.areResponsibleAgentsNullOrEmpty() && !widget._model.isUserDataAdmin()) {
                        return AppLocalizations.of(context)!.respAgentNotAssigned;
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
        const SizedBox(width: 40),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  DoorText("${AppLocalizations.of(context)!.contacts} *",
                      DoorTextStyle.label),
                  DoorMultiDropdown<String>(
                    enabled: widget._model.isMetadataEditable(),
                    key: ValueKey("contact-dropdown-${_contactsSelectKey()}"),
                    items: widget._model
                        .getContactOptions(),
                    onSelectionChange: (values) {
                      setState(() {
                        widget._model.updateContactsOnSelection(values);
                      });
                    },
                    validator: (values) {
                      if (null == values || values.isEmpty) {
                        return AppLocalizations.of(context)!.fieldRequired;
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 40),
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
          assignments: widget._model.getRoleAssignments(),
          isAdmin: widget._model.isUserDataAdmin(),
          onEditorsChanged: 
          (values) {
            setState(() {
              widget._model.updateEditorUris(values);
              widget._model.updateRoles(values);
              _refreshAgentContactOptions();
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

  Widget _buildContactsSection() {
    return Column(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DoorText(
              AppLocalizations.of(context)!.newContacts,
              DoorTextStyle.titleBlack,
            ),
            const Spacer(),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            Flexible(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  DoorText(AppLocalizations.of(context)!.contactName, DoorTextStyle.label),
                  DoorTextFormField(
                    controller: contactNameController,
                    enabled: widget._model.isMetadataEditable(),
                    validator: (values) {
                        if (values!.isNotEmpty) {
                          return AppLocalizations.of(context)!.unsavedChanges;
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
                  DoorText(AppLocalizations.of(context)!.contents, DoorTextStyle.label),
                  DoorTextFormField(
                    controller: contactContentsController,
                    enabled: widget._model.isMetadataEditable(),
                    validator: (values) {
                      if (values!.isNotEmpty) {
                        return AppLocalizations.of(context)!.unsavedChanges;
                      }
                      return null;
                    },)
                ],
              ),
            ),
            Column(
              children: [
                const SizedBox(height: 34),
                DoorSimpleButtonIcon(
                  enabled: widget._model.isMetadataEditable(),
                  AppLocalizations.of(context)!.add,
                  Icons.add_circle_outlined,
                  () { if (_validateContactFieldsBeforeAdding()) {
                    setState(() {
                    widget._model.addToNewContacts(contactNameController.text, contactContentsController.text);
                    contactContentsController.clear();
                    contactNameController.clear();
                  });
                  }},
                )
              ],
            ),
          ],
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
              enabled: !widget._model.isPreview,
              AppLocalizations.of(context)!.save,
              () async {
                if (_formKey.currentState!.validate()) {
                  await widget._cUpsertCatalogueWindow.saveSelected(context);
                } else {
                  SnackMessage().show(context, true, text: AppLocalizations.of(context)!.formError);
                }
              },
            ),
          ),
          SizedBox(
            width: 196,
            height: 48,
            child: DoorButtonLoading(
              AppLocalizations.of(context)!.cancel,
              () async {
                await widget._cUpsertCatalogueWindow.cancelSelected(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class VUpsertCatalogueWindowFactory {
  const VUpsertCatalogueWindowFactory();
  VUpsertCatalogueWindow get(key, model) {
    return VUpsertCatalogueWindow(key, new CUpsertCatalogueWindow(model), model);
  }
}
