import 'package:doorce_panel/common/types/global_role.dart';
import 'package:doorce_panel/common/view_elements/button.dart';
import 'package:doorce_panel/common/view_elements/chips.dart';
import 'package:doorce_panel/common/view_elements/door_dropdown.dart';
import 'package:doorce_panel/common/view_elements/style.dart';
import 'package:doorce_panel/common/view_elements/text.dart';
import 'package:doorce_panel/modules/agent_mgmt/view/controllers/c_upsert_user_window.dart';
import 'package:doorce_panel/modules/agent_mgmt/view/viewmodel/m_upsert_user_window.dart';
import 'package:flutter/material.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';

class VUpsertUserWindow extends StatefulWidget {
  final CUpsertUserWindow _cUpsertUserWindow;
  final MUpsertUserWindow _model;

  const VUpsertUserWindow(GlobalKey? key, this._cUpsertUserWindow, this._model)
      : super(key: key);

  @override
  State<VUpsertUserWindow> createState() => VUpsertUserWindowState();
}

class VUpsertUserWindowState extends State<VUpsertUserWindow> {
  final _formKey = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    widget._model.checkAndUpdateIsInsert();
  }

  void _refreshAvailableAccountIds(String query) async {
    await widget._cUpsertUserWindow.accountIdsSearchQueryChanged(context, query);
  }

  void refresh() {
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    String title = widget._model.isInsert
        ? AppLocalizations.of(context)!.addUser
        : AppLocalizations.of(context)!.editUser;

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
              _buildUserInformationSection(),
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
        GestureDetector(
          onTap: () => widget._cUpsertUserWindow.homeSelected(context),
          child: DoorText(AppLocalizations.of(context)!.mainMenu,
              DoorTextStyle.breadcrumbActive),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Icon(Icons.chevron_right, color: DoorColor.grey),
        ),
        Flexible(
          child: GestureDetector(
            onTap: () =>
                widget._cUpsertUserWindow.agentManagementSelected(context),
            child: DoorText(AppLocalizations.of(context)!.agentManagement,
                DoorTextStyle.breadcrumbActive),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Icon(Icons.chevron_right, color: DoorColor.grey),
        ),
        Flexible(child: DoorText(title, DoorTextStyle.breadcrumb)),
      ],
    );
  }

  Widget _buildUserInformationSection() {
    return Column(
      spacing: 16,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        DoorText(AppLocalizations.of(context)!.userInformation,
            DoorTextStyle.titleBlack),

        // User ID
        Column(
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DoorText("${AppLocalizations.of(context)!.identifier} *",
                DoorTextStyle.label),
            DoorMultiDropdown<String>(
              items: widget._model.getAvailableAccountIdsItems(),
              enabled: widget._model.isInsert,
              singleSelect: true,
              searchEnabled: true,
              onSearchChange: (query) => _refreshAvailableAccountIds(query), 
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.fieldRequired;
                }
                return null;
              },
              onSelectionChange: (val) {
                setState(() {
                  widget._model.user.userId = val.firstOrNull ?? "";
                });
              },
            ),
          ],
        ),

        // Roles
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              DoorText(AppLocalizations.of(context)!.roles,
                  DoorTextStyle.label),
              Wrap(
                spacing: 12,
                children: [
                  ...GlobalRole.values.map((role) {
                    return DoorCheckboxChip(
                      tooltip: AppLocalizations.of(context)!.assignRole,
                      selected: widget._model.user.roles.contains(role),
                      label: role.name,
                      onSelected: (val) {
                        setState(() {
                          if (val) {
                            widget._model.user.roles.add(role);
                          } else {
                            widget._model.user.roles.remove(role);
                          }
                        });
                      },
                    );
                  }).toList(),
                ],
              ),
            ],
          ),
        ),

        // Connected Agent
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              DoorText(AppLocalizations.of(context)!.agent,
                  DoorTextStyle.label),
              DoorMultiDropdown<String>(
                selectHint: AppLocalizations.of(context)!.selectAgent,
                items: widget._model.getAllowedPersonsForAccount(),
                singleSelect: true,
                onSelectionChange: (selected) {
                  setState(() {
                    widget._model.user.personUri =
                        selected.isNotEmpty ? selected.first : null;
                  });
                },
              ),
            ],
          ),
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
                  await widget._cUpsertUserWindow.saveSelected(context);
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
                await widget._cUpsertUserWindow.cancelSelected(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class VUpsertUserWindowFactory {
  const VUpsertUserWindowFactory();
  VUpsertUserWindow get(key, model) {
    return VUpsertUserWindow(key, CUpsertUserWindow(model), model);
  }
}