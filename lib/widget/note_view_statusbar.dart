import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:potato_notes/data/database.dart';

class NoteViewStatusbar extends StatelessWidget {
  final Note note;
  final EdgeInsets padding;

  NoteViewStatusbar({
    @required this.note,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> icons = getIcons(context);

    return Visibility(
      visible: icons.isNotEmpty,
      child: Padding(
        padding: padding ?? const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: IconTheme(
          data: Theme.of(context).iconTheme.copyWith(size: 16),
          child: Wrap(
            alignment: WrapAlignment.end,
            children: List.generate(
              icons.isNotEmpty ? icons.length + icons.length - 1 : 0,
              (index) {
                if (index % 2 == 0)
                  return icons[index ~/ 2];
                else
                  return VerticalDivider(
                    width: 4,
                    color: Colors.transparent,
                  );
              },
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> getIcons(BuildContext context) {
    List<IconData> iconData = [
      CommunityMaterialIcons.eye_off_outline,
      note.usesBiometrics
          ? CommunityMaterialIcons.fingerprint
          : CommunityMaterialIcons.lock_outline,
      CommunityMaterialIcons.alarm,
      CommunityMaterialIcons.sync_icon,
      CommunityMaterialIcons.heart_outline,
    ];

    List<int> iconDataIndexes = [];
    List<Widget> icons = [];

    if (note.hideContent) iconDataIndexes.add(0);

    if (note.lockNote) iconDataIndexes.add(1);

    if (note.reminders.reminders.isNotEmpty) iconDataIndexes.add(2);

    if (note.synced) iconDataIndexes.add(3);

    if (note.starred) iconDataIndexes.add(4);

    for (int i = 0; i < iconDataIndexes.length; i++) {
      icons.add(Icon(iconData[iconDataIndexes[i]]));
    }

    return icons;
  }
}
