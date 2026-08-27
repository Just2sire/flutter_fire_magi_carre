import "package:flutter/material.dart";
import "package:flutter/services.dart" show SystemUiOverlayStyle;
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../../../core/constants/app_assets.dart";
import "../../../../core/constants/app_icons.dart";
import "../../../../core/constants/notification_channels.dart";
import "../../../../core/extensions/build_context_extensions.dart";
import "../../../../core/extensions/navigation_extensions.dart";
import "../../../../core/theme/app_colors.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../../l10n/app_localizations.dart";
import "../../../../shared/domain/entities/storage_key.dart";
import "../../../../shared/presentation/providers/index.dart"
    show storageServiceProvider, notificationServiceProvider;
import "../../../../shared/presentation/widgets/index.dart"
    show AppScaffold, AppElevatedButton;

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  late final PageController _pageViewController;
  var _current = 0;

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController(initialPage: _current);
  }

  int get _length => 3;

  bool get _isLast => _current == _length - 1;

  Future<void> _finish() async {
    await ref
        .read(storageServiceProvider)
        .writeBool(StorageKey.onboardingCompleted, true);
    if (!mounted) return;
    final l10n = context.l10n;
    await ref
        .read(notificationServiceProvider)
        .show(
          id: NotificationId.welcome,
          title: l10n.onboardingNotificationTitle(l10n.appName),
          body: l10n.onboardingNotificationBody,
        );
    if (mounted) context.goAuthLogin();
  }

  void _next() {
    if (_isLast) {
      _finish();
    } else {
      _pageViewController.nextPage(
        duration: AppSpacing.durationBase,
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tt = context.textTheme;
    final l10n = context.l10n;
    final pages = _getOnboardingItems(l10n); // Récupération propre
    return AppScaffold(
      padding: .zero,
      overlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
      color: AppColors.ink,
      body: Stack(
        children: [
          // Arrière-plan avec fondu enchaîné (Cross-fade)
          ...List.generate(_length, (index) {
            final isActive = index == _current;
            return AnimatedOpacity(
              duration: AppSpacing.durationSlow,
              opacity: isActive ? 1.0 : 0.0,
              curve: Curves.easeInOut,
              child: Image.asset(
                pages[index].image,
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
                gaplessPlayback: true,
                color: AppColors.ink.withAlpha(150),
                colorBlendMode: BlendMode.darken,
              ),
            );
          }),

          Column(
            children: [
              _Header(
                tt: tt,
                l10n: l10n,
                current: _current,
                length: _length,
                isLast: _isLast,
                finish: _finish,
              ),
              Expanded(
                child: PageView.builder(
                  onPageChanged: (value) => setState(() => _current = value),
                  controller: _pageViewController,
                  itemCount: _length,
                  itemBuilder: (_, i) {
                    final (:title, :description, :image) = pages[i];
                    return _OnboardingItemView(
                      title: title,
                      tt: tt,
                      description: description,
                    );
                  },
                ),
              ),
              Tooltip(
                message: _isLast ? l10n.onboardingGetStarted : l10n.commonNext,
                child: AppElevatedButton(
                  onPressed: _next,
                  text: _isLast ? l10n.onboardingGetStarted : l10n.commonNext,
                  margin: AppSpacing.insetVMd,
                  icon: const Icon(
                    AppIcons.arrowRightBold,
                    size: AppSpacing.iconLg,
                  ),
                  iconAlignment: IconAlignment.end,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const new({
    required this.tt,
    required this.l10n,
    required this._current,
    required this._length,
    required this._isLast,
    required this._finish,
  });

  final AppLocalizations l10n;
  final int _current;
  final int _length;
  final bool _isLast;
  final VoidCallback _finish;
  final TextTheme tt;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Tooltip(
            message: l10n.onboardingProgressLabel(_current, _length),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(_length, (i) {
                final isActive = i == _current;
                return AnimatedContainer(
                  duration: AppSpacing.durationBase,
                  curve: AppSpacing.curveDefault,
                  width: isActive ? AppSpacing.xl : AppSpacing.sm + 2,
                  height: AppSpacing.sm + 2,
                  margin: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xs / 2,
                  ),
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.textInverse
                        : AppColors.textInverse.withAlpha(100),
                    borderRadius: AppSpacing.roundedFull,
                  ),
                );
              }),
            ),
          ),
          AnimatedOpacity(
            opacity: _isLast ? 0.0 : 1.0,
            duration: AppSpacing.durationBase,
            curve: AppSpacing.curveDefault,
            child: IgnorePointer(
              ignoring: _isLast,
              child: Tooltip(
                message: l10n.onboardingSkip,
                child: TextButton(
                  onPressed: _finish,
                  child: Text(
                    l10n.onboardingSkip,
                    style: tt.titleSmall!.copyWith(
                      color: AppColors.textInverse,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingItemView extends StatelessWidget {
  const new({required this.title, required this.tt, required this.description});

  final String title;
  final TextTheme tt;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.insetMd,
      child: Column(
        spacing: AppSpacing.md,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: context.screenWidth * .8,
            child: Text(
              title,
              style: tt.headlineSmall!.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textInverse,
              ),
            ),
          ),
          Text(
            description,
            style: tt.bodyMedium!.copyWith(
              color: AppColors.textInverse.withAlpha(200),
            ),
          ),
        ],
      ),
    );
  }
}

List<OnboardingItem> _getOnboardingItems(AppLocalizations l10n) {
  return [
    (
      title: l10n.onboardingTitle1,
      description: l10n.onboardingDescription1,
      image: AppAssets.onboarding1,
    ),
    (
      title: l10n.onboardingTitle2,
      description: l10n.onboardingDescription2,
      image: AppAssets.onboarding2,
    ),
    (
      title: l10n.onboardingTitle3,
      description: l10n.onboardingDescription3,
      image: AppAssets.onboarding3,
    ),
  ];
}

typedef OnboardingItem = ({String title, String description, String image});
