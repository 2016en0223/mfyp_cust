import 'dart:convert';
import 'package:get/get.dart';
import 'package:mfyp_cust/includes/global.dart';
import 'package:http/http.dart' as http;
import 'package:mfyp_cust/includes/utilities/dialog.util.dart';

class AutomateFCM extends GetConnect {
  final String apiUrl = "https://fcm.googleapis.com/fcm/send";

  static void sendFCMNotification(
      String token, String requestID, dynamic context) async {
    Map<String, String> headerMap = {
      "Content-Type": "application/json",
      "Authorization": cloudMessagingToken
    };
    Map<String, String> bodyMap = {
      "body": "Let's check if the FCM is working",
      "title": "MFYP User Request - Mustapha Marizuk Oloyede",
    };
    Map<String, String> dataMap = {
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "id": "1",
      "status": "done",
      "request_id": requestID
    };
    Map<String, dynamic> notificationDetails = {
      "notification": bodyMap,
      "data": dataMap,
      "priority": "high",
      "to": token
    };
    String url = "https://fcm.googleapis.com/fcm/send";
    http.post(Uri.parse(url),
        headers: headerMap, body: jsonEncode(notificationDetails));
  }

  void sendFCMNotificationGet(
      String token, String requestID, dynamic context) async {
    Map<String, String> bodyMap = {
      "body": "Let's check if the FCM is working",
      "title": "MFYP User Request - Mustapha Marizuk Oloyede",
    };
    Map<String, String> dataMap = {
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "id": "1",
      "status": "done",
      "request_id": requestID
    };
    Map<String, dynamic> notificationDetails = {
      "notification": bodyMap,
      "data": dataMap,
      "priority": "high",
      "to": token
    };

    Response postResponse = await post(apiUrl, notificationDetails, headers: {
      "Content_type": "application/json",
      "Authorization": cloudMessagingToken
    });
    if (postResponse.statusCode == 200) {
      snackGet("Message", "Request Successfully Sent");
    } else {
      snackGet("Message", "Request failed");
    }
  }
}
