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
/// reveals the contributions that person made.
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
    _controller.dispose();
    super.dispose();
  }

  Color _colorFor(int index) => _palette[index % _palette.length];

  /// Bubble radius scales with the number of contributions.
  double _radiusFor(ContributorInfo c) {
    return (30.0 + 7.0 * c.contributions.length).clamp(30.0, 56.0);
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
        final int cols = math.max(1, math.sqrt(count).ceil());
        final int rows = (count / cols).ceil();
        final double cellW = w / cols;
        final double cellH = h / rows;
        final radii = contributors.map(_radiusFor).toList();
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
          onTap: () => setState(() => _activeIndex = null),
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
                      // Gentle elliptical drift; the active bubble is frozen so
                      // it stays put under the cursor/finger.
                      final double phase = i / count;
                      final double angle = 2 * math.pi * (t + phase);
                      final Offset drift = (widget.animate && !active)
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
                          onEnter: (_) => setState(() => _activeIndex = i),
                          onExit: (_) => setState(() {
                            if (_activeIndex == i) _activeIndex = null;
                          }),
                          child: GestureDetector(
                            onTap: () => setState(
                              () => _activeIndex = active ? null : i,
                            ),
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

    final Widget content = contributor.imagePath == null
        ? initials
        : Image.asset(
            contributor.imagePath!,
            fit: BoxFit.cover,
            width: radius * 2,
            height: radius * 2,
            // Fall back to the initials if the asset is missing.
            errorBuilder: (context, error, stackTrace) => initials,
          );

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

  const _DetailCard({required this.contributor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = contributor;

    return Positioned(
      left: 12,
      right: 12,
      bottom: 12,
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
                      if (c.contributions.isEmpty)
                        Text(
                          "Nessuna contribuzione indicata.",
                          style: theme.textTheme.bodyMedium,
                        )
                      else
                        ...c.contributions.map(
                          (contribution) => Padding(
                            padding: const EdgeInsets.only(bottom: 2.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("•  "),
                                Expanded(
                                  child: Text(
                                    contribution,
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
    );
  }
}
