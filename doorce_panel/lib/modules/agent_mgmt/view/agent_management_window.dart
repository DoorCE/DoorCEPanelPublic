import 'package:doorce_panel/common/types/global_role.dart';
import 'package:doorce_panel/common/view_elements/button.dart';
import 'package:doorce_panel/common/view_elements/chips.dart';
import 'package:doorce_panel/common/view_elements/door_dropdown.dart';
import 'package:doorce_panel/common/view_elements/parameterized_list_view/filter_dialog.dart';
import 'package:doorce_panel/common/view_elements/parameterized_list_view/page_state.dart';
import 'package:doorce_panel/common/view_elements/parameterized_list_view/parameterized_list_view.dart';
import 'package:doorce_panel/common/view_elements/style.dart';
import 'package:doorce_panel/common/view_elements/text.dart';
import 'package:doorce_panel/dtos/organization.dart';
import 'package:doorce_panel/dtos/person.dart';
import 'package:doorce_panel/dtos/user_account.dart';
import 'package:doorce_panel/modules/agent_mgmt/usecases/show_agent_management.dart';
import 'package:doorce_panel/modules/agent_mgmt/view/controllers/c_agent_management_window.dart';
import 'package:doorce_panel/modules/agent_mgmt/view/viewmodel/m_agent_management_window.dart';
import 'package:doorce_panel/modules/main_panel/usecases/start.dart';
import 'package:flutter/material.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class VAgentManagementWindow extends StatefulWidget {
  final MAgentManagementWindow _model;
  final CAgentManagementWindow _cAgentManagementWindow;
  const VAgentManagementWindow(GlobalKey? key, this._cAgentManagementWindow, this._model)
      : super(key: key);

  @override
  State<VAgentManagementWindow> createState() => VAgentManagementWindowState();
}

class VAgentManagementWindowState extends State<VAgentManagementWindow> {
  String selectedOption = "People";
  final _formKey = GlobalKey<FormState>();

  late ParameterizedListController<XPerson> _personController;
  late ParameterizedListController<XOrganization> _orgController;
  late ParameterizedListController<XUserAccount> _userController;

  void refresh() {
    setState(() {
    // Sync controllers with updated model data
    _personController.updateQuerySet(widget._model.peopleResources);
    _orgController.updateQuerySet(widget._model.organizationResources);
    _userController.updateQuerySet(widget._model.userAccounts);
    });
  }

  void resetSelectedOption() {
    setState(() {
      selectedOption = "People";
    });
  }

