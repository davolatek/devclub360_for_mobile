
import 'package:awesome_notifications/awesome_notifications.dart';


  Future<void> createDealConnectNotification(String title, String body) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(4),
        channelKey: 'basic_channel',
        title: title,
        body: body
      )
    );
  }
