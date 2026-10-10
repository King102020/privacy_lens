import 'package:intl/intl.dart';

import '../../l10n/gen/app_localizations.dart';

String formatRelativeTime({
  required DateTime value,
  required DateTime now,
  required AppLocalizations l10n,
}) {
  final local = value.toLocal();
  final elapsed = now.difference(local);
  if (elapsed.isNegative || elapsed.inSeconds < 45) return l10n.relativeJustNow;
  if (elapsed.inMinutes < 60) return l10n.relativeMinutesAgo(elapsed.inMinutes);
  if (elapsed.inHours < 24) return l10n.relativeHoursAgo(elapsed.inHours);
  if (elapsed.inDays < 7) return l10n.relativeDaysAgo(elapsed.inDays);
  return DateFormat.yMMMd().format(local);
}

String formatTodayTime(DateTime value, AppLocalizations l10n) =>
    l10n.relativeToday(DateFormat.jm().format(value.toLocal()));

String formatDuration(Duration duration, AppLocalizations l10n) {
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  if (hours == 0) return l10n.durationMinutes(minutes);
  return l10n.durationHoursMinutes(hours, minutes);
}

String formatBytes(int bytes, AppLocalizations l10n) {
  if (bytes < 1024) return l10n.sizeBytes(bytes);
  if (bytes < 1024 * 1024) {
    return l10n.sizeKilobytes((bytes / 1024).toStringAsFixed(1));
  }
  return l10n.sizeMegabytes((bytes / (1024 * 1024)).toStringAsFixed(1));
}
