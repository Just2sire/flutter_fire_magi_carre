import "package:riverpod_annotation/riverpod_annotation.dart";

import "../../data/services/network_info_impl.dart";
import "../../domain/network_info.dart";

part "network_info_provider.g.dart";

@Riverpod(keepAlive: true)
NetworkInfo networkInfo(Ref ref) => const NetworkInfoImpl();
