/// Chemins d'assets MagiCarré.
///
/// Les fichiers ne sont pas encore présents — chaque constante attend qu'un
/// asset réel soit déposé dans `assets/images/` et déclaré dans `pubspec.yaml`.
class AppAssets {
  AppAssets._();

  static const String _imagesBase = "assets/images";

  static const String logo = "$_imagesBase/logo_light.jpg";
  static const String logoLight = "$_imagesBase/logo_light.jpg";
  static const String logoNotif = "$_imagesBase/logo_notif.jpg";
  static const String logoDark = "$_imagesBase/logo_dark.jpg";

  // ------------- ONBOARDING -------------
  static const String onboarding1 = "$_imagesBase/onboarding_1.jpg";
  static const String onboarding2 = "$_imagesBase/onboarding_2.jpg";
  static const String onboarding3 = "$_imagesBase/onboarding_3.jpg";

  // // ------------- AUTH -------------
  // static const String googleLogo = "$_imagesBase/google.png";
  // static const String login = "$_imagesBase/login.png";
  // static const String register = "$_imagesBase/register.png";
  // static const String forgotPassword = "$_imagesBase/forgot_password.png";
  // static const String resetPassword = "$_imagesBase/reset_password.png";
}
