import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maelys_imo/core/constants/app_colors.dart';
import 'package:maelys_imo/core/domain/models/index.dart';
import 'package:maelys_imo/core/domain/requests/index.dart';
import 'package:maelys_imo/core/extensions/index.dart';
import 'package:maelys_imo/core/manager/state/dashboard/dashboard_bloc.dart';
import 'package:maelys_imo/shared/widgets/index.dart';

import '../../../core/utils/toast/notification_toast.dart';

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
  TenantDashboardModel? _tenantDashboardModel;

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _tenantDashboardModel = context.select(
      (DashboardBloc bloc) => bloc.state.tenantDashboardModel,
    );

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
        SpacerPlatform(),
      ],
    );
  }

  Widget _buildAgencyInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _tenantDashboardModel?.locataire?.agency?.name ?? '',
          style:
              TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ).sourceSansProBold,
        ),
        SizedBox(height: 8.r),
        Text(
          _tenantDashboardModel?.locataire?.agency?.email ?? "",
          style:
              TextStyle(
                fontSize: 16.sp,
                color: AppColors.primary,
              ).sourceSansProRegular,
        ),
        SizedBox(height: 4.r),
        Text(
          _tenantDashboardModel?.locataire?.agency?.contact ?? "",
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
        ),
      ],
    );
  }

  Widget _buildSendButton() {
    return BlocConsumer<DashboardBloc, DashboardState>(
      listenWhen: (previous, current) => current.mailSent != null,
      listener: (context, state) {
        if (state.mailSent ?? false) {
          _clearState();
        }
      },
      buildWhen:
          (previous, current) =>
              current.mailSent != null || current.isLoading != null,
      builder: (context, state) {
        return CustomButton(
          text: 'Envoyer le mail',
          isLoading: state.isLoading ?? false,
          showArrow: true,
          onPressed: () {
            if (_subjectController.text.isEmpty) {
              showToast(msg: "Le sujet du mail est obligatoire ");
              return;
            }
            if (_messageController.text.isEmpty) {
              showToast(msg: "Le message est obligatoire");
              return;
            }

            if ((_tenantDashboardModel?.locataire?.agency?.email ?? '')
                .isEmpty) {
              showToast(msg: "Cette agence ne dispose pas d'email");
              return;
            }

            context.read<DashboardBloc>().add(
              ContactAgencyEvent(
                dto: ContactAgencyRequest(
                  message: _messageController.text,
                  subject: _subjectController.text,
                  agencyEmail:
                      _tenantDashboardModel!.locataire!.agency!.email ?? '',
                ),
              ),
            );
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
      },
    );
  }

  void _clearState() {
    _subjectController.clear();
    _messageController.clear();
    setState(() {});
  }
}
