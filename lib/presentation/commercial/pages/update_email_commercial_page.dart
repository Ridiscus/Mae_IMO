import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:maelys_imo/core/domain/requests/index.dart';
import 'package:maelys_imo/core/extensions/index.dart';
import 'package:maelys_imo/core/manager/state/auth/auth_bloc.dart';
import 'package:maelys_imo/shared/widgets/index.dart';
import 'package:maelys_imo/core/utils/toast/notification_toast.dart';

class UpdateEmailCommercialPage extends StatefulWidget {
  static const routeName = 'updateEmailCommercial';
  static const routePath = '/commercial/update-email';
  const UpdateEmailCommercialPage({super.key});
  @override
  State<UpdateEmailCommercialPage> createState() =>
      _UpdateEmailCommercialPageState();
}

class _UpdateEmailCommercialPageState extends State<UpdateEmailCommercialPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool showPassword = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormWithHeaderLayout(
      headerTitle: 'Modifier mon email',
      content: _buildEmailForm(),
    );
  }

  Widget _buildEmailForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildEmailField(),
        CustomSpacer(),
        _buildPasswordField(),
        const Spacer(),
        _buildSendButton(),
        const SpacerPlatform(),
      ],
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mon email',
          style:
              TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ).sourceSansProBold,
        ),
        SizedBox(height: 8.h),
        CustomInputTextFactory.createEmailInput(
          controller: _emailController,
          hintText: 'Indiquez votre nouvelle adresse email',
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mot de passe de confirmation',
          style:
              TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ).sourceSansProBold,
        ),
        SizedBox(height: 8.h),
        CustomInputTextFactory.createPasswordInput(
          controller: _passwordController,
          hintText: 'Entrez votre mot de passe',
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
      listenWhen: (previous, current) => current.updatedEmail != null,
      listener: (context, state) {
        if (state.updatedEmail ?? false) {
          _clearState();
        }
      },
      buildWhen:
          (previous, current) =>
              current.updatedEmail != null || current.isLoading,
      builder: (context, state) {
        return CustomButton(
          text: 'Modifier le mail',
          isLoading: state.isLoading,
          showArrow: true,
          onPressed: () {
            if (_emailController.text.isEmpty) {
              showToast(msg: "Le mail invalide ");
              return;
            }
            if (_passwordController.text.isEmpty) {
              showToast(msg: "Le mot de passe est incorrect");
              return;
            }

            context.read<AuthBloc>().add(
              UpdateEmailEvent(
                dto: UpdateEmailRequest(
                  password: _passwordController.text,
                  email: _emailController.text,
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
      _emailController.clear();
      _passwordController.clear();
    });

    context.pop();
  }
}
