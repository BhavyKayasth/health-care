import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/app_colors.dart';
import '../controller/chat_controller.dart';
import '../models/chat_model.dart';
import '../widgets/chat_input.dart';
import '../widgets/delete_chat_dialog.dart';
import '../widgets/message_bubble.dart';
import '../widgets/suggestion_chips.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({
    super.key,
    this.onBack,
  });

  final VoidCallback? onBack;

  @override
  ConsumerState<ChatScreen> createState() =>
      _ChatScreenState();
}

class _ChatScreenState
    extends ConsumerState<ChatScreen> {
  final ScrollController _scrollController =
  ScrollController();

  // ==========================================================
  // SCROLL TO BOTTOM
  // ==========================================================

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback(
          (_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration:
            const Duration(milliseconds: 350),
            curve: Curves.easeOut,
          );
        }
      },
    );
  }

  // ==========================================================
  // BACK
  // ==========================================================

  void _handleBack() {
    if (widget.onBack != null) {
      widget.onBack!();
    } else {
      Navigator.pop(context);
    }
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(
      chatControllerProvider,
    );

    final controller = ref.read(
      chatControllerProvider.notifier,
    );

    _scrollToBottom();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.gradientStart,
                  AppColors.gradientMiddle,
                  AppColors.gradientEnd,
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  //================================================
                  // HEADER
                  //================================================

                  Container(
                    padding:
                    const EdgeInsets.fromLTRB(
                      12,
                      14,
                      12,
                      18,
                    ),
                    decoration:
                    const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary,
                          AppColors.secondary,
                        ],
                      ),
                      borderRadius:
                      BorderRadius.vertical(
                        bottom:
                        Radius.circular(28),
                      ),
                    ),
                    child: Row(
                      children: [
                        // ==================================================
                        // BACK BUTTON
                        // ==================================================

                        IconButton(
                          onPressed: _handleBack,
                          icon: const Icon(
                            LucideIcons.arrowLeft,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(width: 4),

                        // ==================================================
                        // BOT ICON
                        // ==================================================

                        Container(
                          width: 48,
                          height: 48,
                          decoration:
                          const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            LucideIcons.bot,
                            color:
                            AppColors.primary,
                            size: 26,
                          ),
                        ),

                        const SizedBox(
                          width: 12,
                        ),

                        // ==================================================
                        // TITLE
                        // ==================================================

                        const Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                            children: [
                              Text(
                                "AI Health Agent",
                                style:
                                TextStyle(
                                  color:
                                  Colors.white,
                                  fontSize: 18,
                                  fontWeight:
                                  FontWeight
                                      .bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Smart Recommendations • 24/7",
                                style:
                                TextStyle(
                                  color:
                                  Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // ==================================================
                        // DELETE
                        // ==================================================

                        IconButton(
                          onPressed:
                          controller
                              .showDeleteDialog,
                          icon: const Icon(
                            LucideIcons.trash2,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  //================================================
                  // CHAT
                  //================================================

                  Expanded(
                    child:
                    ListView.builder(
                      controller:
                      _scrollController,
                      padding:
                      const EdgeInsets.all(
                        18,
                      ),
                      itemCount:
                      state.messages.length,
                      itemBuilder:
                          (context, index) {
                        final ChatModel message =
                        state.messages[index];

                        return MessageBubble(
                          message: message,
                        );
                      },
                    ),
                  ),

                  //================================================
                  // SUGGESTIONS
                  //================================================

                  const SuggestionChips(),

                  //================================================
                  // INPUT
                  //================================================

                  const ChatInput(),
                ],
              ),
            ),
          ),

          //==================================================
          // DELETE DIALOG
          //==================================================

          const DeleteChatDialog(),
        ],
      ),
    );
  }

  // ==========================================================
  // DISPOSE
  // ==========================================================

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}