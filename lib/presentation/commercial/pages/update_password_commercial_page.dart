import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:maelys_imo/core/domain/requests/index.dart';
import 'package:maelys_imo/core/extensions/index.dart';
import 'package:maelys_imo/core/manager/state/auth/auth_bloc.dart';
import 'package:maelys_imo/shared/widgets/index.dart';
import 'package:maelys_imo/core/utils/toast/notification_toast.dart';

class UpdatePasswordCommercialPage extends StatefulWidget {
  static const routeName = 'updatePasswordCommercial';
  static const routePath = '/commercial/update-password';
  const UpdatePasswordCommercialPage({super.key});
  @override
  State<UpdatePasswordCommercialPage> createState() =>
      _UpdatePasswordCommercialPageState();
}

class _UpdatePasswordCommercialPageState
    extends State<UpdatePasswordCommercialPage> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool showPassword = false;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _currentPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormWithHeaderLayout(
      headerTitle: 'Modifier mon mot de passe',
      content: _buildPasswordForm(),
    );
  }

  Widget _buildPasswordForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCurrentPasswordField(),
        CustomSpacer(),
        _buildNewPasswordField(),
        CustomSpacer(),
        _buildConfirmPasswordField(),
        const Spacer(),
        _buildSendButton(),
        const SpacerPlatform(),
      ],
    );
  }

  Widget _buildCurrentPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mot de passe actuel',
          style:
              TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ).sourceSansProBold,
        ),
        SizedBox(height: 8.h),
        CustomInputTextFactory.createPasswordInput(
          controller: _currentPasswordController,
          hintText: 'Indiquez votre mot de passe actuel',
          showPassword: showPassword,
          onTogglePasswordVisibility: () {
            setState(() {
              showPassword = !showPassword;
            });
          },
        ),
      ],
    );
  }

  Widget _buildNewPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nouveau mot de passe',
          style:
              TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ).sourceSansProBold,
        ),
        SizedBox(height: 8.h),
        CustomInputTextFactory.createPasswordInput(
          controller: _newPasswordController,
          hintText: 'Indiquez votre nouveau mot de passe',
          showPassword: showPassword,
          onTogglePasswordVisibility: () {
            setState(() {
              showPassword = !showPassword;
            });
          },
        ),
      ],
    );
  }

  Widget _buildConfirmPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Confirmer le mot de passe',
          style:
              TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ).sourceSansProBold,
        ),
        SizedBox(height: 8.h),
        CustomInputTextFactory.createPasswordInput(
          controller: _confirmPasswordController,
          hintText: 'Indiquez votre nouveau mot de passe',
          showPassword: showPassword,
          onTogglePasswordVisibility: () {
            setState(() {
              showPassword = !showPassword;
            });
          },
        ),
      ],
    );
  }

  Widget _buildSendButton() {
    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (previous, current) => current.updatedPassword != null,
      listener: (context, state) {
        if (state.updatedPassword ?? false) {
          _clearState();
        }
      },
      buildWhen:
          (previous, current) =>
              current.updatedPassword != null || current.isLoading,
      builder: (context, state) {
        return CustomButton(
          text: 'Modifier mon mot de passe',
          isLoading: state.isLoading,
          showArrow: true,
          onPressed: () {
            if (_currentPasswordController.text.isEmpty) {
              showToast(msg: "Le mot de passe actuel est invalide ");
              return;
            }
            if (_newPasswordController.text.isEmpty) {
              showToast(msg: "Le nouveau mot de passe est obligatoire ");
              return;
            }
            if (_confirmPasswordController.text.isEmpty ||
                _confirmPasswordController.text !=
                    _newPasswordController.text) {
              showToast(msg: "Les deux mot de passe ne correspondent pas ");
              return;
            }

            context.read<AuthBloc>().add(
              UpdatePasswordEvent(
                dto: UpdatePasswordRequest(
                  password: _currentPasswordController.text,
                  newPassword: _newPasswordController.text,
                ),
              ),
            );
          },
          buttonVariant: ButtonVariant.primary,
          iconData: Icons.edit,
          textStyle:
              TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ).sourceSansProBold,
        );
      },
    );
  }

  void _clearState() {
    setState(() {
      _newPasswordController.clear();
      _currentPasswordController.clear();
      _confirmPasswordController.clear();
    });
    context.pop();
  }
}
