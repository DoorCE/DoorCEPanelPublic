import 'package:doorce_panel/dtos/contact_data.dart';
import 'package:doorce_panel/dtos/organization.dart';
import 'package:doorce_panel/dtos/person.dart';

class MOrganizationDetailsWindow {
  final List<XContactData> _contactDataResources;
  final List<XPerson> _peopleResources;
  final XOrganization _organizationResource;

  MOrganizationDetailsWindow(this._peopleResources, this._organizationResource,
      this._contactDataResources);

  String getOrganizationName() {
    return _organizationResource.name;
  }

  String? getOrganizationDescription() {
    return _organizationResource.description;
  }

  int getMembersResourceListLenght() {
    return _peopleResources.length;
  }

  String getMembersIdentifier(int index) {
    return _peopleResources[index].identifier;
  }

  String getMembersName(int index) {
    XPerson resource = _peopleResources[index];
    String fullName = "${resource.givenNames.first} ${resource.familyName}";
    return fullName;
  }

  String getOrganizationIdentifier() {
    return _organizationResource.identifier;
  }

  //List<String> getOrganizationManagers() {
  //  return _organizationResource.managersUris;
  //}

  int getContactDataListLenght() {
    return _contactDataResources.length;
  }

  String getContactDataResourceName(int index) {
    return _contactDataResources[index].name;
  }

  XContactData getContactDataResource(int index) {
    return _contactDataResources[index];
  }
}
