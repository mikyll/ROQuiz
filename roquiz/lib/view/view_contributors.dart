import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roquiz/model/persistence/contributor_info.dart';
import 'package:roquiz/model/persistence/contributors_repository.dart';
import 'package:roquiz/model/persistence/settings.dart';
import 'package:roquiz/model/utils/navigation.dart';
import 'package:roquiz/widget/constrained_appbar.dart';
import 'package:roquiz/widget/custom_back_button.dart';

/// Shows the project contributors (loaded from `assets/contributors.yaml`) as
/// floating bubbles. Hovering a bubble (desktop/web) or tapping it (mobile)
/// reveals that person's contributions.
class ViewContributors extends StatefulWidget {
  const ViewContributors({super.key});

  @override
  State<ViewContributors> createState() => _ViewContributorsState();
}

class _ViewContributorsState extends State<ViewContributors> {
  late final Future<List<ContributorInfo>> _future;

  @override
  void initState() {
    super.initState();
    _future = ContributorsRepository.load();
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<Settings>(context);

    return Scaffold(
      appBar: ConstrainedAppBar(
        maxWidth: 500.0,
        title: const Text("Contributors"),
        leading: CustomBackButton(),
      ),
      body: SafeArea(
        child: FutureBuilder<List<ContributorInfo>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(
                child: Text("Impossibile caricare i contributors."),
              );
            }
            final contributors = snapshot.data ?? const <ContributorInfo>[];
            if (contributors.isEmpty) {
              return const Center(child: Text("Nessun contributor."));
            }
            return _FloatingBubbles(
              contributors: contributors,
              animate: settings.animations,
            );
          },
        ),
      ),
    );
  }
}

class _FloatingBubbles extends StatefulWidget {
  final List<ContributorInfo> contributors;
  final bool animate;

  const _FloatingBubbles({required this.contributors, required this.animate});

  @override
  State<_FloatingBubbles> createState() => _FloatingBubblesState();
}

