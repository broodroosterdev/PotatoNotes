import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:potato_notes/data/database.dart';
import 'package:potato_notes/data/model/content_style.dart';
import 'package:potato_notes/data/model/image_list.dart';
import 'package:potato_notes/data/model/list_content.dart';
import 'package:potato_notes/data/model/reminder_list.dart';
import 'package:potato_notes/widget/pass_challenge.dart';
import 'package:recase/recase.dart';

class Utils {
  static Future<dynamic> showPassChallengeSheet(BuildContext context) async {
    return await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => PassChallenge(
        editMode: false,
        onChallengeSuccess: () => Navigator.pop(context, true),
        onSave: null,
      ),
    );
  }

  static bool statusFromResponse(Response response){
    return json.decode(response.body)["status"];
  }

  static Map<String, dynamic> toSyncMap(Note note){
    var originalMap = note.toJson();
    Map<String, dynamic> newMap = Map();
    originalMap.forEach((key, value) {
      var newValue = value;
      var newKey = ReCase(key).snakeCase;
      switch(key){
        case "styleJson":{
          var style = value as ContentStyle;
          newValue = json.encode(style.data);
          break;
        }
        case "images":{
          var images = value as ImageList;
          newValue = json.encode(images.images);
          break;
        }
        case "listContent":{
          var listContent = value as ListContent;
          newValue = json.encode(listContent.content);
          break;
        }
        case "reminders":{
          var reminders = value as ReminderList;
          newValue = json.encode(reminders.reminders);
          break;
        }
      }
      if(key == "id"){
        newKey = "note_id";
      }
      newMap.putIfAbsent(newKey, () => newValue);
    });
    return newMap;
  }

  static Note fromSyncMap(Map<String, dynamic> syncMap){
    Map<String, dynamic> newMap = Map();
    syncMap.forEach((key, value) {
      var newValue = value;
      var newKey = ReCase(key).camelCase;
      switch(key){
        case "style_json":{
          var map = json.decode(value);
          List<int> data = List<int>.from(map.map((i) => i as int)).toList();
          newValue = new ContentStyle(data);
          break;
        }
        case "images":{
          var map = json.decode(value);
          List<Uri> images = List<Uri>.from(map.map((i) => Uri.parse(i))).toList();
          newValue = new ImageList(images);
          break;
        }
        case "list_content":{
          var map = json.decode(value);
          List<ListItem> content = List<ListItem>.from(map.map((i) => ListItem.fromJson(i))).toList();
          newValue = new ListContent(content);
          break;
        }
        case "reminders":{
          var map = json.decode(value);
          List<DateTime> reminders = List<DateTime>.from(map.map((i) => DateTime.parse(i))).toList();
          newValue = new ReminderList(reminders);
          break;
        }
      }
      if(key == "note_id"){
        newKey = "id";
      }
      newMap.putIfAbsent(newKey, () => newValue);
    });
    return Note.fromJson(newMap);
  }
}
