import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rive/rive.dart' as rive;

import '../../../core/design_system/app_dimensions.dart';
import '../../../core/design_system/app_radii.dart';
import '../../../core/design_system/app_spacing.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../access/presentation/access_cubit.dart';
import '../../settings/presentation/settings_cubit.dart';
import '../../trackers/presentation/tracker_shield_cubit.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, this.beat});

  final int? beat;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  static const _story = Duration(milliseconds: 14000);
  static const _centers = [1.8, 5.1, 8.5, 12.0];

  late final AnimationController _clock;

  @override
  void initState() {
    super.initState();
    _clock = AnimationController(vsync: this, duration: _story);
    final beat = widget.beat;
    if (beat == null) {
      unawaited(_clock.repeat());
    } else {
      _clock.value = _centers[beat.clamp(0, 3)] / 14;
    }
  }

  @override
  void didUpdateWidget(OnboardingScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    final beat = widget.beat;
    if (beat != null && beat != oldWidget.beat) {
      _clock.value = _centers[beat.clamp(0, 3)] / 14;
    }
  }

  @override
  void dispose() {
    _clock.dispose();
    super.dispose();
  }

  /// Optional tap: jump to the start of the next beat and keep playing.
  void _next() {
    final next = (_beatAt(_clock.value * 14) + 1) % _beatStarts.length;
    _clock.value = _beatStarts[next] / 14;
    unawaited(_clock.repeat());
  }

  Future<void> _finish() => context.read<SettingsCubit>().completeOnboarding();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final lines = [
      l10n.onboardingBeatApps,
      l10n.onboardingBeatSensors,
      l10n.onboardingBeatTime,
      l10n.onboardingBeatShield,
    ];
    const windows = [(0.15, 3.5), (3.35, 6.9), (6.7, 10.3), (10.05, 13.85)];
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.lg,
          ),
          child: AnimatedBuilder(
            animation: _clock,
            builder: (context, _) {
              final seconds = _clock.value * 14;
              // Both actions belong to the last beat: see it, block it.
              final showActions = _lineOpacity(seconds, 10.05, 13.85) > 0.55;
              return Column(
                children: [
                  Row(
                    children: [
                      ExcludeSemantics(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: context.colors.primary,
                            borderRadius: AppRadii.mediumAll,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpacing.sm),
                            child: Icon(
                              Icons.shield_outlined,
                              size: 18,
                              color: context.colors.onPrimary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        l10n.appTitle,
                        style: context.textStyles.titleMedium,
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () => unawaited(_finish()),
                        child: Text(l10n.skip),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        const SizedBox(height: AppSpacing.lg),
                        // Every line keeps its layout, so the slot is as tall
                        // as the longest one and the picture never shifts
                        // while lines cross-fade.
                        Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            for (var i = 0; i < lines.length; i++)
                              _StaggeredLine(
                                line: lines[i],
                                seconds: seconds,
                                start: windows[i].$1,
                                end: windows[i].$2,
                              ),
                          ],
                        ),
                        Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: widget.beat == null ? _next : null,
                            child: _IntroStory(
                              clock: _clock,
                              enabled: widget.beat == null,
                              fallback: CustomPaint(
                                painter: _StoryPainter(
                                  seconds: seconds,
                                  ink: context.colors.onSurface,
                                  rust: context.colors.primary,
                                  paper: context.colors.surfaceContainerLowest,
                                  screen: context.colors.surfaceContainerHigh,
                                ),
                                child: const SizedBox.expand(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Space stays reserved so the picture never jumps.
                  IgnorePointer(
                    ignoring: !showActions,
                    child: AnimatedOpacity(
                      opacity: showActions ? 1 : 0,
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeOut,
                      child: const Column(
                        children: [_UsageAction(), _ShieldAction()],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    width: double.infinity,
                    height: AppDimensions.primaryButtonHeight,
                    child: FilledButton(
                      onPressed: () => unawaited(_finish()),
                      child: Text(l10n.onboardingFinish),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _StaggeredLine extends StatelessWidget {
  const _StaggeredLine({
    required this.line,
    required this.seconds,
    required this.start,
    required this.end,
  });

  final String line;
  final double seconds;
  final double start;
  final double end;

  @override
  Widget build(BuildContext context) {
    final fade = _lineOpacity(seconds, start, end);
    final visible = fade >= 0.04;
    final words = line.split(' ');
    final style = context.textStyles.headlineSmall;
    return ExcludeSemantics(
      excluding: !visible,
      child: Semantics(
        label: line,
        child: ExcludeSemantics(
          child: Opacity(
            opacity: visible ? fade : 0,
            child: Wrap(
              alignment: WrapAlignment.center,
              children: [
                for (var i = 0; i < words.length; i++)
                  _Word(
                    text: words[i],
                    appear: _out(
                      seconds,
                      start + i * 0.04,
                      start + i * 0.04 + 0.7,
                    ),
                    style: style,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Word extends StatelessWidget {
  const _Word({required this.text, required this.appear, required this.style});

  final String text;
  final double appear;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: appear,
      child: Transform.translate(
        offset: Offset(0, (1 - appear) * 8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: Text(text, style: style),
        ),
      ),
    );
  }
}

/// Plays the Rive story (assets/rive/onboarding.riv, sources in
/// tool/intro_rive) and keeps its `beat` view model property in step with
/// [clock]. Shows [fallback] in tests and if the file cannot load.
class _IntroStory extends StatefulWidget {
  const _IntroStory({
    required this.clock,
    required this.enabled,
    required this.fallback,
  });

  final AnimationController clock;
  final bool enabled;
  final Widget fallback;

  @override
  State<_IntroStory> createState() => _IntroStoryState();
}

class _IntroStoryState extends State<_IntroStory> {
  final _file = rive.FileLoader.fromAsset(
    'assets/rive/onboarding.riv',
    riveFactory: rive.Factory.rive,
  );
  rive.ViewModelInstanceNumber? _beat;

  @override
  void initState() {
    super.initState();
    widget.clock.addListener(_push);
  }

  @override
  void dispose() {
    widget.clock.removeListener(_push);
    _file.dispose();
    super.dispose();
  }

  void _push() {
    final beat = _beatAt(widget.clock.value * 14).toDouble();
    final property = _beat;
    if (property != null && property.value != beat) property.value = beat;
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.fallback;
    return ExcludeSemantics(
      child: rive.RiveWidgetBuilder(
        fileLoader: _file,
        dataBind: rive.DataBind.auto(),
        onLoaded: (state) {
          _beat = state.viewModelInstance?.number('beat');
          _push();
        },
        builder: (context, state) => switch (state) {
          rive.RiveLoading() => const SizedBox.expand(),
          rive.RiveFailed() => widget.fallback,
          rive.RiveLoaded() => rive.RiveWidget(controller: state.controller),
        },
      ),
    );
  }
}

/// Beat index (0-3) for a time on the 14 s story clock.
int _beatAt(double seconds) {
  for (var i = _beatStarts.length - 1; i > 0; i--) {
    if (seconds >= _beatStarts[i]) return i;
  }
  return 0;
}

const _beatStarts = [0.15, 3.35, 6.7, 10.05];

class _StoryPainter extends CustomPainter {
  const _StoryPainter({
    required this.seconds,
    required this.ink,
    required this.rust,
    required this.paper,
    required this.screen,
  });

  final double seconds;
  final Color ink;
  final Color rust;
  final Color paper;
  final Color screen;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width < 72 || size.height < 96) return;
    const margin = 12.0;
    final fittedWidth = math.min(size.width - margin * 2, 230.0);
    final fittedHeight = math.min(size.height - margin * 2, fittedWidth * 1.92);
    final phoneWidth = math.min(fittedWidth, fittedHeight / 1.92);
    final phoneHeight = phoneWidth * 1.92;
    final phoneRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height * 0.5),
      width: phoneWidth,
      height: phoneHeight,
    );
    final corner = Radius.circular(phoneWidth * 0.16);
    final phone = RRect.fromRectAndRadius(phoneRect, corner);
    final bezel = math.max(9.0, phoneWidth * 0.055);
    final glass = phone.deflate(bezel);
    final shieldCenter = Offset(phoneRect.right - 8, phoneRect.center.dy);

    final drawn = _out(seconds, 0.12, 0.95);
    final phoneFill = _out(seconds, 0.8, 1.35);
    canvas.drawOval(
      Rect.fromCenter(
        center: phoneRect.bottomCenter + const Offset(0, 10),
        width: phoneRect.width * 0.68,
        height: 16,
      ),
      Paint()..color = ink.withValues(alpha: 0.12 * drawn),
    );

    final outline = Path()..addRRect(phone);
    final outlineMetric = outline.computeMetrics().first;
    canvas.drawPath(
      outlineMetric.extractPath(0, outlineMetric.length * drawn),
      Paint()
        ..color = ink
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2
        ..strokeCap = StrokeCap.round,
    );
    if (phoneFill > 0) {
      canvas.drawRRect(
        phone,
        Paint()..color = ink.withValues(alpha: phoneFill),
      );
      canvas.drawRRect(
        phone,
        Paint()
          ..color = paper.withValues(alpha: 0.2 * phoneFill)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.2,
      );
      final speaker = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(phoneRect.center.dx, (phoneRect.top + glass.top) / 2),
          width: phoneRect.width * 0.18,
          height: 4,
        ),
        const Radius.circular(2),
      );
      canvas.drawRRect(
        speaker,
        Paint()..color = paper.withValues(alpha: 0.55 * phoneFill),
      );
    }

    if (glass.width < 24 || glass.height < 48 || phoneFill == 0) {
      _shield(canvas, shieldCenter);
      return;
    }

    final sweep = _unit(seconds, 6.9, 9.1);
    final sweepFade = seconds < 6.75
        ? 0.0
        : seconds > 9.45
        ? 1 - _unit(seconds, 9.45, 9.9)
        : 1.0;
    const bandH = 18.0;
    final bandTop = glass.top + (glass.height - bandH) * sweep;
    final scanY = bandTop + bandH / 2;

    canvas.save();
    canvas.clipRRect(glass);
    canvas.drawRect(
      glass.outerRect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            screen.withValues(alpha: phoneFill),
            Color.lerp(screen, ink, 0.16)!.withValues(alpha: phoneFill),
          ],
        ).createShader(glass.outerRect),
    );

    const columns = 3;
    const rows = 4;
    const gap = 8.0;
    final grid = Rect.fromLTRB(
      glass.left + 12,
      glass.top + 14,
      glass.right - 12,
      glass.bottom - 22,
    );
    final tile = math.min(
      (grid.width - gap * (columns - 1)) / columns,
      (grid.height - gap * (rows - 1)) / rows,
    );
    if (tile < 4) {
      canvas.restore();
      _shield(canvas, shieldCenter);
      return;
    }
    final gridWidth = tile * columns + gap * (columns - 1);
    final gridHeight = tile * rows + gap * (rows - 1);
    final origin = Offset(
      grid.center.dx - gridWidth / 2,
      grid.center.dy - gridHeight / 2,
    );
    final tiles = <RRect>[];
    for (var row = 0; row < rows; row++) {
      for (var column = 0; column < columns; column++) {
        tiles.add(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(
              origin.dx + column * (tile + gap),
              origin.dy + row * (tile + gap),
              tile,
              tile,
            ),
            Radius.circular(tile * 0.22),
          ),
        );
      }
    }

    const focusIndex = 4;
    for (var i = 0; i < tiles.length; i++) {
      final shown = _out(seconds, 1.02 + i * 0.045, 1.42 + i * 0.045);
      if (shown == 0) continue;
      final isFocus = i == focusIndex;
      final glow =
          sweepFade *
          (1 - ((tiles[i].center.dy - scanY).abs() / 28).clamp(0.0, 1.0));
      final base = isFocus ? rust : paper;
      final tint = Color.lerp(
        base,
        isFocus ? paper : rust,
        isFocus ? 0.28 * glow : 0.42 * glow,
      )!;
      canvas.drawRRect(
        tiles[i],
        Paint()..color = tint.withValues(alpha: shown * phoneFill),
      );
      _mark(
        canvas,
        tiles[i].outerRect,
        i,
        (isFocus ? paper : ink).withValues(alpha: 0.8 * shown * phoneFill),
      );
    }

    final focusTile = tiles[focusIndex];
    final found = _out(seconds, 1.75, 2.45);
    if (found > 0) {
      canvas.drawArc(
        Rect.fromCircle(
          center: focusTile.center,
          radius: focusTile.width / 2 + 4,
        ),
        -math.pi / 2,
        math.pi * 2 * found,
        false,
        Paint()
          ..color = rust
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.8
          ..strokeCap = StrokeCap.round,
      );
    }

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(phoneRect.center.dx, glass.bottom - 10),
          width: phoneRect.width * 0.28,
          height: 4,
        ),
        const Radius.circular(2),
      ),
      Paint()..color = ink.withValues(alpha: 0.35 * phoneFill),
    );

    if (sweepFade > 0) {
      final band = Rect.fromLTWH(glass.left, bandTop, glass.width, bandH);
      canvas.drawRect(
        band,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              rust.withValues(alpha: 0),
              rust.withValues(alpha: 0.24 * sweepFade),
              rust.withValues(alpha: 0),
            ],
          ).createShader(band),
      );
    }
    canvas.restore();

    _packets(canvas, size, focusTile.center, shieldCenter);
    _shield(canvas, shieldCenter);
  }

  void _packets(Canvas canvas, Size size, Offset start, Offset end) {
    final lift = math.min(26.0, math.max(0.0, start.dy - 8));
    final control = Offset(
      start.dx + (end.dx - start.dx) * 0.62,
      (start.dy - lift * 0.45).clamp(8.0, size.height - 8),
    );
    final lane = Path()
      ..moveTo(start.dx, start.dy)
      ..quadraticBezierTo(control.dx, control.dy, end.dx, end.dy);
    final metric = lane.computeMetrics().first;
    if (metric.length == 0) return;

    final leave = _unit(seconds, 3.5, 6.1);
    final arrive = _unit(seconds, 10.1, 12.2);
    final head = (leave * 0.42 + arrive * 0.58).clamp(0.0, 1.0);
    final spacing = 0.11 * (1 - arrive);
    for (var i = 0; i < 3; i++) {
      final born = _out(seconds, 3.15 + i * 0.12, 3.55 + i * 0.12);
      if (born == 0) continue;
      final alpha = born * (1 - arrive);
      if (alpha == 0) continue;
      final t = (head - i * spacing).clamp(0.0, 0.999);
      for (var step = 4; step >= 1; step--) {
        final back = t - step * 0.035;
        if (back <= 0) continue;
        final trail = metric.getTangentForOffset(metric.length * back);
        if (trail == null) continue;
        canvas.drawCircle(
          trail.position,
          2.1,
          Paint()
            ..color = rust.withValues(alpha: alpha * (1 - step / 5) * 0.65),
        );
      }
      final tangent = metric.getTangentForOffset(metric.length * t);
      if (tangent == null) continue;
      canvas.save();
      canvas.translate(tangent.position.dx, tangent.position.dy);
      canvas.rotate(tangent.angle);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTWH(-6, -2.4, 12, 4.8),
          const Radius.circular(2.4),
        ),
        Paint()..color = rust.withValues(alpha: alpha),
      );
      canvas.restore();
    }
  }

  void _shield(Canvas canvas, Offset center) {
    final shieldStroke = _out(seconds, 9.55, 10.45);
    final shieldFill = _out(seconds, 10.35, 11.2);
    if (shieldStroke == 0) return;
    final shieldPath = Path()
      ..moveTo(center.dx, center.dy - 22)
      ..lineTo(center.dx + 16, center.dy - 6)
      ..quadraticBezierTo(
        center.dx + 13,
        center.dy + 16,
        center.dx,
        center.dy + 24,
      )
      ..quadraticBezierTo(
        center.dx - 13,
        center.dy + 16,
        center.dx - 16,
        center.dy - 6,
      )
      ..close();
    final shieldMetric = shieldPath.computeMetrics().first;
    if (shieldFill > 0) {
      canvas.drawCircle(
        center + const Offset(0, 10),
        14,
        Paint()..color = ink.withValues(alpha: 0.12 * shieldFill),
      );
      canvas.drawPath(
        shieldPath,
        Paint()..color = rust.withValues(alpha: 0.94 * shieldFill),
      );
    }
    canvas.drawPath(
      shieldMetric.extractPath(0, shieldMetric.length * shieldStroke),
      Paint()
        ..color = rust
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round,
    );
    final check = _out(seconds, 11.15, 11.9);
    if (check == 0 || shieldFill == 0) return;
    final checkPath = Path()
      ..moveTo(center.dx - 7, center.dy + 1)
      ..lineTo(center.dx - 2, center.dy + 6)
      ..lineTo(center.dx + 8, center.dy - 6);
    final checkMetric = checkPath.computeMetrics().first;
    canvas.drawPath(
      checkMetric.extractPath(0, checkMetric.length * check),
      Paint()
        ..color = paper
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  void _mark(Canvas canvas, Rect rect, int index, Color color) {
    final center = rect.center;
    final arm = rect.shortestSide * 0.2;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.35
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    switch (index % 4) {
      case 0:
        canvas.drawCircle(center, arm, paint);
      case 1:
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(center: center, width: arm * 2, height: arm * 2),
            const Radius.circular(2),
          ),
          paint,
        );
      case 2:
        canvas.drawPath(
          Path()
            ..moveTo(center.dx, center.dy - arm)
            ..lineTo(center.dx + arm, center.dy + arm * 0.75)
            ..lineTo(center.dx - arm, center.dy + arm * 0.75)
            ..close(),
          paint,
        );
      default:
        canvas.drawPath(
          Path()
            ..moveTo(center.dx, center.dy - arm)
            ..lineTo(center.dx + arm, center.dy)
            ..lineTo(center.dx, center.dy + arm)
            ..lineTo(center.dx - arm, center.dy)
            ..close(),
          paint,
        );
    }
  }

  @override
  bool shouldRepaint(covariant _StoryPainter oldDelegate) =>
      oldDelegate.seconds != seconds ||
      oldDelegate.ink != ink ||
      oldDelegate.rust != rust ||
      oldDelegate.paper != paper ||
      oldDelegate.screen != screen;
}

class _UsageAction extends StatelessWidget {
  const _UsageAction();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<AccessCubit, AccessState>(
      builder: (context, state) {
        final ready = state is AccessReady ? state.status : null;
        final granted = ready?.hasUsageAccess ?? false;
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton.tonal(
              onPressed: granted
                  ? null
                  : () => unawaited(
                      context.read<AccessCubit>().openUsageAccessSettings(),
                    ),
              child: Text(
                granted
                    ? l10n.onboardingUsageGranted
                    : l10n.onboardingGrantUsage,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ShieldAction extends StatelessWidget {
  const _ShieldAction();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: SizedBox(
        width: double.infinity,
        child: FilledButton.tonal(
          onPressed: () =>
              unawaited(context.read<TrackerShieldCubit>().start()),
          child: Text(context.l10n.onboardingStartShield),
        ),
      ),
    );
  }
}

double _out(double seconds, double start, double end) {
  if (seconds <= start) return 0;
  if (seconds >= end) return 1;
  return Curves.easeOutCubic.transform((seconds - start) / (end - start));
}

double _unit(double seconds, double start, double end) {
  if (seconds <= start) return 0;
  if (seconds >= end) return 1;
  return Curves.easeInOutCubic.transform((seconds - start) / (end - start));
}

double _lineOpacity(double seconds, double start, double end) {
  const fade = 0.4;
  final inn = _unit(seconds, start, start + fade);
  final out = 1 - _unit(seconds, end - fade, end);
  return (inn * out).clamp(0, 1);
}
