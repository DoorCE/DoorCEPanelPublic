import 'package:doorce_panel/common/types/account_options.dart';
import 'package:doorce_panel/common/view_elements/account_selector.dart';
import 'package:doorce_panel/common/view_elements/button.dart';
import 'package:doorce_panel/common/view_elements/door_dropdown.dart';
import 'package:doorce_panel/common/view_elements/manager_selector.dart';
import 'package:doorce_panel/common/view_elements/style.dart';
import 'package:doorce_panel/common/view_elements/text.dart';
import 'package:doorce_panel/common/view_elements/text_chips.dart';
import 'package:doorce_panel/modules/agent_mgmt/view/controllers/c_upsert_person_window.dart';
import 'package:doorce_panel/modules/agent_mgmt/view/viewmodel/m_upsert_person_window.dart';
import 'package:doorce_panel/common/view_elements/snack_message.dart';
import 'package:flutter/material.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';

class VUpsertPersonWindow extends StatefulWidget {
  final CUpsertPersonWindow _cUpsertPersonWindow;
  final MUpsertPersonWindow _model;

  const VUpsertPersonWindow(GlobalKey? key, this._cUpsertPersonWindow, this._model)
      : super(key: key);

  @override
  State<VUpsertPersonWindow> createState() => VUpsertPersonWindowState();
}

class VUpsertPersonWindowState extends State<VUpsertPersonWindow> {
  final _formKey = GlobalKey<FormState>();

