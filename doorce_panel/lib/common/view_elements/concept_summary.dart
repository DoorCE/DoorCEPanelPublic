import 'package:doorce_panel/common/view_elements/style.dart';
import 'package:doorce_panel/common/view_elements/text.dart';
import 'package:doorce_panel/locales/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class ConceptSummaryWidget extends StatelessWidget {
  final Map<String, int> summaries;
  final double maxWidth;

  const ConceptSummaryWidget({
    super.key,
    required this.summaries,
    this.maxWidth = 500,
  });

  @override
  Widget build(BuildContext context) {
    return Align( // important on web
      alignment: Alignment.topLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth,
        ),
        child: Table(
          columnWidths: const {
            0: FlexColumnWidth(3),
            1: FlexColumnWidth(1),
          },
          border: TableBorder.all(color: DoorColor.darkEmph, width: 1),
          children: [
            // Header row
            TableRow(
              decoration: const BoxDecoration(color: DoorColor.lightEmph),
              children: [
                _HeaderCell(AppLocalizations.of(context)!.conceptUri),
                _HeaderCell(AppLocalizations.of(context)!.dataRows),
              ],
            ),

            // Data rows
              ...summaries.entries.map(
                (e) => TableRow(
                  children: [
                    _Cell(e.key),
                    _Cell(
                      e.value.toString()
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String text;

  const _HeaderCell(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: DoorText(
        text,
        DoorTextStyle.label,
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  final String text;

  const _Cell(
    this.text, 
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: DoorText(
        text,
        DoorTextStyle.norm
      ),
    );
  }
}
