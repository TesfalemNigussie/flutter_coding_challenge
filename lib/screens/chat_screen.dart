import 'package:flutter/material.dart';
import 'package:flutter_chat_app/model/message.dart';
import 'package:flutter_chat_app/screens/widgets/message_item.dart';
import 'package:get/get.dart';

import '../controllers/chat_controller.dart';
import 'widgets/message_composer.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ChatController get chatController => Get.find();
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Chat App",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 1.0,
        backgroundColor: Colors.indigo,
      ),
      body: chatController.obx(
        (state) => Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: state.length,
                reverse: true,
                itemBuilder: (context, index) {
                  final message = state[index];
                  return Builder(builder: (context) {
                    return MessageItem(
                      message: message,
                      onSwipe: (replayMessage) => chatController
                          .currentReplayMessageMessageModel = replayMessage,
                      onScrollToMessage: (replayMessage) {
                        scrollController.animateTo(
                          50.0 * index,
                          duration: const Duration(
                            milliseconds: 100,
                          ),
                          curve: Curves.easeOut,
                        );

                        Scrollable.ensureVisible(
                          (state as List<MessageModel>)
                                  .firstWhere((element) =>
                                      element.messageId ==
                                      replayMessage.messageId)
                                  .globalKey
                                  ?.currentState
                                  ?.context ??
                              context,
                          alignmentPolicy:
                              ScrollPositionAlignmentPolicy.keepVisibleAtStart,
                        );
                      },
                    );
                  });
                },
              ),
            ),
            chatController.currentReplayMessageMessageModel != null
                ? Container(
                    padding: const EdgeInsets.all(10),
                    color: Colors.grey.shade300,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.reply,
                          color: Colors.indigo,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${chatController.currentReplayMessageMessageModel?.authorName}',
                              ),
                              Text(
                                '${chatController.currentReplayMessageMessageModel?.text}',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () {
                            chatController.currentReplayMessageMessageModel =
                                null;
                          },
                          child: const Icon(
                            Icons.close,
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(),
            const MessageComposer()
          ],
        ),
        onEmpty: const Center(
          child: Text("No messages found"),
        ),
        onError: (error) => Center(
          child: Text("Error: $error"),
        ),
        onLoading: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
