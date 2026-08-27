abstract class Failure {
  const Failure({required this.message, this.cause});

  final String message;
  final Object? cause;

  @override
  String toString() => "$runtimeType: $message";
}
