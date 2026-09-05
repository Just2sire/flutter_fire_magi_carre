import "package:hive_flutter/hive_flutter.dart";

/// Cache local générique (Hive) — persiste des listes ou objets JSON avec un
/// horodatage, pour servir de repli en mode hors-ligne. Aucun `TypeAdapter`
/// nécessaire : seuls des types primitifs (Map/List/String/int/bool) sont
/// stockés, ce que Hive encode nativement.
class LocalCacheService {
  const LocalCacheService(this._box);

  final Box<dynamic> _box;

  static const String boxName = "app_cache";

  /// À appeler une fois avant `runApp`.
  static Future<Box<dynamic>> init() async {
    await Hive.initFlutter();
    return Hive.openBox<dynamic>(boxName);
  }

  Future<void> saveList(String key, List<Map<String, dynamic>> items) {
    return _box.put(key, {
      "cachedAt": DateTime.now().toIso8601String(),
      "items": items,
    });
  }

  CachedList? readList(String key) {
    final raw = _box.get(key);
    if (raw == null) return null;
    final map = Map<String, dynamic>.from(raw as Map);
    final items = [
      for (final item in map["items"] as List)
        Map<String, dynamic>.from(item as Map),
    ];
    return CachedList(
      items: items,
      cachedAt: DateTime.parse(map["cachedAt"] as String),
    );
  }

  Future<void> saveObject(String key, Map<String, dynamic> item) {
    return _box.put(key, {
      "cachedAt": DateTime.now().toIso8601String(),
      "item": item,
    });
  }

  CachedObject? readObject(String key) {
    final raw = _box.get(key);
    if (raw == null) return null;
    final map = Map<String, dynamic>.from(raw as Map);
    return CachedObject(
      item: Map<String, dynamic>.from(map["item"] as Map),
      cachedAt: DateTime.parse(map["cachedAt"] as String),
    );
  }
}

/// Liste mise en cache, avec l'horodatage de sa dernière écriture.
class CachedList {
  const CachedList({required this.items, required this.cachedAt});

  final List<Map<String, dynamic>> items;
  final DateTime cachedAt;
}

/// Objet mis en cache, avec l'horodatage de sa dernière écriture.
class CachedObject {
  const CachedObject({required this.item, required this.cachedAt});

  final Map<String, dynamic> item;
  final DateTime cachedAt;
}
