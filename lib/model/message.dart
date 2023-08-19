// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class MessageModel {
  final String text;
  final String authorId;
  final String authorName;
  final DateTime createdAt;
  final String? messageId;
  final MessageModel? replayMessage;
  GlobalKey? globalKey;
  MessageModel({
    required this.text,
    required this.authorId,
    required this.authorName,
    required this.createdAt,
    required this.messageId,
    required this.replayMessage,
    this.globalKey,
  });

  MessageModel copyWith({
    String? text,
    String? authorId,
    String? messageId,
    MessageModel? replayMessage,
    String? authorName,
    DateTime? createdAt,
  }) {
    return MessageModel(
      text: text ?? this.text,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      createdAt: createdAt ?? this.createdAt,
      replayMessage: replayMessage ?? this.replayMessage,
      messageId: messageId ?? this.messageId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
      'authorId': authorId,
      'authorName': authorName,
      'createdAt': createdAt,
      'replayMessage': replayMessage?.toMap(),
      'messageId': messageId,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      text: map['text'] as String,
      authorId: map['authorId'] as String,
      messageId: map['messageId'] as String?,
      replayMessage: map['replayMessage'] != null
          ? MessageModel.fromMap(map['replayMessage'])
          : null,
      authorName: map['authorName'] as String,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageModel.fromJson(String source) =>
      MessageModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Message(text: $text, authorId: $authorId, authorName: $authorName, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant MessageModel other) {
    if (identical(this, other)) return true;

    return other.text == text &&
        other.authorId == authorId &&
        other.authorName == authorName &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return text.hashCode ^
        authorId.hashCode ^
        authorName.hashCode ^
        createdAt.hashCode;
  }
}
