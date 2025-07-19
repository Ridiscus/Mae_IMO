import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:maelys_imo/core/constants/app_colors.dart';
import 'package:maelys_imo/core/constants/assets.dart';
import 'package:maelys_imo/core/extensions/index.dart';
import 'package:maelys_imo/presentation/agent/pages/tenant_detail_page.dart';
import 'package:maelys_imo/shared/widgets/index.dart';

enum TenantListType { upToDate, late, pendingPayment }

class TenantListPage extends StatefulWidget {
  static const routeName = 'tenantList';
  static const routePath = '/tenant-list/:type';

  final TenantListType listType;

  const TenantListPage({super.key, required this.listType});

  @override
  State<TenantListPage> createState() => _TenantListPageState();
}

class _TenantListPageState extends State<TenantListPage> {
  String _getPageTitle() {
    switch (widget.listType) {
      case TenantListType.upToDate:
        return 'Les locataires à jour';
      case TenantListType.late:
        return 'Les locataires en retard';
      case TenantListType.pendingPayment:
        return 'Les paiements en attente';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormWithHeaderLayout(
      headerTitle: _getPageTitle(),
      padding: EdgeInsets.symmetric(horizontal: 16.sp),
      content: _buildTenantList(),
    );
  }

  // Header est désormais géré par FormWithHeaderLayout

  Widget _buildTenantList() {
    return Column(
      children: [
        ...List.generate(
          5,
          (index) => _buildTenantCard(index),
        ).expand((element) => [CustomSpacer(), element]),
        SpacerPlatform(),
      ],
    );
  }

  Widget _buildTenantCard(int index) {
    return GestureDetector(
      onTap: () {
        // Navigate to tenant detail page with dummy ID
        context.pushNamed(
          TenantDetailPage.routeName,
          pathParameters: {'id': '${index + 1}'},
        );
      },
      child: Container(
        padding: EdgeInsets.all(16.sp),
        decoration: BoxDecoration(
          color: Color.fromRGBO(2, 36, 91, 0.06),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: Color.fromRGBO(2, 36, 91, 0.25)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 90.r,
              height: 90.r,
              padding: EdgeInsets.all(8.sp),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,

                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Center(
                child: SvgPicture.asset(
                  Assets.user,
                  width: 40.r,
                  height: 40.r,
                  colorFilter: ColorFilter.mode(
                    AppColors.black,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            CustomSpacer(isVertical: false),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nom du locataire',
                    style:
                        TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ).sourceSansProSemiBold,
                  ),
                  CustomSpacer(space: .5),
                  Text(
                    'email@locataire.com',
                    style:
                        TextStyle(
                          fontSize: 16.sp,
                          color: Colors.grey,
                        ).sourceSansProRegular,
                  ),
                  CustomSpacer(space: .2),
                  Text(
                    '+225 0807676565',
                    style:
                        TextStyle(
                          fontSize: 16.sp,
                          color: Colors.grey,
                        ).sourceSansProRegular,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
