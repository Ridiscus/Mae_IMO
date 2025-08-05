import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:maelys_imo/core/constants/app_colors.dart';
import 'package:maelys_imo/core/constants/assets.dart';
import 'package:maelys_imo/core/extensions/index.dart';
import 'package:maelys_imo/shared/widgets/index.dart';

class DocumentsTenantPage extends StatefulWidget {
  static const routeName = 'documentsTenant';
  static const routePath = '/documents-tenant';

  const DocumentsTenantPage({super.key});

  @override
  State<DocumentsTenantPage> createState() => _DocumentsTenantPageState();
}

class _DocumentsTenantPageState extends State<DocumentsTenantPage> {
  @override
  Widget build(BuildContext context) {
    return PageWithHeaderLayout(
      headerContent: _buildHeaderContent(),
      bodyContent: _buildContent(),
    );
  }

  Widget _buildHeaderContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // CircularBackButton(), // Retiré comme demandé
        CustomSpacer(),
        Text(
          'Mes documents',
          style:
              TextStyle(
                fontSize: 32.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ).sourceSansProBold,
        ),
      ],
    );
  }

  Widget _buildContent() {
    final documentsItems = [
      {'label': 'Contrat de bail'},
      {'label': "Etat des lieux d'entrée"},
      {'label': "Etat des lieux de sortie"},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...documentsItems
            .map((payment) {
              return _buildDocumentItem(label: payment['label'] as String);
            })
            .expand((element) => [element, CustomSpacer(space: .5)]),
      ],
    );
  }

  Widget _buildDocumentItem({required String label}) {
    return GestureDetector(
      onTap: () => {},
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: AppColors.borderColor),
        ),
        padding: EdgeInsets.all(16.r),
        child: Row(
          children: [
            Container(
              width: 48.r,
              height: 48.r,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(Icons.picture_as_pdf_outlined, color: Colors.grey[600]),
            ),
            SizedBox(width: 16.r),
            Expanded(
              child: Text(
                label,
                style:
                TextStyle(
                  fontSize: 16.r,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ).sourceSansProSemiBold,
              ),
            ),
            SvgPicture.asset(
              Assets.cloudDownload,
              colorFilter: ColorFilter.mode(
                AppColors.black,
                BlendMode.srcIn,
              ),
            )
          ],
        ),
      ),
    );
  }

}
