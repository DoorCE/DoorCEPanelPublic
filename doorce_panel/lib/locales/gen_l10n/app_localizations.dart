import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_hr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_sk.dart';
import 'app_localizations_sl.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('hr'),
    Locale('it'),
    Locale('pl'),
    Locale('sk'),
    Locale('sl')
  ];

  /// No description provided for @panelName.
  ///
  /// In en, this message translates to:
  /// **'UDAS Data Management Panel'**
  String get panelName;

  /// No description provided for @main.
  ///
  /// In en, this message translates to:
  /// **'Main'**
  String get main;

  /// No description provided for @mainMenu.
  ///
  /// In en, this message translates to:
  /// **'Main Menu'**
  String get mainMenu;

  /// No description provided for @dataManagement.
  ///
  /// In en, this message translates to:
  /// **'Data Management'**
  String get dataManagement;

  /// No description provided for @dataManagementDescription.
  ///
  /// In en, this message translates to:
  /// **'Manage data contents of your datasets'**
  String get dataManagementDescription;

  /// No description provided for @datasets.
  ///
  /// In en, this message translates to:
  /// **'Datasets'**
  String get datasets;

  /// No description provided for @cataloguing.
  ///
  /// In en, this message translates to:
  /// **'Metadata Management'**
  String get cataloguing;

  /// No description provided for @metadataManagementDescription.
  ///
  /// In en, this message translates to:
  /// **'Manage metadata of catalogues and datasets'**
  String get metadataManagementDescription;

  /// No description provided for @catalogue.
  ///
  /// In en, this message translates to:
  /// **'Catalogues'**
  String get catalogue;

  /// No description provided for @schemaManagement.
  ///
  /// In en, this message translates to:
  /// **'Schema Management'**
  String get schemaManagement;

  /// No description provided for @schemaManagementDescription.
  ///
  /// In en, this message translates to:
  /// **'Manage data structures of your datasets'**
  String get schemaManagementDescription;

  /// No description provided for @schemas.
  ///
  /// In en, this message translates to:
  /// **'Schemas'**
  String get schemas;

  /// No description provided for @agentManagement.
  ///
  /// In en, this message translates to:
  /// **'Agent Management'**
  String get agentManagement;

  /// No description provided for @agentManagementDescription.
  ///
  /// In en, this message translates to:
  /// **'Manage people and organisations'**
  String get agentManagementDescription;

  /// No description provided for @agents.
  ///
  /// In en, this message translates to:
  /// **'Agents'**
  String get agents;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @dataResources.
  ///
  /// In en, this message translates to:
  /// **'Data Resources'**
  String get dataResources;

  /// No description provided for @invalidIdentifier.
  ///
  /// In en, this message translates to:
  /// **'Invalid Identifier'**
  String get invalidIdentifier;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @identifier.
  ///
  /// In en, this message translates to:
  /// **'Identifier'**
  String get identifier;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'* Required'**
  String get fieldRequired;

  /// No description provided for @formError.
  ///
  /// In en, this message translates to:
  /// **'Errors in the form - check above'**
  String get formError;

  /// No description provided for @unsavedChanges.
  ///
  /// In en, this message translates to:
  /// **'Unsaved changes'**
  String get unsavedChanges;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @addIcon.
  ///
  /// In en, this message translates to:
  /// **'Add Icon'**
  String get addIcon;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @and.
  ///
  /// In en, this message translates to:
  /// **'AND'**
  String get and;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// No description provided for @fromList.
  ///
  /// In en, this message translates to:
  /// **'From list'**
  String get fromList;

  /// No description provided for @own.
  ///
  /// In en, this message translates to:
  /// **'Own'**
  String get own;

  /// No description provided for @iconName.
  ///
  /// In en, this message translates to:
  /// **'Icon name'**
  String get iconName;

  /// No description provided for @selectIcon.
  ///
  /// In en, this message translates to:
  /// **'Icon selection'**
  String get selectIcon;

  /// No description provided for @wrongName.
  ///
  /// In en, this message translates to:
  /// **'Incorrect name or it already exists'**
  String get wrongName;

  /// No description provided for @selectFile.
  ///
  /// In en, this message translates to:
  /// **'Select file'**
  String get selectFile;

  /// No description provided for @preview.
  ///
  /// In en, this message translates to:
  /// **'Preview:'**
  String get preview;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @text.
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get text;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @toDelete.
  ///
  /// In en, this message translates to:
  /// **'Deleting - are you sure?'**
  String get toDelete;

  /// No description provided for @toPublish.
  ///
  /// In en, this message translates to:
  /// **'Will be published - are you sure?'**
  String get toPublish;

  /// No description provided for @toUnpublish.
  ///
  /// In en, this message translates to:
  /// **'Will be unpublished - are you sure?'**
  String get toUnpublish;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @noRolesAssigned.
  ///
  /// In en, this message translates to:
  /// **'No roles assigned'**
  String get noRolesAssigned;

  /// No description provided for @clickToExpand.
  ///
  /// In en, this message translates to:
  /// **'Click to expand'**
  String get clickToExpand;

  /// No description provided for @selectRolesForEditors.
  ///
  /// In en, this message translates to:
  /// **'Select roles for all editors'**
  String get selectRolesForEditors;

  /// No description provided for @removeAgent.
  ///
  /// In en, this message translates to:
  /// **'Remove agent'**
  String get removeAgent;

  /// No description provided for @removeEditor.
  ///
  /// In en, this message translates to:
  /// **'Remove editor'**
  String get removeEditor;

  /// No description provided for @ownershipEditorError.
  ///
  /// In en, this message translates to:
  /// **'Select at least 1 Ownership Editor'**
  String get ownershipEditorError;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @editableByMe.
  ///
  /// In en, this message translates to:
  /// **'Editable by me'**
  String get editableByMe;

  /// No description provided for @showing.
  ///
  /// In en, this message translates to:
  /// **'Showing'**
  String get showing;

  /// No description provided for @outOf.
  ///
  /// In en, this message translates to:
  /// **'of'**
  String get outOf;

  /// No description provided for @noItemsFound.
  ///
  /// In en, this message translates to:
  /// **'No items found'**
  String get noItemsFound;

  /// No description provided for @clearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get clearFilters;

  /// No description provided for @draft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get draft;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @deleted.
  ///
  /// In en, this message translates to:
  /// **'Deleted'**
  String get deleted;

  /// No description provided for @source.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get source;

  /// No description provided for @independent.
  ///
  /// In en, this message translates to:
  /// **'Independent'**
  String get independent;

  /// No description provided for @quantitative.
  ///
  /// In en, this message translates to:
  /// **'Quantitative'**
  String get quantitative;

  /// No description provided for @qualitative.
  ///
  /// In en, this message translates to:
  /// **'Qualitative'**
  String get qualitative;

  /// No description provided for @geospatial.
  ///
  /// In en, this message translates to:
  /// **'Geospatial'**
  String get geospatial;

  /// No description provided for @timeSeries.
  ///
  /// In en, this message translates to:
  /// **'TimeSeries'**
  String get timeSeries;

  /// No description provided for @textual.
  ///
  /// In en, this message translates to:
  /// **'Textual'**
  String get textual;

  /// No description provided for @images.
  ///
  /// In en, this message translates to:
  /// **'Images'**
  String get images;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'available'**
  String get available;

  /// No description provided for @unavailable.
  ///
  /// In en, this message translates to:
  /// **'unavailable'**
  String get unavailable;

  /// No description provided for @defective.
  ///
  /// In en, this message translates to:
  /// **'Defective'**
  String get defective;

  /// No description provided for @public.
  ///
  /// In en, this message translates to:
  /// **'Public'**
  String get public;

  /// No description provided for @confidential.
  ///
  /// In en, this message translates to:
  /// **'Confidential'**
  String get confidential;

  /// No description provided for @nonPublic.
  ///
  /// In en, this message translates to:
  /// **'NonPublic'**
  String get nonPublic;

  /// No description provided for @restricted.
  ///
  /// In en, this message translates to:
  /// **'Restricted'**
  String get restricted;

  /// No description provided for @sensitive.
  ///
  /// In en, this message translates to:
  /// **'Sensitive'**
  String get sensitive;

  /// No description provided for @provisional.
  ///
  /// In en, this message translates to:
  /// **'Provisional'**
  String get provisional;

  /// No description provided for @distributionEditor.
  ///
  /// In en, this message translates to:
  /// **'Distribution Editor'**
  String get distributionEditor;

  /// No description provided for @metadataEditor.
  ///
  /// In en, this message translates to:
  /// **'Metadata Editor'**
  String get metadataEditor;

  /// No description provided for @ownershipEditor.
  ///
  /// In en, this message translates to:
  /// **'Ownership Editor'**
  String get ownershipEditor;

  /// No description provided for @agentManager.
  ///
  /// In en, this message translates to:
  /// **'Agent Manager'**
  String get agentManager;

  /// No description provided for @metadataManager.
  ///
  /// In en, this message translates to:
  /// **'Metadata Manager'**
  String get metadataManager;

  /// No description provided for @distributionManager.
  ///
  /// In en, this message translates to:
  /// **'Distribution Manager'**
  String get distributionManager;

  /// No description provided for @ownershipManager.
  ///
  /// In en, this message translates to:
  /// **'Ownership Manager'**
  String get ownershipManager;

  /// No description provided for @agentAdmin.
  ///
  /// In en, this message translates to:
  /// **'Agent Admin'**
  String get agentAdmin;

  /// No description provided for @dataAdmin.
  ///
  /// In en, this message translates to:
  /// **'Data Admin'**
  String get dataAdmin;

  /// No description provided for @schemaCreator.
  ///
  /// In en, this message translates to:
  /// **'Schema Creator'**
  String get schemaCreator;

  /// No description provided for @authKeycloakError.
  ///
  /// In en, this message translates to:
  /// **'Authentication failed'**
  String get authKeycloakError;

  /// No description provided for @authError.
  ///
  /// In en, this message translates to:
  /// **'You are not authorized to edit this resource'**
  String get authError;

  /// No description provided for @authBackendError.
  ///
  /// In en, this message translates to:
  /// **'User account does not exist or server not available'**
  String get authBackendError;

  /// No description provided for @reloginRequired.
  ///
  /// In en, this message translates to:
  /// **'Session timed out - login required'**
  String get reloginRequired;

  /// No description provided for @agentDeleted.
  ///
  /// In en, this message translates to:
  /// **'Person/organisation deleted'**
  String get agentDeleted;

  /// No description provided for @agentDeleteError.
  ///
  /// In en, this message translates to:
  /// **'Person/organisation deletion error!'**
  String get agentDeleteError;

  /// No description provided for @userDeleted.
  ///
  /// In en, this message translates to:
  /// **'User deleted'**
  String get userDeleted;

  /// No description provided for @userDeleteError.
  ///
  /// In en, this message translates to:
  /// **'Error deleting user!'**
  String get userDeleteError;

  /// No description provided for @userUpdated.
  ///
  /// In en, this message translates to:
  /// **'User account updated'**
  String get userUpdated;

  /// No description provided for @userError.
  ///
  /// In en, this message translates to:
  /// **'User account update error!'**
  String get userError;

  /// No description provided for @agentUpdated.
  ///
  /// In en, this message translates to:
  /// **'Person/organisation updated'**
  String get agentUpdated;

  /// No description provided for @agentCreated.
  ///
  /// In en, this message translates to:
  /// **'Person/organisation created'**
  String get agentCreated;

  /// No description provided for @agentError.
  ///
  /// In en, this message translates to:
  /// **'Person/organisation update error!'**
  String get agentError;

  /// No description provided for @agentContactError.
  ///
  /// In en, this message translates to:
  /// **'Contacts are used by resources!'**
  String get agentContactError;

  /// No description provided for @agentResourceError.
  ///
  /// In en, this message translates to:
  /// **'Person/Organisation manages resources!'**
  String get agentResourceError;

  /// No description provided for @people.
  ///
  /// In en, this message translates to:
  /// **'People'**
  String get people;

  /// No description provided for @users.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get users;

  /// No description provided for @organisations.
  ///
  /// In en, this message translates to:
  /// **'Organisations'**
  String get organisations;

  /// No description provided for @addPerson.
  ///
  /// In en, this message translates to:
  /// **'Add person'**
  String get addPerson;

  /// No description provided for @editPerson.
  ///
  /// In en, this message translates to:
  /// **'Edit person'**
  String get editPerson;

  /// No description provided for @openPerson.
  ///
  /// In en, this message translates to:
  /// **'Person details'**
  String get openPerson;

  /// No description provided for @deletePerson.
  ///
  /// In en, this message translates to:
  /// **'Delete person'**
  String get deletePerson;

  /// No description provided for @addUser.
  ///
  /// In en, this message translates to:
  /// **'Add user'**
  String get addUser;

  /// No description provided for @editUser.
  ///
  /// In en, this message translates to:
  /// **'Edit user'**
  String get editUser;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveChanges;

  /// No description provided for @deleteUser.
  ///
  /// In en, this message translates to:
  /// **'Delete user'**
  String get deleteUser;

  /// No description provided for @roles.
  ///
  /// In en, this message translates to:
  /// **'Roles'**
  String get roles;

  /// No description provided for @assignRole.
  ///
  /// In en, this message translates to:
  /// **'Click to assign role'**
  String get assignRole;

  /// No description provided for @associatedAgent.
  ///
  /// In en, this message translates to:
  /// **'Associated agent profile'**
  String get associatedAgent;

  /// No description provided for @noAgentSelected.
  ///
  /// In en, this message translates to:
  /// **'No agent selected'**
  String get noAgentSelected;

  /// No description provided for @agentAlreadyAssigned.
  ///
  /// In en, this message translates to:
  /// **'Agent already assigned'**
  String get agentAlreadyAssigned;

  /// No description provided for @addOrganization.
  ///
  /// In en, this message translates to:
  /// **'Add organization'**
  String get addOrganization;

  /// No description provided for @editOrganization.
  ///
  /// In en, this message translates to:
  /// **'Edit organization'**
  String get editOrganization;

  /// No description provided for @openOrganization.
  ///
  /// In en, this message translates to:
  /// **'Organisation details'**
  String get openOrganization;

  /// No description provided for @deleteOrganization.
  ///
  /// In en, this message translates to:
  /// **'Delete organisation'**
  String get deleteOrganization;

  /// No description provided for @members.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get members;

  /// No description provided for @orgName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get orgName;

  /// No description provided for @managers.
  ///
  /// In en, this message translates to:
  /// **'Managers'**
  String get managers;

  /// No description provided for @contacts.
  ///
  /// In en, this message translates to:
  /// **'Contacts'**
  String get contacts;

  /// No description provided for @contactName.
  ///
  /// In en, this message translates to:
  /// **'Contact Name'**
  String get contactName;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @forward.
  ///
  /// In en, this message translates to:
  /// **'Forward'**
  String get forward;

  /// No description provided for @personalInformations.
  ///
  /// In en, this message translates to:
  /// **'Personal Informations'**
  String get personalInformations;

  /// No description provided for @personName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get personName;

  /// No description provided for @familyName.
  ///
  /// In en, this message translates to:
  /// **'Surname'**
  String get familyName;

  /// No description provided for @otherNames.
  ///
  /// In en, this message translates to:
  /// **'Other names'**
  String get otherNames;

  /// No description provided for @manager.
  ///
  /// In en, this message translates to:
  /// **'Manager'**
  String get manager;

  /// No description provided for @contents.
  ///
  /// In en, this message translates to:
  /// **'Contents'**
  String get contents;

  /// No description provided for @warningAccount.
  ///
  /// In en, this message translates to:
  /// **'Caution: after assigning a user account to this person, only Agent Admin will be able to change this'**
  String get warningAccount;

  /// No description provided for @selectAccountId.
  ///
  /// In en, this message translates to:
  /// **'Select account ID'**
  String get selectAccountId;

  /// No description provided for @hasAccount.
  ///
  /// In en, this message translates to:
  /// **'Has account'**
  String get hasAccount;

  /// No description provided for @userInformation.
  ///
  /// In en, this message translates to:
  /// **'User information'**
  String get userInformation;

  /// No description provided for @agent.
  ///
  /// In en, this message translates to:
  /// **'Agent'**
  String get agent;

  /// No description provided for @selectAgent.
  ///
  /// In en, this message translates to:
  /// **'Select agent'**
  String get selectAgent;

  /// No description provided for @noEmailOrPasswordWarning.
  ///
  /// In en, this message translates to:
  /// **'Enter email or password'**
  String get noEmailOrPasswordWarning;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'No account'**
  String get noAccount;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// No description provided for @accountId.
  ///
  /// In en, this message translates to:
  /// **'Account Id'**
  String get accountId;

  /// No description provided for @userAccount.
  ///
  /// In en, this message translates to:
  /// **'User account'**
  String get userAccount;

  /// No description provided for @datasetDeleted.
  ///
  /// In en, this message translates to:
  /// **'Dataset deleted'**
  String get datasetDeleted;

  /// No description provided for @datasetDeleteError.
  ///
  /// In en, this message translates to:
  /// **'Dataset deletion error!'**
  String get datasetDeleteError;

  /// No description provided for @distributionDeleted.
  ///
  /// In en, this message translates to:
  /// **'Distribution deleted'**
  String get distributionDeleted;

  /// No description provided for @distributionDeleteError.
  ///
  /// In en, this message translates to:
  /// **'Distribution deletion error!'**
  String get distributionDeleteError;

  /// No description provided for @fileNull.
  ///
  /// In en, this message translates to:
  /// **'File is empty!'**
  String get fileNull;

  /// No description provided for @fileTooBig.
  ///
  /// In en, this message translates to:
  /// **'File is too large!'**
  String get fileTooBig;

  /// No description provided for @fileUploadError.
  ///
  /// In en, this message translates to:
  /// **'Error uploading file!'**
  String get fileUploadError;

  /// No description provided for @distributionUpdated.
  ///
  /// In en, this message translates to:
  /// **'Distribution updated'**
  String get distributionUpdated;

  /// No description provided for @distributionCreated.
  ///
  /// In en, this message translates to:
  /// **'Distribution created'**
  String get distributionCreated;

  /// No description provided for @distributionError.
  ///
  /// In en, this message translates to:
  /// **'Distribution update error!'**
  String get distributionError;

  /// No description provided for @dataUploadError.
  ///
  /// In en, this message translates to:
  /// **'Data upload error!'**
  String get dataUploadError;

  /// No description provided for @dataUploaded.
  ///
  /// In en, this message translates to:
  /// **'Data uploaded'**
  String get dataUploaded;

  /// No description provided for @dataFileNotLoaded.
  ///
  /// In en, this message translates to:
  /// **'Data file not loaded!'**
  String get dataFileNotLoaded;

  /// No description provided for @dataDeleted.
  ///
  /// In en, this message translates to:
  /// **'Data deleted'**
  String get dataDeleted;

  /// No description provided for @dataDeleteError.
  ///
  /// In en, this message translates to:
  /// **'Error deleting data!'**
  String get dataDeleteError;

  /// No description provided for @goToApp.
  ///
  /// In en, this message translates to:
  /// **'Go to app'**
  String get goToApp;

  /// No description provided for @selectApp.
  ///
  /// In en, this message translates to:
  /// **'Select application'**
  String get selectApp;

  /// No description provided for @datasetSeries.
  ///
  /// In en, this message translates to:
  /// **'Dataset Series'**
  String get datasetSeries;

  /// No description provided for @openDatasetSeriesDetails.
  ///
  /// In en, this message translates to:
  /// **'Dataset series details'**
  String get openDatasetSeriesDetails;

  /// No description provided for @addDistribution.
  ///
  /// In en, this message translates to:
  /// **'Add distribution'**
  String get addDistribution;

  /// No description provided for @editDistribution.
  ///
  /// In en, this message translates to:
  /// **'Edit distribution'**
  String get editDistribution;

  /// No description provided for @openDataset.
  ///
  /// In en, this message translates to:
  /// **'Dataset details'**
  String get openDataset;

  /// No description provided for @openDistribution.
  ///
  /// In en, this message translates to:
  /// **'Distribution details'**
  String get openDistribution;

  /// No description provided for @deleteDistribution.
  ///
  /// In en, this message translates to:
  /// **'Delete distribution'**
  String get deleteDistribution;

  /// No description provided for @dataset.
  ///
  /// In en, this message translates to:
  /// **'Dataset'**
  String get dataset;

  /// No description provided for @distribution.
  ///
  /// In en, this message translates to:
  /// **'Distributions'**
  String get distribution;

  /// No description provided for @series.
  ///
  /// In en, this message translates to:
  /// **'Series'**
  String get series;

  /// No description provided for @catalog.
  ///
  /// In en, this message translates to:
  /// **'Catalogue'**
  String get catalog;

  /// No description provided for @data.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get data;

  /// No description provided for @file.
  ///
  /// In en, this message translates to:
  /// **'File'**
  String get file;

  /// No description provided for @formats.
  ///
  /// In en, this message translates to:
  /// **'Formats'**
  String get formats;

  /// No description provided for @distributionLanguages.
  ///
  /// In en, this message translates to:
  /// **'Distribution languages'**
  String get distributionLanguages;

  /// No description provided for @byteSize.
  ///
  /// In en, this message translates to:
  /// **'Size in bytes'**
  String get byteSize;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @advancedSettings.
  ///
  /// In en, this message translates to:
  /// **'Advanced settings'**
  String get advancedSettings;

  /// No description provided for @fileExtension.
  ///
  /// In en, this message translates to:
  /// **'File extension'**
  String get fileExtension;

  /// No description provided for @tableConceptMapping.
  ///
  /// In en, this message translates to:
  /// **'Custom sheet names and id fields'**
  String get tableConceptMapping;

  /// No description provided for @isIncluded.
  ///
  /// In en, this message translates to:
  /// **'Concept included in the file'**
  String get isIncluded;

  /// No description provided for @conceptUri.
  ///
  /// In en, this message translates to:
  /// **'Concept uri'**
  String get conceptUri;

  /// No description provided for @sheetName.
  ///
  /// In en, this message translates to:
  /// **'Sheet name'**
  String get sheetName;

  /// No description provided for @idFieldName.
  ///
  /// In en, this message translates to:
  /// **'Id field name'**
  String get idFieldName;

  /// No description provided for @loadData.
  ///
  /// In en, this message translates to:
  /// **'Load data'**
  String get loadData;

  /// No description provided for @errorWidgetMessage.
  ///
  /// In en, this message translates to:
  /// **'We encountered an error during file processing'**
  String get errorWidgetMessage;

  /// No description provided for @dataImportErrors.
  ///
  /// In en, this message translates to:
  /// **'Data import errors'**
  String get dataImportErrors;

  /// No description provided for @clearData.
  ///
  /// In en, this message translates to:
  /// **'Delete all data for dataset'**
  String get clearData;

  /// No description provided for @dataRows.
  ///
  /// In en, this message translates to:
  /// **'Data rows'**
  String get dataRows;

  /// No description provided for @structuredData.
  ///
  /// In en, this message translates to:
  /// **'Structured data'**
  String get structuredData;

  /// No description provided for @moreErrorsNotShown.
  ///
  /// In en, this message translates to:
  /// **'more errors not shown'**
  String get moreErrorsNotShown;

  /// No description provided for @downloadErrorLog.
  ///
  /// In en, this message translates to:
  /// **'Download full error log'**
  String get downloadErrorLog;

  /// No description provided for @couldNotReadFile.
  ///
  /// In en, this message translates to:
  /// **'Could not read selected file.'**
  String get couldNotReadFile;

  /// No description provided for @viewAndEditWithDefaultApp.
  ///
  /// In en, this message translates to:
  /// **'View and edit with default app'**
  String get viewAndEditWithDefaultApp;

  /// No description provided for @viewWithSelectedApp.
  ///
  /// In en, this message translates to:
  /// **'View and edit with selected app'**
  String get viewWithSelectedApp;

  /// No description provided for @catalogueUpdated.
  ///
  /// In en, this message translates to:
  /// **'Catalogue updated'**
  String get catalogueUpdated;

  /// No description provided for @catalogueCreated.
  ///
  /// In en, this message translates to:
  /// **'Catalogue created'**
  String get catalogueCreated;

  /// No description provided for @catalogueError.
  ///
  /// In en, this message translates to:
  /// **'Catalogue update error!'**
  String get catalogueError;

  /// No description provided for @catalogueDeleted.
  ///
  /// In en, this message translates to:
  /// **'Catalogue deleted'**
  String get catalogueDeleted;

  /// No description provided for @catalogueResourceError.
  ///
  /// In en, this message translates to:
  /// **'Catalogue contains resources!'**
  String get catalogueResourceError;

  /// No description provided for @catalogueDeleteError.
  ///
  /// In en, this message translates to:
  /// **'Catalogue deletion error!'**
  String get catalogueDeleteError;

  /// No description provided for @datasetUpdated.
  ///
  /// In en, this message translates to:
  /// **'Dataset updated'**
  String get datasetUpdated;

  /// No description provided for @datasetCreated.
  ///
  /// In en, this message translates to:
  /// **'Dataset created'**
  String get datasetCreated;

  /// No description provided for @datasetCreatedPublished.
  ///
  /// In en, this message translates to:
  /// **'Dataset created and published'**
  String get datasetCreatedPublished;

  /// No description provided for @datasetUpdatedPublished.
  ///
  /// In en, this message translates to:
  /// **'Dataset updated and published'**
  String get datasetUpdatedPublished;

  /// No description provided for @datasetPublished.
  ///
  /// In en, this message translates to:
  /// **'Dataset published'**
  String get datasetPublished;

  /// No description provided for @datasetPublishError.
  ///
  /// In en, this message translates to:
  /// **'Dataset publishing error!'**
  String get datasetPublishError;

  /// No description provided for @datasetUnpublishError.
  ///
  /// In en, this message translates to:
  /// **'Dataset unpublishing error!'**
  String get datasetUnpublishError;

  /// No description provided for @datasetUnpublished.
  ///
  /// In en, this message translates to:
  /// **'Dataset unpublished'**
  String get datasetUnpublished;

  /// No description provided for @datasetError.
  ///
  /// In en, this message translates to:
  /// **'Dataset update error!'**
  String get datasetError;

  /// No description provided for @seriesUpdated.
  ///
  /// In en, this message translates to:
  /// **'Dataset series updated'**
  String get seriesUpdated;

  /// No description provided for @seriesCreated.
  ///
  /// In en, this message translates to:
  /// **'Dataset series created'**
  String get seriesCreated;

  /// No description provided for @seriesError.
  ///
  /// In en, this message translates to:
  /// **'Dataset series update error!'**
  String get seriesError;

  /// No description provided for @seriesDeleted.
  ///
  /// In en, this message translates to:
  /// **'Series deleted'**
  String get seriesDeleted;

  /// No description provided for @seriesDeleteError.
  ///
  /// In en, this message translates to:
  /// **'Series deletion error!'**
  String get seriesDeleteError;

  /// No description provided for @serviceUpdated.
  ///
  /// In en, this message translates to:
  /// **'Data service updated'**
  String get serviceUpdated;

  /// No description provided for @serviceCreated.
  ///
  /// In en, this message translates to:
  /// **'Data service created'**
  String get serviceCreated;

  /// No description provided for @serviceError.
  ///
  /// In en, this message translates to:
  /// **'Data service update error!'**
  String get serviceError;

  /// No description provided for @serviceDeleted.
  ///
  /// In en, this message translates to:
  /// **'Service deleted'**
  String get serviceDeleted;

  /// No description provided for @serviceDeleteError.
  ///
  /// In en, this message translates to:
  /// **'Service deletion error!'**
  String get serviceDeleteError;

  /// No description provided for @dataPublishError.
  ///
  /// In en, this message translates to:
  /// **'Error publishing data to Ckan Datastore!'**
  String get dataPublishError;

  /// No description provided for @datastoreSuccess.
  ///
  /// In en, this message translates to:
  /// **'Data uploaded to Datastore'**
  String get datastoreSuccess;

  /// No description provided for @datastorePartialSuccess.
  ///
  /// In en, this message translates to:
  /// **'Data upload was partially successful'**
  String get datastorePartialSuccess;

  /// No description provided for @datastoreFailure.
  ///
  /// In en, this message translates to:
  /// **'Data upload failed'**
  String get datastoreFailure;

  /// No description provided for @upsertedRows.
  ///
  /// In en, this message translates to:
  /// **'Upserted rows'**
  String get upsertedRows;

  /// No description provided for @warningIndependentDataset.
  ///
  /// In en, this message translates to:
  /// **'Warning: dataset is independent'**
  String get warningIndependentDataset;

  /// No description provided for @datasetServices.
  ///
  /// In en, this message translates to:
  /// **'Dataset Service'**
  String get datasetServices;

  /// No description provided for @addNewDataset.
  ///
  /// In en, this message translates to:
  /// **'Add new dataset'**
  String get addNewDataset;

  /// No description provided for @addNewCatalogue.
  ///
  /// In en, this message translates to:
  /// **'Add new catalogue'**
  String get addNewCatalogue;

  /// No description provided for @addNewSeries.
  ///
  /// In en, this message translates to:
  /// **'Add new series'**
  String get addNewSeries;

  /// No description provided for @addNewService.
  ///
  /// In en, this message translates to:
  /// **'Add new service'**
  String get addNewService;

  /// No description provided for @editDataset.
  ///
  /// In en, this message translates to:
  /// **'Edit dataset'**
  String get editDataset;

  /// No description provided for @editCatalog.
  ///
  /// In en, this message translates to:
  /// **'Edit catalogue'**
  String get editCatalog;

  /// No description provided for @editSeries.
  ///
  /// In en, this message translates to:
  /// **'Edit series'**
  String get editSeries;

  /// No description provided for @editService.
  ///
  /// In en, this message translates to:
  /// **'Edit service'**
  String get editService;

  /// No description provided for @openCatalog.
  ///
  /// In en, this message translates to:
  /// **'Open catalogue'**
  String get openCatalog;

  /// No description provided for @deleteCatalog.
  ///
  /// In en, this message translates to:
  /// **'Delete catalogue'**
  String get deleteCatalog;

  /// No description provided for @deleteDataset.
  ///
  /// In en, this message translates to:
  /// **'Delete dataset'**
  String get deleteDataset;

  /// No description provided for @openSeries.
  ///
  /// In en, this message translates to:
  /// **'Open series'**
  String get openSeries;

  /// No description provided for @openService.
  ///
  /// In en, this message translates to:
  /// **'Open service'**
  String get openService;

  /// No description provided for @deleteSeries.
  ///
  /// In en, this message translates to:
  /// **'Delete series'**
  String get deleteSeries;

  /// No description provided for @deleteService.
  ///
  /// In en, this message translates to:
  /// **'Delete service'**
  String get deleteService;

  /// No description provided for @publish.
  ///
  /// In en, this message translates to:
  /// **'Publish'**
  String get publish;

  /// No description provided for @parentCatalog.
  ///
  /// In en, this message translates to:
  /// **'Parent catalogue'**
  String get parentCatalog;

  /// No description provided for @addLanguage.
  ///
  /// In en, this message translates to:
  /// **'Add Language'**
  String get addLanguage;

  /// No description provided for @newContacts.
  ///
  /// In en, this message translates to:
  /// **'New contacts'**
  String get newContacts;

  /// No description provided for @dateInvalid.
  ///
  /// In en, this message translates to:
  /// **'Date not valid'**
  String get dateInvalid;

  /// No description provided for @respAgentNotAssigned.
  ///
  /// In en, this message translates to:
  /// **'Select responsible person or organisation!'**
  String get respAgentNotAssigned;

  /// No description provided for @mainCatalog.
  ///
  /// In en, this message translates to:
  /// **'Main Catalog'**
  String get mainCatalog;

  /// No description provided for @publishMetadata.
  ///
  /// In en, this message translates to:
  /// **'Publish metadata'**
  String get publishMetadata;

  /// No description provided for @publishData.
  ///
  /// In en, this message translates to:
  /// **'Publish data with metadata'**
  String get publishData;

  /// No description provided for @unpublish.
  ///
  /// In en, this message translates to:
  /// **'Unpublish'**
  String get unpublish;

  /// No description provided for @previewDataset.
  ///
  /// In en, this message translates to:
  /// **'Preview dataset'**
  String get previewDataset;

  /// No description provided for @createDefaultApp.
  ///
  /// In en, this message translates to:
  /// **'Create default edit application'**
  String get createDefaultApp;

  /// No description provided for @schemaNotSelected.
  ///
  /// In en, this message translates to:
  /// **'Please select a schema before creating an app'**
  String get schemaNotSelected;

  /// No description provided for @previewSeries.
  ///
  /// In en, this message translates to:
  /// **'Preview series'**
  String get previewSeries;

  /// No description provided for @previewCatalogue.
  ///
  /// In en, this message translates to:
  /// **'Preview catalogue'**
  String get previewCatalogue;

  /// No description provided for @previewService.
  ///
  /// In en, this message translates to:
  /// **'Preview service'**
  String get previewService;

  /// No description provided for @noItemsFoundForCatalogues.
  ///
  /// In en, this message translates to:
  /// **'No items found, create new catalogue or switch to Data Resources to view them'**
  String get noItemsFoundForCatalogues;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @accessStatus.
  ///
  /// In en, this message translates to:
  /// **'Access status'**
  String get accessStatus;

  /// No description provided for @mediaType.
  ///
  /// In en, this message translates to:
  /// **'Media type'**
  String get mediaType;

  /// No description provided for @accessUrl.
  ///
  /// In en, this message translates to:
  /// **'Access URL'**
  String get accessUrl;

  /// No description provided for @metadataLanguage.
  ///
  /// In en, this message translates to:
  /// **'Metadata Language'**
  String get metadataLanguage;

  /// No description provided for @dataLanguage.
  ///
  /// In en, this message translates to:
  /// **'Data languages'**
  String get dataLanguage;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @statusField.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get statusField;

  /// No description provided for @typesField.
  ///
  /// In en, this message translates to:
  /// **'Types'**
  String get typesField;

  /// No description provided for @titleField.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get titleField;

  /// No description provided for @documentation.
  ///
  /// In en, this message translates to:
  /// **'Documentation'**
  String get documentation;

  /// No description provided for @provenance.
  ///
  /// In en, this message translates to:
  /// **'Provenance'**
  String get provenance;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @versionNotes.
  ///
  /// In en, this message translates to:
  /// **'Version notes'**
  String get versionNotes;

  /// No description provided for @geographicalCoverage.
  ///
  /// In en, this message translates to:
  /// **'Geographical Coverage'**
  String get geographicalCoverage;

  /// No description provided for @frequency.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get frequency;

  /// No description provided for @temporalCoverage.
  ///
  /// In en, this message translates to:
  /// **'Temporal Coverage (from - to)'**
  String get temporalCoverage;

  /// No description provided for @temporalCoverageFrom.
  ///
  /// In en, this message translates to:
  /// **'Temporal Coverage from'**
  String get temporalCoverageFrom;

  /// No description provided for @temporalCoverageTo.
  ///
  /// In en, this message translates to:
  /// **'Temporal Coverage to'**
  String get temporalCoverageTo;

  /// No description provided for @releaseDate.
  ///
  /// In en, this message translates to:
  /// **'Release Date'**
  String get releaseDate;

  /// No description provided for @accessRights.
  ///
  /// In en, this message translates to:
  /// **'Access rights'**
  String get accessRights;

  /// No description provided for @keywords.
  ///
  /// In en, this message translates to:
  /// **'Keywords'**
  String get keywords;

  /// No description provided for @themes.
  ///
  /// In en, this message translates to:
  /// **'Themes'**
  String get themes;

  /// No description provided for @responsiblePerson.
  ///
  /// In en, this message translates to:
  /// **'Responsible person'**
  String get responsiblePerson;

  /// No description provided for @responsibleOrganization.
  ///
  /// In en, this message translates to:
  /// **'Responsible organization'**
  String get responsibleOrganization;

  /// No description provided for @applicableLegislation.
  ///
  /// In en, this message translates to:
  /// **'Applicable Legislation'**
  String get applicableLegislation;

  /// No description provided for @licence.
  ///
  /// In en, this message translates to:
  /// **'Licence'**
  String get licence;

  /// No description provided for @editors.
  ///
  /// In en, this message translates to:
  /// **'Editors'**
  String get editors;

  /// No description provided for @actions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get actions;

  /// No description provided for @datasetTitle.
  ///
  /// In en, this message translates to:
  /// **'Dataset Title'**
  String get datasetTitle;

  /// No description provided for @dataServiceTitle.
  ///
  /// In en, this message translates to:
  /// **'DataService Title'**
  String get dataServiceTitle;

  /// No description provided for @endpointUrl.
  ///
  /// In en, this message translates to:
  /// **'Endpoint URL'**
  String get endpointUrl;

  /// No description provided for @endpointDescription.
  ///
  /// In en, this message translates to:
  /// **'Endpoint description'**
  String get endpointDescription;

  /// No description provided for @targetDataset.
  ///
  /// In en, this message translates to:
  /// **'Target dataset'**
  String get targetDataset;

  /// No description provided for @schemaCreated.
  ///
  /// In en, this message translates to:
  /// **'Data schema created'**
  String get schemaCreated;

  /// No description provided for @schemaUpdated.
  ///
  /// In en, this message translates to:
  /// **'Data schema updated'**
  String get schemaUpdated;

  /// No description provided for @schemaError.
  ///
  /// In en, this message translates to:
  /// **'Data schema update error!'**
  String get schemaError;

  /// No description provided for @defaultValue.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get defaultValue;

  /// No description provided for @deleteConcept.
  ///
  /// In en, this message translates to:
  /// **'Delete concept'**
  String get deleteConcept;

  /// No description provided for @deleteProperty.
  ///
  /// In en, this message translates to:
  /// **'Delete property'**
  String get deleteProperty;

  /// No description provided for @defaultNotSet.
  ///
  /// In en, this message translates to:
  /// **'Default namespace is not set'**
  String get defaultNotSet;

  /// No description provided for @deleteSchema.
  ///
  /// In en, this message translates to:
  /// **'Delete schema'**
  String get deleteSchema;

  /// No description provided for @schemaDeleted.
  ///
  /// In en, this message translates to:
  /// **'Schema deleted'**
  String get schemaDeleted;

  /// No description provided for @schemaDeleteError.
  ///
  /// In en, this message translates to:
  /// **'Error deleting schema!'**
  String get schemaDeleteError;

  /// No description provided for @addConcept.
  ///
  /// In en, this message translates to:
  /// **'Add concept'**
  String get addConcept;

  /// No description provided for @addProperty.
  ///
  /// In en, this message translates to:
  /// **'Add property'**
  String get addProperty;

  /// No description provided for @schemaSeriesCreated.
  ///
  /// In en, this message translates to:
  /// **'Schema series created'**
  String get schemaSeriesCreated;

  /// No description provided for @schemaSeriesUpdated.
  ///
  /// In en, this message translates to:
  /// **'Schema series updated'**
  String get schemaSeriesUpdated;

  /// No description provided for @schemaSeriesError.
  ///
  /// In en, this message translates to:
  /// **'Schema series update error!'**
  String get schemaSeriesError;

  /// No description provided for @deleteSchemaSeries.
  ///
  /// In en, this message translates to:
  /// **'Delete schema series'**
  String get deleteSchemaSeries;

  /// No description provided for @schemaSeriesDeleted.
  ///
  /// In en, this message translates to:
  /// **'Schema series deleted'**
  String get schemaSeriesDeleted;

  /// No description provided for @schemaSeriesDeleteError.
  ///
  /// In en, this message translates to:
  /// **'Error deleting schema series!'**
  String get schemaSeriesDeleteError;

  /// No description provided for @schemaSeriesResourceError.
  ///
  /// In en, this message translates to:
  /// **'Series contains resources'**
  String get schemaSeriesResourceError;

  /// No description provided for @schemaSeriesNotFoundError.
  ///
  /// In en, this message translates to:
  /// **'Series not found'**
  String get schemaSeriesNotFoundError;

  /// No description provided for @appUpdated.
  ///
  /// In en, this message translates to:
  /// **'App updated'**
  String get appUpdated;

  /// No description provided for @appError.
  ///
  /// In en, this message translates to:
  /// **'App update error!'**
  String get appError;

  /// No description provided for @appDeleted.
  ///
  /// In en, this message translates to:
  /// **'App deleted'**
  String get appDeleted;

  /// No description provided for @appDeleteError.
  ///
  /// In en, this message translates to:
  /// **'App deletion error!'**
  String get appDeleteError;

  /// No description provided for @templateDeleted.
  ///
  /// In en, this message translates to:
  /// **'Template deleted'**
  String get templateDeleted;

  /// No description provided for @templateDeleteError.
  ///
  /// In en, this message translates to:
  /// **'Template deletion error!'**
  String get templateDeleteError;

  /// No description provided for @templateCreated.
  ///
  /// In en, this message translates to:
  /// **'Template created'**
  String get templateCreated;

  /// No description provided for @templateError.
  ///
  /// In en, this message translates to:
  /// **'Template creation error!'**
  String get templateError;

  /// No description provided for @templateGenerated.
  ///
  /// In en, this message translates to:
  /// **'Template generated'**
  String get templateGenerated;

  /// No description provided for @templateGenerateError.
  ///
  /// In en, this message translates to:
  /// **'Template generation error!'**
  String get templateGenerateError;

  /// No description provided for @appDeployStarted.
  ///
  /// In en, this message translates to:
  /// **'App deployment initialized'**
  String get appDeployStarted;

  /// No description provided for @appDeployError.
  ///
  /// In en, this message translates to:
  /// **'App deployment error!'**
  String get appDeployError;

  /// No description provided for @appStatusesRefreshed.
  ///
  /// In en, this message translates to:
  /// **'App statuses refreshed'**
  String get appStatusesRefreshed;

  /// No description provided for @schema.
  ///
  /// In en, this message translates to:
  /// **'Data Schema'**
  String get schema;

  /// No description provided for @listVersions.
  ///
  /// In en, this message translates to:
  /// **'List versions'**
  String get listVersions;

  /// No description provided for @openSchema.
  ///
  /// In en, this message translates to:
  /// **'Preview data schema'**
  String get openSchema;

  /// No description provided for @noSeries.
  ///
  /// In en, this message translates to:
  /// **'[Not in series]'**
  String get noSeries;

  /// No description provided for @array.
  ///
  /// In en, this message translates to:
  /// **'Array'**
  String get array;

  /// No description provided for @unique.
  ///
  /// In en, this message translates to:
  /// **'Unique'**
  String get unique;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @schemaSeries.
  ///
  /// In en, this message translates to:
  /// **'Schema series'**
  String get schemaSeries;

  /// No description provided for @addSchema.
  ///
  /// In en, this message translates to:
  /// **'Add data schema'**
  String get addSchema;

  /// No description provided for @editSchema.
  ///
  /// In en, this message translates to:
  /// **'Edit data schema'**
  String get editSchema;

  /// No description provided for @schemaTitle.
  ///
  /// In en, this message translates to:
  /// **'Data schema title'**
  String get schemaTitle;

  /// No description provided for @namespacePrefix.
  ///
  /// In en, this message translates to:
  /// **'Namespace prefix'**
  String get namespacePrefix;

  /// No description provided for @namespaces.
  ///
  /// In en, this message translates to:
  /// **'Namespaces'**
  String get namespaces;

  /// No description provided for @usedNamespaces.
  ///
  /// In en, this message translates to:
  /// **'Used namespaces'**
  String get usedNamespaces;

  /// No description provided for @newNamespaces.
  ///
  /// In en, this message translates to:
  /// **'New namespaces'**
  String get newNamespaces;

  /// No description provided for @namespace.
  ///
  /// In en, this message translates to:
  /// **'Namespace'**
  String get namespace;

  /// No description provided for @namespaceIri.
  ///
  /// In en, this message translates to:
  /// **'Namespace iri'**
  String get namespaceIri;

  /// No description provided for @defaultNamespace.
  ///
  /// In en, this message translates to:
  /// **'Default namespace'**
  String get defaultNamespace;

  /// No description provided for @concepts.
  ///
  /// In en, this message translates to:
  /// **'Concepts'**
  String get concepts;

  /// No description provided for @conceptName.
  ///
  /// In en, this message translates to:
  /// **'Concept name'**
  String get conceptName;

  /// No description provided for @untitledConcept.
  ///
  /// In en, this message translates to:
  /// **'Untitled concept'**
  String get untitledConcept;

  /// No description provided for @mainConcept.
  ///
  /// In en, this message translates to:
  /// **'Main concept'**
  String get mainConcept;

  /// No description provided for @properties.
  ///
  /// In en, this message translates to:
  /// **'Properties'**
  String get properties;

  /// No description provided for @propertyName.
  ///
  /// In en, this message translates to:
  /// **'Property name'**
  String get propertyName;

  /// No description provided for @currentSchema.
  ///
  /// In en, this message translates to:
  /// **'Current data schema'**
  String get currentSchema;

  /// No description provided for @customIriNotUnique.
  ///
  /// In en, this message translates to:
  /// **'Custom namespace iri cannot be the same as standard namespace iri'**
  String get customIriNotUnique;

  /// No description provided for @customPrefixNotUnique.
  ///
  /// In en, this message translates to:
  /// **'Custom namespace prefix cannot be the same as standard namespace prefix'**
  String get customPrefixNotUnique;

  /// No description provided for @valueAlreadyUsed.
  ///
  /// In en, this message translates to:
  /// **'Value already used!'**
  String get valueAlreadyUsed;

  /// No description provided for @noSeriesPrivileges.
  ///
  /// In en, this message translates to:
  /// **'You have no priviliges to any schema series'**
  String get noSeriesPrivileges;

  /// No description provided for @showAppDetails.
  ///
  /// In en, this message translates to:
  /// **'Preview app'**
  String get showAppDetails;

  /// No description provided for @deleteApp.
  ///
  /// In en, this message translates to:
  /// **'Delete app'**
  String get deleteApp;

  /// No description provided for @addNewApp.
  ///
  /// In en, this message translates to:
  /// **'Add new app'**
  String get addNewApp;

  /// No description provided for @apps.
  ///
  /// In en, this message translates to:
  /// **'Acquisition apps'**
  String get apps;

  /// No description provided for @appTemplates.
  ///
  /// In en, this message translates to:
  /// **'App templates'**
  String get appTemplates;

  /// No description provided for @template.
  ///
  /// In en, this message translates to:
  /// **'Template'**
  String get template;

  /// No description provided for @addNewTemplate.
  ///
  /// In en, this message translates to:
  /// **'Add new template'**
  String get addNewTemplate;

  /// No description provided for @openTemplate.
  ///
  /// In en, this message translates to:
  /// **'Preview template'**
  String get openTemplate;

  /// No description provided for @editTemplate.
  ///
  /// In en, this message translates to:
  /// **'Edit template'**
  String get editTemplate;

  /// No description provided for @deleteTemplate.
  ///
  /// In en, this message translates to:
  /// **'Delete template'**
  String get deleteTemplate;

  /// No description provided for @enabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get enabled;

  /// No description provided for @disabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get disabled;

  /// No description provided for @visible.
  ///
  /// In en, this message translates to:
  /// **'Visible'**
  String get visible;

  /// No description provided for @hidden.
  ///
  /// In en, this message translates to:
  /// **'Hidden'**
  String get hidden;

  /// No description provided for @toUpdate.
  ///
  /// In en, this message translates to:
  /// **'Will be updated - are you sure?'**
  String get toUpdate;

  /// No description provided for @createApp.
  ///
  /// In en, this message translates to:
  /// **'Create app'**
  String get createApp;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @activeResource.
  ///
  /// In en, this message translates to:
  /// **'Active resource'**
  String get activeResource;

  /// No description provided for @app.
  ///
  /// In en, this message translates to:
  /// **'App'**
  String get app;

  /// No description provided for @editApp.
  ///
  /// In en, this message translates to:
  /// **'Edit app'**
  String get editApp;

  /// No description provided for @noNameError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a name.'**
  String get noNameError;

  /// No description provided for @noCatalogueError.
  ///
  /// In en, this message translates to:
  /// **'Please select a parent catalogue.'**
  String get noCatalogueError;

  /// No description provided for @datasetIdentifierNotUnique.
  ///
  /// In en, this message translates to:
  /// **'A dataset with this identifier already exists.'**
  String get datasetIdentifierNotUnique;

  /// No description provided for @selectEditors.
  ///
  /// In en, this message translates to:
  /// **'Select editors'**
  String get selectEditors;

  /// No description provided for @selectCatForResources.
  ///
  /// In en, this message translates to:
  /// **'Select catalogue for new resources'**
  String get selectCatForResources;

  /// No description provided for @sourceResources.
  ///
  /// In en, this message translates to:
  /// **'Source resources'**
  String get sourceResources;

  /// No description provided for @addNewResource.
  ///
  /// In en, this message translates to:
  /// **'Add new resource'**
  String get addNewResource;

  /// No description provided for @newField.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get newField;

  /// No description provided for @activeResourceCannotBeSourceResource.
  ///
  /// In en, this message translates to:
  /// **'Active resource cannot also be a source resource'**
  String get activeResourceCannotBeSourceResource;

  /// No description provided for @createTemplate.
  ///
  /// In en, this message translates to:
  /// **'Create app template'**
  String get createTemplate;

  /// No description provided for @isReadyLabel.
  ///
  /// In en, this message translates to:
  /// **'Is ready'**
  String get isReadyLabel;

  /// No description provided for @usecaseScenarios.
  ///
  /// In en, this message translates to:
  /// **'Use cases'**
  String get usecaseScenarios;

  /// No description provided for @fillTitlesAndDescriptions.
  ///
  /// In en, this message translates to:
  /// **'Fill out all text fields!'**
  String get fillTitlesAndDescriptions;

  /// No description provided for @versionOf.
  ///
  /// In en, this message translates to:
  /// **'Is version of:'**
  String get versionOf;

  /// No description provided for @scenarios.
  ///
  /// In en, this message translates to:
  /// **'Scenarios'**
  String get scenarios;

  /// No description provided for @titleNotUnique.
  ///
  /// In en, this message translates to:
  /// **'Title must be unique'**
  String get titleNotUnique;

  /// No description provided for @useCase.
  ///
  /// In en, this message translates to:
  /// **'Use case'**
  String get useCase;

  /// No description provided for @untitledProperty.
  ///
  /// In en, this message translates to:
  /// **'Untitled property'**
  String get untitledProperty;

  /// No description provided for @idProperty.
  ///
  /// In en, this message translates to:
  /// **'Default identifier'**
  String get idProperty;

  /// No description provided for @deleteConceptWarning.
  ///
  /// In en, this message translates to:
  /// **'Warning: deleting concept from schema will result in deleting its data items'**
  String get deleteConceptWarning;

  /// No description provided for @idMustBeUniqueAndRequired.
  ///
  /// In en, this message translates to:
  /// **'Default identifier property must be unique and required'**
  String get idMustBeUniqueAndRequired;

  /// No description provided for @auxiliaryConcepts.
  ///
  /// In en, this message translates to:
  /// **'Auxiliary concepts'**
  String get auxiliaryConcepts;

  /// No description provided for @activateAdvancedScenarioEditing.
  ///
  /// In en, this message translates to:
  /// **'Activate advanced scenario editing'**
  String get activateAdvancedScenarioEditing;

  /// No description provided for @cannotRevertWarning.
  ///
  /// In en, this message translates to:
  /// **'Warning: this action cannot be reverted'**
  String get cannotRevertWarning;

  /// No description provided for @compileTemplate.
  ///
  /// In en, this message translates to:
  /// **'Compile template'**
  String get compileTemplate;

  /// No description provided for @deployApp.
  ///
  /// In en, this message translates to:
  /// **'Deploy App'**
  String get deployApp;

  /// No description provided for @created.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get created;

  /// No description provided for @inProcessing.
  ///
  /// In en, this message translates to:
  /// **'In Processing'**
  String get inProcessing;

  /// No description provided for @ready.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get ready;

  /// No description provided for @hasErrors.
  ///
  /// In en, this message translates to:
  /// **'Has Errors'**
  String get hasErrors;

  /// No description provided for @refreshAppStatuses.
  ///
  /// In en, this message translates to:
  /// **'Refresh app statuses'**
  String get refreshAppStatuses;

  /// No description provided for @isCompiled.
  ///
  /// In en, this message translates to:
  /// **'Compiled'**
  String get isCompiled;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get emailHint;

  /// No description provided for @unvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email (e.g. abc@gmail.com)'**
  String get unvalidEmail;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get passwordHint;

  /// No description provided for @unvalidPassword.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get unvalidPassword;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Email or Password is incorrect'**
  String get loginFailed;

  /// No description provided for @datasetCatalogue.
  ///
  /// In en, this message translates to:
  /// **'Dataset Catalogue'**
  String get datasetCatalogue;

  /// No description provided for @editCurrent.
  ///
  /// In en, this message translates to:
  /// **'Edit current'**
  String get editCurrent;

  /// No description provided for @editContents.
  ///
  /// In en, this message translates to:
  /// **'Edit contents'**
  String get editContents;

  /// No description provided for @openSchemaSeries.
  ///
  /// In en, this message translates to:
  /// **'Preview schema series'**
  String get openSchemaSeries;

  /// No description provided for @rolesAndOrganizations.
  ///
  /// In en, this message translates to:
  /// **'Roles and organizations'**
  String get rolesAndOrganizations;

  /// No description provided for @memberOf.
  ///
  /// In en, this message translates to:
  /// **'Member of'**
  String get memberOf;

  /// No description provided for @selectMember.
  ///
  /// In en, this message translates to:
  /// **'Select member'**
  String get selectMember;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phone;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @dataService.
  ///
  /// In en, this message translates to:
  /// **'Data service'**
  String get dataService;

  /// No description provided for @responsiblePersonUri.
  ///
  /// In en, this message translates to:
  /// **'Responsible person URI'**
  String get responsiblePersonUri;

  /// No description provided for @responsiblePersonName.
  ///
  /// In en, this message translates to:
  /// **'Responsible person name'**
  String get responsiblePersonName;

  /// No description provided for @responsibleOrganizationUri.
  ///
  /// In en, this message translates to:
  /// **'Responsible organisation URI'**
  String get responsibleOrganizationUri;

  /// No description provided for @responsibleOrganizationName.
  ///
  /// In en, this message translates to:
  /// **'Responsible organisation name'**
  String get responsibleOrganizationName;

  /// No description provided for @editorsUris.
  ///
  /// In en, this message translates to:
  /// **'Editors URIs'**
  String get editorsUris;

  /// No description provided for @contactsUris.
  ///
  /// In en, this message translates to:
  /// **'Contacts URIs'**
  String get contactsUris;

  /// No description provided for @languages.
  ///
  /// In en, this message translates to:
  /// **'Languages'**
  String get languages;

  /// No description provided for @catalogueUri.
  ///
  /// In en, this message translates to:
  /// **'Catalogue URI'**
  String get catalogueUri;

  /// No description provided for @catalogueTitle.
  ///
  /// In en, this message translates to:
  /// **'Catalogue title'**
  String get catalogueTitle;

  /// No description provided for @standardUris.
  ///
  /// In en, this message translates to:
  /// **'Standard URIs'**
  String get standardUris;

  /// No description provided for @standardTitle.
  ///
  /// In en, this message translates to:
  /// **'Standard title'**
  String get standardTitle;

  /// No description provided for @datasetUri.
  ///
  /// In en, this message translates to:
  /// **'Dataset URI'**
  String get datasetUri;

  /// No description provided for @compressionFormat.
  ///
  /// In en, this message translates to:
  /// **'Compression format'**
  String get compressionFormat;

  /// No description provided for @downloadUrl.
  ///
  /// In en, this message translates to:
  /// **'Download URL'**
  String get downloadUrl;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'de',
        'en',
        'hr',
        'it',
        'pl',
        'sk',
        'sl'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'hr':
      return AppLocalizationsHr();
    case 'it':
      return AppLocalizationsIt();
    case 'pl':
      return AppLocalizationsPl();
    case 'sk':
      return AppLocalizationsSk();
    case 'sl':
      return AppLocalizationsSl();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
