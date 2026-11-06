import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/design_system/app_radii.dart';
import '../../core/design_system/app_spacing.dart';
import '../extensions/context_extensions.dart';

/// One stop of a spotlight tour: the widget to cut out and what it does.
class TourStep {
  const TourStep({
    required this.target,
    required this.title,
    required this.body,
    this.reveal,
  });

  final GlobalKey target;
  final String title;
  final String body;

  /// Brings a target that isn't built yet (far down a lazy list) on screen.
  final Future<void> Function()? reveal;
}

bool _open = false;

/// Whether a tour is on screen. Only one runs at a time.
bool get isSpotlightTourOpen => _open;

/// Dims the app, cuts out each step's target in turn, and explains it.
///
/// Returns true when the user reaches Done, false on Skip or back, and null
/// when nothing was shown (another tour is open, or no target is on screen).
Future<bool?> showSpotlightTour(
  BuildContext context,
  List<TourStep> steps,
) async {
  if (_open) return null;
  final live = [
    for (final step in steps)
      if (step.target.currentContext != null || step.reveal != null) step,
  ];
  if (live.isEmpty) return null;
  _open = true;
  try {
    final done = await Navigator.of(context, rootNavigator: true).push<bool>(
      PageRouteBuilder<bool>(
        opaque: false,
        transitionDuration: const Duration(milliseconds: 250),
        reverseTransitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (_, _, _) => _SpotlightTour(steps: live),
        transitionsBuilder: (_, animation, _, child) => FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
          child: child,
        ),
      ),
    );
    return done ?? false;
  } finally {
    _open = false;
  }
}

class _SpotlightTour extends StatefulWidget {
  const _SpotlightTour({required this.steps});

  final List<TourStep> steps;

  @override
  State<_SpotlightTour> createState() => _SpotlightTourState();
}

