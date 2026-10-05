import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../models/chat_model.dart';

class ChatState {
  final List<ChatModel> messages;
  final bool isLoading;
  final bool isSending;
  final bool showDeleteDialog;
  final TextEditingController messageController;

  const ChatState({
    required this.messages,
    required this.messageController,
    this.isLoading = false,
    this.isSending = false,
    this.showDeleteDialog = false,
  });

  ChatState copyWith({
    List<ChatModel>? messages,
    bool? isLoading,
    bool? isSending,
    bool? showDeleteDialog,
    TextEditingController? messageController,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      messageController:
      messageController ?? this.messageController,
      isLoading: isLoading ?? this.isLoading,
      isSending: isSending ?? this.isSending,
      showDeleteDialog:
      showDeleteDialog ?? this.showDeleteDialog,
    );
  }
}

class ChatController extends StateNotifier<ChatState> {
  ChatController()
      : super(
    ChatState(
      messageController: TextEditingController(),
      messages: [
        ChatModel(
          id: "1",
          text:
          "Hello! 👋 I'm your AI Health Assistant. How can I help you today?",
          sender: MessageSender.ai,
          timestamp: DateTime.now(),
        ),
      ],
    ),
  );

  //==========================================================
  // CLOUDFLARE WORKER URL
  //==========================================================

  static const String _baseUrl =
      'https://healthcare-ai-api.healthcare-ai-bhavy.workers.dev';

  //==========================================================
  // SUGGESTIONS
  //==========================================================

  final List<String> suggestions = const [
    "I have a fever and headache",
    "Find nearby hospitals",
    "Emergency help needed",
    "Book appointment",
  ];

  TextEditingController get textController =>
      state.messageController;

  //==========================================================
  // SEND MESSAGE
  //==========================================================


  Future<void> sendMessage([String? text]) async {
    final message =
        text?.trim() ?? state.messageController.text.trim();

    if (message.isEmpty || state.isSending) {
      return;
    }

    final userMessage = ChatModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: message,
      sender: MessageSender.user,
      timestamp: DateTime.now(),
    );

    state.messageController.clear();

    state = state.copyWith(
      messages: [
        ...state.messages,
        userMessage,
      ],
      isSending: true,
    );

    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'message': message,
        }),
      );

      // ----------------------------------------------------------
      // DEBUG RESPONSE
      // ----------------------------------------------------------

      debugPrint('========================================');
      debugPrint('CHAT API STATUS: ${response.statusCode}');
      debugPrint('CHAT API BODY: ${response.body}');
      debugPrint('CHAT API HEADERS: ${response.headers}');
      debugPrint('========================================');

      // ----------------------------------------------------------
      // SUCCESS
      // ----------------------------------------------------------

      if (response.statusCode >= 200 &&
          response.statusCode < 300) {
        try {
          final data =
          jsonDecode(response.body);

          debugPrint('DECODED DATA: $data');

          if (data is Map<String, dynamic>) {
            final reply =
            data['reply']?.toString().trim();

            if (reply != null && reply.isNotEmpty) {
              final aiMessage = ChatModel(
                id: DateTime.now()
                    .microsecondsSinceEpoch
                    .toString(),
                text: reply,
                sender: MessageSender.ai,
                timestamp: DateTime.now(),
              );

              state = state.copyWith(
                messages: [
                  ...state.messages,
                  aiMessage,
                ],
                isSending: false,
              );

              return;
            }
          }

          // --------------------------------------------------------
          // 200 BUT NO REPLY
          // --------------------------------------------------------

          _addErrorMessage(
            'The AI service responded, but no AI reply was returned.',
          );

          return;
        } catch (e) {
          debugPrint(
            'JSON DECODE ERROR: $e',
          );

          _addErrorMessage(
            'The AI service returned an invalid response.',
          );

          return;
        }
      }

      // ----------------------------------------------------------
      // SERVER ERROR
      // ----------------------------------------------------------

      _addErrorMessage(
        'AI service error (${response.statusCode}): ${response.body}',
      );
    } catch (error, stackTrace) {
      debugPrint('========================================');
      debugPrint('CHAT NETWORK ERROR: $error');
      debugPrint('STACK TRACE: $stackTrace');
      debugPrint('========================================');

      _addErrorMessage(
        'Unable to connect to the AI service. Please check your internet connection.',
      );
    }
  }

  //==========================================================
  // ERROR MESSAGE
  //==========================================================

  void _addErrorMessage(String message) {
    final errorMessage = ChatModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      text: message,
      sender: MessageSender.ai,
      timestamp: DateTime.now(),
    );

    state = state.copyWith(
      messages: [
        ...state.messages,
        errorMessage,
      ],
      isSending: false,
    );
  }

  //==========================================================
  // SUGGESTION
  //==========================================================

  void sendSuggestion(String suggestion) {
    sendMessage(suggestion);
  }

  //==========================================================
  // DELETE DIALOG
  //==========================================================

  void showDeleteDialog() {
    state = state.copyWith(
      showDeleteDialog: true,
    );
  }

  void hideDeleteDialog() {
    state = state.copyWith(
      showDeleteDialog: false,
    );
  }

  //==========================================================
  // DELETE ALL CHATS
  //==========================================================

  void deleteAllChats() {
    state.messageController.clear();

    state = state.copyWith(
      showDeleteDialog: false,
      messages: [
        ChatModel(
          id: "1",
          text:
          "Hello! 👋 I'm your AI Health Assistant. How can I help you today?",
          sender: MessageSender.ai,
          timestamp: DateTime.now(),
        ),
      ],
    );
  }

  //==========================================================
  // DISPOSE
  //==========================================================

  @override
  void dispose() {
    state.messageController.dispose();
    super.dispose();
  }
}

final chatControllerProvider =
StateNotifierProvider<ChatController, ChatState>(
      (ref) => ChatController(),
);