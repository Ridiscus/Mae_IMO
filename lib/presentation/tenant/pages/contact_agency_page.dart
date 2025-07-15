import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maelys_imo/core/extensions/text_style_ext.dart';
import 'package:maelys_imo/shared/widgets/custom_input_text.dart';

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
    return Scaffold(
      body: Column(
        children: [_buildHeader(), Expanded(child: _buildContactForm())],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8.r,
        left: 16.r,
        right: 16.r,
        bottom: 24.r,
      ),
      width: double.infinity,
      color: Color(0xFF0A2342),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.chevron_left, color: Colors.white, size: 30.r),
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
          ),
          SizedBox(height: 16.r),
          Text(
            'Contacter l\'agence',
            style:
                TextStyle(
                  fontSize: 28.r,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ).sourceSansProBold,
          ),
        ],
      ),
    );
  }

  Widget _buildContactForm() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAgencyInfo(),
              SizedBox(height: 32.r),
              _buildSubjectField(),
              SizedBox(height: 24.r),
              _buildMessageField(),
              Padding(
                padding: EdgeInsets.only(top: 48.r, bottom: 24.r),
                child: _buildSendButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAgencyInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nom de l\'agence',
          style:
              TextStyle(
                fontSize: 24.r,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ).sourceSansProBold,
        ),
        SizedBox(height: 8.r),
        Text(
          'Entrez les informations à transmettre a l\'agence',
          style:
              TextStyle(
                fontSize: 16.r,
                color: Colors.black87,
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
          'Objet',
          style:
              TextStyle(
                fontSize: 16.r,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ).sourceSansProSemiBold,
        ),
        SizedBox(height: 8.r),
        CustomInputTextFactory.createTextInput(
          controller: _subjectController,
          hintText: 'Objet du mail',
          validator: (value) {
            return null;
          },
        ),
        // TextFormField(
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
                fontSize: 16.r,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ).sourceSansProSemiBold,
        ),
        SizedBox(height: 8.r),
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
    return Container(
      width: double.infinity,
      height: 56.r,
      child: ElevatedButton(
        onPressed: () {
          // Handle sending email
          // Could show a success dialog and then pop back
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF0A2342),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Envoyer le mail',
              style:
                  TextStyle(
                    fontSize: 18.r,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ).sourceSansProBold,
            ),
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 16.r,
              child: Icon(
                Icons.arrow_forward,
                color: Color(0xFF0A2342),
                size: 20.r,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
