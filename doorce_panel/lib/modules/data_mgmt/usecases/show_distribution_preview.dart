import 'dart:typed_data';

import 'package:doorce_panel/common/utils/exception_handler.dart';
import 'package:doorce_panel/dtos/distribution.dart';
import 'package:doorce_panel/dtos/language.dart';
import 'package:doorce_panel/common/view_elements/wait_message.dart';
import 'package:doorce_panel/modules/data_mgmt/view/presenters/p_distribution_preview_window.dart';
import 'package:doorce_panel/services/dataset_mgmt_api.dart';
import 'package:doorce_panel/services/storage_api.dart';
import 'package:doorce_panel/services/vocabulary_mgmt_api.dart';
import 'package:flutter/material.dart';

abstract interface class IUCShowDistributionPreview {
  closeSelected(BuildContext context);
  showDistributionContentSelected(BuildContext context, String identifier, [bool pathFromMetadataMgmt = true]);
}

class UCShowDistributionPreview with ExceptionHandler implements IUCShowDistributionPreview {
  final IPDistributionPreviewWindow _pDistributionContentWindow;
  final DatasetManagementAPI _datasetManagement;
  final VocabularyManagementAPI _vocabularyManagement;
  final StorageAPI _storageAPI;

  const UCShowDistributionPreview(this._pDistributionContentWindow,
      this._datasetManagement, this._vocabularyManagement, this._storageAPI);

  @override
  closeSelected(BuildContext context) {
    _pDistributionContentWindow.close(context);
  }

  @override
  showDistributionContentSelected(BuildContext context, String identifier, [bool pathFromMetadataMgmt = true]) async {
    await tryForApiExceptions(context, () async {      
      WaitMessage().show(context);
      String locale = Localizations.localeOf(context).languageCode;
      XDistribution distributionResource = await _datasetManagement.getDistribution(identifier);
      Uint8List? fileContent = await _storageAPI.getFile(distributionResource.fileId);
      List<Language> languageResources =
          await _vocabularyManagement.getLanguages(locale);
      WaitMessage().dismiss();

      _pDistributionContentWindow.show(context, distributionResource, languageResources, fileContent, pathFromMetadataMgmt);
    });
  }
}
