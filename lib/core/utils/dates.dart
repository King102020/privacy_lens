DateTime startOfLocalDay(DateTime moment) {
  final local = moment.toLocal();
  return DateTime(local.year, local.month, local.day);
}
