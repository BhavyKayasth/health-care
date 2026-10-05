import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../core/theme/app_colors.dart';
import '../models/chat_model.dart';
import 'hospital_card.dart';

class MessageBubble extends StatelessWidget {
  final ChatModel message;

  const MessageBubble({
    super.key,
    required this.message,
  });

  String _formatTime(DateTime time) {
    final hour = time.hour > 12
        ? time.hour - 12
        : (time.hour == 0 ? 12 : time.hour);

    final minute = time.minute.toString().padLeft(2, '0');

    final period = time.hour >= 12 ? "PM" : "AM";

    return "$hour:$minute $period";
  }

  @override
  Widget build(BuildContext context) {
    final isUser = message.sender == MessageSender.user;

    return Align(
      alignment:
      isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment:
          isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (!isUser) ...[
              const _Avatar(
                icon: LucideIcons.bot,
                background: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.secondary,
                  ],
                ),
              ),
              const SizedBox(width: 10),
            ],

            Flexible(
              child: Column(
                crossAxisAlignment: isUser
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Container(
                    constraints: const BoxConstraints(
                      maxWidth: 280,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: isUser
                          ? const LinearGradient(
                        colors: [
                          AppColors.primary,
                          AppColors.secondary,
                        ],
                      )
                          : null,
                      color: isUser ? null : Colors.white,
                      boxShadow: isUser
                          ? null
                          : const [
                        BoxShadow(
                          color: Color(0x12000000),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      message.text,
                      style: TextStyle(
                        color: isUser
                            ? Colors.white
                            : AppColors.darkBlue,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ),

                  if (message.type ==
                      MessageType.hospitalRecommendation &&
                      message.hospitals.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Column(
                        children: message.hospitals
                            .map(
                              (hospital) => Padding(
                            padding: const EdgeInsets.only(
                              bottom: 12,
                            ),
                            child: HospitalCard(
                              hospital: hospital,
                            ),
                          ),
                        )
                            .toList(),
                      ),
                    ),

                  const SizedBox(height: 6),

                  Text(
                    _formatTime(message.timestamp),
                    style: const TextStyle(
                      color: AppColors.textGrey,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),

            if (isUser) ...[
              const SizedBox(width: 10),
              const _Avatar(
                icon: LucideIcons.user,
                background: LinearGradient(
                  colors: [
                    Color(0xFFBFDBFE),
                    Color(0xFF93C5FD),
                  ],
                ),
                iconColor: AppColors.darkBlue,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final IconData icon;
  final Gradient background;
  final Color iconColor;

  const _Avatar({
    required this.icon,
    required this.background,
    this.iconColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: background,
      ),
      child: Icon(
        icon,
        size: 18,
        color: iconColor,
      ),
    );
  }
}