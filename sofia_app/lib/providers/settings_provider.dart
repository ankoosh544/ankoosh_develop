import 'package:flutter/material.dart';

class SettingsProvider with ChangeNotifier {
  bool isAudioEnabled = false;
  bool isVisualEnabled = false;
  bool isNotificationsEnabled = false;
  bool isDarkModeEnabled = false;
  bool isPresidentEnabled = false;
  bool isDisablePeopleEnabled = false;

  void loadSettings() {
    // Load settings from storage or any other source
    // and update the provider's variables accordingly
  }

  void saveSettings() {
    // Save the settings to storage or any other destination
    // based on the provider's variables
  }

  void setAudioEnabled(bool value) {
    isAudioEnabled = value;
    saveSettings();
    notifyListeners();
  }

  void setVisualEnabled(bool value) {
    isVisualEnabled = value;
    saveSettings();
    notifyListeners();
  }

  void setNotificationsEnabled(bool value) {
    isNotificationsEnabled = value;
    saveSettings();
    notifyListeners();
  }

  void setDarkModeEnabled(bool value) {
    isDarkModeEnabled = value;
    saveSettings();
    notifyListeners();
  }

  void setPresidentEnabled(bool value) {
    isPresidentEnabled = value;
    saveSettings();
    notifyListeners();
  }

  void setDisablePeopleEnabled(bool value) {
    isDisablePeopleEnabled = value;
    saveSettings();
    notifyListeners();
  }
}
