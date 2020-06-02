import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:potato_notes/data/dao/note_helper.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/internal/preferences.dart';
import 'package:potato_notes/locator.dart';
import 'package:potato_notes/widget/pass_challenge.dart';
import 'package:potato_notes/widget/settings_category.dart';
import 'package:provider/provider.dart';
import 'package:spicy_components/spicy_components.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Preferences prefs;
  bool removingMasterPass = false;

  @override
  Widget build(BuildContext context) {
    if (prefs == null) prefs = locator<Preferences>();

    return WillPopScope(
      onWillPop: () async => !removingMasterPass,
      child: Scaffold(
        body: ListView(
          children: [
            SettingsCategory(
              header: "Personalization",
              children: [
                ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 32, vertical: 4),
                  leading: Icon(CommunityMaterialIcons.theme_light_dark),
                  title: Text("Theme mode"),
                  trailing: DropdownButton(
                    items: [
                      DropdownMenuItem(
                        child: Text("System"),
                        value: ThemeMode.system,
                      ),
                      DropdownMenuItem(
                        child: Text("Light"),
                        value: ThemeMode.light,
                      ),
                      DropdownMenuItem(
                        child: Text("Dark"),
                        value: ThemeMode.dark,
                      ),
                    ],
                    onChanged: (value) => prefs.themeMode = value,
                    value: prefs.themeMode,
                  ),
                ),
                SwitchListTile(
                  value: prefs.useAmoled,
                  onChanged: (value) => prefs.useAmoled = value,
                  title: Text("Use AMOLED theme"),
                  secondary: Icon(CommunityMaterialIcons.brightness_6),
                  activeColor: Theme.of(context).accentColor,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 32, vertical: 4),
                ),
              ],
            ),
            SettingsCategory(
              header: "Privacy",
              children: [
                SwitchListTile(
                  value: prefs.masterPass != "",
                  onChanged: (value) async {
                    if (prefs.masterPass == "") {
                      showMasterPassChoiceSheet(context);
                    } else {
                      bool confirm =
                          await showPassChallengeSheet(context, false) ?? false;

                      if (confirm) {
                        prefs.masterPass = "";

                        NoteHelper helper =
                            Provider.of<NoteHelper>(context, listen: false);
                        List<Note> notes =
                            await helper.listNotes(ReturnMode.ALL);

                        setState(() => removingMasterPass = true);
                        for (int i = 0; i < notes.length; i++) {
                          await helper
                              .saveNote(notes[i].copyWith(lockNote: false, synced: false, lastModifyDate: DateTime.now()));
                        }
                        setState(() => removingMasterPass = false);
                      }
                    }
                  },
                  secondary: Icon(OMIcons.vpnKey),
                  title: Text("Use master pass"),
                  activeColor: Theme.of(context).accentColor,
                  subtitle:
                      removingMasterPass ? LinearProgressIndicator() : null,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 32, vertical: 4),
                ),
                ListTile(
                  leading: Icon(CommunityMaterialIcons.textbox_password),
                  title: Text("Modify master pass"),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 32, vertical: 4),
                  enabled: prefs.masterPass != "",
                  onTap: () async {
                    bool confirm =
                        await showPassChallengeSheet(context, false) ?? false;
                    if (confirm) showPassChallengeSheet(context);
                  },
                ),
              ],
            ),
          ],
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        ),
        bottomNavigationBar: SpicyBottomBar(
          leftItems: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              padding: EdgeInsets.all(0),
              onPressed: () => Navigator.pop(context),
            ),
            Text(
              'Settings',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showMasterPassChoiceSheet(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                  "Warning: if you ever forget the pass you can't reset it, you'll need to uninstall the app, hence getting all the notes erased, and reinstall it. Please write it down somewhere.")),
          ListTile(
            leading: Icon(CommunityMaterialIcons.arrow_right),
            title: Text("Go on"),
            contentPadding: EdgeInsets.symmetric(horizontal: 32),
            onTap: () {
              Navigator.pop(context);
              showPassChallengeSheet(context);
            },
          ),
        ],
      ),
    );
  }

  Future<dynamic> showPassChallengeSheet(BuildContext context,
      [bool editMode = true]) async {
    return await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => PassChallenge(
        editMode: editMode,
        onChallengeSuccess: () => Navigator.pop(context, true),
        onSave: (text) async {
          prefs.masterPass = text;

          Navigator.pop(context);
        },
      ),
    );
  }
}