  @override
  void initState() {
    super.initState();

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

    _personController = widget._model.setController<XPerson>(context);
    _orgController = widget._model.setController<XOrganization>(context);
    _userController = widget._model.setController<XUserAccount>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 12, top: 20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBreadcrumb(context),
            _buildTransitionButtons(),
            if (selectedOption == "People")
              peoplePage(context)
            else if (selectedOption == "Organisations")
              organisationsPage(context)
            else
              usersPage(context),
          ],
        ),
      )
    );
  }

  Widget _buildBreadcrumb(BuildContext context) {
    return Row(
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              context.read<IUCStart>().startSelected(context);
            },
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
            onTap: () {
              context
                  .read<IUCShowAgentManagement>()
                  .showAgentManagementSelected(context, "");
            },
            child: DoorText(AppLocalizations.of(context)!.agentManagement,
                DoorTextStyle.breadcrumbActive),
          ),
        )),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Icon(Icons.chevron_right, color: DoorColor.grey),
        ),
        Flexible(child: DoorText(
            selectedOption == "People"
                ? AppLocalizations.of(context)!.people
                : selectedOption == "Users"
                  ? AppLocalizations.of(context)!.users
                  : AppLocalizations.of(context)!.organisations,
            DoorTextStyle.breadcrumb)),
      ],
    );
  }

  Widget _buildTransitionButtons() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DoorButtonCard(
            AppLocalizations.of(context)!.people,
            () => {
              setState(() {
                selectedOption = "People";
              })
            },
            "left",
            selectedOption == "People", // isSelected
          ),
          if (widget._model.isUserAgentAdmin())
            DoorButtonCard(
              AppLocalizations.of(context)!.users,
              () {
                setState(() {
                  selectedOption = "Users";
                });
              },
              "middle",
              selectedOption == "Users",
            ),
          DoorButtonCard(
              AppLocalizations.of(context)!.organisations,
              () => {
                    setState(() {
                      selectedOption = "Organisations";
                    })
                  },
              "right",
              selectedOption == "Organisations" // isSelected
              ),
        ],
      ),
    );
  }

  Widget peoplePage(BuildContext context) {
    Widget rightButtons;

    return Expanded(
      child: Column(
        spacing: 12,
        children: [
          Row(
            children: [
              const Spacer(),
              DoorSimpleButtonIcon(
                  AppLocalizations.of(context)!.addPerson,
                  Icons.add_circle_outlined,
                  () => widget._cAgentManagementWindow
                      .upsertPersonSelected(context, ""),
                  enabled: widget._model.isUserAgentAdmin()),
              DoorSimpleButtonIcon(
                AppLocalizations.of(context)!.filter,
                _personController.areFiltersApplied() ? Icons.filter_alt : Icons.filter_alt_outlined,
                () {
                  setFilters(_personController);
                }),
              const SizedBox(width: 50),
            ],
          ),
          Expanded(
            child: ParameterizedListView<XPerson>(
              controller: _personController,
              itemBuilder: (context, person, index) {
                rightButtons = Center(
                  child: DoorButtonColumn([
                    (
                      AppLocalizations.of(context)!.editPerson,
                      Icons.edit,
                      () => widget._cAgentManagementWindow
                          .upsertPersonSelected(context, person.identifier),
                      widget._model.isPersonEditableAndDeletable(person)
                    ),
                    (
                      AppLocalizations.of(context)!.openPerson,
                      Icons.remove_red_eye_sharp,
                      () => widget._cAgentManagementWindow
                          .openPersonDetails(context, person.identifier),
                      true
                    ),
                    (
                      AppLocalizations.of(context)!.deletePerson,
                      Icons.delete_forever,
                      () => widget._cAgentManagementWindow.deleteAgentSelected(context, person),
                      widget._model.isPersonEditableAndDeletable(person)
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
                          child: Image.asset("images/person.png"),
                        ),
                        Expanded(
                          child: Column(
                            spacing: 5,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              DoorText(
                                widget._model.getPersonName(person),
                                DoorTextStyle.main,
                              ),
                                  Wrap(
                                    spacing: 8.0,
                                    runSpacing: 2.0,
                                    children: widget._model
                                        .getPersonOrganizations(person)
                                        .map((organization) {
                                      return ConstrainedBox(
                                        constraints: BoxConstraints(
                                          maxWidth: 500),
                                        child: Chip(
                                        backgroundColor: DoorColor.lightEmph,
                                        side: const BorderSide(
                                            color: DoorColor.darkEmph),
                                        elevation: 4,
                                        label: DoorText(
                                          organization,
                                          DoorTextStyle.emph,
                                        ),
                                      ));
                                    }).toList(),
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

Widget usersPage(BuildContext context) {
  Widget rightButtons;

  //String getDropdownKey(XUserAccount user) {
  ///  String key = "${user.userId}-${widget._model.getUsersAgentIds().join("-")}---${widget._model.getAllowedPersonsForAccount(user).map((p) => p.identifier).toList().join("-")}";
  //  return key;
  //}

  return Expanded(
    child: Column(
      spacing: 12,
      children: [
        Row(
          children: [
            const Spacer(),
            DoorSimpleButtonIcon(
              AppLocalizations.of(context)!.addUser,
              Icons.add_circle_outlined,
              () {
                widget._cAgentManagementWindow.showUpsertUserSelected(context, "");
              },
            ),
            DoorSimpleButtonIcon(
              AppLocalizations.of(context)!.filter,
              _userController.areFiltersApplied() ? Icons.filter_alt : Icons.filter_alt_outlined,
              () {
                setFilters(_userController);
              }),
            const SizedBox(width: 50),
          ],
        ),
        Expanded(
          child: ParameterizedListView<XUserAccount>(
              controller: _userController,
              itemBuilder: (context, user, index) {

              rightButtons = Center(
                child: DoorButtonColumn([
                  (
                    AppLocalizations.of(context)!.saveChanges,
                    Icons.save,
                    () {
                      if (_formKey.currentState!.validate()) {
                        widget._cAgentManagementWindow.saveUserSelected(context, user);
                      }
                    },
                    true
                  ),
                  (
                    AppLocalizations.of(context)!.deleteUser,
                    Icons.delete_forever,
                    () {
                      widget._cAgentManagementWindow.deleteUserSelected(context, user);
                    },
                    true
                  ),
                ]),
              );

              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      spacing: 12,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Avatar / icon
                        SizedBox(
                          width: 80,
                          height: 80,
                          child: Image.asset("images/person.png"), // placeholder avatar
                        ),

                        // Middle content
                        Expanded(
                          child: Column(
                            spacing: 12,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DoorText(user.userId, DoorTextStyle.main),

                              // Roles section
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 4,
                                children: [
                                  DoorText("${AppLocalizations.of(context)!.roles}:", DoorTextStyle.emph),
                                  Wrap(
                                    spacing: 12,
                                    runSpacing: 4,
                                    children: [
                                      ...GlobalRole.values.map((role) {
                                        return DoorCheckboxChip(
                                          tooltip: AppLocalizations.of(context)!.assignRole,
                                          selected: user.roles.contains(role),
                                          label: role.name,
                                          onSelected: (val) {
                                            setState(() {
                                              // Update the user roles in the model
                                              if (val) {
                                                user.roles.add(role);
                                              } else {
                                                user.roles.remove(role);
                                              }
                                            });
                                          },
                                        );
                                      }).toList(),
                                    ],
                                  ),
                                ],
                              ),

                              // Connected Agent dropdown
                              SizedBox(
                                width: 300,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  spacing: 4,
                                  children: [
                                    DoorText(
                                      "${AppLocalizations.of(context)!.associatedAgent}:",
                                      DoorTextStyle.emph,
                                    ),
                                    DoorMultiDropdown<String>(
                                      key: ValueKey("agentDropdown-${user.userId}--${widget._model.getAllowedPersonsForAccountIds(user).join("-")}"),
                                      selectHint: AppLocalizations.of(context)!.noAgentSelected,
                                      items: widget._model.getAllowedPersonsForAccountItems(user),
                                      singleSelect: true,
                                      validator: (selected) {
                                        if (null != selected && selected.isNotEmpty 
                                          && widget._model.areAgentsDuplicated(selected.firstOrNull!.value)) {
                                            return AppLocalizations.of(context)!.agentAlreadyAssigned;
                                        }
                                        return null;
                                      },
                                      onSelectionChange: (selected) {
                                        setState(() {
                                          widget._model.assignAgentToUser(user, selected.firstOrNull);
                                        });
                                      },
                                    )
                            ]),
                          )],
                          ),
                        ),

                        // Right buttons
                        rightButtons,
                      ],
                    ),
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

  Widget organisationsPage(BuildContext context) {
    Widget rightButtons;

    return Expanded(
      child: Column(
        spacing: 12,
        children: [
          Row(
            children: [
              const Spacer(),
              DoorSimpleButtonIcon(
                  AppLocalizations.of(context)!.addOrganization,
                  Icons.add_circle_outlined,
                  () => widget._cAgentManagementWindow
                      .upsertOrganizationSelected(context, ""),
                  enabled: widget._model.isUserAgentAdmin()),
              DoorSimpleButtonIcon(
                AppLocalizations.of(context)!.filter,
                _orgController.areFiltersApplied() ? Icons.filter_alt : Icons.filter_alt_outlined,
                () {
                  setFilters(_orgController);
                }),
              const SizedBox(width: 50),
            ],
          ),
          Expanded(
            child: ParameterizedListView<XOrganization>(
              controller: _orgController,
              itemBuilder: (context, organization, index) {
                rightButtons = Center(
                  child: DoorButtonColumn([
                    (
                      AppLocalizations.of(context)!.editOrganization,
                      Icons.edit,
                      () => widget._cAgentManagementWindow
                          .upsertOrganizationSelected(context, organization.identifier),
                      widget._model.isOrganizationEditable(organization)
                    ),
                    (
                      AppLocalizations.of(context)!.openOrganization,
                      Icons.remove_red_eye_sharp,
                      () => widget._cAgentManagementWindow
                          .openOrganizationDetails(context, organization.identifier),
                      true
                    ),
                    (
                      AppLocalizations.of(context)!.deleteOrganization,
                      Icons.delete_forever,
                      () => widget._cAgentManagementWindow.deleteAgentSelected(context, organization),
                      widget._model.isOrganizationDeletable(organization)
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
                          child: Image.asset("images/organisation.png"),
                        ),
                        Expanded(
                          child: Column(
                            spacing: 5,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                                  DoorText(
                                    organization.name,
                                    DoorTextStyle.main,
                                  ),
                                  Column(
                                    spacing: 12,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      DoorText(
                                        organization.description ?? "",
                                        DoorTextStyle.norm,
                                      ),
                                      Row(
                                        spacing: 12,
                                        children: [
                                          DoorText(
                                            "${AppLocalizations.of(context)!.members}:",
                                            DoorTextStyle.emph,
                                          ),
                                          Chip(
                                            backgroundColor:
                                                DoorColor.lightEmph,
                                            side: const BorderSide(
                                                color: DoorColor.darkEmph),
                                            elevation: 4,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 2.0, vertical: 0.0),
                                            label: Text(
                                              widget._model
                                                  .getOrganizationMembersCount(organization),
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: DoorColor.black,
                                                height: 1.0,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
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
}

class VAgentManagementWindowFactory {
  const VAgentManagementWindowFactory();
  VAgentManagementWindow get(key, model) {
    return VAgentManagementWindow(key, new CAgentManagementWindow(model), model);
  }
}
