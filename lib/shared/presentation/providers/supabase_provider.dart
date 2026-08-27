import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:supabase_flutter/supabase_flutter.dart";

part "supabase_provider.g.dart";

/// Expose le client Supabase en tant que singleton dans l'arbre de providers.
/// Toutes les datasources qui ont besoin d'accéder à Supabase passent
/// par ce provider.
@Riverpod(keepAlive: true)
SupabaseClient supabaseClient(Ref ref) {
  return Supabase.instance.client;
}
