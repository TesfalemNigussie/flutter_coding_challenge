// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:math';

import 'package:flutter_chat_app/data_provider/messages_remote.dart';
import 'package:flutter_chat_app/model/message.dart';
import 'package:get/get.dart';

import 'auth_controller.dart';

class ChatController extends GetxController with StateMixin {
  final MessageRemoteDataProvider messageRemoteDataProvider;

  StreamSubscription? _subscription;
  ChatController({
    required this.messageRemoteDataProvider,
  });
  @override
  void onInit() {
    super.onInit();
    initSubscription();
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }

  initSubscription() {
    change([], status: RxStatus.loading());
    _subscription =
        messageRemoteDataProvider.listenToMessages().listen((messages) {
      if (messages.isEmpty) {
        change([], status: RxStatus.empty());
        return;
      }
      change(messages, status: RxStatus.success());
    });
  }

  Future<void> sendMessage(String message) {
    final myId = Get.find<AuthController>().userId;
    final messageData = MessageModel(
      text: message,
      authorId: myId,
      authorName: myId.substring(0, 5),
      createdAt: DateTime.now(),
      messageId: Random().nextInt(1000).toString(),
      replayMessage: currentReplayMessageMessageModel,
    );
    return messageRemoteDataProvider.sendMessage(messageData);
  }

  MessageModel? _currentReplayMessageMessageModel;
  MessageModel? get currentReplayMessageMessageModel =>
      _currentReplayMessageMessageModel;
  set currentReplayMessageMessageModel(MessageModel? value) {
    _currentReplayMessageMessageModel = value;
    update();
  }
}
