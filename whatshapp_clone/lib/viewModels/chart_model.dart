import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:whatshapp_clone/core/services/chat_service.dart';
import 'package:whatshapp_clone/models/conversation.dart';

class ChartModel with ChangeNotifier {
  Stream<List<Conversation>> conversations(String userId) {
    final ChatService _db = GetIt.instance<ChatService>();
    return _db.getConvarsation(userId);
  }
}
