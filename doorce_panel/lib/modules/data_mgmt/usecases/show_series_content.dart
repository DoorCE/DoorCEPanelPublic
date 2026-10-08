import 'package:doorce_panel/common/utils/exception_handler.dart';
import 'package:doorce_panel/dtos/contact_data.dart';
import 'package:doorce_panel/dtos/dataset.dart';
import 'package:doorce_panel/dtos/dataset_series.dart';
import 'package:doorce_panel/dtos/dataset_theme.dart';
import 'package:doorce_panel/dtos/frequency.dart';
import 'package:doorce_panel/dtos/language.dart';
import 'package:doorce_panel/dtos/licence.dart';
import 'package:doorce_panel/common/view_elements/wait_message.dart';
import 'package:doorce_panel/modules/data_mgmt/view/presenters/p_series_content_window.dart';
import 'package:doorce_panel/services/agent_mgmt_api.dart';
import 'package:doorce_panel/services/dataset_mgmt_api.dart';
import 'package:doorce_panel/services/icon_api.dart';
import 'package:doorce_panel/services/vocabulary_mgmt_api.dart';
import 'package:flutter/material.dart';

abstract interface class IUCShowSeriesContent {
  closeSelected(BuildContext context);
  showSeriesContentSelected(BuildContext context, String identifier);
}

class UCShowSeriesContent with ExceptionHandler implements IUCShowSeriesContent {
  final IPSeriesContentWindow pSeriesDetailsWindow;
  final DatasetManagementAPI datasetManagement;
  final AgentManagementAPI agentManagement;
  final VocabularyManagementAPI vocabularyManagement;
  final IconAPI iconAPI;

  const UCShowSeriesContent(this.pSeriesDetailsWindow, this.datasetManagement, this.agentManagement,
      this.vocabularyManagement, this.iconAPI);

  @override
  closeSelected(BuildContext context) {
    pSeriesDetailsWindow.close(context);
  }

  @override
  showSeriesContentSelected(BuildContext context, String identifier) async {
    await tryForApiExceptions(context, () async {
      WaitMessage().show(context);
      String locale = Localizations.localeOf(context).languageCode;
      XDatasetSeries series = await datasetManagement.getSeries(identifier);
      if (null != series.iconUri) series.icon = await iconAPI.getIcon(series.iconUri);

      List<XContactData> seriesContactsResources =
          await agentManagement.getResourceContactData(identifier);
      List<Language> languageResources =
          await vocabularyManagement.getLanguages(locale);
      List<Licence> licenceResources =
          await vocabularyManagement.getLicences(locale);
      List<DatasetTheme> themeResources =
          await vocabularyManagement.getThemes(locale);
      List<Frequency> frequencyResources =
          await vocabularyManagement.getFrequencies(locale);
      List<XDataset> datasetResources =
          (await datasetManagement.getSeriesDatasetList(identifier));
      WaitMessage().dismiss();

      pSeriesDetailsWindow.show(context,series,seriesContactsResources,languageResources,
          datasetResources,licenceResources,themeResources,frequencyResources);
    });
  }
}
