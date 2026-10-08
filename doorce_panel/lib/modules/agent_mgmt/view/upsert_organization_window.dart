import 'package:doorce_panel/common/view_elements/button.dart';
import 'package:doorce_panel/common/view_elements/manager_selector.dart';
import 'package:doorce_panel/common/view_elements/style.dart';
import 'package:doorce_panel/common/view_elements/text.dart';
import 'package:doorce_panel/modules/agent_mgmt/view/controllers/c_upsert_organization_window.dart';
import 'package:doorce_panel/modules/agent_mgmt/view/viewmodel/m_upsert_organization_window.dart';
import 'package:doorce_panel/common/view_elements/snack_message.dart';
import 'package:flutter/material.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';

class VUpsertOrganizationWindow extends StatefulWidget {
  final CUpsertOrganizationWindow _cUpsertOrganizationWindow;
  final MUpsertOrganizationWindow _model;

  const VUpsertOrganizationWindow(GlobalKey? key, this._cUpsertOrganizationWindow, this._model)
      : super(key: key);

  @override
  State<VUpsertOrganizationWindow> createState() =>
      VUpsertOrganizationWindowState();
}

class VUpsertOrganizationWindowState extends State<VUpsertOrganizationWindow> {
  final _formKey = GlobalKey<FormState>();

  // Text Fields Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController identifierController = TextEditingController();
  final TextEditingController contactContentsController = TextEditingController();
  final TextEditingController contactNameController = TextEditingController();