  // Text Fields Controllers
  final TextEditingController familyNameController = TextEditingController();
  final TextEditingController givenNamesController = TextEditingController();
  final TextEditingController identifierController = TextEditingController();
  final TextEditingController contactContentsController = TextEditingController();
  final TextEditingController contactNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    familyNameController.dispose();
    givenNamesController.dispose();
    identifierController.dispose();
    contactContentsController.dispose();
    contactNameController.dispose();
    super.dispose();
  }

  void refresh() {
    setState(() {
    });
  }

  void _updateIdentifier() {
    var model = widget._model;
    setState(() {
      if (model.isInsert){
        identifierController.text = model.createPersonIdentifier(familyNameController.text);
        widget._model.person.identifier = identifierController.text; // TODO - this is a temporary fix
      }
    });
  }

  bool _validateContactFieldsBeforeAdding() {
    bool isNew = widget._model.isContactNew(contactNameController.text, contactContentsController.text);
    bool isNameNotEmpty = contactNameController.text.isNotEmpty;
    bool isContentsNotEmpty = contactContentsController.text.isNotEmpty;
    return isNew && isNameNotEmpty && isContentsNotEmpty;
  }

  void _refreshAvailableAccountIds(String query) async {
    await widget._cUpsertPersonWindow.accountIdsSearchQueryChanged(context, query);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    widget._model.checkAndUpdateIsInsert();

    if (!widget._model.isInsert) {
      identifierController.text = widget._model.person.identifier;
      familyNameController.text = widget._model.person.familyName;
    } else {
    }
  }

  @override
  Widget build(BuildContext context) {
    String title = widget._model.isInsert ? AppLocalizations.of(context)!.addPerson :
                                                AppLocalizations.of(context)!.editPerson;
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
              _buildPersonalInformationSection(),
              _buildAccountSection(),
              _buildOrganizationSection(),
              _buildContactsSection(),
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
            onTap: () => widget._cUpsertPersonWindow.homeSelected(context),
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
                widget._cUpsertPersonWindow.agentManagementSelected(context),
            child: DoorText(AppLocalizations.of(context)!.agentManagement,
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

  Widget _buildPersonalInformationSection() {
    return Column(
      spacing: 12,
      children: [
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DoorText(
              AppLocalizations.of(context)!.personalInformations,
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
                  DoorText("${AppLocalizations.of(context)!.personName} *", DoorTextStyle.label),
                  DoorTextFormFieldWithChips(
                    isRequired: true,
                    items: widget._model.person.givenNames, 
                    onChipAddedOrRemoved: (values) {
                      setState(() {
                        widget._model.person.givenNames = values;
                      });
                    },
                    )
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
                  DoorText("${AppLocalizations.of(context)!.familyName} *", DoorTextStyle.label),
                  DoorTextFormField(
                    controller: familyNameController, 
                    onChanged: (values) {
                      setState(() {
                        widget._model.person.familyName = values;
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
            Flexible(flex: 3, child: Container()),
          ],
        ),
      ]
    );
  }

  Widget _buildAccountSection() {
    return Column(
      spacing: 12,
      children: [
        SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DoorText(
              AppLocalizations.of(context)!.userAccount,
              DoorTextStyle.titleBlack,
            ),
            const Spacer(),
          ],
        ),
        RadioConditionalSection<AccountOption>(
          enabled: widget._model.canChangeAccount(),
          initialValue: widget._model.getAccountOptionInitialValue(), 
          onChanged: (value) {
            setState(() {
              widget._model.resetAllAccountData();
            });
          },
          options: [
            RadioOption(
              value: AccountOption.noAccount,
              label: AppLocalizations.of(context)!.noAccount,
            ),

            RadioOption(
              value: AccountOption.hasAccount,
              label: 'Has account',
              builder: (context) {
                return DoorMultiDropdown<String>(
                  enabled: widget._model.canChangeAccount(),
                  items: widget._model.getAvailableAccountIdsItems(),
                  searchEnabled: true,
                  singleSelect: true,
                  selectHint: AppLocalizations.of(context)!.selectAccountId,
                  onSearchChange: (query) => _refreshAvailableAccountIds(query),
                  onSelectionChange: (value) {
                    setState(() {
                      widget._model.person.userId = value.isNotEmpty ? value.first : null;
                    });
                  },
                );
              },
            ),

            RadioOption(
              value: AccountOption.createAccount,
              label: AppLocalizations.of(context)!.createAccount,
              builder: (context) {
                return Column(
                  children: [
                    // TODO - add label to DoorTextFormField
                    TextFormField(
                      enabled: widget._model.canChangeAccount(),
                      initialValue: widget._model.person.userId,
                      onChanged: (value) {
                        setState((){
                          widget._model.person.userId = value;
                        });
                      },
                      decoration: InputDecoration(labelText: "${AppLocalizations.of(context)!.accountId} *"),
                      validator: (value) {
                        if (null == value || value.isEmpty) {
                          return AppLocalizations.of(context)!.fieldRequired;
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      enabled: widget._model.canChangeAccount(),
                      initialValue: widget._model.person.userEmail,
                      onChanged: (value) {
                        setState((){
                          widget._model.person.userEmail = value;
                        });
                      },
                      decoration: InputDecoration(labelText: AppLocalizations.of(context)!.email),
                      validator: (value) {
                        if (!widget._model.validateCreateAccountData()) {
                          return AppLocalizations.of(context)!.noEmailOrPasswordWarning;
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      enabled: widget._model.canChangeAccount(),
                      initialValue: widget._model.person.userPassword,
                      onChanged: (value) {
                        setState((){
                          widget._model.person.userPassword = value;
                        });
                      },
                      obscureText: true,
                      decoration: InputDecoration(labelText: AppLocalizations.of(context)!.password),
                      validator: (value) {
                        if (!widget._model.validateCreateAccountData()) {
                          return AppLocalizations.of(context)!.noEmailOrPasswordWarning;
                        }
                        return null;
                      },
                    ),
                  ],
                );
              },
            )
          ])
      ]);
  }

  Widget _buildOrganizationSection() {
    return Column(
      spacing: 12,
      children: [
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DoorText(
              AppLocalizations.of(context)!.organisations,
              DoorTextStyle.titleBlack,
            ),
            const Spacer(),
          ],
        ),
        ManagerRoleAssignmentWidget(
          availableAgents: widget._model.getAvailableOrganizations(),
          disabledAgents: widget._model.getDisabledOrganizations(),
          assignments: widget._model.getRoleAssignments(),
          onManagersChanged: 
          (values) {
            setState(() {
              widget._model.updateOrganizationUris(values);
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
                    spacing: 8,
                    runSpacing: 8,
                    children: widget._model.getContactOptions().map((contents) {
                      return InputChip(
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
                  AppLocalizations.of(context)!.add,
                  Icons.add_circle_outlined,
                  () { if (_validateContactFieldsBeforeAdding())  {
                    setState(() {
                      widget._model.addToNewContacts(
                          contactNameController.text,
                          contactContentsController.text,
                        );
                    contactNameController.clear();
                    contactContentsController.clear();
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
              AppLocalizations.of(context)!.save,
              () async {
                if (_formKey.currentState!.validate()) {
                  await widget._cUpsertPersonWindow.saveSelected(context);
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
                await widget._cUpsertPersonWindow.cancelSelected(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class VUpsertPersonWindowFactory {
  const VUpsertPersonWindowFactory();
  VUpsertPersonWindow get(key, model) {
    return VUpsertPersonWindow(key, new CUpsertPersonWindow(model), model);
  }
}
