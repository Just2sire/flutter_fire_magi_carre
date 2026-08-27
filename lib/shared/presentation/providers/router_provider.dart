import "package:go_router/go_router.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../../core/routing/app_router.dart";

part "router_provider.g.dart";

@riverpod
GoRouter appRouter(Ref ref) {
  return buildRouter();
}
