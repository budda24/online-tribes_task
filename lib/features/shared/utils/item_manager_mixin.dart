import 'package:flutter/material.dart';

mixin ItemManagerMixin<T extends StatefulWidget> on State<T> {
  // List of items (e.g., hobbies or themes)
  List<String> items = [];

  // Maximum number of items allowed
  int maxItems = 5;

  // Text controller for the input field
  late TextEditingController itemController;

  // Initialize the mixin
  void initItemManager({
    required List<String> initialItems,
    required TextEditingController controller,
    int? maxItems,
  }) {
    items = List<String>.from(initialItems);
    itemController = controller;
    if (maxItems != null) {
      this.maxItems = maxItems;
    }
    itemController.addListener(validateInput);
  }

  // Dispose the mixin
  void disposeItemManager() {
    itemController.removeListener(validateInput);
  }

  // Add an item to the list
  void addItem(String item) {
    setState(() {
      if (!items.contains(item)) {
        if (items.length >= maxItems) {
          onLimitExceeded(item);
        } else {
          items.add(item);
          onItemsChanged(items);
        }
        validateInput();
      }
    });
    itemController.clear();
  }

  // Remove an item from the list
  void removeItem(String item) {
    setState(() {
      items.remove(item);
      onItemsChanged(items);
      validateInput();
    });
  }

  // Abstract methods to be implemented by the State class
  void validateInput();
  void onItemsChanged(List<String> items);
  void onLimitExceeded(String item);
}
