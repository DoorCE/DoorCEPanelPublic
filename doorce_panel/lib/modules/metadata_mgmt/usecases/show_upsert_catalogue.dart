import 'dart:typed_data';

import 'package:doorce_panel/common/utils/exception_handler.dart';
import 'package:doorce_panel/common/view_elements/file_picker.dart';
import 'package:doorce_panel/dtos/agent.dart';
import 'package:doorce_panel/dtos/catalogue.dart';
import 'package:doorce_panel/dtos/contact_data.dart';
import 'package:doorce_panel/dtos/icon_data.dart';
import 'package:doorce_panel/dtos/language.dart';
import 'package:doorce_panel/dtos/organization.dart';
import 'package:doorce_panel/dtos/person.dart';
import 'package:doorce_panel/dtos/user_account.dart';
import 'package:doorce_panel/common/view_elements/snack_message.dart';
import 'package:doorce_panel/common/view_elements/wait_message.dart';
import 'package:doorce_panel/modules/metadata_mgmt/view/presenters/p_upsert_catalogue_window.dart';
import 'package:doorce_panel/services/agent_mgmt_api.dart';
import 'package:doorce_panel/services/dataset_mgmt_api.dart';
import 'package:doorce_panel/services/icon_api.dart';
import 'package:doorce_panel/services/vocabulary_mgmt_api.dart';
import 'package:flutter/material.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';
import 'package:http/http.dart';

abstract interface class IUCShowUpsertCatalogue {
  showUpsertCatalogueSelected(BuildContext context, String? identifier, [String? parentId, bool? isPreview]);
  Future<void> contactSourcesChanged(List<String> agentIds);
  Future<void> upsertCatalogue(BuildContext context, XCatalogue xCatalogue,
      List<XContactData> newContacts, bool isInsert);
  closeSelected(BuildContext context);
  void pickIconSelected(BuildContext context);
}

class UCShowUpsertCatalogue with ExceptionHandler implements IUCShowUpsertCatalogue {
  final IPUpsertCatalogueWindow _pUpsertCatalogueWindow;
  final DatasetManagementAPI _datasetManagement;
  final VocabularyManagementAPI _vocabularyManagement;
  final AgentManagementAPI _agentManagement;
  final IconAPI _iconAPI;

  const UCShowUpsertCatalogue(this._pUpsertCatalogueWindow, this._datasetManagement, this._vocabularyManagement,
      this._agentManagement, this._iconAPI);

  @override
  showUpsertCatalogueSelected(BuildContext context, String? identifier, [String? parentId, bool? isPreview]) async {
    await tryForApiExceptions(context, () async {
      WaitMessage().show(context);

      String locale = Localizations.localeOf(context).languageCode;
      List<XPerson> peopleResources = await _agentManagement.getPersons("");
      List<XOrganization> organizationResources = await _agentManagement.getOrganizations("");
      List<XCatalogue> agentCatalogsResources;
      List<Language> languageResources = await _vocabularyManagement.getLanguages(locale);
      XUserAccount currentUserAccount = await _agentManagement.getCurrentUserAccount();
      XAgent? currentAgent = await _agentManagement.getCurrentAgent();

      List<XContactData> existingContactResources = [];

      XCatalogue catalogue;
      if (identifier == null || identifier.isEmpty) {
        agentCatalogsResources = await _datasetManagement.getAllowedCatalogues(null);

        catalogue = XCatalogue.forInsert(); // sets user roles
        catalogue.parentID = parentId ?? null;

      } else {
        catalogue = await _datasetManagement.getCatalog(identifier);
        existingContactResources = await _agentManagement.getResourceContactData(identifier);
        if (null != catalogue.iconUri) catalogue.icon = await _iconAPI.getIcon(catalogue.iconUri);

        agentCatalogsResources = await _datasetManagement.getAllowedCatalogues(catalogue.identifier);

      }
      WaitMessage().dismiss();

      _pUpsertCatalogueWindow.show(context,catalogue,languageResources,agentCatalogsResources,peopleResources,
          organizationResources,existingContactResources,currentUserAccount,currentAgent, isPreview);
    });
  }

  @override
  Future<void> contactSourcesChanged(List<String> agentIds) async {
    // TODO - update for tryForApiExceptions
    List<XContactData> agentContacts = await _datasetManagement.getMultipleAgentContacts(agentIds);
    _pUpsertCatalogueWindow.refreshContactResources(agentContacts);
  }

  @override
  Future<void> upsertCatalogue(BuildContext context, XCatalogue xCatalogue, List<XContactData> newContacts, bool isInsert) async {
    await tryForApiExceptions(context, () async {
      if (isInsert && !await _datasetManagement.checkCatalogueId(xCatalogue.identifier)){
        SnackMessage().show(context, true, text: AppLocalizations.of(context)!.invalidIdentifier);
        return;
      }
      Response response = await _datasetManagement.upsertCatalogue(xCatalogue, newContacts);
      int code = response.statusCode;

      if (code == 200) {
        SnackMessage().show(context, false, text: AppLocalizations.of(context)!.catalogueUpdated);
      } else if (code == 403) {
        SnackMessage().show(context, true, text: AppLocalizations.of(context)!.authError);
      } else {SnackMessage().show(context, true, text: AppLocalizations.of(context)!.catalogueError);}

      _pUpsertCatalogueWindow.refreshIsInsert(code);
      _pUpsertCatalogueWindow.refreshUserRoles(code);
    });
  }

  @override
  closeSelected(BuildContext context) {
    _pUpsertCatalogueWindow.close(context);
  }

  @override
  void pickIconSelected(BuildContext context) async {
    await tryForApiExceptions(context, () async {
      List<XIconData> icons = await _iconAPI.getIconList('');
      List<(XIconData,Uint8List?)> fullIcons = [];
      for (XIconData icon in icons){
        Uint8List? file = await _iconAPI.getIcon(icon.iconUri);
        fullIcons.add((icon,file));
      }

      XIconData? newIcon;
      Uint8List? newIconFile;

      await showIconPickerDialog(context, fullIcons,
        ({required XIconData? icon, iconBytes}) {
          if (null == icon) return;
          newIconFile = iconBytes;
          newIcon = icon;
        }
      );
      if (null != newIcon) {
        if (null == newIcon?.iconUri) {
          newIcon!.iconUri ??= "doorce/${newIcon!.iconName!.toLowerCase().replaceAll(" ", "-")}";
          await _iconAPI.upsertIcon(newIcon!, newIconFile!);
        }
        _pUpsertCatalogueWindow.refreshIcon(newIcon!.iconUri!, newIconFile!);
    }
    });
  }
}
