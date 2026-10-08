import 'package:doorce_panel/common/utils/exception_handler.dart';
import 'package:doorce_panel/dtos/data_schema.dart';
import 'package:doorce_panel/dtos/dataset.dart';
import 'package:doorce_panel/dtos/dataset_service.dart';
import 'package:doorce_panel/dtos/distribution.dart';
import 'package:doorce_panel/dtos/file_data.dart';
import 'package:doorce_panel/dtos/language.dart';
import 'package:doorce_panel/dtos/maturity_status.dart';
import 'package:doorce_panel/common/view_elements/snack_message.dart';
import 'package:doorce_panel/common/view_elements/wait_message.dart';
import 'package:doorce_panel/modules/data_mgmt/view/presenters/p_upsert_distribution_window.dart';
import 'package:doorce_panel/services/icon_api.dart';
import 'package:doorce_panel/services/schema_mgmt_api.dart';
import 'package:doorce_panel/services/storage_api.dart';
import 'package:doorce_panel/services/vocabulary_mgmt_api.dart';
import 'package:doorce_panel/services/dataset_mgmt_api.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';
import 'package:http/http.dart';
import 'package:mime/mime.dart';

abstract interface class IUCShowUpsertDistribution {
  showUpsertDistributionSelected(BuildContext context, String datasetIdentifier, String? identifier);
  Future<void> upsertDistribution(
    BuildContext context,
    XDistribution xDistribution,
    XFileData? file,
    bool isInsert
  );
  closeSelected(BuildContext context);
}

class UCShowUpsertDistribution with ExceptionHandler implements IUCShowUpsertDistribution {
  final IPUpsertDistributionWindow pUpsertDistributionWindow;
  final DatasetManagementAPI _datasetManagement;
  final VocabularyManagementAPI _vocabularyManagement;
  final StorageAPI _storageAPI;
  final IconAPI _iconAPI;
  final SchemaAPI schemaManagement;

  const UCShowUpsertDistribution(
      this._datasetManagement,
      this.pUpsertDistributionWindow,
      this._vocabularyManagement,
      this._storageAPI,
      this._iconAPI,
      this.schemaManagement);

  @override
  showUpsertDistributionSelected(BuildContext context, String datasetIdentifier, String? identifier) async {
    await tryForApiExceptions(context, () async {
      WaitMessage().show(context);
      String locale = Localizations.localeOf(context).languageCode;
      List<XDataset> agentDatasetResources;
      List<XDatasetService> agentServiceResources;
      List<Language> languageResources = await _vocabularyManagement.getLanguages(locale);
      List<MaturityStatus> maturityStatusResources = await _vocabularyManagement.getMaturityStatus(locale);
      List<String> formatResources = await _vocabularyManagement.getFormatMediaTypes("");
      List<String> mediaTypeResources = await _vocabularyManagement.getMediaTypes("");
      List<XDataSchema> schemaResources = await schemaManagement.getDataSchemaList(null);

      XDataset dataset = await _datasetManagement.getDataset(datasetIdentifier);

      XDistribution distribution;
      if (identifier == null || identifier.isEmpty) {
        distribution = XDistribution();
        distribution.icon = await _iconAPI.getIcon(dataset.iconUri);
        agentDatasetResources = await _datasetManagement.getAllowedDatasets(null);
        agentServiceResources = await _datasetManagement.getAllowedServices(null);
      } else {
        distribution = await _datasetManagement.getDistribution(identifier);
        agentDatasetResources = await _datasetManagement.getAllowedDatasets(distribution.identifier);
        agentServiceResources = await _datasetManagement.getAllowedServices(distribution.identifier);
      }

      XFileData? file;
      if (null != distribution.fileId && 0 < distribution.fileId!){
        Uint8List? fileContent = await _storageAPI.getFile(distribution.fileId);
        String? fileType = lookupMimeType(distribution.fileName!, headerBytes: fileContent);
        file = XFileData(
          fileId: distribution.fileId,
          fileName: distribution.fileName,
          contentType: fileType,
          content: fileContent
        );
      }

      WaitMessage().dismiss();
      pUpsertDistributionWindow.show(context,dataset,distribution,languageResources,formatResources,
          mediaTypeResources,agentDatasetResources,agentServiceResources,maturityStatusResources,
          file,schemaResources);
    });
  }

  @override
  closeSelected(BuildContext context)
  {
    pUpsertDistributionWindow.close(context);
  }

  @override
  Future<void> upsertDistribution(BuildContext context,XDistribution xDistribution, XFileData? file, bool isInsert) async {
    await tryForApiExceptions(context, () async {
      if (isInsert && !await _datasetManagement.checkDistributionId(xDistribution.identifier)){
        SnackMessage().show(context, true, text: AppLocalizations.of(context)!.invalidIdentifier);
        return;
      }

      int? id;
      if (null != file){
        if (null != file.fileId){
          id = file.fileId;
        } else {
        id = await _storageAPI.upsertFile(file);
        if (0 >= id){
          if (-1 == id) {SnackMessage().show(context, true, text: AppLocalizations.of(context)!.fileNull);}
          else if (-2 == id) {SnackMessage().show(context, true, text: AppLocalizations.of(context)!.fileTooBig);}
          else {SnackMessage().show(context, true, text: AppLocalizations.of(context)!.fileUploadError);}
          return;
          }
        };
      }
      xDistribution.fileId = id; 

      //TODO - delete file from database when it's removed from distribution
        
      Response response = await _datasetManagement.upsertDistribution(xDistribution);
      int code = response.statusCode;

      if (code == 200) {
        SnackMessage().show(context, false, text: AppLocalizations.of(context)!.distributionUpdated);
      } else if (code == 403) {
        SnackMessage().show(context, true, text: AppLocalizations.of(context)!.authError);
      } else {SnackMessage().show(context, true, text: AppLocalizations.of(context)!.distributionError);}
      
      pUpsertDistributionWindow.refreshIsInsert(code);
    });
  }
}
