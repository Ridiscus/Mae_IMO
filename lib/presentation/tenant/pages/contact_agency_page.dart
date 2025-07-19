import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maelys_imo/core/constants/app_colors.dart';
import 'package:maelys_imo/core/extensions/index.dart';
import 'package:maelys_imo/shared/widgets/index.dart';

class ContactAgencyPage extends StatefulWidget {
  static const routeName = 'contactAgency';
  static const routePath = '/contact-agency';

  const ContactAgencyPage({super.key});

  @override
  State<ContactAgencyPage> createState() => _ContactAgencyPageState();
}

class _ContactAgencyPageState extends State<ContactAgencyPage> {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormWithHeaderLayout(
      headerTitle: 'Contacter l\'agence',
      content: _buildContactForm(),
    );
  }

  Widget _buildContactForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAgencyInfo(),
        CustomSpacer(space: 2),
        _buildSubjectField(),
        CustomSpacer(),
        _buildMessageField(),
        Spacer(),
        _buildSendButton(),
        SpacerPlatform()
      ],
    );
  }

  Widget _buildAgencyInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Maelys Immobilier',
          style:
              TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ).sourceSansProBold,
        ),
        SizedBox(height: 8.r),
        Text(
          'contact@maelys-immobilier.fr',
          style:
              TextStyle(
                fontSize: 16.sp,
                color: AppColors.primary,
              ).sourceSansProRegular,
        ),
        SizedBox(height: 4.r),
        Text(
          '+33 6 12 34 56 78',
          style:
              TextStyle(
                fontSize: 16.sp,
                color: Colors.black54,
              ).sourceSansProRegular,
        ),
      ],
    );
  }

  Widget _buildSubjectField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sujet',
          style:
              TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ).sourceSansProBold,
        ),
        SizedBox(height: 8.h),
        CustomInputTextFactory.createTextInput(
          controller: _subjectController,
          hintText: 'Indiquez le sujet de votre message',
          validator: (value) {
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildMessageField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Message',
          style:
              TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ).sourceSansProBold,
        ),
        SizedBox(height: 8.h),
        CustomInputTextFactory.createTextAreaInput(
          controller: _messageController,
          hintText: 'Entrez votre message',
          validator: (value) {
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSendButton() {
    return CustomButton(
      text: 'Envoyer le mail',
      showArrow: true,
      onPressed: () {
        // Handle sending email
        // Could show a success dialog and then pop back
      },
      buttonVariant: ButtonVariant.primary,
      iconData: Icons.send,
      textStyle:
          TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ).sourceSansProBold,
    );
  }
}