class _SpotlightTourState extends State<_SpotlightTour>
    with TickerProviderStateMixin {
  static const _pad = 6.0;
  static const _edge = 8.0;
  static const _cardMaxWidth = 400.0;
  static const _cardRoom = 196.0;

  late final AnimationController _move = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 420),
  );
  late final AnimationController _ring = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 600),
  );
  late final Animation<double> _moveCurve = CurvedAnimation(
    parent: _move,
    curve: Curves.easeInOutCubic,
  );

  int _index = 0;
  Rect? _from;
  Rect? _to;
  bool _cardShown = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => unawaited(_goTo(0)));
  }

  @override
  void dispose() {
    _move.dispose();
    _ring.dispose();
    super.dispose();
  }

  Future<void> _goTo(int index) async {
    final reduce = MediaQuery.disableAnimationsOf(context);
    setState(() => _cardShown = false);
    final step = widget.steps[index];
    if (step.reveal case final reveal?) {
      await reveal();
      await WidgetsBinding.instance.endOfFrame;
      if (!mounted) return;
    }
    final target = step.target.currentContext;
    if (target == null) return _advance(index);
    if (target.mounted) {
      await Scrollable.ensureVisible(
        target,
        alignment: 0.35,
        duration: reduce ? Duration.zero : const Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
      );
    }
    if (!mounted) return;
    final rect = _measure(widget.steps[index].target);
    if (rect == null) return _advance(index);
    setState(() {
      _index = index;
      _from = _current ?? rect;
      _to = rect;
    });
    _move.duration = reduce ? Duration.zero : const Duration(milliseconds: 420);
    await _move.forward(from: 0);
    if (!mounted) return;
    setState(() => _cardShown = true);
    unawaited(_ring.forward(from: reduce ? 1 : 0));
  }

  Future<void> _advance(int skipped) async {
    if (skipped + 1 < widget.steps.length) return _goTo(skipped + 1);
    if (mounted) Navigator.of(context).pop(true);
  }

  Rect? _measure(GlobalKey key) {
    final box = key.currentContext?.findRenderObject();
    if (box is! RenderBox || !box.hasSize || !box.attached) return null;
    final overlay = context.findRenderObject();
    final origin = overlay is RenderBox
        ? box.localToGlobal(Offset.zero, ancestor: overlay)
        : box.localToGlobal(Offset.zero);
    final screen = (Offset.zero & MediaQuery.sizeOf(context)).deflate(_edge);
    final hole = (origin & box.size).inflate(_pad);
    // Horizontal lists run off the screen edge; keep the window inside it.
    return Rect.fromLTRB(
      math.max(hole.left, screen.left),
      hole.top,
      math.min(hole.right, screen.right),
      hole.bottom,
    );
  }

  Rect? get _current {
    final from = _from;
    final to = _to;
    if (from == null || to == null) return to;
    return Rect.lerp(from, to, _moveCurve.value);
  }

  void _next() {
    if (_index + 1 >= widget.steps.length) {
      Navigator.of(context).pop(true);
    } else {
      unawaited(_goTo(_index + 1));
    }
  }

  void _skip() => Navigator.of(context).pop(false);

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final scrim = dark ? const Color(0xB8000000) : const Color(0xB81C1410);
    return Material(
      type: MaterialType.transparency,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = constraints.biggest;
          return Stack(
            children: [
              Positioned.fill(
                child: ExcludeSemantics(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {},
                    child: AnimatedBuilder(
                      animation: Listenable.merge([_move, _ring]),
                      builder: (context, _) => CustomPaint(
                        painter: _SpotlightPainter(
                          hole: _current,
                          scrim: scrim,
                          ring: context.colors.primary,
                          ringStrength: Curves.easeOut.transform(_ring.value),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 240),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween(
                        begin: const Offset(0, 0.008),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  ),
                  child: _cardShown && _to != null
                      ? _placedCard(size, _to!)
                      : const SizedBox.expand(key: ValueKey('empty')),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _placedCard(Size size, Rect hole) {
    final width = math.min(size.width - AppSpacing.md * 2, _cardMaxWidth);
    final left = (size.width - width) / 2;
    final spaceBelow = size.height - hole.bottom;
    final below = spaceBelow >= hole.top;
    // A tall target leaves no room on either side: float the card over its
    // lower edge instead, without the pointer.
    final fits = math.max(spaceBelow, hole.top) >= _cardRoom;
    final nubX = (hole.center.dx - left).clamp(24.0, width - 24.0);
    final card = _TourCard(
      step: widget.steps[_index],
      index: _index,
      count: widget.steps.length,
      nubX: nubX,
      nubOnTop: below,
      showNub: fits,
      onNext: _next,
      onSkip: _skip,
    );
    final bottomInset = MediaQuery.paddingOf(context).bottom + AppSpacing.lg;
    return Stack(
      key: ValueKey(_index),
      children: [
        Positioned(
          left: left,
          width: width,
          top: fits && below ? hole.bottom + AppSpacing.sm : null,
          bottom: !fits
              ? bottomInset
              : below
              ? null
              : size.height - hole.top + AppSpacing.sm,
          child: card,
        ),
      ],
    );
  }
}

class _TourCard extends StatelessWidget {
  const _TourCard({
    required this.step,
    required this.index,
    required this.count,
    required this.nubX,
    required this.nubOnTop,
    required this.showNub,
    required this.onNext,
    required this.onSkip,
  });

  final TourStep step;
  final int index;
  final int count;
  final double nubX;
  final bool nubOnTop;
  final bool showNub;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final last = index == count - 1;
    // Lift the card off the dimmed app: brightest surface in light mode,
    // the raised one in dark mode, edged in the same rust as the ring.
    final dark = Theme.of(context).brightness == Brightness.dark;
    final surface = dark
        ? context.colors.surfaceContainerHighest
        : context.colors.surfaceContainerLowest;
    final nub = Padding(
      padding: EdgeInsets.only(left: nubX - 9),
      child: CustomPaint(
        size: const Size(18, 9),
        painter: _NubPainter(color: surface, pointsUp: nubOnTop),
      ),
    );
    return Semantics(
      liveRegion: true,
      container: true,
      label:
          '${l10n.guideStepOf(index + 1, count)}. ${step.title}. ${step.body}',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showNub && nubOnTop) nub,
          DecoratedBox(
            decoration: BoxDecoration(
              color: surface,
              borderRadius: AppRadii.largeAll,
              border: Border.all(
                color: context.colors.primary.withValues(alpha: 0.45),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x66000000),
                  blurRadius: 28,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // The card's own label already reads these once.
                  ExcludeSemantics(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.guideStepOf(index + 1, count),
                          style: context.textStyles.labelMedium?.copyWith(
                            color: context.colors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          step.title,
                          style: context.textStyles.titleLarge?.copyWith(
                            color: context.colors.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          step.body,
                          style: context.textStyles.bodyLarge?.copyWith(
                            color: context.colors.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  // Wide pills, like the app's own primary actions.
                  Row(
                    children: [
                      if (!last) ...[
                        Expanded(
                          child: OutlinedButton(
                            onPressed: onSkip,
                            child: Text(l10n.guideSkip),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                      ],
                      Expanded(
                        child: FilledButton(
                          onPressed: onNext,
                          child: Text(last ? l10n.guideDone : l10n.guideNext),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (showNub && !nubOnTop) nub,
        ],
      ),
    );
  }
}

class _SpotlightPainter extends CustomPainter {
  _SpotlightPainter({
    required this.hole,
    required this.scrim,
    required this.ring,
    required this.ringStrength,
  });

  final Rect? hole;
  final Color scrim;
  final Color ring;
  final double ringStrength;

  @override
  void paint(Canvas canvas, Size size) {
    final screen = Path()..addRect(Offset.zero & size);
    final hole = this.hole;
    if (hole == null) {
      canvas.drawPath(screen, Paint()..color = scrim);
      return;
    }
    final radius = math.min(20.0, hole.shortestSide / 2);
    final cut = RRect.fromRectAndRadius(hole, Radius.circular(radius));
    canvas.drawPath(
      Path.combine(PathOperation.difference, screen, Path()..addRRect(cut)),
      Paint()..color = scrim,
    );
    final strength = 0.4 + 0.6 * ringStrength;
    canvas
      ..drawRRect(
        cut,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 6
          ..color = ring.withValues(alpha: 0.35 * ringStrength)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
      )
      ..drawRRect(
        cut,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = ring.withValues(alpha: strength),
      );
  }

  @override
  bool shouldRepaint(_SpotlightPainter old) =>
      old.hole != hole ||
      old.ringStrength != ringStrength ||
      old.scrim != scrim ||
      old.ring != ring;
}

class _NubPainter extends CustomPainter {
  _NubPainter({required this.color, required this.pointsUp});

  final Color color;
  final bool pointsUp;

  @override
  void paint(Canvas canvas, Size size) {
    final path = pointsUp
        ? (Path()
            ..moveTo(0, size.height)
            ..lineTo(size.width / 2, 0)
            ..lineTo(size.width, size.height)
            ..close())
        : (Path()
            ..moveTo(0, 0)
            ..lineTo(size.width / 2, size.height)
            ..lineTo(size.width, 0)
            ..close());
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_NubPainter old) =>
      old.color != color || old.pointsUp != pointsUp;
}
