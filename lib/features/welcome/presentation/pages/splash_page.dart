import "dart:math" as math;

import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "../../../../core/constants/app_assets.dart";
import "../../../../core/extensions/navigation_extensions.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../../shared/presentation/widgets/layouts/app_scaffold.dart";

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;

  late AnimationController _exitController;
  late Animation<double> _exitOpacityAnimation;
  late Animation<double> _exitScaleAnimation;

  var _completedLoops = 0;
  final _maxLoops = 3;
  final _animationCurve = Curves.easeInOut;

  @override
  void initState() {
    super.initState();

    // Waiting animations
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 4.0 * math.pi,
    ).animate(CurvedAnimation(parent: _controller, curve: _animationCurve));

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 1.2,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 50.0, // Première moitié de la durée
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.2,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 50.0, // Seconde moitié de la durée
      ),
    ]).animate(CurvedAnimation(parent: _controller, curve: _animationCurve));

    // Exit animations
    _exitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _exitOpacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _exitController, curve: _animationCurve));

    _exitScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 10.0,
    ).animate(CurvedAnimation(parent: _exitController, curve: _animationCurve));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _completedLoops++;
        if (_completedLoops < _maxLoops) {
          _controller.forward(from: 0.0); // Relance le cycle
        } else {
          // 🚀 Les 3 tours sont finis, on lance la sortie !
          _exitController.forward();
        }
      }
    });

    _exitController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Hydrate le contexte persisté, puis route selon l'état onboarding
        // et l'état d'authentification :
        // - Onboarding non complété → onboarding.
        // - Onboarding complété + session → /home.
        // - Onboarding complété + pas de session → /auth/login.

        // if (!mounted) return;
        // final storage = ref.read(storageServiceProvider);
        // await ref.read(userContextTypeProvider.notifier).loadFromStorage();
        // if (!mounted) return;
        // final onboardingDone =
        //     await storage.readBool(StorageKey.onboardingCompleted) ?? false;
        // if (!mounted) return;
        //
        // if (onboardingDone) {
        //   final supabase = ref.read(supabaseClientProvider);
        //   final user = supabase.auth.currentSession?.user;
        //   if (user != null) {
        //     context.go(AppRoutes.home);
        //   } else {
        //     context.go(AppRoutes.authLogin);
        //   }
        // } else {
        //   context.goOnboarding();
        // }
        if (!mounted) return;
        context.goOnboarding();
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _exitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      canPop: false,
      body: Center(
        child: AnimatedBuilder(
          animation: Listenable.merge([_controller, _exitController]),
          builder: (context, child) {
            return Opacity(
              opacity: _exitOpacityAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value * _exitScaleAnimation.value,
                child: Transform.rotate(
                  angle: _rotationAnimation.value,
                  child: child,
                ),
              ),
            );
          },
          child: Card(
            elevation: AppSpacing.elevationLg,
            shape: const RoundedRectangleBorder(
              borderRadius: AppSpacing.roundedLg,
            ),
            child: ClipRRect(
              borderRadius: AppSpacing.roundedLg,
              child: Image.asset(
                AppAssets.logo,
                height: AppSpacing.exa * 1.25,
                width: AppSpacing.exa * 1.25,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
