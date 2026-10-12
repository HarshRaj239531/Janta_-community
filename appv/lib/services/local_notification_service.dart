import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../models/installment_model.dart';

class LocalNotificationService {
  LocalNotificationService._();
  static final LocalNotificationService instance = LocalNotificationService._();

  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const String _channelId = 'janta_payment_reminders_channel';
  static const String _channelName = 'Payment Reminders';
  static const String _channelDesc =
      'High priority reminders for upcoming loan EMIs and committee payments';

  /// Initialize local notifications plugin and configure timezone
  static Future<void> initialize() async {
    try {
      // 1. Initialize timezone database
      tz.initializeTimeZones();
      try {
        tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));
      } catch (_) {
        try {
          tz.setLocalLocation(tz.local);
        } catch (_) {}
      }

      // 2. Android Initialization Settings
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/launcher_icon');

      // 3. iOS Initialization Settings
      const DarwinInitializationSettings initializationSettingsDarwin =
          DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin,
      );

      await _notificationsPlugin.initialize(
        settings: initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          debugPrint('Notification clicked with payload: ${response.payload}');
        },
      );

      // 4. Request permissions on Android 13+
      if (Platform.isAndroid) {
        final androidImplementation = _notificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>();

        await androidImplementation?.requestNotificationsPermission();
        await androidImplementation?.requestExactAlarmsPermission();

        // Create high importance notification channel
        const AndroidNotificationChannel channel = AndroidNotificationChannel(
          _channelId,
          _channelName,
          description: _channelDesc,
          importance: Importance.max,
          playSound: true,
          enableVibration: true,
        );

        await androidImplementation?.createNotificationChannel(channel);
      }
      debugPrint('LocalNotificationService initialized successfully.');
    } catch (e) {
      debugPrint('Error initializing LocalNotificationService: $e');
    }
  }

  /// Base NotificationDetails with High Priority & Sound
  static NotificationDetails _getNotificationDetails() {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDesc,
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'Payment Reminder',
      icon: '@mipmap/launcher_icon',
      color: Color(0xFF0F4C3A),
      playSound: true,
      enableVibration: true,
      styleInformation: BigTextStyleInformation(''),
    );

    const DarwinNotificationDetails darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    return const NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
    );
  }

  /// Show an immediate notification right now on phone notification tray
  static Future<void> showInstantNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    try {
      await _notificationsPlugin.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: _getNotificationDetails(),
        payload: payload,
      );
    } catch (e) {
      debugPrint('Error showing instant notification: $e');
    }
  }

  /// Schedule a notification at a specific future date & time
  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    // Only schedule future notifications
    if (scheduledDate.isBefore(DateTime.now())) return;

    try {
      final tzDateTime = tz.TZDateTime.from(scheduledDate, tz.local);

      try {
        await _notificationsPlugin.zonedSchedule(
          id: id,
          title: title,
          body: body,
          scheduledDate: tzDateTime,
          notificationDetails: _getNotificationDetails(),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          payload: payload,
        );
      } catch (e) {
        // Fallback to inexact if exact alarm permission is restricted
        await _notificationsPlugin.zonedSchedule(
          id: id,
          title: title,
          body: body,
          scheduledDate: tzDateTime,
          notificationDetails: _getNotificationDetails(),
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          payload: payload,
        );
      }
      debugPrint('Scheduled notification $id at $scheduledDate: $title');
    } catch (e) {
      debugPrint('Error scheduling notification: $e');
    }
  }

  /// Schedule automated reminders for loan / committee installments:
  /// - 1 Day Before Due Date at 10:00 AM
  /// - On Due Date at 09:00 AM
  static Future<void> scheduleLoanReminders(List<InstallmentModel> installments) async {
    if (installments.isEmpty) return;

    final now = DateTime.now();

    for (final inst in installments) {
      // Only schedule for pending installments
      if (!inst.isPending || inst.dueDate == null) continue;

      DateTime? dueDate;
      try {
        dueDate = DateTime.parse(inst.dueDate!);
      } catch (_) {
        continue;
      }

      final amountStr = inst.amount != null ? '₹${inst.amount!.toStringAsFixed(0)}' : 'your installment';

      // 1. One Day Before Due Date at 10:00 AM
      final oneDayBefore = DateTime(dueDate.year, dueDate.month, dueDate.day - 1, 10, 0);
      if (oneDayBefore.isAfter(now)) {
        await scheduleNotification(
          id: (inst.id * 10) + 1,
          title: 'Upcoming Payment Reminder ⏰',
          body: 'Your EMI of $amountStr is due tomorrow. Pay on time to avoid late penalty.',
          scheduledDate: oneDayBefore,
          payload: 'installment_${inst.id}',
        );
      }

      // 2. On Due Date at 09:00 AM
      final onDueDate = DateTime(dueDate.year, dueDate.month, dueDate.day, 9, 0);
      if (onDueDate.isAfter(now)) {
        await scheduleNotification(
          id: (inst.id * 10) + 2,
          title: 'Payment Due Today! ⚠️',
          body: 'Your loan installment of $amountStr is due today. Tap here to pay now.',
          scheduledDate: onDueDate,
          payload: 'installment_${inst.id}',
        );
      }
    }
  }

  /// Cancel a specific notification
  static Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id: id);
  }

  /// Cancel all scheduled notifications
  static Future<void> cancelAll() async {
    await _notificationsPlugin.cancelAll();
  }
}
