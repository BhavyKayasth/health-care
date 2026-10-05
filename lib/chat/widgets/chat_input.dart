import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/app_colors.dart';
import '../controller/chat_controller.dart';

class ChatInput extends ConsumerWidget {
  const ChatInput({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(chatControllerProvider);
    final controller = ref.read(chatControllerProvider.notifier);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      decoration: const BoxDecoration(
        color: AppColors.background,
      ),
      child: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 16,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              /// Attachment
              IconButton(
                onPressed: () {
                  // TODO: Pick File / Image
                },
                icon: const Icon(
                  LucideIcons.paperclip,
                  color: AppColors.textGrey,
                ),
              ),

              /// Message Field
              Expanded(
                child: TextField(
                  controller: state.messageController,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) {
                    controller.sendMessage();
                  },
                  decoration: const InputDecoration(
                    hintText: "Type your message...",
                    hintStyle: TextStyle(
                      color: AppColors.textGrey,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),

              /// Voice
              IconButton(
                onPressed: () {
                  // TODO: Voice Input
                },
                icon: const Icon(
                  LucideIcons.mic,
                  color: AppColors.textGrey,
                ),
              ),

              const SizedBox(width: 6),

              /// Send Button
              GestureDetector(
                onTap: state.isSending
                    ? null
                    : () {
                  controller.sendMessage();
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary,
                        AppColors.secondary,
                      ],
                    ),
                  ),
                  child: state.isSending
                      ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor:
                      AlwaysStoppedAnimation(
                        Colors.white,
                      ),
                    ),
                  )
                      : const Icon(
                    LucideIcons.send,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}