class _FloatingBubblesState extends State<_FloatingBubbles>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  /// Index of the contributor whose detail card is currently shown.
  int? _activeIndex;

  /// Per-bubble time offset (in controller units). Each bubble's drift is
  /// computed from `controller.value - offset[i]`. When a bubble is frozen and
  /// later released we bump its offset so it resumes exactly where it was,
  /// instead of jumping to wherever the global clock has advanced to.
  late List<double> _timeOffsets;

  /// Effective time the active bubble is frozen at (so it stays under the
  /// pointer while hovered).
  double _frozenT = 0;

  /// Pending dismiss, deferred so the pointer can travel from a bubble to the
  /// detail card without the card vanishing mid-move.
  Timer? _clearTimer;

  void _ensureOffsets(int count) {
    if (_timeOffsets.length != count) {
      _timeOffsets = List<double>.filled(count, 0.0);
    }
  }

  void _setActive(int i) {
    _clearTimer?.cancel();
    setState(() {
      // Hand off: bank the currently-active bubble's position before freezing
      // the new one, so the old one doesn't teleport when it resumes.
      if (_activeIndex != null && _activeIndex != i) {
        _timeOffsets[_activeIndex!] = _controller.value - _frozenT;
      }
      _activeIndex = i;
      _frozenT = _controller.value - _timeOffsets[i];
    });
  }

  void _clearActive() {
    _clearTimer?.cancel();
    if (_activeIndex == null) return;
    setState(() {
      // Resume exactly from the frozen position.
      _timeOffsets[_activeIndex!] = _controller.value - _frozenT;
      _activeIndex = null;
    });
  }

  void _scheduleClear() {
    _clearTimer?.cancel();
    _clearTimer = Timer(const Duration(milliseconds: 200), _clearActive);
  }

  void _cancelClear() => _clearTimer?.cancel();

  static const List<Color> _palette = [
    Color(0xFF5C6BC0),
    Color(0xFF26A69A),
    Color(0xFFEF5350),
    Color(0xFFAB47BC),
    Color(0xFF42A5F5),
    Color(0xFF66BB6A),
    Color(0xFFFFA726),
    Color(0xFFEC407A),
    Color(0xFF8D6E63),
  ];

  @override
  void initState() {
    super.initState();
    _timeOffsets = List<double>.filled(widget.contributors.length, 0.0);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
    );
    if (widget.animate) _controller.repeat();
  }

  @override
  void didUpdateWidget(_FloatingBubbles oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.animate && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _clearTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Color _colorFor(int index) => _palette[index % _palette.length];

  /// Bubble radius scales with the contributor's weight. GitHub contribution
  /// counts are heavily skewed (one person with hundreds, the rest with a
  /// handful), so we scale by `sqrt` relative to the busiest contributor to
  /// keep the smaller bubbles from all collapsing to the minimum size.
  double _radiusFor(ContributorInfo c, int maxWeight) {
    if (maxWeight <= 0) return 36.0;
    final double frac = math.sqrt(c.weight) / math.sqrt(maxWeight);
    return (30.0 + 26.0 * frac).clamp(30.0, 56.0);
  }

  @override
  Widget build(BuildContext context) {
    final contributors = widget.contributors;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double w = constraints.maxWidth;
        final double h = constraints.maxHeight;

        // Lay the bubbles out on a relaxed grid so they don't overlap, with a
        // small deterministic jitter to avoid a rigid look.
        final int count = contributors.length;
        _ensureOffsets(count);
        final int cols = math.max(1, math.sqrt(count).ceil());
        final int rows = (count / cols).ceil();
        final double cellW = w / cols;
        final double cellH = h / rows;
        final int maxWeight = contributors
            .map((c) => c.weight)
            .fold(1, (a, b) => b > a ? b : a);
        final radii = contributors
            .map((c) => _radiusFor(c, maxWeight))
            .toList();
        final rnd = math.Random(42);

        final List<Offset> bases = List.generate(count, (i) {
          final int col = i % cols;
          final int row = i ~/ cols;
          final double r = radii[i];
          // Keep the bubble (plus drift slack) fully inside its cell.
          final double slackX = math.max(0, cellW / 2 - r - 14);
          final double slackY = math.max(0, cellH / 2 - r - 14);
          final double cx =
              cellW * col + cellW / 2 + (rnd.nextDouble() * 2 - 1) * slackX;
          final double cy =
              cellH * row + cellH / 2 + (rnd.nextDouble() * 2 - 1) * slackY;
          return Offset(cx, cy);
        });

        return GestureDetector(
          // Tap on empty space dismisses the detail card.
          behavior: HitTestBehavior.opaque,
          onTap: _clearActive,
          child: Stack(
            children: [
              AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  final double t = _controller.value;
                  return Stack(
                    children: List.generate(count, (i) {
                      final double r = radii[i];
                      final bool active = _activeIndex == i;
                      // Gentle elliptical drift. The active bubble is frozen at
                      // its current position (_frozenT); each bubble carries a
                      // time offset so it resumes from where it was frozen
                      // instead of jumping to the global clock position.
                      final double phase = i / count;
                      final double effectiveT = active
                          ? _frozenT
                          : t - _timeOffsets[i];
                      final double angle = 2 * math.pi * (effectiveT + phase);
                      final Offset drift = widget.animate
                          ? Offset(12 * math.sin(angle), 10 * math.cos(angle))
                          : Offset.zero;
                      final Offset pos = bases[i] + drift;

                      return Positioned(
                        left: pos.dx - r,
                        top: pos.dy - r,
                        width: r * 2,
                        height: r * 2,
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          onEnter: (_) => _setActive(i),
                          onExit: (_) {
                            if (_activeIndex == i) _scheduleClear();
                          },
                          child: GestureDetector(
                            onTap: () =>
                                active ? _clearActive() : _setActive(i),
                            child: _Bubble(
                              contributor: contributors[i],
                              radius: r,
                              color: _colorFor(i),
                              active: active,
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                },
              ),
              _DetailCard(
                contributor: _activeIndex == null
                    ? null
                    : contributors[_activeIndex!],
                onHoverEnter: _cancelClear,
                onHoverExit: _scheduleClear,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Bubble extends StatelessWidget {
  final ContributorInfo contributor;
  final double radius;
  final Color color;
  final bool active;

  const _Bubble({
    required this.contributor,
    required this.radius,
    required this.color,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    final Widget initials = Center(
      child: Text(
        contributor.initials,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: radius * 0.6,
        ),
      ),
    );

    // Prefer a bundled asset, then a remote avatar URL, then the initials.
    final Widget content;
    if (contributor.imagePath != null) {
      content = Image.asset(
        contributor.imagePath!,
        fit: BoxFit.cover,
        width: radius * 2,
        height: radius * 2,
        errorBuilder: (context, error, stackTrace) => initials,
      );
    } else if (contributor.imageUrl != null) {
      content = Image.network(
        contributor.imageUrl!,
        fit: BoxFit.cover,
        width: radius * 2,
        height: radius * 2,
        errorBuilder: (context, error, stackTrace) => initials,
      );
    } else {
      content = initials;
    }

    return AnimatedScale(
      scale: active ? 1.12 : 1.0,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: active
              ? Border.all(color: Colors.white, width: 3)
              : Border.all(color: Colors.white24, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: active ? 0.35 : 0.20),
              blurRadius: active ? 14 : 7,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipOval(child: content),
      ),
    );
  }
}

/// Bottom card that reveals the active contributor's name, contributions and
/// profile link. Animates in/out as the selection changes.
class _DetailCard extends StatelessWidget {
  final ContributorInfo? contributor;

  /// Keep the selection alive while the pointer is over the card, so the card
  /// stays clickable when the pointer travels onto it from a bubble.
  final VoidCallback onHoverEnter;
  final VoidCallback onHoverExit;

  const _DetailCard({
    required this.contributor,
    required this.onHoverEnter,
    required this.onHoverExit,
  });

  /// Human-readable summary lines: the GitHub contribution/co-author counts
  /// followed by any hand-written contribution descriptions. Falls back to a
  /// placeholder when there is nothing to show.
  List<String> _buildContributionLines(ContributorInfo c) {
    final List<String> lines = [];
    if (c.contributionCount > 0) {
      lines.add(
        "${c.contributionCount} "
        "${c.contributionCount == 1 ? 'contributo' : 'contributi'}",
      );
    }
    if (c.coAuthored > 0) {
      lines.add("Co-autore di ${c.coAuthored} commit");
    }
    lines.addAll(c.contributions);
    if (lines.isEmpty) lines.add("Nessuna contribuzione indicata.");
    return lines;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = contributor;

    return Positioned(
      left: 12,
      right: 12,
      bottom: 12,
      child: MouseRegion(
        onEnter: (_) => onHoverEnter(),
        onExit: (_) => onHoverExit(),
        // Absorb taps so clicking the card doesn't fall through to the
        // background dismiss handler.
        child: GestureDetector(
          onTap: () {},
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: SizeTransition(sizeFactor: animation, child: child),
            ),
            child: c == null
                ? const SizedBox.shrink()
                : Card(
                    key: ValueKey(c.name),
                    elevation: 6,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(c.name, style: theme.textTheme.titleLarge),
                          const SizedBox(height: 8),
                          ..._buildContributionLines(c).map(
                            (line) => Padding(
                              padding: const EdgeInsets.only(bottom: 2.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("•  "),
                                  Expanded(
                                    child: Text(
                                      line,
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (c.url != null) ...[
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton.icon(
                                onPressed: () => openUrl(c.url!),
                                icon: const Icon(Icons.open_in_new, size: 18),
                                label: const Text("Apri profilo"),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
