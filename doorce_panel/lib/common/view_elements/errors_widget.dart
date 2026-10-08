import 'dart:convert';
import 'package:doorce_panel/common/view_elements/button.dart';
import 'package:doorce_panel/common/view_elements/style.dart';
import 'package:doorce_panel/common/view_elements/text.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;

class DataFileErrorsWidget extends StatelessWidget {
  final String errorString;

  const DataFileErrorsWidget({
    super.key,
    required this.errorString,
  });

  Map<String, Map<String, List<String>>>? _tryParseStructuredErrors() {
    try {
      final decoded = jsonDecode(errorString);

      if (decoded is! Map<String, dynamic>) return null;

      return decoded.map(
        (entityKey, entityValue) {
          if (entityValue is! Map<String, dynamic>) {
            throw const FormatException();
          }

          return MapEntry(
            entityKey,
            entityValue.map(
              (rowKey, errors) {
                if (errors is! List) {
                  throw const FormatException();
                }

                return MapEntry(
                  rowKey,
                  List<String>.from(errors),
                );
              },
            ),
          );
        },
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final structuredErrors = _tryParseStructuredErrors();

    return Card(
      color: DoorColor.lightEmph,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: structuredErrors != null
            ? _StructuredErrorsView(structuredErrors)
            : _GenericErrorView(errorString),
      ),
    );
  }
}

class _StructuredErrorsView extends StatelessWidget {
  final Map<String, Map<String, List<String>>> errors;
  static const int maxVisibleErrors = 10;

  const _StructuredErrorsView(this.errors);

  @override
  Widget build(BuildContext context) {
    final limiter = _ErrorRenderLimiter(maxVisibleErrors);
    final tiles = <Widget>[];

    for (final entity in errors.entries) {
      final entityChildren = <Widget>[];

      for (final row in entity.value.entries) {
        final visibleErrors = <String>[];

        for (final error in row.value) {
          if (limiter.allow()) {
            visibleErrors.add(error);
          }
        }

        if (visibleErrors.isNotEmpty) {
          entityChildren.add(
            SizedBox( // <- ensure full width to avoid sporadic indent shifts
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  DoorText(
                    row.key,
                    DoorTextStyle.emph,
                  ),
                  const SizedBox(height: 4),
                  ...visibleErrors.map(
                    (e) => Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: DoorText(
                        '• $e',
                        DoorTextStyle.norm,
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

      if (entityChildren.isNotEmpty) {
        tiles.add(
          ListTileTheme(
            contentPadding: EdgeInsets.zero,
            horizontalTitleGap: 0,
            minLeadingWidth: 0,
            child: ExpansionTile(
              expandedAlignment: Alignment.centerLeft,
              initiallyExpanded: true,
              tilePadding: EdgeInsets.zero,
              childrenPadding: const EdgeInsets.only(left: 16), // <- consistent inset
              collapsedIconColor: DoorColor.greyBlur,
              iconColor: DoorColor.darkEmph,
              title: DoorText(
                entity.key,
                DoorTextStyle.label,
              ),
              children: entityChildren,
            ),
          )
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _ErrorHeader(),
        const SizedBox(height: 12),
        ...tiles,

        if (limiter.hidden > 0) ...[
          const SizedBox(height: 12),
          DoorText(
            '+ ${limiter.hidden} ${AppLocalizations.of(context)!.moreErrorsNotShown}',
            DoorTextStyle.norm,
          ),
          const SizedBox(height: 8),
          _DownloadErrorsButton(errors),
        ],
      ],
    );
  }
}

class _DownloadErrorsButton extends StatelessWidget {
  final Map<String, Map<String, List<String>>> errors;

  const _DownloadErrorsButton(this.errors);

  @override
  Widget build(BuildContext context) {
    return DoorButtonIcon(
      AppLocalizations.of(context)!.downloadErrorLog,
      Icons.download,
       () {
        final jsonString =
            const JsonEncoder.withIndent('  ').convert(errors);
        _downloadJson(jsonString);
      },
    );
  }

  void _downloadJson(String content) {

    final blob = html.Blob([utf8.encode(content)]);
    final url = html.Url.createObjectUrlFromBlob(blob);

    html.AnchorElement(href: url)
      ..setAttribute('download', 'error_log.json')
      ..click();

    html.Url.revokeObjectUrl(url);
  }
}


class _GenericErrorView extends StatelessWidget {
  final String message;

  const _GenericErrorView(this.message);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _ErrorHeader(),
        const SizedBox(height: 8),
        Text(
          AppLocalizations.of(context)!.errorWidgetMessage,
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        Text(
          message,
          style: const TextStyle(color: Colors.red),
        ),
      ],
    );
  }
}

class _ErrorHeader extends StatelessWidget {
  const _ErrorHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.error,
          color: DoorColor.red,
          size: 20,
        ),
        const SizedBox(width: 8),
        DoorText(
          AppLocalizations.of(context)!.dataImportErrors,
          DoorTextStyle.error
        ),
      ],
    );
  }
}


class _ErrorRenderLimiter {
  int remaining;
  int hidden = 0;

  _ErrorRenderLimiter(this.remaining);

  bool allow() {
    if (remaining > 0) {
      remaining--;
      return true;
    }
    hidden++;
    return false;
  }
}


