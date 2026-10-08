import 'package:doorce_panel/dtos/person.dart';
import 'package:doorce_panel/dtos/user_account.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class MUpsertUserWindow {
  final XUserAccount user;
  final List<XPerson> _allowedPersons;

  late List<String> _availableAccountIds = [];
  late bool isInsert;

  MUpsertUserWindow(this.user, this._allowedPersons);

  // ### isInsert
  void checkAndUpdateIsInsert() {
    this.isInsert = user.userId.isEmpty;
  }

  // **** User ****

  // Accounts
  void refreshAvailableAccountIds(List<String> newAccountIds) {
    _availableAccountIds = newAccountIds;
  }

  // **** Options for dropdowns ****

  List<String> getAvailableAccountIds() {
    final availableAccountIds = List<String>.from(_availableAccountIds);
    if (user.userId.isNotEmpty && !availableAccountIds.contains(user.userId)) {
      availableAccountIds.add(user.userId);
    }
    return availableAccountIds;
  }

  List<DropdownItem<String>> getAvailableAccountIdsItems() {
    return getAvailableAccountIds().map((id) {
      return DropdownItem<String>(
        value: id,
        label: id,
        selected: user.userId == id
      );
    }).toList();
  }

  List<DropdownItem<String>> getAllowedPersonsForAccount() {
    return _allowedPersons.map((person) {
      return DropdownItem<String>(
        value: person.identifier,
        label: "${person.givenNames.firstOrNull ?? ""} ${person.familyName}",
        selected: user.personUri == person.identifier
      );
    }).toList();
  }

}
