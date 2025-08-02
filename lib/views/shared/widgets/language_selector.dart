import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/localization/index.dart';

/// A widget that allows users to select their preferred language
class LanguageSelector extends ConsumerWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    final supportedLocales = ref.watch(supportedLocalesWithNamesProvider);
    final isRTL = ref.watch(isRTLProvider);

    return PopupMenuButton<String>(
      icon: Icon(
        Icons.language,
        textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      ),
      tooltip: context.l10n.language,
      onSelected: (String languageCode) {
        ref.read(localeProvider.notifier).setLanguage(languageCode);
      },
      itemBuilder: (BuildContext context) {
        return supportedLocales.map((localeInfo) {
          final isSelected =
              localeInfo.locale.languageCode == currentLocale.languageCode;

          return PopupMenuItem<String>(
            value: localeInfo.locale.languageCode,
            child: Directionality(
              textDirection: localeInfo.isRTL
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          localeInfo.displayName,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                        ),
                        Text(
                          localeInfo.displayNameEnglish,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      Icons.check,
                      size: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  if (localeInfo.isRTL)
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Icon(
                        Icons.format_textdirection_r_to_l,
                        size: 14,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),
          );
        }).toList();
      },
    );
  }
}

/// A more detailed language selector dialog
class LanguageSelectorDialog extends ConsumerWidget {
  const LanguageSelectorDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (context) => const LanguageSelectorDialog(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    final supportedLocales = ref.watch(supportedLocalesWithNamesProvider);
    final isRTL = ref.watch(isRTLProvider);

    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: AlertDialog(
        title: Text(context.l10n.language),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: supportedLocales.length,
            itemBuilder: (context, index) {
              final localeInfo = supportedLocales[index];
              final isSelected =
                  localeInfo.locale.languageCode == currentLocale.languageCode;

              return Directionality(
                textDirection: localeInfo.isRTL
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                child: RadioListTile<String>(
                  value: localeInfo.locale.languageCode,
                  groupValue: currentLocale.languageCode,
                  onChanged: (String? value) {
                    if (value != null) {
                      ref.read(localeProvider.notifier).setLanguage(value);
                      Navigator.of(context).pop();
                    }
                  },
                  title: Text(
                    localeInfo.displayName,
                    style: TextStyle(
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                  subtitle: Row(
                    children: [
                      Text(
                        localeInfo.displayNameEnglish,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      if (localeInfo.isRTL) ...[
                        const SizedBox(width: 8),
                        Icon(
                          Icons.format_textdirection_r_to_l,
                          size: 14,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'RTL',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                                fontSize: 10,
                              ),
                        ),
                      ],
                    ],
                  ),
                  secondary: localeInfo.isRTL
                      ? Icon(
                          Icons.format_textdirection_r_to_l,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      : null,
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(context.l10n.close),
          ),
        ],
      ),
    );
  }
}

/// A simple language selector tile for settings pages
class LanguageSelectorTile extends ConsumerWidget {
  const LanguageSelectorTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLanguageDisplayName = ref.watch(
      currentLanguageDisplayNameProvider,
    );
    final isRTL = ref.watch(isRTLProvider);

    return ListTile(
      leading: Icon(
        Icons.language,
        textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      ),
      title: Text(context.l10n.language),
      subtitle: Text(currentLanguageDisplayName),
      trailing: Icon(
        Icons.chevron_right,
        textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      ),
      onTap: () => LanguageSelectorDialog.show(context),
    );
  }
}
