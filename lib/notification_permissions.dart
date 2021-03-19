import 'dart:async';

import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

class NotificationPermissions {
  static const MethodChannel _channel =
      const MethodChannel('notification_permissions');

  static Future<PermissionStatusEnum> requestNotificationPermissions(
      {NotificationSettingsIos iosSettings = const NotificationSettingsIos(),
      bool openSettings = true}) async {
    final map = iosSettings.toMap();
    map["openSettings"] = openSettings;
    String status =
        await _channel.invokeMethod('requestNotificationPermissions', map);
    return _getPermissionStatus(status);
  }

  static Future<PermissionStatusEnum> getNotificationPermissionStatus() async {
    final String status =
        await _channel.invokeMethod('getNotificationPermissionStatus');
    return _getPermissionStatus(status);
  }

  /// Gets the PermissionStatus from the channel Method
  ///
  /// Given a [String] status from the method channel, it returns a
  /// [PermissionStatus]
  static PermissionStatusEnum _getPermissionStatus(String status) {
    switch (status) {
      case "denied":
        return PermissionStatusEnum.denied;
      case "granted":
        return PermissionStatusEnum.granted;
      case "provisional":
        return PermissionStatusEnum.provisional;
      default:
        return PermissionStatusEnum.unknown;
    }
  }
}

enum PermissionStatusEnum { granted, unknown, denied, provisional }

class NotificationSettingsIos {
  const NotificationSettingsIos({
    this.sound = true,
    this.alert = true,
    this.badge = true,
  });

  NotificationSettingsIos._fromMap(Map<String, bool> settings)
      : sound = settings['sound'],
        alert = settings['alert'],
        badge = settings['badge'];

  final bool sound;
  final bool alert;
  final bool badge;

  @visibleForTesting
  Map<String, dynamic> toMap() {
    return <String, bool>{'sound': sound, 'alert': alert, 'badge': badge};
  }

  @override
  String toString() => 'PushNotificationSettings ${toMap()}';
}
