// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationPayload _$NotificationPayloadFromJson(Map<String, dynamic> json) {
  return NotificationPayload(
    noteId: json['noteId'] as String,
    action: _$enumDecodeNullable(_$NotificationActionEnumMap, json['action']),
    notificationId: json['notificationId'] as int,
  );
}

Map<String, dynamic> _$NotificationPayloadToJson(
        NotificationPayload instance) =>
    <String, dynamic>{
      'noteId': instance.noteId,
      'action': _$NotificationActionEnumMap[instance.action],
      'notificationId': instance.notificationId,
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$NotificationActionEnumMap = {
  NotificationAction.PIN: 'PIN',
  NotificationAction.REMINDER: 'REMINDER',
};
