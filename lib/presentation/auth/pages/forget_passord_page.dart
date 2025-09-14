import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:maelys_imo/core/domain/requests/index.dart';
import 'package:maelys_imo/core/extensions/index.dart';
import 'package:maelys_imo/core/manager/state/reset-password/reset_password_bloc.dart';
import 'package:maelys_imo/presentation/auth/pages/reset_passord_page.dart';
import 'package:maelys_imo/shared/widgets/index.dart';

import '../../../core/utils/toast/notification_toast.dart';
import '../../../di_container.dart';

class ForgetPasswordPage extends StatefulWidget {
  static const routeName = 'forgetPassword';
  static const routePath = '/forget-password';

  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final TextEditingController _codeIdController = TextEditingController(text: kDebugMode ? "": "MA935006");

  @override
  void dispose() {
    _codeIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ResetPasswordBloc>(),
      child: FormWithHeaderLayout(
        headerTitle: 'Réinitialiser le mot de passe',
        content: _buildResetForm(),
      ),
    );
  }

  Widget _buildResetForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mot de passe oublié',
          style:
              TextStyle(
                fontSize: 24.r,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ).sourceSansProBold,
        ),
        SizedBox(height: 8.r),
        Text(
          'Renseignez votre email pour la réinitialisation',
          style:
              TextStyle(
                fontSize: 14.r,
                color: Colors.grey[700],
              ).sourceSansProRegular,
        ),
        SizedBox(height: 32.r),
        _buildInputField(
          label: 'Identifiant',
          controller: _codeIdController,
          hintText: 'Entrez votre identifiant de connexion',
        ),
        Spacer(),
        _buildSendLinkButton(),
        SizedBox(height: 24.r),
      ],
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String hintText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style:
              TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ).sourceSansProSemiBold,
        ),
        SizedBox(height: 8.h),
        CustomInputTextFactory.createTextInput(
          controller: controller,
          hintText: hintText,
        ),
      ],
    );
  }

  Widget _buildSendLinkButton() {
    return BlocConsumer<ResetPasswordBloc, ResetPasswordState>(
      listenWhen: (previous, current) => current.emailSent != null,
      listener: (context, state) {
        if (state.emailSent == true) {
          // Retourner à la page précédente après succès
          context.pop();
        }
      },
      buildWhen: (previous, current) => 
          current.emailSent != null || current.isLoading != previous.isLoading,
      builder: (context, state) {
        return CustomButton(
          text: 'Envoyer le lien',
          isLoading: state.isLoading,
          showArrow: true,
          onPressed: () {
            if (_codeIdController.text.isEmpty) {
              showToast(msg: 'Veuillez entrer votre identifiant');
              return;
            }

            // Déclencher l'événement de réinitialisation de mot de passe
            context.read<ResetPasswordBloc>().add(
              ForgotPasswordEvent(
                dto: ForgotPasswordRequest(codeId: _codeIdController.text),
              ),
            );
          },
          buttonVariant: ButtonVariant.primary,
          textStyle:
              TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ).sourceSansProBold,
        );
      },
    );
  }
}
