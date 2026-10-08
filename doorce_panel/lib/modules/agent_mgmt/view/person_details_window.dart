import 'package:doorce_panel/common/view_elements/button.dart';
import 'package:doorce_panel/common/view_elements/style.dart';
import 'package:doorce_panel/common/view_elements/text.dart';
import 'package:doorce_panel/modules/agent_mgmt/view/controllers/c_person_details_window.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';
import 'package:doorce_panel/modules/agent_mgmt/view/viewmodel/m_person_details_window.dart';
import 'package:flutter/material.dart';

class VPersonDetailsWindow extends StatelessWidget {
  final MPersonDetailsWindow _model;
  final CPersonDetailsWindow _cPersonDetailsWindow;

  const VPersonDetailsWindow(this._cPersonDetailsWindow, this._model,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBreadcrumb(context),
            DoorText(AppLocalizations.of(context)!.openPerson,
                DoorTextStyle.titleBlack),
            _buildPersonDetails(context),
            const Divider(),
            _buildContactSection(context),
            const Divider(),
            _buildOrganizationsSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBreadcrumb(BuildContext context) {
    return Row(
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => _cPersonDetailsWindow.homeSelected(context),
            child: DoorText(AppLocalizations.of(context)!.mainMenu,
                DoorTextStyle.breadcrumbActive),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Icon(Icons.chevron_right, color: DoorColor.grey),
        ),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => _cPersonDetailsWindow.agentManagementSelected(context),
            child: DoorText(AppLocalizations.of(context)!.agentManagement,
                DoorTextStyle.breadcrumbActive),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Icon(Icons.chevron_right, color: DoorColor.grey),
        ),
        Flexible(child: DoorText(_model.getPersonName(), DoorTextStyle.breadcrumb)),
      ],
    );
  }

  Widget _buildPersonDetails(BuildContext context) {
    return Column(
      spacing: 12,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            DoorText(AppLocalizations.of(context)!.personalInformations,
                DoorTextStyle.titleBlack),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: DoorColor.lightEmph,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: DoorColor.darkEmph, width: 1),
          ),
          child: Column(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                spacing: 2,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 3,
                    child: Column(
                      spacing: 4,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DoorText(
                          AppLocalizations.of(context)!.personName,
                          DoorTextStyle.label,
                        ),
                        DoorText(
                          _model.getPersonGivenName(),
                          DoorTextStyle.norm,
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    child: Column(
                      spacing: 4,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DoorText(
                          AppLocalizations.of(context)!.familyName,
                          DoorTextStyle.label,
                        ),
                        DoorText(
                          _model.getPersonFamilyName(),
                          DoorTextStyle.norm,
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    child: Column(
                      spacing: 4,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DoorText(
                          AppLocalizations.of(context)!.identifier,
                          DoorTextStyle.label,
                        ),
                        DoorText(
                          _model.getPersonIdentifier(),
                          DoorTextStyle.norm,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 5,
                    child: Column(
                      spacing: 4,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DoorText(
                          AppLocalizations.of(context)!.otherNames,
                          DoorTextStyle.label,
                        ),
                        DoorText(
                          _model.getPersonGivenNames().join(' | '),
                          DoorTextStyle.norm,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DoorText(
                      AppLocalizations.of(context)!.manager,
                      DoorTextStyle.label,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      //children: _model.getPersonManagedOrganizations().map((manager) {
                        //return Chip(
                          //label: DoorText(
                            //manager,
                            //DoorTextStyle.reverse,
                          //),
                          //backgroundColor: DoorColor.darkEmph,
                        //);
                      //}).toList(),
                    ),
                  ],
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

  Widget _buildContactSection(BuildContext context) {
    return Column(
      spacing: 12,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 8,
          children: [
            DoorText(AppLocalizations.of(context)!.contacts,
                DoorTextStyle.titleBlack),
          ],
        ),
        Table(
          columnWidths: const {
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(3),
          },
          border: TableBorder.all(color: DoorColor.darkEmph, width: 1),
          children: [
            TableRow(
              decoration: const BoxDecoration(color: DoorColor.lightEmph),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DoorText(
                    AppLocalizations.of(context)!.contactName,
                    DoorTextStyle.label,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DoorText(
                    AppLocalizations.of(context)!.contacts,
                    DoorTextStyle.label,
                  ),
                ),
              ],
            ),
            ...List.generate(
              _model.getContactDataListLenght(),
              (index) {
                final contactData = _model.getContactDataResource(index);
                return TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DoorText(
                        contactData.name,
                        DoorTextStyle.norm,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DoorText(
                        contactData.contents,
                        DoorTextStyle.norm,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOrganizationsSection(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    bool isScrolling = false;

    void scrollContinuously(double offset) async {
      while (isScrolling && scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.offset + offset,
          duration: const Duration(milliseconds: 100),
          curve: Curves.linear,
        );
        await Future.delayed(const Duration(milliseconds: 50));
      }
    }

    void scrollOnce(double offset) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.offset + offset,
          duration: const Duration(milliseconds: 300),
          curve: Curves.linear,
        );
      }
    }

    void startScrolling(double offset) {
      isScrolling = true;
      scrollContinuously(offset);
    }

    void stopScrolling() {
      isScrolling = false;
    }

    return Column(
      spacing: 12,
      children: [
        Row(
          children: [
            DoorText(AppLocalizations.of(context)!.organisations,
                DoorTextStyle.titleBlack),
            const Spacer(),
          ],
        ),
        Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
            color: DoorColor.lightEmph,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              spacing: 4,
              children: [
                Row(
                  children: [
                    const Spacer(),
                    GestureDetector(
                      onTapDown: (_) => startScrolling(-50),
                      onTapUp: (_) => stopScrolling(),
                      onTapCancel: stopScrolling,
                      child: DoorSimpleButtonIcon(
                        AppLocalizations.of(context)!.back,
                        Icons.arrow_back,
                        () => scrollOnce(-150),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTapDown: (_) => startScrolling(50),
                      onTapUp: (_) => stopScrolling(),
                      onTapCancel: stopScrolling,
                      child: DoorSimpleButtonIcon(
                        AppLocalizations.of(context)!.forward,
                        Icons.arrow_forward,
                        () => scrollOnce(150),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    controller: scrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: _model.getPersonOrganizationsListLenght(),
                    itemBuilder: (context, index) {
                      final organizationIdentifier =
                          _model.getPersonOrganizationsIdentifier(index);
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            minWidth: 180,
                          ),
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(8),
                              onTap: () {
                                _cPersonDetailsWindow
                                    .showOrganizationDetailsSelected(
                                        context, organizationIdentifier);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.people_rounded,
                                      size: 48,
                                      color: DoorColor.darkEmph,
                                    ),
                                    const SizedBox(height: 8),
                                    DoorText(
                                      _model.getPersonOrganizationsName(index),
                                      DoorTextStyle.norm,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class VPersonDetailsWindowFactory {
  const VPersonDetailsWindowFactory();
  VPersonDetailsWindow get(model) =>
      VPersonDetailsWindow(new CPersonDetailsWindow(model), model);
}
