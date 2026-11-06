import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/settings/presentation/settings_cubit.dart';
import 'spotlight_tour.dart';

abstract final class TabGuideIds {
  static const homeStart = 'home_start';
  static const home = 'home';
  static const apps = 'apps';
  static const findings = 'findings';
  static const trackers = 'trackers';
  static const settings = 'settings';
}

/// Runs a tab's spotlight tour the first time the tab is on screen with
/// something to show. Settings → Replay tips clears the seen list, which
/// arms every tour again.
class TabTour extends StatefulWidget {
  const TabTour({
    required this.id,
    required this.ready,
    required this.steps,
    required this.child,
    super.key,
  });

  final String id;

  /// False while the tab has nothing worth pointing at yet (no scan, loading).
  final bool ready;
  final List<TourStep> Function(BuildContext context) steps;
  final Widget child;

  @override
  State<TabTour> createState() => _TabTourState();
}

class _TabTourState extends State<TabTour> {
  static const _settle = Duration(milliseconds: 450);

  Timer? _pending;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // TickerMode flips when the shell shows or hides this tab.
    _schedule();
  }

  @override
  void didUpdateWidget(TabTour oldWidget) {
    super.didUpdateWidget(oldWidget);
    _schedule();
  }

  @override
  void dispose() {
    _pending?.cancel();
    super.dispose();
  }

  bool get _wanted =>
      widget.ready &&
      TickerMode.of(context) &&
      !context.read<SettingsCubit>().state.seenTabGuides.contains(widget.id);

  void _schedule() {
    _pending?.cancel();
    if (_wanted) _pending = Timer(_settle, () => unawaited(_start()));
  }

  Future<void> _start() async {
    if (!mounted || !_wanted || isSpotlightTourOpen) return;
    final settings = context.read<SettingsCubit>();
    final shown = await showSpotlightTour(context, widget.steps(context));
    if (shown != null) unawaited(settings.markTabGuideSeen(widget.id));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingsCubit, SettingsState>(
      listenWhen: (a, b) => a.seenTabGuides != b.seenTabGuides,
      listener: (_, _) => _schedule(),
      child: widget.child,
    );
  }
}
