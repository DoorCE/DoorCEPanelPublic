// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get panelName => 'UDAS Data Management Panel';

  @override
  String get main => 'Main';

  @override
  String get mainMenu => 'Main Menu';

  @override
  String get dataManagement => 'Data Management';

  @override
  String get dataManagementDescription =>
      'Manage data contents of your datasets';

  @override
  String get datasets => 'Datasets';

  @override
  String get cataloguing => 'Metadata Management';

  @override
  String get metadataManagementDescription =>
      'Manage metadata of catalogues and datasets';

  @override
  String get catalogue => 'Catalogues';

  @override
  String get schemaManagement => 'Schema Management';

  @override
  String get schemaManagementDescription =>
      'Manage data structures of your datasets';

  @override
  String get schemas => 'Schemas';

  @override
  String get agentManagement => 'Agent Management';

  @override
  String get agentManagementDescription => 'Manage people and organisations';

  @override
  String get agents => 'Agents';

  @override
  String get profile => 'Profile';

  @override
  String get logout => 'Logout';

  @override
  String get settings => 'Settings';

  @override
  String get dataResources => 'Data Resources';

  @override
  String get invalidIdentifier => 'Invalid Identifier';

  @override
  String get filter => 'Filter';

  @override
  String get close => 'Close';

  @override
  String get save => 'Save';

  @override
  String get identifier => 'Identifier';

  @override
  String get description => 'Description';

  @override
  String get fieldRequired => '* Required';

  @override
  String get formError => 'Errors in the form - check above';

  @override
  String get unsavedChanges => 'Unsaved changes';

  @override
  String get add => 'Add';

  @override
  String get loading => 'Loading...';

  @override
  String get addIcon => 'Add Icon';

  @override
  String get apply => 'Apply';

  @override
  String get and => 'AND';

  @override
  String get or => 'OR';

  @override
  String get fromList => 'From list';

  @override
  String get own => 'Own';

  @override
  String get iconName => 'Icon name';

  @override
  String get selectIcon => 'Icon selection';

  @override
  String get wrongName => 'Incorrect name or it already exists';

  @override
  String get selectFile => 'Select file';

  @override
  String get preview => 'Preview:';

  @override
  String get cancel => 'Cancel';

  @override
  String get text => 'Text';

  @override
  String get select => 'Select';

  @override
  String get toDelete => 'Deleting - are you sure?';

  @override
  String get toPublish => 'Will be published - are you sure?';

  @override
  String get toUnpublish => 'Will be unpublished - are you sure?';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get noRolesAssigned => 'No roles assigned';

  @override
  String get clickToExpand => 'Click to expand';

  @override
  String get selectRolesForEditors => 'Select roles for all editors';

  @override
  String get removeAgent => 'Remove agent';

  @override
  String get removeEditor => 'Remove editor';

  @override
  String get ownershipEditorError => 'Select at least 1 Ownership Editor';

  @override
  String get search => 'Search';

  @override
  String get delete => 'Delete';

  @override
  String get editableByMe => 'Editable by me';

  @override
  String get showing => 'Showing';

  @override
  String get outOf => 'of';

  @override
  String get noItemsFound => 'No items found';

  @override
  String get clearFilters => 'Clear filters';

  @override
  String get draft => 'Draft';

  @override
  String get active => 'Active';

  @override
  String get deleted => 'Deleted';

  @override
  String get source => 'Source';

  @override
  String get independent => 'Independent';

  @override
  String get quantitative => 'Quantitative';

  @override
  String get qualitative => 'Qualitative';

  @override
  String get geospatial => 'Geospatial';

  @override
  String get timeSeries => 'TimeSeries';

  @override
  String get textual => 'Textual';

  @override
  String get images => 'Images';

  @override
  String get available => 'available';

  @override
  String get unavailable => 'unavailable';

  @override
  String get defective => 'Defective';

  @override
  String get public => 'Public';

  @override
  String get confidential => 'Confidential';

  @override
  String get nonPublic => 'NonPublic';

  @override
  String get restricted => 'Restricted';

  @override
  String get sensitive => 'Sensitive';

  @override
  String get provisional => 'Provisional';

  @override
  String get distributionEditor => 'Distribution Editor';

  @override
  String get metadataEditor => 'Metadata Editor';

  @override
  String get ownershipEditor => 'Ownership Editor';

  @override
  String get agentManager => 'Agent Manager';

  @override
  String get metadataManager => 'Metadata Manager';

  @override
  String get distributionManager => 'Distribution Manager';

  @override
  String get ownershipManager => 'Ownership Manager';

  @override
  String get agentAdmin => 'Agent Admin';

  @override
  String get dataAdmin => 'Data Admin';

  @override
  String get schemaCreator => 'Schema Creator';

  @override
  String get authKeycloakError => 'Authentication failed';

  @override
  String get authError => 'You are not authorized to edit this resource';

  @override
  String get authBackendError =>
      'User account does not exist or server not available';

  @override
  String get reloginRequired => 'Session timed out - login required';

  @override
  String get agentDeleted => 'Person/organisation deleted';

  @override
  String get agentDeleteError => 'Person/organisation deletion error!';

  @override
  String get userDeleted => 'User deleted';

  @override
  String get userDeleteError => 'Error deleting user!';

  @override
  String get userUpdated => 'User account updated';

  @override
  String get userError => 'User account update error!';

  @override
  String get agentUpdated => 'Person/organisation updated';

  @override
  String get agentCreated => 'Person/organisation created';

  @override
  String get agentError => 'Person/organisation update error!';

  @override
  String get agentContactError => 'Contacts are used by resources!';

  @override
  String get agentResourceError => 'Person/Organisation manages resources!';

  @override
  String get people => 'People';

  @override
  String get users => 'Users';

  @override
  String get organisations => 'Organisations';

  @override
  String get addPerson => 'Add person';

  @override
  String get editPerson => 'Edit person';

  @override
  String get openPerson => 'Person details';

  @override
  String get deletePerson => 'Delete person';

  @override
  String get addUser => 'Add user';

  @override
  String get editUser => 'Edit user';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get deleteUser => 'Delete user';

  @override
  String get roles => 'Roles';

  @override
  String get assignRole => 'Click to assign role';

  @override
  String get associatedAgent => 'Associated agent profile';

  @override
  String get noAgentSelected => 'No agent selected';

  @override
  String get agentAlreadyAssigned => 'Agent already assigned';

  @override
  String get addOrganization => 'Add organization';

  @override
  String get editOrganization => 'Edit organization';

  @override
  String get openOrganization => 'Organisation details';

  @override
  String get deleteOrganization => 'Delete organisation';

  @override
  String get members => 'Members';

  @override
  String get orgName => 'Name';

  @override
  String get managers => 'Managers';

  @override
  String get contacts => 'Contacts';

  @override
  String get contactName => 'Contact Name';

  @override
  String get back => 'Back';

  @override
  String get forward => 'Forward';

  @override
  String get personalInformations => 'Personal Informations';

  @override
  String get personName => 'Name';

  @override
  String get familyName => 'Surname';

  @override
  String get otherNames => 'Other names';

  @override
  String get manager => 'Manager';

  @override
  String get contents => 'Contents';

  @override
  String get warningAccount =>
      'Caution: after assigning a user account to this person, only Agent Admin will be able to change this';

  @override
  String get selectAccountId => 'Select account ID';

  @override
  String get hasAccount => 'Has account';

  @override
  String get userInformation => 'User information';

  @override
  String get agent => 'Agent';

  @override
  String get selectAgent => 'Select agent';

  @override
  String get noEmailOrPasswordWarning => 'Enter email or password';

  @override
  String get noAccount => 'No account';

  @override
  String get createAccount => 'Create account';

  @override
  String get accountId => 'Account Id';

  @override
  String get userAccount => 'User account';

  @override
  String get datasetDeleted => 'Dataset deleted';

  @override
  String get datasetDeleteError => 'Dataset deletion error!';

  @override
  String get distributionDeleted => 'Distribution deleted';

  @override
  String get distributionDeleteError => 'Distribution deletion error!';

  @override
  String get fileNull => 'File is empty!';

  @override
  String get fileTooBig => 'File is too large!';

  @override
  String get fileUploadError => 'Error uploading file!';

  @override
  String get distributionUpdated => 'Distribution updated';

  @override
  String get distributionCreated => 'Distribution created';

  @override
  String get distributionError => 'Distribution update error!';

  @override
  String get dataUploadError => 'Data upload error!';

  @override
  String get dataUploaded => 'Data uploaded';

  @override
  String get dataFileNotLoaded => 'Data file not loaded!';

  @override
  String get dataDeleted => 'Data deleted';

  @override
  String get dataDeleteError => 'Error deleting data!';

  @override
  String get goToApp => 'Go to app';

  @override
  String get selectApp => 'Select application';

  @override
  String get datasetSeries => 'Dataset Series';

  @override
  String get openDatasetSeriesDetails => 'Dataset series details';

  @override
  String get addDistribution => 'Add distribution';

  @override
  String get editDistribution => 'Edit distribution';

  @override
  String get openDataset => 'Dataset details';

  @override
  String get openDistribution => 'Distribution details';

  @override
  String get deleteDistribution => 'Delete distribution';

  @override
  String get dataset => 'Dataset';

  @override
  String get distribution => 'Distributions';

  @override
  String get series => 'Series';

  @override
  String get catalog => 'Catalogue';

  @override
  String get data => 'Data';

  @override
  String get file => 'File';

  @override
  String get formats => 'Formats';

  @override
  String get distributionLanguages => 'Distribution languages';

  @override
  String get byteSize => 'Size in bytes';

  @override
  String get download => 'Download';

  @override
  String get advancedSettings => 'Advanced settings';

  @override
  String get fileExtension => 'File extension';

  @override
  String get tableConceptMapping => 'Custom sheet names and id fields';

  @override
  String get isIncluded => 'Concept included in the file';

  @override
  String get conceptUri => 'Concept uri';

  @override
  String get sheetName => 'Sheet name';

  @override
  String get idFieldName => 'Id field name';

  @override
  String get loadData => 'Load data';

  @override
  String get errorWidgetMessage =>
      'We encountered an error during file processing';

  @override
  String get dataImportErrors => 'Data import errors';

  @override
  String get clearData => 'Delete all data for dataset';

  @override
  String get dataRows => 'Data rows';

  @override
  String get structuredData => 'Structured data';

  @override
  String get moreErrorsNotShown => 'more errors not shown';

  @override
  String get downloadErrorLog => 'Download full error log';

  @override
  String get couldNotReadFile => 'Could not read selected file.';

  @override
  String get viewAndEditWithDefaultApp => 'View and edit with default app';

  @override
  String get viewWithSelectedApp => 'View and edit with selected app';

  @override
  String get catalogueUpdated => 'Catalogue updated';

  @override
  String get catalogueCreated => 'Catalogue created';

  @override
  String get catalogueError => 'Catalogue update error!';

  @override
  String get catalogueDeleted => 'Catalogue deleted';

  @override
  String get catalogueResourceError => 'Catalogue contains resources!';

  @override
  String get catalogueDeleteError => 'Catalogue deletion error!';

  @override
  String get datasetUpdated => 'Dataset updated';

  @override
  String get datasetCreated => 'Dataset created';

  @override
  String get datasetCreatedPublished => 'Dataset created and published';

  @override
  String get datasetUpdatedPublished => 'Dataset updated and published';

  @override
  String get datasetPublished => 'Dataset published';

  @override
  String get datasetPublishError => 'Dataset publishing error!';

  @override
  String get datasetUnpublishError => 'Dataset unpublishing error!';

  @override
  String get datasetUnpublished => 'Dataset unpublished';

  @override
  String get datasetError => 'Dataset update error!';

  @override
  String get seriesUpdated => 'Dataset series updated';

  @override
  String get seriesCreated => 'Dataset series created';

  @override
  String get seriesError => 'Dataset series update error!';

  @override
  String get seriesDeleted => 'Series deleted';

  @override
  String get seriesDeleteError => 'Series deletion error!';

  @override
  String get serviceUpdated => 'Data service updated';

  @override
  String get serviceCreated => 'Data service created';

  @override
  String get serviceError => 'Data service update error!';

  @override
  String get serviceDeleted => 'Service deleted';

  @override
  String get serviceDeleteError => 'Service deletion error!';

  @override
  String get dataPublishError => 'Error publishing data to Ckan Datastore!';

  @override
  String get datastoreSuccess => 'Data uploaded to Datastore';

  @override
  String get datastorePartialSuccess => 'Data upload was partially successful';

  @override
  String get datastoreFailure => 'Data upload failed';

  @override
  String get upsertedRows => 'Upserted rows';

  @override
  String get warningIndependentDataset => 'Warning: dataset is independent';

  @override
  String get datasetServices => 'Dataset Service';

  @override
  String get addNewDataset => 'Add new dataset';

  @override
  String get addNewCatalogue => 'Add new catalogue';

  @override
  String get addNewSeries => 'Add new series';

  @override
  String get addNewService => 'Add new service';

  @override
  String get editDataset => 'Edit dataset';

  @override
  String get editCatalog => 'Edit catalogue';

  @override
  String get editSeries => 'Edit series';

  @override
  String get editService => 'Edit service';

  @override
  String get openCatalog => 'Open catalogue';

  @override
  String get deleteCatalog => 'Delete catalogue';

  @override
  String get deleteDataset => 'Delete dataset';

  @override
  String get openSeries => 'Open series';

  @override
  String get openService => 'Open service';

  @override
  String get deleteSeries => 'Delete series';

  @override
  String get deleteService => 'Delete service';

  @override
  String get publish => 'Publish';

  @override
  String get parentCatalog => 'Parent catalogue';

  @override
  String get addLanguage => 'Add Language';

  @override
  String get newContacts => 'New contacts';

  @override
  String get dateInvalid => 'Date not valid';

  @override
  String get respAgentNotAssigned =>
      'Select responsible person or organisation!';

  @override
  String get mainCatalog => 'Main Catalog';

  @override
  String get publishMetadata => 'Publish metadata';

  @override
  String get publishData => 'Publish data with metadata';

  @override
  String get unpublish => 'Unpublish';

  @override
  String get previewDataset => 'Preview dataset';

  @override
  String get createDefaultApp => 'Create default edit application';

  @override
  String get schemaNotSelected =>
      'Please select a schema before creating an app';

  @override
  String get previewSeries => 'Preview series';

  @override
  String get previewCatalogue => 'Preview catalogue';

  @override
  String get previewService => 'Preview service';

  @override
  String get noItemsFoundForCatalogues =>
      'No items found, create new catalogue or switch to Data Resources to view them';

  @override
  String get status => 'Status';

  @override
  String get accessStatus => 'Access status';

  @override
  String get mediaType => 'Media type';

  @override
  String get accessUrl => 'Access URL';

  @override
  String get metadataLanguage => 'Metadata Language';

  @override
  String get dataLanguage => 'Data languages';

  @override
  String get type => 'Type';

  @override
  String get statusField => 'Status';

  @override
  String get typesField => 'Types';

  @override
  String get titleField => 'Title';

  @override
  String get documentation => 'Documentation';

  @override
  String get provenance => 'Provenance';

  @override
  String get version => 'Version';

  @override
  String get versionNotes => 'Version notes';

  @override
  String get geographicalCoverage => 'Geographical Coverage';

  @override
  String get frequency => 'Frequency';

  @override
  String get temporalCoverage => 'Temporal Coverage (from - to)';

  @override
  String get temporalCoverageFrom => 'Temporal Coverage from';

  @override
  String get temporalCoverageTo => 'Temporal Coverage to';

  @override
  String get releaseDate => 'Release Date';

  @override
  String get accessRights => 'Access rights';

  @override
  String get keywords => 'Keywords';

  @override
  String get themes => 'Themes';

  @override
  String get responsiblePerson => 'Responsible person';

  @override
  String get responsibleOrganization => 'Responsible organization';

  @override
  String get applicableLegislation => 'Applicable Legislation';

  @override
  String get licence => 'Licence';

  @override
  String get editors => 'Editors';

  @override
  String get actions => 'Actions';

  @override
  String get datasetTitle => 'Dataset Title';

  @override
  String get dataServiceTitle => 'DataService Title';

  @override
  String get endpointUrl => 'Endpoint URL';

  @override
  String get endpointDescription => 'Endpoint description';

  @override
  String get targetDataset => 'Target dataset';

  @override
  String get schemaCreated => 'Data schema created';

  @override
  String get schemaUpdated => 'Data schema updated';

  @override
  String get schemaError => 'Data schema update error!';

  @override
  String get defaultValue => 'Default';

  @override
  String get deleteConcept => 'Delete concept';

  @override
  String get deleteProperty => 'Delete property';

  @override
  String get defaultNotSet => 'Default namespace is not set';

  @override
  String get deleteSchema => 'Delete schema';

  @override
  String get schemaDeleted => 'Schema deleted';

  @override
  String get schemaDeleteError => 'Error deleting schema!';

  @override
  String get addConcept => 'Add concept';

  @override
  String get addProperty => 'Add property';

  @override
  String get schemaSeriesCreated => 'Schema series created';

  @override
  String get schemaSeriesUpdated => 'Schema series updated';

  @override
  String get schemaSeriesError => 'Schema series update error!';

  @override
  String get deleteSchemaSeries => 'Delete schema series';

  @override
  String get schemaSeriesDeleted => 'Schema series deleted';

  @override
  String get schemaSeriesDeleteError => 'Error deleting schema series!';

  @override
  String get schemaSeriesResourceError => 'Series contains resources';

  @override
  String get schemaSeriesNotFoundError => 'Series not found';

  @override
  String get appUpdated => 'App updated';

  @override
  String get appError => 'App update error!';

  @override
  String get appDeleted => 'App deleted';

  @override
  String get appDeleteError => 'App deletion error!';

  @override
  String get templateDeleted => 'Template deleted';

  @override
  String get templateDeleteError => 'Template deletion error!';

  @override
  String get templateCreated => 'Template created';

  @override
  String get templateError => 'Template creation error!';

  @override
  String get templateGenerated => 'Template generated';

  @override
  String get templateGenerateError => 'Template generation error!';

  @override
  String get appDeployStarted => 'App deployment initialized';

  @override
  String get appDeployError => 'App deployment error!';

  @override
  String get appStatusesRefreshed => 'App statuses refreshed';

  @override
  String get schema => 'Data Schema';

  @override
  String get listVersions => 'List versions';

  @override
  String get openSchema => 'Preview data schema';

  @override
  String get noSeries => '[Not in series]';

  @override
  String get array => 'Array';

  @override
  String get unique => 'Unique';

  @override
  String get required => 'Required';

  @override
  String get schemaSeries => 'Schema series';

  @override
  String get addSchema => 'Add data schema';

  @override
  String get editSchema => 'Edit data schema';

  @override
  String get schemaTitle => 'Data schema title';

  @override
  String get namespacePrefix => 'Namespace prefix';

  @override
  String get namespaces => 'Namespaces';

  @override
  String get usedNamespaces => 'Used namespaces';

  @override
  String get newNamespaces => 'New namespaces';

  @override
  String get namespace => 'Namespace';

  @override
  String get namespaceIri => 'Namespace iri';

  @override
  String get defaultNamespace => 'Default namespace';

  @override
  String get concepts => 'Concepts';

  @override
  String get conceptName => 'Concept name';

  @override
  String get untitledConcept => 'Untitled concept';

  @override
  String get mainConcept => 'Main concept';

  @override
  String get properties => 'Properties';

  @override
  String get propertyName => 'Property name';

  @override
  String get currentSchema => 'Current data schema';

  @override
  String get customIriNotUnique =>
      'Custom namespace iri cannot be the same as standard namespace iri';

  @override
  String get customPrefixNotUnique =>
      'Custom namespace prefix cannot be the same as standard namespace prefix';

  @override
  String get valueAlreadyUsed => 'Value already used!';

  @override
  String get noSeriesPrivileges =>
      'You have no priviliges to any schema series';

  @override
  String get showAppDetails => 'Preview app';

  @override
  String get deleteApp => 'Delete app';

  @override
  String get addNewApp => 'Add new app';

  @override
  String get apps => 'Acquisition apps';

  @override
  String get appTemplates => 'App templates';

  @override
  String get template => 'Template';

  @override
  String get addNewTemplate => 'Add new template';

  @override
  String get openTemplate => 'Preview template';

  @override
  String get editTemplate => 'Edit template';

  @override
  String get deleteTemplate => 'Delete template';

  @override
  String get enabled => 'Enabled';

  @override
  String get disabled => 'Disabled';

  @override
  String get visible => 'Visible';

  @override
  String get hidden => 'Hidden';

  @override
  String get toUpdate => 'Will be updated - are you sure?';

  @override
  String get createApp => 'Create app';

  @override
  String get create => 'Create';

  @override
  String get activeResource => 'Active resource';

  @override
  String get app => 'App';

  @override
  String get editApp => 'Edit app';

  @override
  String get noNameError => 'Please enter a name.';

  @override
  String get noCatalogueError => 'Please select a parent catalogue.';

  @override
  String get datasetIdentifierNotUnique =>
      'A dataset with this identifier already exists.';

  @override
  String get selectEditors => 'Select editors';

  @override
  String get selectCatForResources => 'Select catalogue for new resources';

  @override
  String get sourceResources => 'Source resources';

  @override
  String get addNewResource => 'Add new resource';

  @override
  String get newField => 'New';

  @override
  String get activeResourceCannotBeSourceResource =>
      'Active resource cannot also be a source resource';

  @override
  String get createTemplate => 'Create app template';

  @override
  String get isReadyLabel => 'Is ready';

  @override
  String get usecaseScenarios => 'Use cases';

  @override
  String get fillTitlesAndDescriptions => 'Fill out all text fields!';

  @override
  String get versionOf => 'Is version of:';

  @override
  String get scenarios => 'Scenarios';

  @override
  String get titleNotUnique => 'Title must be unique';

  @override
  String get useCase => 'Use case';

  @override
  String get untitledProperty => 'Untitled property';

  @override
  String get idProperty => 'Default identifier';

  @override
  String get deleteConceptWarning =>
      'Warning: deleting concept from schema will result in deleting its data items';

  @override
  String get idMustBeUniqueAndRequired =>
      'Default identifier property must be unique and required';

  @override
  String get auxiliaryConcepts => 'Auxiliary concepts';

  @override
  String get activateAdvancedScenarioEditing =>
      'Activate advanced scenario editing';

  @override
  String get cannotRevertWarning => 'Warning: this action cannot be reverted';

  @override
  String get compileTemplate => 'Compile template';

  @override
  String get deployApp => 'Deploy App';

  @override
  String get created => 'Created';

  @override
  String get inProcessing => 'In Processing';

  @override
  String get ready => 'Ready';

  @override
  String get hasErrors => 'Has Errors';

  @override
  String get refreshAppStatuses => 'Refresh app statuses';

  @override
  String get isCompiled => 'Compiled';

  @override
  String get login => 'Login';

  @override
  String get email => 'Email';

  @override
  String get emailHint => 'Enter your email';

  @override
  String get unvalidEmail => 'Enter a valid email (e.g. abc@gmail.com)';

  @override
  String get password => 'Password';

  @override
  String get passwordHint => 'Enter your password';

  @override
  String get unvalidPassword => 'Password must be at least 6 characters';

  @override
  String get loginFailed => 'Email or Password is incorrect';

  @override
  String get datasetCatalogue => 'Dataset Catalogue';

  @override
  String get editCurrent => 'Edit current';

  @override
  String get editContents => 'Edit contents';

  @override
  String get openSchemaSeries => 'Preview schema series';

  @override
  String get rolesAndOrganizations => 'Roles and organizations';

  @override
  String get memberOf => 'Member of';

  @override
  String get selectMember => 'Select member';

  @override
  String get phone => 'Phone number';

  @override
  String get address => 'Address';

  @override
  String get dataService => 'Data service';

  @override
  String get responsiblePersonUri => 'Responsible person URI';

  @override
  String get responsiblePersonName => 'Responsible person name';

  @override
  String get responsibleOrganizationUri => 'Responsible organisation URI';

  @override
  String get responsibleOrganizationName => 'Responsible organisation name';

  @override
  String get editorsUris => 'Editors URIs';

  @override
  String get contactsUris => 'Contacts URIs';

  @override
  String get languages => 'Languages';

  @override
  String get catalogueUri => 'Catalogue URI';

  @override
  String get catalogueTitle => 'Catalogue title';

  @override
  String get standardUris => 'Standard URIs';

  @override
  String get standardTitle => 'Standard title';

  @override
  String get datasetUri => 'Dataset URI';

  @override
  String get compressionFormat => 'Compression format';

  @override
  String get downloadUrl => 'Download URL';
}
