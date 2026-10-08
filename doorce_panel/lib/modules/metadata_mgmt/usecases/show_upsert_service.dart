import 'dart:typed_data';

import 'package:doorce_panel/common/utils/exception_handler.dart';
import 'package:doorce_panel/common/view_elements/file_picker.dart';
import 'package:doorce_panel/dtos/agent.dart';
import 'package:doorce_panel/dtos/catalogue.dart';
import 'package:doorce_panel/dtos/contact_data.dart';
import 'package:doorce_panel/dtos/dataset_service.dart';
import 'package:doorce_panel/dtos/dataset_theme.dart';
import 'package:doorce_panel/dtos/icon_data.dart';
import 'package:doorce_panel/dtos/language.dart';
import 'package:doorce_panel/dtos/licence.dart';
import 'package:doorce_panel/dtos/organization.dart';
import 'package:doorce_panel/dtos/person.dart';
import 'package:doorce_panel/dtos/user_account.dart';
import 'package:doorce_panel/common/view_elements/snack_message.dart';
import 'package:doorce_panel/common/view_elements/wait_message.dart';
import 'package:doorce_panel/modules/metadata_mgmt/view/presenters/p_upsert_service_window.dart';
import 'package:doorce_panel/services/agent_mgmt_api.dart';
import 'package:doorce_panel/services/icon_api.dart';
import 'package:doorce_panel/services/vocabulary_mgmt_api.dart';
import 'package:doorce_panel/services/dataset_mgmt_api.dart';
import 'package:flutter/material.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';
import 'package:http/http.dart';

abstract interface class IUCShowUpsertService {
  showUpsertServiceSelected(BuildContext context, String? identifier, String? parent, [bool? isPreview]);
  Future<void> upsertService(BuildContext context, XDatasetService xDatasetService, List<XContactData> newContacts, bool isInsert);
  closeSelected(BuildContext context);
  void pickIconSelected(BuildContext context);
  Future<void> contactSourcesChanged(List<String> agentIds);
}

class UCShowUpsertService with ExceptionHandler implements IUCShowUpsertService {
  final IPUpsertServiceWindow _pUpsertServiceWindow;
  final DatasetManagementAPI _datasetManagement;
  final VocabularyManagementAPI _vocabularyManagement;
  final AgentManagementAPI _agentManagement;
  final IconAPI _iconAPI;

  const UCShowUpsertService(this._datasetManagement, this._pUpsertServiceWindow, this._vocabularyManagement,
      this._agentManagement, this._iconAPI);

  @override
  showUpsertServiceSelected(BuildContext context, String? identifier, String? parent, [bool? isPreview]) async {
    await tryForApiExceptions(context, () async {
      WaitMessage().show(context);
      String locale = Localizations.localeOf(context).languageCode;
      List<XPerson> peopleResources = await _agentManagement.getPersons("");
      List<XOrganization> organizationResources = await _agentManagement.getOrganizations("");
      List<XCatalogue> agentCatalogsResources;
      List<Language> languageResources = await _vocabularyManagement.getLanguages(locale);
      List<Licence> licenceResources = await _vocabularyManagement.getLicences(locale);
      List<DatasetTheme> themeResources = await _vocabularyManagement.getThemes(locale);
      List<String> formatResources = await _vocabularyManagement.getFormatMediaTypes("");
      XUserAccount currentUserAccount = await _agentManagement.getCurrentUserAccount();
      XAgent? currentAgent = await _agentManagement.getCurrentAgent();

      List<XContactData> existingContactResources = [];

      XDatasetService datasetService;
      if (identifier == null || identifier.isEmpty) {
        datasetService = XDatasetService.forInsert();
        datasetService.catalogueID = parent!;
        agentCatalogsResources = await _datasetManagement.getAllowedCatalogues(null);
      } else {
        datasetService = await _datasetManagement.getDataService(identifier);
        existingContactResources = await _agentManagement.getResourceContactData(identifier);
        if (null != datasetService.iconUri) datasetService.icon = await _iconAPI.getIcon(datasetService.iconUri);
        agentCatalogsResources = await _datasetManagement.getAllowedCatalogues(datasetService.identifier);
      }

      WaitMessage().dismiss();

      _pUpsertServiceWindow.show(context, datasetService, languageResources, licenceResources, themeResources,
          agentCatalogsResources, peopleResources, organizationResources, formatResources, existingContactResources,
          currentUserAccount, currentAgent, isPreview);
    });
  }

  @override
  closeSelected(BuildContext context) {
    _pUpsertServiceWindow.close(context);
  }

  @override
  Future<void> upsertService(BuildContext context, XDatasetService xDatasetService, List<XContactData> newContacts, bool isInsert) async {
    await tryForApiExceptions(context, () async {
      if (isInsert && !await _datasetManagement.checkDataServiceId(xDatasetService.identifier)){
        SnackMessage().show(context, true, text: AppLocalizations.of(context)!.invalidIdentifier);
        return;
      }
      Response response = await _datasetManagement.upsertService(xDatasetService, newContacts);
      int code = response.statusCode;

      if (code == 200) {
        SnackMessage().show(context, false, text: AppLocalizations.of(context)!.serviceUpdated);
      } else if (code == 403) {
        SnackMessage().show(context, true, text: AppLocalizations.of(context)!.authError);
      } else {SnackMessage().show(context, true, text: AppLocalizations.of(context)!.serviceError);}

      _pUpsertServiceWindow.refreshIsInsert(code);
      _pUpsertServiceWindow.refreshUserRoles(code);
    });
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
        _pUpsertServiceWindow.refreshIcon(newIcon!.iconUri!, newIconFile!);
      }
    });
  }

  @override
  Future<void> contactSourcesChanged(List<String> agentIds) async {
    // TODO - update for tryForApiExceptions
    List<XContactData> agentContacts = await _datasetManagement.getMultipleAgentContacts(agentIds);
    _pUpsertServiceWindow.refreshContactResources(agentContacts);
  }
}
