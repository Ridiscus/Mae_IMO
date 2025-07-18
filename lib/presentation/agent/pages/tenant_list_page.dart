import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
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
      content: _buildTenantList(),
    );
  }

  // Header est désormais géré par FormWithHeaderLayout

  Widget _buildTenantList() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 16.sp),
      itemCount: 5, // Demo count, replace with actual data
      itemBuilder: (context, index) {
        return _buildTenantCard(index);
      },
    );
  }

  Widget _buildTenantCard(int index) {
    return InkWell(
      onTap: () {
        // Navigate to tenant detail page with dummy ID
        context.goNamed(TenantDetailPage.routeName, pathParameters: {'id': '${index + 1}'});
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16.sp),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 80.w,
              height: 80.h,
              padding: EdgeInsets.all(10.sp),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  bottomLeft: Radius.circular(16.r),
                ),
              ),
              child: Center(
                child: Icon(Icons.person, size: 36.sp, color: Colors.black45),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 12.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nom du locataire',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ).sourceSansProSemiBold,
                    ),
                    SizedBox(height: 6.sp),
                    Text(
                      'email@locataire.com',
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: Colors.grey[500],
                      ).sourceSansProRegular,
                    ),
                    SizedBox(height: 4.sp),
                    Text(
                      '+225 0807676565',
                      style: TextStyle(
                        fontSize: 15.sp,
                        color: Colors.grey[500],
                      ).sourceSansProRegular,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
