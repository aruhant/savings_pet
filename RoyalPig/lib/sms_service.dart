import 'dart:async';
import 'package:goals/dynamo_service.dart';
import 'package:goals/log_entry.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:readsms/readsms.dart';
import 'dart:io' show Platform;

class SmsService {
  final _plugin = Readsms();
  final StreamController<Map<String, String>> _smsController =
      StreamController<Map<String, String>>.broadcast();

  Stream<Map<String, String>> get smsStream => _smsController.stream;

  Future<bool> initialize() async {
    if (!Platform.isAndroid) return false;

    bool hasPermission = await _getPermission();
    if (hasPermission) {
      _plugin.read();
      _plugin.smsStream.listen((event) {
        _smsController.add({
          'body': event.body,
          'sender': event.sender,
          'time': event.timeReceived.toString(),
        });
      });
    }
    return hasPermission;
  }

  Future<bool> _getPermission() async {
    if (await Permission.sms.status == PermissionStatus.granted) {
      return true;
    } else {
      return await Permission.sms.request() == PermissionStatus.granted;
    }
  }

  void dispose() {
    _plugin.dispose();
    _smsController.close();
  }
}

class SmsMonitor {
  SmsMonitor();
  final SmsService _smsService = SmsService();
  StreamSubscription<Map<String, String>>? _subscription;

  void startMonitoring(void Function(Map<String, String>) onSmsReceived) async {
    bool initialized = await _smsService.initialize();
    DynamoService dynamoService = DynamoService();
    if (initialized) {
      _smsService.smsStream.listen((smsData) async {
        print("New SMS from ${smsData['sender']}: ${smsData['body']}");
        onSmsReceived(smsData);
        LogEntry logEntry = LogEntry(
          text: smsData['body']!,
          sender: smsData['sender']!,
          category: "",
          time: smsData['time']!,
        );
        await logEntry.classify();
        dynamoService.insertNewItem(logEntry.toDBValue(), 'messages');
      });
    }
  }

  void stopMonitoring() {
    _subscription?.cancel();
    _smsService.dispose();
  }
}
