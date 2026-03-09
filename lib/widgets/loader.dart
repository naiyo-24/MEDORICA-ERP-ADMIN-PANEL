import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class MedoricaLoader extends StatefulWidget {
  const MedoricaLoader({
    super.key,
    this.title = 'Loading Data',
    this.subtitle = 'Fetching the latest information from server',
    this.compact = false,
  });

  final String title;
  final String subtitle;
  final bool compact;

  @override
  State<MedoricaLoader> createState() => _MedoricaLoaderState();
}

class _MedoricaLoaderState extends State<MedoricaLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final logoSize = widget.compact ? 58.0 : 78.0;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final t = _controller.value;
        final pulse = 1 + (math.sin(t * math.pi * 2) * 0.05);
        final shimmerX = (t * 180) - 90;

        return Center(
          child: Container(
            width: widget.compact ? 300 : 380,
            padding: EdgeInsets.symmetric(
              horizontal: widget.compact ? AppSpacing.md : AppSpacing.lg,
              vertical: widget.compact ? AppSpacing.md : AppSpacing.lg,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.xl),
              gradient: const LinearGradient(
                colors: [Color(0xFFFDFDFD), Color(0xFFF4F6F7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(color: AppColors.border),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.shadowColor,
                  blurRadius: 24,
                  offset: Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: logoSize + 26,
                  height: logoSize + 26,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Transform.rotate(
                        angle: t * math.pi * 2,
                        child: Container(
                          width: logoSize + 24,
                          height: logoSize + 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.2),
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      Transform.scale(
                        scale: pulse,
                        child: Container(
                          width: logoSize,
                          height: logoSize,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            border: Border.all(color: AppColors.border),
                            boxShadow: const [
                              BoxShadow(
                                color: AppColors.shadowColor,
                                blurRadius: 12,
                                offset: Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Image.asset(
                            'assets/logo/logo.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontSize: widget.compact ? 22 : 24,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  widget.subtitle,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.quaternary,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Stack(
                    children: [
                      Container(
                        width: 180,
                        height: 6,
                        color: AppColors.primaryLight,
                      ),
                      Transform.translate(
                        offset: Offset(shimmerX, 0),
                        child: Container(
                          width: 90,
                          height: 6,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                AppColors.primary,
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