  void refresh() {
    setState(() {
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    identifierController.dispose();
    contactContentsController.dispose();
    contactNameController.dispose();
    super.dispose();
  }

  void _updateIdentifier() {
    var model = widget._model;
    setState(() {
      if (model.isInsert){
        identifierController.text = model.createOrganizationIdentifier(nameController.text);
        widget._model.organization.identifier = identifierController.text; // TODO - this is a temporary fix
      }
    });
  }

  bool _validateContactFieldsBeforeAdding() {
    bool isNew = widget._model.isContactNew(contactNameController.text, contactContentsController.text);
    bool isNameNotEmpty = contactNameController.text.isNotEmpty;
    bool isContentsNotEmpty = contactContentsController.text.isNotEmpty;
    return isNew && isNameNotEmpty && isContentsNotEmpty;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    widget._model.checkAndUpdateIsInsert();

    if (!widget._model.isInsert) {
      identifierController.text = widget._model.organization.identifier;
      nameController.text = widget._model.organization.name;
    } else {
    }
  }

  @override
  Widget build(BuildContext context) {
    String title = widget._model.isInsert ? AppLocalizations.of(context)!.addOrganization :
                                                AppLocalizations.of(context)!.editOrganization;
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
              _buildOrganizationDetailsSection(),
              _buildContactsSection(),
              _buildMembersSection(),
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
                widget._cUpsertOrganizationWindow.homeSelected(context),
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
            onTap: () => widget._cUpsertOrganizationWindow
                .agentManagementSelected(context),
            child: DoorText(AppLocalizations.of(context)!.agentManagement,
                DoorTextStyle.breadcrumbActive),
          ),
        )),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Icon(Icons.chevron_right, color: DoorColor.grey),
        ),
        Flexible(child:DoorText(title, DoorTextStyle.breadcrumb)),
      ],
    );
  }

  Widget _buildOrganizationDetailsSection() {
    return Column(
      spacing: 12,
      children: [
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DoorText(
              AppLocalizations.of(context)!.openOrganization,
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
                  DoorText("${AppLocalizations.of(context)!.orgName} *", DoorTextStyle.label),
                  DoorTextFormField(
                    controller: nameController,
                    enabled: widget._model.isUserMetadataManager(),
                    onChanged: (values) {
                      setState(() {
                        widget._model.organization.name = values;
                        _updateIdentifier();
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
            Flexible(flex: 3, child: Container()),
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
                      // final RegExp identifierRegex = RegExp(
                      //     r'^doorce/[a-z0-9_]+/[0-9]+(\.[0-9]+)*$');
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.fieldRequired;
                      }
                      // if (!identifierRegex.hasMatch(value)) {
                      //   return AppLocalizations.of(context)!
                      //       .invalidIdentifier;
                      // }
                      return null;
                    },
                    enabled: false,
                  ),
                ],
              ),
            ),
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
                  DoorText(AppLocalizations.of(context)!.description, DoorTextStyle.label),
                  DoorTextFormField(
                    initialValue: widget._model.organization.description ?? '',
                    enabled: widget._model.isUserMetadataManager(),
                    onChanged: (values) {
                      setState(() {
                        widget._model.organization.description = values;
                      });
                    },
                  )
                ],
              ),
            ),
          ],
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
              "${AppLocalizations.of(context)!.contacts} *",
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
              flex: 7,
              child: Column(
                children: [
                  Wrap(
                    runSpacing: 8,
                    spacing: 8,
                    children: widget._model.getContactOptions().map((contents) {
                      return InputChip(
                        isEnabled: widget._model.isUserMetadataManager(),
                        backgroundColor: DoorColor.lightEmph,
                        side: const BorderSide(color: DoorColor.darkEmph),
                        label: DoorText("${contents.name}: ${contents.contents}", DoorTextStyle.norm),
                        onDeleted: () {
                          setState(() {
                            if (!widget._model.newContacts.remove(contents)){
                              widget._model.removeExistingContact(contents);
                            }
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
                    enabled: widget._model.isUserMetadataManager(),
                    validator: (value) {
                      if (widget._model.getContactOptions().isEmpty) {
                        return AppLocalizations.of(context)!.fieldRequired;
                      } else if (value!.isNotEmpty) {
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
                  enabled: widget._model.isUserMetadataManager(),
                  validator: (values) {
                      if (values!.isNotEmpty) {
                        return AppLocalizations.of(context)!.unsavedChanges;
                      }
                      return null;
                    })
                ],
              ),
            ),
            Column(
              children: [
                const SizedBox(height: 34),
                DoorSimpleButtonIcon(
                  enabled: widget._model.isUserMetadataManager(),
                  AppLocalizations.of(context)!.add,
                  Icons.add_circle_outlined,
                  () { if (_validateContactFieldsBeforeAdding()) {
                    setState(() {
                      widget._model.addToNewContacts(
                          contactNameController.text,
                          contactContentsController.text,
                        );
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

  Widget _buildMembersSection() {
    return Column(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DoorText(
              AppLocalizations.of(context)!.members,
              DoorTextStyle.titleBlack,
            ),
            const Spacer(),
          ],
        ),
        ManagerRoleAssignmentWidget(
          adminMode: widget._model.isUserAllowedToEditMembers(),
          availableAgents: widget._model.getAvailableMembers(), 
          assignments: widget._model.getRoleAssignments(),
          isOrganisation: true,
          onManagersChanged: 
          (values) {
            setState(() {
              widget._model.organization.membersUris = values.map((e) => e.agent.identifier).toList();
              widget._model.organization.membersRoles = values.asMap().map((index, value) 
                => MapEntry(value.agent.identifier, value.roles));
            });
          },
          onRolesChanged: (values) {
            setState(() {
              widget._model.organization.membersRoles = values.asMap().map((index, value) 
                => MapEntry(value.agent.identifier, value.roles));
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
                  await widget._cUpsertOrganizationWindow.saveSelected(context);
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
                await widget._cUpsertOrganizationWindow.cancelSelected(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class VUpsertOrganizationWindowFactory {
  const VUpsertOrganizationWindowFactory();
  VUpsertOrganizationWindow get(key, model) =>
      VUpsertOrganizationWindow(key, new CUpsertOrganizationWindow(model), model);
}
