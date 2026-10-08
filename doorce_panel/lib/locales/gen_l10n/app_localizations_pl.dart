// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get panelName => 'Panel zarządzania danymi';

  @override
  String get main => 'Główny';

  @override
  String get mainMenu => 'Menu główne';

  @override
  String get dataManagement => 'Zarządzanie danymi';

  @override
  String get dataManagementDescription =>
      'Zarządzaj zawartością zbiorów danych';

  @override
  String get datasets => 'Zbiory danych';

  @override
  String get cataloguing => 'Zarządzanie metadanymi';

  @override
  String get metadataManagementDescription =>
      'Zarządzaj metadanymi katalogów i zbiorów danych';

  @override
  String get catalogue => 'Katalogi';

  @override
  String get schemaManagement => 'Zarządzanie schematami danych';

  @override
  String get schemaManagementDescription =>
      'Zarządzaj strukturami danych zbiorów danych';

  @override
  String get schemas => 'Schematy';

  @override
  String get agentManagement => 'Zarządzanie agentami danych';

  @override
  String get agentManagementDescription => 'Zarządzaj osobami i organizacjami';

  @override
  String get agents => 'Agenci';

  @override
  String get profile => 'Profil';

  @override
  String get logout => 'Wyloguj się';

  @override
  String get settings => 'Ustawienia';

  @override
  String get dataResources => 'Zasoby danych';

  @override
  String get invalidIdentifier => 'Nieprawidłowy identyfikator';

  @override
  String get filter => 'Filtruj';

  @override
  String get close => 'Zamknij';

  @override
  String get save => 'Zapisz';

  @override
  String get identifier => 'Identyfikator';

  @override
  String get description => 'Opis';

  @override
  String get fieldRequired => '* Wymagane';

  @override
  String get formError => 'Błędy w formularzu - sprawdź powyżej';

  @override
  String get unsavedChanges => 'Niezapisane zmiany';

  @override
  String get add => 'Dodaj';

  @override
  String get loading => 'Ładowanie...';

  @override
  String get addIcon => 'Dodaj ikonę';

  @override
  String get apply => 'Zastosuj';

  @override
  String get and => 'AND';

  @override
  String get or => 'OR';

  @override
  String get fromList => 'Z listy';

  @override
  String get own => 'Własna';

  @override
  String get iconName => 'Nazwa ikony';

  @override
  String get selectIcon => 'Wybór ikony';

  @override
  String get wrongName => 'Nazwa nieprawidłowa lub już istnieje';

  @override
  String get selectFile => 'Wybierz plik';

  @override
  String get preview => 'Podgląd:';

  @override
  String get cancel => 'Anuluj';

  @override
  String get text => 'Tekst';

  @override
  String get select => 'Wybierz';

  @override
  String get toDelete => 'Kasowanie - jesteś pewien?';

  @override
  String get toPublish => 'Publikacja zbioru danych - jesteś pewien?';

  @override
  String get toUnpublish => 'Cofnięcie publikacji - jesteś pewien?';

  @override
  String get yes => 'Tak';

  @override
  String get no => 'Nie';

  @override
  String get noRolesAssigned => 'Brak przypisanych ról';

  @override
  String get clickToExpand => 'Kliknij, aby rozwinąć';

  @override
  String get selectRolesForEditors => 'Wybierz role dla wszystkich redaktorów';

  @override
  String get removeAgent => 'Usuń agenta';

  @override
  String get removeEditor => 'Usuń redaktora';

  @override
  String get ownershipEditorError =>
      'Wybierz co najmniej 1 Redaktora Własności';

  @override
  String get search => 'Szukaj';

  @override
  String get delete => 'Usuń';

  @override
  String get editableByMe => 'Edytowalne przeze mnie';

  @override
  String get showing => 'Pokazuje';

  @override
  String get outOf => 'z';

  @override
  String get noItemsFound => 'Nie znaleziono elementów';

  @override
  String get clearFilters => 'Wyczyść filtry';

  @override
  String get draft => 'Szkic';

  @override
  String get active => 'Aktywny';

  @override
  String get deleted => 'Usunięty';

  @override
  String get source => 'Źródłowy';

  @override
  String get independent => 'Independent';

  @override
  String get quantitative => 'Ilościowy';

  @override
  String get qualitative => 'Jakościowy';

  @override
  String get geospatial => 'Geolokalizacyjny';

  @override
  String get timeSeries => 'SeriaCzasowa';

  @override
  String get textual => 'Tekstowy';

  @override
  String get images => 'Obrazy';

  @override
  String get available => 'dostępny';

  @override
  String get unavailable => 'niedostępny';

  @override
  String get defective => 'uszkodzony';

  @override
  String get public => 'Publiczny';

  @override
  String get confidential => 'Poufny';

  @override
  String get nonPublic => 'Niepubliczny';

  @override
  String get restricted => 'Ograniczony';

  @override
  String get sensitive => 'Wrażliwy';

  @override
  String get provisional => 'Tymczasowy';

  @override
  String get distributionEditor => 'Redaktor Dystrybucji';

  @override
  String get metadataEditor => 'Redaktor Metadanych';

  @override
  String get ownershipEditor => 'Redaktor Własności';

  @override
  String get agentManager => 'Menedżer Agentów';

  @override
  String get metadataManager => 'Menedżer Metadanych';

  @override
  String get distributionManager => 'Menedżer Dystrybucji';

  @override
  String get ownershipManager => 'Menedżer Własności';

  @override
  String get agentAdmin => 'Administrator Agentów';

  @override
  String get dataAdmin => 'Administrator Danych';

  @override
  String get schemaCreator => 'Schema Creator';

  @override
  String get authKeycloakError => 'Błąd uwierzytelniania';

  @override
  String get authError => 'Nie masz uprawnień do edycji tego zasobu';

  @override
  String get authBackendError =>
      'Konto użytkownika nie istnieje lub serwer jest niedostępny';

  @override
  String get reloginRequired => 'Sesja wygasła - wymagane logowanie';

  @override
  String get agentDeleted => 'Osoba/organizacja skasowana';

  @override
  String get agentDeleteError => 'Błąd kasowania osoby/organizacji!';

  @override
  String get userDeleted => 'Użytkownik skasowany';

  @override
  String get userDeleteError => 'Błąd kasowania użytkownika!';

  @override
  String get userUpdated => 'Konto użytkownika zaktualizowane';

  @override
  String get userError => 'Błąd aktualizacji konta użytkownika!';

  @override
  String get agentUpdated => 'Osoba/organizacja zaktualizowana';

  @override
  String get agentCreated => 'Osoba/organizacja utworzona';

  @override
  String get agentError => 'Błąd aktualizacji osoby/organizacji!';

  @override
  String get agentContactError => 'Kontakty są wykorzystywane przez zasoby!';

  @override
  String get agentResourceError =>
      'Osoba/organizacja zarządza zasobami danych!';

  @override
  String get people => 'Osoby';

  @override
  String get users => 'Użytkownicy';

  @override
  String get organisations => 'Organizacje';

  @override
  String get addPerson => 'Dodaj osobę';

  @override
  String get editPerson => 'Edytuj osobę';

  @override
  String get openPerson => 'Szczegóły osoby';

  @override
  String get deletePerson => 'Skasuj osobę';

  @override
  String get addUser => 'Dodaj użytkownika';

  @override
  String get editUser => 'Edytuj użytkownika';

  @override
  String get saveChanges => 'Zapisz zmiany';

  @override
  String get deleteUser => 'Skasuj użytkownika';

  @override
  String get roles => 'Role';

  @override
  String get assignRole => 'Kliknij, aby przypisać rolę';

  @override
  String get associatedAgent => 'Powiązany profil agenta';

  @override
  String get noAgentSelected => 'Nie wybrano agenta';

  @override
  String get agentAlreadyAssigned => 'Agent już przypisany';

  @override
  String get addOrganization => 'Dodaj organizację';

  @override
  String get editOrganization => 'Edytuj organizację';

  @override
  String get openOrganization => 'Szczegóły organizacji';

  @override
  String get deleteOrganization => 'Skasuj organisację';

  @override
  String get members => 'Członkowie';

  @override
  String get orgName => 'Nazwa';

  @override
  String get managers => 'Zarządcy';

  @override
  String get contacts => 'Kontakty';

  @override
  String get contactName => 'Nazwa kontaktu';

  @override
  String get back => 'Cofnij';

  @override
  String get forward => 'Naprzód';

  @override
  String get personalInformations => 'Informacje osobiste';

  @override
  String get personName => 'Imię';

  @override
  String get familyName => 'Nazwisko';

  @override
  String get otherNames => 'Inne Imiona';

  @override
  String get manager => 'Zarządca';

  @override
  String get contents => 'Treść';

  @override
  String get warningAccount =>
      'Uwaga: po przypisaniu konta użytkownika do tej osoby, tylko Administrator Agentów będzie mógł to zmienić';

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
  String get noEmailOrPasswordWarning => 'Wprowadź email lub hasło';

  @override
  String get noAccount => 'Brak konta';

  @override
  String get createAccount => 'Utwórz konto';

  @override
  String get accountId => 'Identyfikator konta';

  @override
  String get userAccount => 'Konto użytkownika';

  @override
  String get datasetDeleted => 'Zbiór danych skasowany';

  @override
  String get datasetDeleteError => 'Błąd kasowania zbioru danych!';

  @override
  String get distributionDeleted => 'Dystrybucja skasowana';

  @override
  String get distributionDeleteError => 'Błąd kasowania dystrybucji!';

  @override
  String get fileNull => 'Plik jest pusty';

  @override
  String get fileTooBig => 'Plik jest za duży';

  @override
  String get fileUploadError => 'Błąd dodawania pliku';

  @override
  String get distributionUpdated => 'Dystrybucja zaktualizowana';

  @override
  String get distributionCreated => 'Dystrybucja utworzona';

  @override
  String get distributionError => 'Błąd aktualizacji dystrybucji!';

  @override
  String get dataUploadError => 'Błąd przesyłania danych!';

  @override
  String get dataUploaded => 'Dane przesłane';

  @override
  String get dataFileNotLoaded => 'Plik danych nie został załadowany!';

  @override
  String get dataDeleted => 'Dane usunięte';

  @override
  String get dataDeleteError => 'Błąd usuwania danych!';

  @override
  String get goToApp => 'Go to app';

  @override
  String get selectApp => 'Select application';

  @override
  String get datasetSeries => 'Seria zbiorów danych';

  @override
  String get openDatasetSeriesDetails => 'Szczegóły serii zbiorów danych';

  @override
  String get addDistribution => 'Dodaj nową dystrybucję';

  @override
  String get editDistribution => 'Edytuj dystrybucję';

  @override
  String get openDataset => 'Szczegóły zbioru danych';

  @override
  String get openDistribution => 'Szczegóły dystrybucji';

  @override
  String get deleteDistribution => 'Usuń dystrybucję';

  @override
  String get dataset => 'Zbiór danych';

  @override
  String get distribution => 'Dystrybucje';

  @override
  String get series => 'Serie';

  @override
  String get catalog => 'Katalog';

  @override
  String get data => 'Dane';

  @override
  String get file => 'Plik';

  @override
  String get formats => 'Formaty';

  @override
  String get distributionLanguages => 'Języki dystrybucji';

  @override
  String get byteSize => 'Rozmiar w bajtach';

  @override
  String get download => 'Pobierz';

  @override
  String get advancedSettings => 'Ustawienia zaawansowane';

  @override
  String get fileExtension => 'Rozszerzenie pliku';

  @override
  String get tableConceptMapping => 'Niestandardowe nazwy arkuszy i pola id';

  @override
  String get isIncluded => 'Pojęcie zawarte w pliku';

  @override
  String get conceptUri => 'Uri pojęcia';

  @override
  String get sheetName => 'Nazwa arkusza';

  @override
  String get idFieldName => 'Nazwa pola Id';

  @override
  String get loadData => 'Załaduj dane';

  @override
  String get errorWidgetMessage => 'Wystąpił błąd podczas przetwarzania pliku';

  @override
  String get dataImportErrors => 'Błędy importu danych';

  @override
  String get clearData => 'Usuń wszystkie dane dla zbioru danych';

  @override
  String get dataRows => 'Wiersze danych';

  @override
  String get structuredData => 'Dane strukturalne';

  @override
  String get moreErrorsNotShown => 'więcej błędów nie pokazano';

  @override
  String get downloadErrorLog => 'Pobierz pełny dziennik błędów';

  @override
  String get couldNotReadFile => 'Nie można odczytać wybranego pliku.';

  @override
  String get viewAndEditWithDefaultApp => 'View and edit with default app';

  @override
  String get viewWithSelectedApp => 'View and edit with selected app';

  @override
  String get catalogueUpdated => 'Katalog zaktualizowany';

  @override
  String get catalogueCreated => 'Katalog utworzony';

  @override
  String get catalogueError => 'Błąd aktializacji katalogu!';

  @override
  String get catalogueDeleted => 'Katalog skasowany';

  @override
  String get catalogueResourceError => 'Katalog zawiera zasoby!';

  @override
  String get catalogueDeleteError => 'Błąd kasowania katalogu!';

  @override
  String get datasetUpdated => 'Zbiór danych zaktualizowany';

  @override
  String get datasetCreated => 'Zbiór danych utworzony';

  @override
  String get datasetCreatedPublished => 'Zbiór danych utworzony i opublikowany';

  @override
  String get datasetUpdatedPublished =>
      'Zbiór danych zaktualizowany i opublikowany';

  @override
  String get datasetPublished => 'Zbiór danych opublikowany';

  @override
  String get datasetPublishError => 'Błąd publikacji zbioru danych!';

  @override
  String get datasetUnpublishError =>
      'Błąd cofnięcia publikacji zbioru danych!';

  @override
  String get datasetUnpublished => 'Zbiór danych cofnięty z publikacji';

  @override
  String get datasetError => 'Błąd aktualizacji zbioru danych!';

  @override
  String get seriesUpdated => 'Seria zaktualizowana';

  @override
  String get seriesCreated => 'Seria utworzona';

  @override
  String get seriesError => 'Błąd aktualizacji serii!';

  @override
  String get seriesDeleted => 'Seria skasowana';

  @override
  String get seriesDeleteError => 'Błąd kasowania serii!';

  @override
  String get serviceUpdated => 'Usługa zaktualizowana';

  @override
  String get serviceCreated => 'Usługa utworzona';

  @override
  String get serviceError => 'Błąd aktualizacji usługi!';

  @override
  String get serviceDeleted => 'Usługa skasowana';

  @override
  String get serviceDeleteError => 'Błąd kasowania usługi!';

  @override
  String get dataPublishError => 'Błąd publikacji danych do Ckan Datastore!';

  @override
  String get datastoreSuccess => 'Dane przesłane do Datastore';

  @override
  String get datastorePartialSuccess => 'Przesyłanie danych częściowo udane';

  @override
  String get datastoreFailure => 'Przesyłanie danych nie powiodło się';

  @override
  String get upsertedRows => 'Zaktualizowane wiersze';

  @override
  String get warningIndependentDataset => 'Warning: dataset is independent';

  @override
  String get datasetServices => 'Usługa udostępniania danych';

  @override
  String get addNewDataset => 'Dodaj nowy zbiór danych';

  @override
  String get addNewCatalogue => 'Dodaj nowy katalog';

  @override
  String get addNewSeries => 'Dodaj nową serię zbiorów danych';

  @override
  String get addNewService => 'Dodaj nową usługę';

  @override
  String get editDataset => 'Edytuj zbiór danych';

  @override
  String get editCatalog => 'Edytuj katalog';

  @override
  String get editSeries => 'Edytuj serię';

  @override
  String get editService => 'Edytuj usługę';

  @override
  String get openCatalog => 'Otwórz katalog';

  @override
  String get deleteCatalog => 'Skasuj katalog';

  @override
  String get deleteDataset => 'Skasuj zbiór danych';

  @override
  String get openSeries => 'Otwórz serię';

  @override
  String get openService => 'Otwórz usługę';

  @override
  String get deleteSeries => 'Skasuj serię';

  @override
  String get deleteService => 'Skasuj usługę';

  @override
  String get publish => 'Publikuj';

  @override
  String get parentCatalog => 'Katalog nadrzędny';

  @override
  String get addLanguage => 'Zapisz wersję językową';

  @override
  String get newContacts => 'Nowe kontakty';

  @override
  String get dateInvalid => 'Data nieprawidłowa';

  @override
  String get respAgentNotAssigned =>
      'Wybierz odpowiedzialną osobę lub organizację!';

  @override
  String get mainCatalog => 'Katalog główny';

  @override
  String get publishMetadata => 'Publikuj metadane';

  @override
  String get publishData => 'Publikuj dane z metadanymi';

  @override
  String get unpublish => 'Cofnij publikację';

  @override
  String get previewDataset => 'Podgląd zbioru danych';

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
  String get accessStatus => 'Status dostępu';

  @override
  String get mediaType => 'Typ mediów';

  @override
  String get accessUrl => 'URL dostępu';

  @override
  String get metadataLanguage => 'Język metadanych';

  @override
  String get dataLanguage => 'Język danych';

  @override
  String get type => 'Typ';

  @override
  String get statusField => 'Status';

  @override
  String get typesField => 'Typy';

  @override
  String get titleField => 'Tytuł';

  @override
  String get documentation => 'Dokumentacja';

  @override
  String get provenance => 'Pochodzenie';

  @override
  String get version => 'Wersja';

  @override
  String get versionNotes => 'Notka wersji';

  @override
  String get geographicalCoverage => 'Zasięg geograficzny';

  @override
  String get frequency => 'Częstotliwość';

  @override
  String get temporalCoverage => 'Zasięg czasowy (od - do)';

  @override
  String get temporalCoverageFrom => 'Zasięg czasowy - od';

  @override
  String get temporalCoverageTo => 'Zasięg czasowy - do';

  @override
  String get releaseDate => 'Data wydania';

  @override
  String get accessRights => 'Prawa dostępu';

  @override
  String get keywords => 'Słowa kluczowe';

  @override
  String get themes => 'Tematyka';

  @override
  String get responsiblePerson => 'Osoba odpowiedzialna';

  @override
  String get responsibleOrganization => 'Organizacja odpowiedzialna';

  @override
  String get applicableLegislation => 'Prawo właściwe';

  @override
  String get licence => 'Licencja';

  @override
  String get editors => 'Redaktorzy';

  @override
  String get actions => 'Akcje';

  @override
  String get datasetTitle => 'Tytuł zbioru danych';

  @override
  String get dataServiceTitle => 'Tytuł usługi';

  @override
  String get endpointUrl => 'URL punktu dostępu';

  @override
  String get endpointDescription => 'Opis punktu dostępu';

  @override
  String get targetDataset => 'Docelowy zbiór danych';

  @override
  String get schemaCreated => 'Utworzono schemat danych';

  @override
  String get schemaUpdated => 'Zaktualizowano schemat danych';

  @override
  String get schemaError => 'Błąd aktualizacji schematu danych!';

  @override
  String get defaultValue => 'Domyślna';

  @override
  String get deleteConcept => 'Usuń pojęcie';

  @override
  String get deleteProperty => 'Usuń właściwość';

  @override
  String get defaultNotSet => 'Domyślna przestrzeń nazw nie jest ustawiona';

  @override
  String get deleteSchema => 'Usuń schemat';

  @override
  String get schemaDeleted => 'Schemat usunięty';

  @override
  String get schemaDeleteError => 'Błąd usuwania schematu!';

  @override
  String get addConcept => 'Dodaj pojęcie';

  @override
  String get addProperty => 'Dodaj właściwość';

  @override
  String get schemaSeriesCreated => 'Seria schematów została utworzona';

  @override
  String get schemaSeriesUpdated => 'Seria schematów została zaktualizowana';

  @override
  String get schemaSeriesError => 'Błąd aktualizacji serii schematów!';

  @override
  String get deleteSchemaSeries => 'Usuń serię schematów';

  @override
  String get schemaSeriesDeleted => 'Seria schematów została usunięta';

  @override
  String get schemaSeriesDeleteError => 'Błąd usuwania serii schematów!';

  @override
  String get schemaSeriesResourceError => 'Seria zawiera zasoby';

  @override
  String get schemaSeriesNotFoundError => 'Seria nie została znaleziona';

  @override
  String get appUpdated => 'Aplikacja zaktualizowana';

  @override
  String get appError => 'Błąd aktualizacji aplikacji!';

  @override
  String get appDeleted => 'Aplikacja usunięta';

  @override
  String get appDeleteError => 'Błąd usuwania aplikacji!';

  @override
  String get templateDeleted => 'Szablon usunięty';

  @override
  String get templateDeleteError => 'Błąd usuwania szablonu!';

  @override
  String get templateCreated => 'Szablon utworzony';

  @override
  String get templateError => 'Błąd tworzenia szablonu!';

  @override
  String get templateGenerated => 'Szablon wygenerowany';

  @override
  String get templateGenerateError => 'Błąd generowania szablonu!';

  @override
  String get appDeployStarted => 'Wdrożenie aplikacji zainicjowane';

  @override
  String get appDeployError => 'Błąd wdrożenia aplikacji!';

  @override
  String get appStatusesRefreshed => 'Statusy aplikacji odświeżone';

  @override
  String get schema => 'Schemat danych';

  @override
  String get listVersions => 'Pokaż wersje';

  @override
  String get openSchema => 'Szczegóły schematu danych';

  @override
  String get noSeries => '[Bez serii]';

  @override
  String get array => 'Tablica';

  @override
  String get unique => 'Unikalna';

  @override
  String get required => 'Wymagana';

  @override
  String get schemaSeries => 'Seria schematów';

  @override
  String get addSchema => 'Dodaj schemat danych';

  @override
  String get editSchema => 'Edytuj schemat danych';

  @override
  String get schemaTitle => 'Tytuł schematu danych';

  @override
  String get namespacePrefix => 'Prefix przestrzeni nazw';

  @override
  String get namespaces => 'Przestrzenie nazw';

  @override
  String get usedNamespaces => 'Używane przestrzenie nazw';

  @override
  String get newNamespaces => 'Nowe przestrzenie nazw';

  @override
  String get namespace => 'Przestrzeń nazw';

  @override
  String get namespaceIri => 'Iri przestrzeni nazw';

  @override
  String get defaultNamespace => 'Domyślna przestrzeń nazw';

  @override
  String get concepts => 'Pojęcia';

  @override
  String get conceptName => 'Nazwa pojęcia';

  @override
  String get untitledConcept => 'Pojęcie bez tytułu';

  @override
  String get mainConcept => 'Pojęcie główne';

  @override
  String get properties => 'Właściwości';

  @override
  String get propertyName => 'Nazwa właściwości';

  @override
  String get currentSchema => 'Bieżący schemat danych';

  @override
  String get customIriNotUnique =>
      'Niestandardowy IRI przestrzeni nazw nie może być taki sam jak standardowy IRI przestrzeni nazw';

  @override
  String get customPrefixNotUnique =>
      'Niestandardowy prefiks przestrzeni nazw nie może być taki sam jak standardowy prefiks przestrzeni nazw';

  @override
  String get valueAlreadyUsed => 'Wartość już użyta!';

  @override
  String get noSeriesPrivileges =>
      'You have no priviliges to any schema series';

  @override
  String get showAppDetails => 'Pokaż szczegóły aplikacji';

  @override
  String get deleteApp => 'Usuń aplikację';

  @override
  String get addNewApp => 'Dodaj nową aplikację';

  @override
  String get apps => 'Aplikacje do pozyskiwania';

  @override
  String get appTemplates => 'Szablony aplikacji';

  @override
  String get template => 'Szablon';

  @override
  String get addNewTemplate => 'Dodaj nowy szablon';

  @override
  String get openTemplate => 'Otwórz szablon';

  @override
  String get editTemplate => 'Edytuj szablon';

  @override
  String get deleteTemplate => 'Usuń szablon';

  @override
  String get enabled => 'Włączony';

  @override
  String get disabled => 'Wyłączony';

  @override
  String get visible => 'Widoczny';

  @override
  String get hidden => 'Ukryty';

  @override
  String get toUpdate => 'Zostanie zaktualizowane - jesteś pewien?';

  @override
  String get createApp => 'Utwórz aplikację';

  @override
  String get create => 'Utwórz';

  @override
  String get activeResource => 'Aktywny zasób';

  @override
  String get app => 'Aplikacja';

  @override
  String get editApp => 'Edytuj aplikację';

  @override
  String get noNameError => 'Proszę podać nazwę.';

  @override
  String get noCatalogueError => 'Proszę wybrać katalog nadrzędny.';

  @override
  String get datasetIdentifierNotUnique =>
      'Zbiór danych o takim identyfikatorze już istnieje.';

  @override
  String get selectEditors => 'Wybierz redaktorów';

  @override
  String get selectCatForResources => 'Wybierz katalog dla nowych zasobów';

  @override
  String get sourceResources => 'Zasoby źródłowe';

  @override
  String get addNewResource => 'Dodaj nowy zasób';

  @override
  String get newField => 'Nowe';

  @override
  String get activeResourceCannotBeSourceResource =>
      'Aktywny zasób nie może jednocześnie być zasobem źródłowym';

  @override
  String get createTemplate => 'Utwórz szablon aplikacji';

  @override
  String get isReadyLabel => 'Gotowe';

  @override
  String get usecaseScenarios => 'Scenariusze użycia';

  @override
  String get fillTitlesAndDescriptions => 'Wypełnij wszystkie pola tekstowe!';

  @override
  String get versionOf => 'Jest wersją:';

  @override
  String get scenarios => 'Scenariusze';

  @override
  String get titleNotUnique => 'Tytuł musi być unikalny';

  @override
  String get useCase => 'Przypadek użycia';

  @override
  String get untitledProperty => 'Właściwość bez tytułu';

  @override
  String get idProperty => 'Domyślny identyfikator';

  @override
  String get deleteConceptWarning =>
      'Uwaga: usunięcie pojęcia ze schematu spowoduje usunięcie jego elementów danych';

  @override
  String get idMustBeUniqueAndRequired =>
      'Właściwość domyślnego identyfikatora musi być unikalna i wymagana';

  @override
  String get auxiliaryConcepts => 'Pojęcia pomocnicze';

  @override
  String get activateAdvancedScenarioEditing =>
      'Aktywuj zaawansowaną edycję scenariuszy';

  @override
  String get cannotRevertWarning => 'Uwaga: tej operacji nie można cofnąć';

  @override
  String get compileTemplate => 'Kompiluj szablon';

  @override
  String get deployApp => 'Wdróż aplikację';

  @override
  String get created => 'Utworzono';

  @override
  String get inProcessing => 'W trakcie przetwarzania';

  @override
  String get ready => 'Gotowe';

  @override
  String get hasErrors => 'Zawiera błędy';

  @override
  String get refreshAppStatuses => 'Odśwież statusy aplikacji';

  @override
  String get isCompiled => 'Skompilowano';

  @override
  String get login => 'Login';

  @override
  String get email => 'Email';

  @override
  String get emailHint => 'Wprowadź email';

  @override
  String get unvalidEmail => 'Wprowadź prawidłowy email (np. abc@mail.com)';

  @override
  String get password => 'Hasło';

  @override
  String get passwordHint => 'Wprowadź hasło';

  @override
  String get unvalidPassword => 'Hasło musi mieć co najmniej 6 znaków';

  @override
  String get loginFailed => 'Email lub hasło są nieprawidłowe';

  @override
  String get datasetCatalogue => 'Katalog zbiorów danych';

  @override
  String get editCurrent => 'Edytuj aktualny';

  @override
  String get editContents => 'Edytuj zawartość';

  @override
  String get openSchemaSeries => 'Szczegóły serii schematów';

  @override
  String get rolesAndOrganizations => 'Role i organizacje';

  @override
  String get memberOf => 'Członek';

  @override
  String get selectMember => 'Wybierz członka';

  @override
  String get phone => 'Numer telefonu';

  @override
  String get address => 'Adres';

  @override
  String get dataService => 'Usługa';

  @override
  String get responsiblePersonUri => 'URI osoby odpowiedzialnej';

  @override
  String get responsiblePersonName => 'Imię/nazwisko osoby odpowiedzialnej';

  @override
  String get responsibleOrganizationUri => 'URI organizacji odpowiedzialnej';

  @override
  String get responsibleOrganizationName => 'Nazwa organizacji odpowiedzialnej';

  @override
  String get editorsUris => 'URI redaktorów';

  @override
  String get contactsUris => 'URI kontaktów';

  @override
  String get languages => 'Języki';

  @override
  String get catalogueUri => 'URI katalogu';

  @override
  String get catalogueTitle => 'Tytuł katalogu';

  @override
  String get standardUris => 'URI standardu';

  @override
  String get standardTitle => 'Tytuł standardu';

  @override
  String get datasetUri => 'URI zbioru danych';

  @override
  String get compressionFormat => 'Format kompresji';

  @override
  String get downloadUrl => 'URL pobierania';
}
