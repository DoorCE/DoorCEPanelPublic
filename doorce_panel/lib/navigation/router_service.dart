import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

/// Service responsible for managing navigation state using MVVM pattern
class RouterService {
  final ValueNotifier<List<(String, Widget?)>> navigationStack = 
    ValueNotifier<List<(String, Widget?)>>([("", null)]);
  final ValueNotifier<List<(String, Widget?)>> navigationForwardStorage = 
    ValueNotifier<List<(String, Widget?)>>([("", null)]);
  
  void push(String path, Widget screen) {
    navigationForwardStorage.value.clear();

    if (path == navigationStack.value.last.$1) {
      navigationStack.value = [
        ...navigationStack.value.sublist(0, navigationStack.value.length - 1),
        (path, screen)
      ];
      Logger.root.fine('Navigation stack (after push-last): ${navigationStack.value}');
      return;
    }
    navigationStack.value = [...navigationStack.value, (path, screen)];
    Logger.root.fine('Navigation stack (after push): ${navigationStack.value}');
  }

  void pop() {
    if (navigationStack.value.length <= 1) return;
    navigationForwardStorage.value.add(navigationStack.value.last);
    navigationStack.value = navigationStack.value.sublist(
      0, navigationStack.value.length - 1,
    );
    Logger.root.fine('Navigation stack (after pop): ${navigationStack.value}');
  }

  void replaceAll(String path, Widget? screen) {
    navigationStack.value = [(path, screen)];
    navigationForwardStorage.value.clear();
    Logger.root.fine('Navigation stack (after replaceAll): ${navigationStack.value}');
  }
  
  void referesh() {
    navigationStack.value = [
      ...navigationStack.value.sublist(0, navigationStack.value.length - 1),
      (navigationStack.value.last.$1, null)
    ];
    Logger.root.fine('Navigation stack (after refresh): ${navigationStack.value}');
  }

  bool tryNavigateTo(String path) {
    Logger.root.fine('Trying to navigate to: $path');
    final index = navigationStack.value.lastIndexWhere((entry) => entry.$1 == path);
    if (index != -1) {
      navigationForwardStorage.value = [
        ...navigationStack.value.sublist(index + 1),
        ...navigationForwardStorage.value
      ];

      navigationStack.value = [
        ...navigationStack.value.sublist(0, index + 1)
      ];
      Logger.root.fine('Navigation stack (after tryNavigateTo - back button): ${navigationStack.value}');
      return true;
    } else {
      final forwardIndex = navigationForwardStorage.value.indexWhere((entry) => entry.$1 == path);
      if (forwardIndex != -1) {
        navigationStack.value = [
          ...navigationStack.value,
          ...navigationForwardStorage.value.sublist(0, forwardIndex + 1)
        ];
        navigationForwardStorage.value = navigationForwardStorage.value.sublist(forwardIndex + 1);
        Logger.root.fine('Navigation stack (after tryNavigateTo - forward button): ${navigationStack.value}');
        return true;
      }
    }
    return false;
  }
}
