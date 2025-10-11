import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:maelys_imo/core/constants/app_colors.dart';
import 'package:maelys_imo/core/constants/assets.dart';
import 'package:maelys_imo/core/domain/models/index.dart';
import 'package:maelys_imo/core/extensions/index.dart';
import 'package:maelys_imo/presentation/agent/pages/tenant_detail_page.dart';
import 'package:maelys_imo/shared/widgets/index.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/manager/state/tenant/tenant_bloc.dart';

enum TenantListType {
  upToDate('a-jour'),
  late('retard'),
  pendingPayment('en-attente');

  const TenantListType(this.value);

  final String value;
}

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
  void initState() {
    context.read<TenantBloc>().add(
      FetchTenantsByStatusEvent(status: widget.listType.value),
    );
    super.initState();
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
    final state = context.select((TenantBloc bloc) => bloc.state);
    final tenants = state.tenants ?? [];
    return RefreshIndicator.adaptive(
      onRefresh: () async {
        context.read<TenantBloc>().add(
          FetchTenantsByStatusEvent(status: widget.listType.value),
        );
      },
      child: Skeletonizer(
        enabled: state.isLoading ?? false,
        child: tenants.isEmpty
            ? SizedBox(
                height: context.getSize.height,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: context.getSize.height * 0.8,
                    child: EmptyStateWidget(
                      title: "Aucun locataire disponible",
                      icon: Icons.search_off,
                    ),
                  ),
                ),
              )
            : SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [

                    ...tenants
                        .map((tenant) => _buildTenantCard(tenant: tenant))
                        .expand((element) => [CustomSpacer(), element]),
                    SpacerPlatform(),
                  ],
                ),
              ),
      ),
    );
  }


  Widget _buildTenantCard({required TenantItemModel tenant}) {
    return GestureDetector(
      onTap: () {
        // Navigate to tenant detail page with dummy ID
        context.pushNamed(
          TenantDetailPage.routeName,
          pathParameters: {'id': '${tenant.id ?? 1}'},
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
                    tenant.fullName ?? "",
                    style:
                        TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ).sourceSansProSemiBold,
                  ),
                  CustomSpacer(space: .5),
                  Text(
                    tenant.email ?? "",
                    style:
                        TextStyle(
                          fontSize: 16.sp,
                          color: Colors.grey,
                        ).sourceSansProRegular,
                  ),
                  CustomSpacer(space: .2),
                  Text(
                    tenant.contact ?? "",
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
