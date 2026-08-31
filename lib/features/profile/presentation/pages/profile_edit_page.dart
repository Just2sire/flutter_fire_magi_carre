import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:image_picker/image_picker.dart";

import "../../../../core/constants/app_icons.dart";
import "../../../../core/extensions/failure_extensions.dart";
import "../../../../core/extensions/index.dart"
    show BuildContextExtensions, NavigationExtensions;
import "../../../../core/theme/app_spacing.dart";
import "../../../../shared/presentation/widgets/index.dart"
    show AppScaffold, AppTopbar, AppTextFormField, AppElevatedButton;
import "../../../auth/domain/entities/auth_state.dart";
import "../../../auth/presentation/providers/auth_providers.dart";
import "../widgets/profile_avatar.dart";

class ProfileEditPage extends ConsumerStatefulWidget {
  const ProfileEditPage({super.key});

  @override
  ConsumerState<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends ConsumerState<ProfileEditPage> {
  late GlobalKey<FormState> _formKey;
  late TextEditingController _usernameController;
  late TextEditingController _bioController;
  bool _isLoading = false;
  String? _pendingAvatarUrl;

  @override
  void initState() {
    super.initState();
    final state = ref.read(authProvider);
    final profile = state is AuthAuthenticated ? state.profile : null;

    _formKey = GlobalKey<FormState>();
    _usernameController = TextEditingController(text: profile?.username);
    _bioController = TextEditingController(text: profile?.bio);
    _pendingAvatarUrl = profile?.avatarUrl;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AppScaffold(
      scrollable: true,
      body: Column(
        children: [
          AppTopbar(title: l10n.profileEditTitle),
          AppSpacing.gapVXl,
          Center(
            child: GestureDetector(
              onTap: _isLoading ? null : _pickAvatar,
              child: Stack(
                children: [
                  ProfileAvatar(avatarUrl: _pendingAvatarUrl),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: context.colorScheme.primary,
                      child: Icon(
                        AppIcons.camera,
                        size: 18,
                        color: context.colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          AppSpacing.gapVXxl,
          Form(
            key: _formKey,
            child: Column(
              children: [
                AppTextFormField(
                  isRequired: true,
                  labelText: l10n.profileEditUsernameLabel,
                  keyboardType: .name,
                  textInputAction: .next,
                  prefixIconData: AppIcons.user,
                  controller: _usernameController,
                  validatorFunction: (value) {
                    final input = value ?? "";
                    if (input.length < 3) {
                      return l10n.validationUsernameTooShort(3);
                    } else if (input.length > 20) {
                      return l10n.validationUsernameTooLong(20);
                    }
                    return null;
                  },
                ),
                AppSpacing.gapVLg,
                AppTextFormField(
                  labelText: l10n.profileEditBioLabel,
                  textInputAction: .done,
                  maxLines: 4,
                  controller: _bioController,
                ),
              ],
            ),
          ),
          AppSpacing.gapVXxl,
          AppElevatedButton(
            text: l10n.commonSave,
            isLoading: _isLoading,
            onPressed: _save,
          ),
        ],
      ),
    );
  }

  Future<void> _pickAvatar() async {
    final file = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 1024,
    );
    if (file == null || !mounted) return;

    setState(() => _isLoading = true);
    final bytes = await file.readAsBytes();
    final extension = file.path.split(".").last.toLowerCase();
    final result = await ref
        .read(authProvider.notifier)
        .uploadAvatar(bytes, extension);
    if (mounted) setState(() => _isLoading = false);
    if (!mounted) return;

    result.fold(
      (error) => context.showError(context.localizeFailure(error)),
      (profile) => setState(() => _pendingAvatarUrl = profile.avatarUrl),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final state = ref.read(authProvider);
    final currentProfile = state is AuthAuthenticated ? state.profile : null;
    if (currentProfile == null) return;

    final newUsername = _usernameController.text.trim();
    final newBio = _bioController.text.trim();

    setState(() => _isLoading = true);
    final notifier = ref.read(authProvider.notifier);

    if (newUsername != currentProfile.username) {
      final result = await notifier.updateUsername(newUsername);
      if (!mounted) return;
      final failed = result.fold((error) {
        context.showError(context.localizeFailure(error));
        return true;
      }, (_) => false);
      if (failed) {
        setState(() => _isLoading = false);
        return;
      }
    }

    if (newBio != (currentProfile.bio ?? "")) {
      final result = await notifier.updateBio(newBio);
      if (!mounted) return;
      final failed = result.fold((error) {
        context.showError(context.localizeFailure(error));
        return true;
      }, (_) => false);
      if (failed) {
        setState(() => _isLoading = false);
        return;
      }
    }

    if (mounted) setState(() => _isLoading = false);
    if (!mounted) return;
    context.showSuccess(context.l10n.profileUpdateSuccess);
    context.popScreen();
  }
}
