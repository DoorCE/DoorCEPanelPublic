import 'package:doorce_panel/common/utils/exception_handler.dart';
import 'package:doorce_panel/dtos/app.dart';
import 'package:doorce_panel/dtos/concept.dart';
import 'package:doorce_panel/dtos/contact_data.dart';
import 'package:doorce_panel/dtos/data_schema.dart';
import 'package:doorce_panel/dtos/dataset.dart';
import 'package:doorce_panel/dtos/dataset_theme.dart';
import 'package:doorce_panel/dtos/distribution.dart';
import 'package:doorce_panel/dtos/frequency.dart';
import 'package:doorce_panel/dtos/language.dart';
import 'package:doorce_panel/dtos/licence.dart';
import 'package:doorce_panel/common/view_elements/wait_message.dart';
import 'package:doorce_panel/modules/data_mgmt/view/presenters/p_dataset_content_window.dart';
import 'package:doorce_panel/services/agent_mgmt_api.dart';
import 'package:doorce_panel/services/app_mgmt.dart';
import 'package:doorce_panel/services/data_upload_api.dart';
import 'package:doorce_panel/services/dataset_mgmt_api.dart';
import 'package:doorce_panel/services/icon_api.dart';
import 'package:doorce_panel/services/schema_mgmt_api.dart';
import 'package:doorce_panel/services/vocabulary_mgmt_api.dart';
import 'package:flutter/material.dart';

abstract interface class IUCShowDatasetContent {
  closeSelected(BuildContext context);
  showDatasetContentSelected(BuildContext context, String identifier);
}

class UCShowDatasetContent with ExceptionHandler implements IUCShowDatasetContent {
  final IPDatasetContentWindow pDatasetContentWindow;
  final DatasetManagementAPI datasetManagement;
  final AgentManagementAPI agentManagement;
  final VocabularyManagementAPI vocabularyManagement;
  final IconAPI iconAPI;
  final SchemaAPI schemaAPI;
  final DataUploadAPI dataUploadAPI;
  final AppManagementAPI appManagement;

  const UCShowDatasetContent(this.pDatasetContentWindow, this.datasetManagement, this.agentManagement,
      this.vocabularyManagement, this.iconAPI, this.schemaAPI, this.dataUploadAPI, this.appManagement);
  @override
  closeSelected(BuildContext context) {
    pDatasetContentWindow.close(context);
  }

  @override
  showDatasetContentSelected(BuildContext context, String identifier) async {
    await tryForApiExceptions(context, () async {
      WaitMessage().show(context);
      String locale = Localizations.localeOf(context).languageCode;
      XDataset datasetResources = await datasetManagement.getDataset(identifier);
      if (null != datasetResources.iconUri) datasetResources.icon = await iconAPI.getIcon(datasetResources.iconUri);

      List<XContactData> datasetContactsResources =
          await agentManagement.getResourceContactData(identifier);
      List<Language> languageResources =
          await vocabularyManagement.getLanguages(locale);
      List<Licence> licenceResources =
          await vocabularyManagement.getLicences(locale);
      List<DatasetTheme> themeResources =
          await vocabularyManagement.getThemes(locale);
      List<Frequency> frequencyResources =
          await vocabularyManagement.getFrequencies(locale);
      List<XDistribution> distributionResources =
          await datasetManagement.getDatasetDistributionList(identifier);
      List<XApp> datasetApps = await appManagement.getDatasetApps(identifier);
      XApp? defaultApp = await appManagement.getDatasetDefaultApp(identifier);

      List<XConcept> concepts = [];
      if (null != datasetResources.schemaID && datasetResources.schemaID!.isNotEmpty) {
        XDataSchema schema = await schemaAPI.getDataSchema(datasetResources.schemaID!);
        concepts = schema.concepts;
      }
      Map<String, int> conceptSummaries = await dataUploadAPI.getDataItemCounts(identifier);
      WaitMessage().dismiss();

      pDatasetContentWindow.show(context,datasetResources,datasetContactsResources,languageResources,
          distributionResources,licenceResources,themeResources,frequencyResources,conceptSummaries, concepts, datasetApps, defaultApp);
    });
  }
}
