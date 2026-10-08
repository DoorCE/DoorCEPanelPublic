import 'package:doorce_panel/common/view_elements/button.dart';
import 'package:doorce_panel/common/view_elements/style.dart';
import 'package:doorce_panel/common/view_elements/text.dart';
import 'package:doorce_panel/modules/agent_mgmt/view/controllers/c_organization_details_window.dart';
import 'package:doorce_panel/modules/agent_mgmt/view/viewmodel/m_organization_details_window.dart';
import 'package:flutter/material.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';

class VOrganizationDetailsWindow extends StatelessWidget {
  final MOrganizationDetailsWindow _model;
  final COrganizationDetailsWindow _cOrganizationDetailsWindow;
  const VOrganizationDetailsWindow(
      this._cOrganizationDetailsWindow, this._model,
      {super.key});

  // @override
  // Widget build(BuildContext context) {
  //   return SingleChildScrollView(
  //     padding: const EdgeInsets.all(16.0),
  //     child: Column(
  //       spacing: 20,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         _buildBreadcrumb(context),
  //         DoorText(
  //           AppLocalizations.of(context)!.openOrganization,
  //           DoorTextStyle.titleBlack,
  //         ),
  //         _organizationDetails(context),
  //       ],
  //     ),
  //   );
  // }

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
            DoorText(AppLocalizations.of(context)!.openOrganization,
                DoorTextStyle.titleBlack),
            _buildOrganizationDetails(context),
            const Divider(),
            _buildContactSection(context),
            const Divider(),
            _buildMembersSection(context),
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
            onTap: () => _cOrganizationDetailsWindow.homeSelected(context),
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
            onTap: () =>
                _cOrganizationDetailsWindow.agentManagementSelected(context),
            child: DoorText(AppLocalizations.of(context)!.agentManagement,
                DoorTextStyle.breadcrumbActive),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Icon(Icons.chevron_right, color: DoorColor.grey),
        ),
        Flexible(child: DoorText(_model.getOrganizationName(), DoorTextStyle.breadcrumb)),
      ],
    );
  }

  Widget _buildOrganizationDetails(BuildContext context) {
    return Container(
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DoorText(
                      AppLocalizations.of(context)!.orgName,
                      DoorTextStyle.label,
                    ),
                    const SizedBox(height: 4),
                    DoorText(
                      _model.getOrganizationName(),
                      DoorTextStyle.norm,
                    ),
                  ],
                ),
              ),
              Flexible(flex: 1, child: Container()),
              Flexible(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DoorText(
                      AppLocalizations.of(context)!.identifier,
                      DoorTextStyle.label,
                    ),
                    const SizedBox(height: 4),
                    DoorText(
                      _model.getOrganizationIdentifier(),
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
                      AppLocalizations.of(context)!.description,
                      DoorTextStyle.label,
                    ),
                    const SizedBox(height: 4),
                    DoorText(
                      _model.getOrganizationDescription() ?? '',
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
                      AppLocalizations.of(context)!.managers,
                      DoorTextStyle.label,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      //children: _model.getOrganizationManagers().map((manager) {
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

  Widget _buildMembersSection(BuildContext context) {
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
            DoorText(AppLocalizations.of(context)!.members,
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
                    itemCount: _model.getMembersResourceListLenght(),
                    itemBuilder: (context, index) {
                      final memberIdentifier =
                          _model.getMembersIdentifier(index);
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
                                _cOrganizationDetailsWindow
                                    .showPersonDetailsSelected(
                                        context, memberIdentifier);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.account_circle,
                                      size: 48,
                                      color: DoorColor.darkEmph,
                                    ),
                                    const SizedBox(height: 8),
                                    DoorText(
                                      _model.getMembersName(index),
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

class VOrganizationDetailsWindowFactory {
  const VOrganizationDetailsWindowFactory();
  VOrganizationDetailsWindow get(model) =>
      VOrganizationDetailsWindow(new COrganizationDetailsWindow(model), model);
}
