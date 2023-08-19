import 'package:flutter/material.dart';
import 'package:flutter_chat_app/model/message.dart';
import 'package:get/get.dart';
import 'package:swipe_to/swipe_to.dart';

import '../../controllers/auth_controller.dart';

class MessageItem extends StatelessWidget {
  final MessageModel message;
  final Function(MessageModel) onSwipe;
  final Function(MessageModel) onScrollToMessage;
  final GlobalKey globalKey = GlobalKey();

  MessageItem(
      {super.key,
      required this.message,
      required this.onSwipe,
      required this.onScrollToMessage}) {
    message.globalKey = globalKey;
  }
  bool get isMyMessage => message.authorId == Get.find<AuthController>().userId;

  @override
  Widget build(BuildContext context) {
    return SwipeTo(
      onLeftSwipe: () => onSwipe.call(message),
      leftSwipeWidget: Row(
        mainAxisAlignment:
            isMyMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: Colors.indigo,
              borderRadius: BorderRadius.circular(100),
            ),
            child: const Icon(
              Icons.reply,
              color: Colors.white,
            ),
          ),
        ],
      ),
      key: ValueKey(message.messageId),
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 5.0,
          horizontal: 8.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMyMessage) ...[
              Padding(
                padding: const EdgeInsets.only(
                  left: 6.0,
                ),
                child: Text(
                  message.authorName,
                  style: const TextStyle(
                    fontSize: 12.0,
                  ),
                ),
              ),
            ],
            Row(
              mainAxisAlignment:
                  isMyMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 16.0,
                  ),
                  decoration: BoxDecoration(
                    color: isMyMessage ? Colors.indigo : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Column(
                    crossAxisAlignment: isMyMessage
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      if (message.replayMessage != null) ...[
                        GestureDetector(
                          onTap: () =>
                              onScrollToMessage.call(message.replayMessage!),
                          child: IntrinsicHeight(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: isMyMessage
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              children: [
                                Container(
                                  color: Colors.grey,
                                  width: 3,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      message.replayMessage?.authorName ?? "",
                                      style: TextStyle(
                                        color: isMyMessage
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                    Text(
                                      message.replayMessage?.text ?? "",
                                      style: TextStyle(
                                        color: isMyMessage
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                      Text(
                        message.text,
                        style: TextStyle(
                          color: isMyMessage ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
