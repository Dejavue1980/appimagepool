import 'package:gtk/gtk.dart';
import 'package:flutter/material.dart';
import 'package:nativeshell/nativeshell.dart';
import 'package:adwaita_icons/adwaita_icons.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../utils/utils.dart';
import '../providers/providers.dart';

class PoolApp extends HookConsumerWidget {
  final String? title;
  final List<Widget> leading;
  final List<Widget> trailing;
  final bool showBackButton;
  final Widget body;
  final VoidCallback? onBackPressed;

  const PoolApp({
    Key? key,
    this.title,
    required this.body,
    this.leading = const [],
    this.trailing = const [],
    this.showBackButton = false,
    this.onBackPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return Column(
      children: [
        GtkHeaderBar.nativeshell(
          padding: const EdgeInsets.only(right: 7),
          window: Window.of(context),
          onClose: Window.of(context).close,
          onMinimize: context.width >= mobileWidth ? () {} : null,
          onMaximize: context.width >= mobileWidth ? () {} : null,
          leading: Row(children: [
            if (showBackButton)
              Hero(
                tag: 'back-button',
                child: Material(
                  type: MaterialType.transparency,
                  child: GtkHeaderButton(
                    icon: const AdwaitaIcon(AdwaitaIcons.go_previous),
                    onPressed: () {
                      if (onBackPressed != null) onBackPressed!();
                      context.back();
                    },
                  ),
                ),
              ),
            ...leading,
          ]),
          center: (title != null && title!.isNotEmpty)
              ? Text(
                  title!,
                  style: context.textTheme.headline6!.copyWith(fontSize: 17),
                )
              : const SizedBox(),
          trailling: Row(children: trailing),
          themeType: ref.watch(themeTypeProvider),
        ),
        Expanded(child: body),
      ],
    );
  }
}