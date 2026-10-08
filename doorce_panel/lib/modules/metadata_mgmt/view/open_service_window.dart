import 'package:doorce_panel/common/view_elements/button.dart';
import 'package:doorce_panel/common/view_elements/style.dart';
import 'package:doorce_panel/common/view_elements/text.dart';
import 'package:doorce_panel/modules/metadata_mgmt/view/controllers/c_open_service_window.dart';
import 'package:doorce_panel/modules/metadata_mgmt/view/viewmodel/m_open_service_window.dart';
import 'package:flutter/material.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';

class VOpenServiceWindow extends StatelessWidget {
  final MOpenServiceWindow _model;
  final COpenServiceWindow _cServicesContentWindow;

  const VOpenServiceWindow(this._cServicesContentWindow, this._model,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 12, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBreadcrumb(context),
          seriesContentPage(context),
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
            onTap: () => _cServicesContentWindow.homeSelected(context),
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
                _cServicesContentWindow.showCataloguesSelected(context, ""),
            child: DoorText(AppLocalizations.of(context)!.cataloguing,
                DoorTextStyle.breadcrumbActive),
          ),
        )),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Icon(Icons.chevron_right, color: DoorColor.grey),
        ),
        Flexible(child: DoorText(_model.getServicesTitle(), DoorTextStyle.breadcrumb)),
      ],
    );
  }

  Widget seriesContentPage(BuildContext context) {
    Widget rightButtons;

    return Expanded(
      child: Column(
        spacing: 12,
        children: [
          Row(
            children: [
              const Spacer(),
              DoorSimpleButtonIcon(AppLocalizations.of(context)!.addDistribution,
                  Icons.add_circle_outlined, () => {}),
              // DoorSimpleButtonIcon(AppLocalizations.of(context)!.filter, Icons.filter_alt, () => {}),
              const SizedBox(width: 50),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _model.getDistributionResourceListLength(),
              itemBuilder: (context, index) {
                var identifier =
                    _model.getDistributionResourceIdentifier(index);
                rightButtons = Center(
                  child: DoorButtonColumn([
                    (
                      AppLocalizations.of(context)!.openDistribution,
                      Icons.edit,
                      () => {_cServicesContentWindow.distributionContentSelected(context, identifier)},
                      true
                    ),
                    /*(
                      AppLocalizations.of(context)!.listVersions,
                      Icons.edit,
                      () => {}
                    )*/ 
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
                          child: null == _model.getDistributionResourceIcon(index) ?
                            Image.asset("images/distribution.png") :
                            Image.memory(_model.getDistributionResourceIcon(index)!)
                        ),
                        Expanded(
                          child: Column(
                            spacing: 5,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              DoorText(
                                _model.getDistributionResourceTitle(context, index),
                                DoorTextStyle.main,
                              ),
                              DoorText(
                                _model.getDistributionResourceParams(context, index),
                                DoorTextStyle.emph,
                              ),
                              DoorText(
                                _model.getDistributionResourceDescription(context, index),
                                DoorTextStyle.norm,
                              ),
                              // Chip(
                              //   backgroundColor: DoorColor.lightEmph,
                              //   side:
                              //       const BorderSide(color: DoorColor.darkEmph),
                              //   elevation: 4,
                              //   label: DoorText(
                              //     displayText.$4,
                              //     DoorTextStyle.emph,
                              //   ),
                              // ),
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

class VOpenServiceWindowFactory {
  const VOpenServiceWindowFactory();

  VOpenServiceWindow get(model) =>
      VOpenServiceWindow(new COpenServiceWindow(model), model);
}
