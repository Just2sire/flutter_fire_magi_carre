import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";

import "../../../../core/constants/app_assets.dart";
import "../../../../core/extensions/build_context_extensions.dart";
import "../../../../core/theme/app_spacing.dart";
import "../../../../shared/presentation/widgets/layouts/app_scaffold.dart";

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    // Hydrate le contexte OCR persisté, puis route selon l'état onboarding
    // et l'état d'authentification :
    // - Onboarding non complété → onboarding.
    // - Onboarding complété + session → /home.
    // - Onboarding complété + pas de session → /auth/login.
    Future.delayed(const Duration(seconds: 2), () async {
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
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Center(
        child: SlideTransition(
          position:
              Tween<Offset>(
                begin: const Offset(0, -0.075),
                end: const Offset(0, 0.075),
              ).animate(
                CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
              ),
          child: Card(
            elevation: AppSpacing.elevationSm,
            shape: const RoundedRectangleBorder(
              borderRadius: AppSpacing.roundedXxl,
            ),
            child: Container(
              height: AppSpacing.exa * 1.25,
              width: AppSpacing.exa * 1.25,
              decoration: BoxDecoration(
                color: context.colorScheme.primary,
                borderRadius: AppSpacing.roundedXxl,
              ),
              child: Image.asset(AppAssets.logo),
            ),
          ),
        ),
      ),
    );
  }
}
