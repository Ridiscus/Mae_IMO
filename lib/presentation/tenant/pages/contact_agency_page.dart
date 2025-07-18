import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAgencyInfo(),
          CustomSpacer(space: 2),
          _buildSubjectField(),
          CustomSpacer(),
          _buildMessageField(),
          SizedBox(height: 48.r),
          _buildSendButton(),
          SizedBox(height: 24.r),
        ],
      ),
    );
  }

  Widget _buildAgencyInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Maelys Immobilier',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ).sourceSansProBold,
        ),
        SizedBox(height: 8.r),
        Text(
          'contact@maelys-immobilier.fr',
          style: TextStyle(
            fontSize: 16.sp,
            color: Color(0xFF0A2342),
          ).sourceSansProRegular,
        ),
        SizedBox(height: 4.r),
        Text(
          '+33 6 12 34 56 78',
          style: TextStyle(
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
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ).sourceSansProBold,
        ),
        SizedBox(height: 8.r),
        Container(
          height: 56.r,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            color: Color(0xFFF5F5F5),
          ),
          child: TextField(
            controller: _subjectController,
            decoration: InputDecoration(
              hintText: 'Indiquez le sujet de votre message',
              hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: 14.sp,
              ).sourceSansProRegular,
              contentPadding: EdgeInsets.symmetric(horizontal: 16.r),
              border: InputBorder.none,
            ),
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.black,
            ).sourceSansProRegular,
          ),
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
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ).sourceSansProBold,
        ),
        SizedBox(height: 8.r),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            color: Color(0xFFF5F5F5),
          ),
          child: TextField(
            controller: _messageController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Entrez votre message',
              hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: 14.sp,
              ).sourceSansProRegular,
              contentPadding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 12.r),
              border: InputBorder.none,
            ),
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.black,
            ).sourceSansProRegular,
          ),
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
      textStyle: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ).sourceSansProBold,
    );
  }
}
