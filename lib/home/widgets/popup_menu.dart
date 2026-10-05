import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../controller/home_controller.dart';
import 'menu_item.dart';

class PopupMenuWidget extends ConsumerWidget {
  const PopupMenuWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 240,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.12),
              blurRadius: 25,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MenuItemWidget(
              icon: LucideIcons.settings,
              label: "App Settings",
              onTap: () {
                ref.read(homeControllerProvider.notifier).closeMenu();
              },
            ),

            MenuItemWidget(
              icon: LucideIcons.info,
              label: "About Us",
              onTap: () {
                ref.read(homeControllerProvider.notifier).closeMenu();
              },
            ),

            MenuItemWidget(
              icon: LucideIcons.circleHelp,
              label: "Help & Support",
              onTap: () {
                ref.read(homeControllerProvider.notifier).closeMenu();
              },
            ),

            MenuItemWidget(
              icon: LucideIcons.shield,
              label: "Terms & Privacy",
              onTap: () {
                ref.read(homeControllerProvider.notifier).closeMenu();
              },
            ),

            MenuItemWidget(
              icon: LucideIcons.share2,
              label: "Share App",
              onTap: () {
                ref.read(homeControllerProvider.notifier).closeMenu();
              },
            ),

            MenuItemWidget(
              icon: LucideIcons.star,
              label: "Rate Us",
              onTap: () {
                ref.read(homeControllerProvider.notifier).closeMenu();
              },
            ),

            MenuItemWidget(
              icon: LucideIcons.logOut,
              label: "Logout",
              isDanger: true,
              isLast: true,
              onTap: () {
                ref.read(homeControllerProvider.notifier).closeMenu();

                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/',
                      (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}