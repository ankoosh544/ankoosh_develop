import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sofia_app/main.dart';
import 'package:sofia_app/models/language.dart';
import 'package:sofia_app/providers/settings_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final isAudioEnabled = settingsProvider.isAudioEnabled;
    final isVisualEnabled = settingsProvider.isVisualEnabled;
    final isNotificationsEnabled = settingsProvider.isNotificationsEnabled;
    final isDarkModeEnabled = settingsProvider.isDarkModeEnabled;
    final isPresidentEnabled = settingsProvider.isPresidentEnabled;
    final isDisablePeopleEnabled = settingsProvider.isDisablePeopleEnabled;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
        actions: <Widget>[
          Container(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: DropdownButton<Language>(
                underline: SizedBox(),
                icon: Icon(
                  Icons.language,
                  color: Colors.black,
                ),
                onChanged: (Language? language) {
                  if (language != null) {
                    SofiaApp.setLocale(
                        context, Locale(language.languageCode, ''));
                  }
                },
                items: Language.languageList()
                    .map<DropdownMenuItem<Language>>(
                      (e) => DropdownMenuItem<Language>(
                        value: e,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Text(
                              e.flag,
                              style: TextStyle(fontSize: 30),
                            ),
                            Text(e.name),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            _buildSectionTitle(
              AppLocalizations.of(context)!.settingsstatement1,
            ),
            _buildSwitchListTile(
              AppLocalizations.of(context)!.settingsstatement1Option1,
              isAudioEnabled,
              settingsProvider.setAudioEnabled,
            ),
            _buildSwitchListTile(
              AppLocalizations.of(context)!.settingsstatement1Option2,
              isVisualEnabled,
              settingsProvider.setVisualEnabled,
            ),
            _buildSectionTitle(
              AppLocalizations.of(context)!.settingsstatement2,
            ),
            _buildSwitchListTile(
              AppLocalizations.of(context)!.settingsstatement2Option1,
              isNotificationsEnabled,
              settingsProvider.setNotificationsEnabled,
            ),
            _buildSwitchListTile(
              AppLocalizations.of(context)!.settingsstatement2Option2,
              isDarkModeEnabled,
              settingsProvider.setDarkModeEnabled,
            ),
            _buildSectionTitle(
              AppLocalizations.of(context)!.settingsstatement3,
            ),
            _buildSwitchListTile(
              AppLocalizations.of(context)!.settingsstatement3Option1,
              isPresidentEnabled,
              settingsProvider.setPresidentEnabled,
            ),
            _buildSwitchListTile(
              AppLocalizations.of(context)!.settingsstatement3Option2,
              isDisablePeopleEnabled,
              settingsProvider.setDisablePeopleEnabled,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Column(
      children: [
        ListTile(
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 18,
            ),
          ),
        ),
        Divider(),
      ],
    );
  }

  Widget _buildRadioListTile(
    String title,
    String value,
    bool currentValue,
    Function(bool) onChanged,
  ) {
    return RadioListTile<String>(
      title: Text(title),
      value: value,
      groupValue: currentValue ? value : null,
      onChanged: (newValue) {
        if (newValue != null) {
          // Handle the onChanged callback here
          // You can access the new value (newValue) of the selected radio button
        }
      },
    );
  }

  Widget _buildSwitchListTile(
    String title,
    bool value,
    Function(bool) onChanged,
  ) {
    return ListTile(
      title: Text(title),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
