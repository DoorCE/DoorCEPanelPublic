import 'package:doorce_panel/dtos/contact_data.dart';
import 'package:doorce_panel/dtos/person.dart';

class MPersonDetailsWindow {
  final List<XContactData> _contactDataResources;
  final XPerson _personResource;

  MPersonDetailsWindow(this._personResource, this._contactDataResources);

  String getPersonName() {
    XPerson resource = _personResource;
    String fullName = "${resource.givenNames.first} ${resource.familyName}";
    return fullName;
  }

  List<String> getPersonGivenNames() {
    return _personResource.givenNames.skip(1).toList();
  }

  String getPersonGivenName() {
    return _personResource.givenNames.first;
  }

  String getPersonFamilyName() {
    return _personResource.familyName;
  }

  String getPersonIdentifier() {
    return _personResource.identifier;
  }

  int getPersonOrganizationsListLenght() {
    return _personResource.organisationsNames.length;
  }

  String getPersonOrganizationsIdentifier(int index) {
    return _personResource.organisationsNames.keys.elementAt(index);
  }

  String getPersonOrganizationsName(int index) {
    return _personResource.organisationsNames.values.elementAt(index);
  }

  //List<String> getPersonManagedOrganizations() {
    //return _personResource.managedOrganisationsUris;
  //}

  int getContactDataListLenght() {
    return _contactDataResources.length;
  }

  XContactData getContactDataResource(int index) {
    return _contactDataResources[index];
  }
}
