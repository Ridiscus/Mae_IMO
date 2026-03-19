import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:maelys_imo/core/constants/app_colors.dart';
import 'package:maelys_imo/core/domain/models/index.dart';
import 'package:maelys_imo/shared/widgets/index.dart';
import 'package:maelys_imo/core/extensions/index.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maelys_imo/core/manager/state/dashboard/dashboard_bloc.dart';
import 'package:maelys_imo/core/api_manager/endpoints.dart';
import 'property_detail_page.dart';

class PropertiesListPage extends StatefulWidget {
  static const routeName = 'propertiesListCommercial';
  static const routePath = '/commercial/properties';

  const PropertiesListPage({super.key});

  @override
  State<PropertiesListPage> createState() => _PropertiesListPageState();
}

class _PropertiesListPageState extends State<PropertiesListPage> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardBloc>().add(const FetchCommercialPropertiesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return PageWithHeaderLayout(
      headerHeight: MediaQuery.of(context).size.height * .20,
      headerContent: Row(
        children: [
          const CircularBackButton(),
          SizedBox(width: 12.w),
          Text(
            'Biens Immobiliers',
            style:
                TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ).sourceSansProBold,
          ),
        ],
      ),
      bodyContent: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state.isLoading ?? false) {
            return const Center(child: CircularProgressIndicator());
          }

          final properties = state.properties ?? [];

          if (properties.isEmpty) {
            return const Center(
              child: Text(
                'Aucun bien trouvé !',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return Column(
            children:
                properties
                    .map(
                      (property) => Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: _buildPropertyCard(property),
                      ),
                    )
                    .toList(),
          );
        },
      ),
    );
  }

  Widget _buildPropertyCard(PropertyModel property) {
    final bool isAgency = property.owner?.gestion?.toLowerCase() == "agence";

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        onTap:
            () => context.pushNamed(
              PropertyDetailPage.routeName,
              extra: property,
            ),
        contentPadding: EdgeInsets.all(12.sp),
        leading: Container(
          width: 70.sp,
          height: 70.sp,
          decoration: BoxDecoration(
            color: (isAgency ? AppColors.primary : AppColors.orange).withValues(
              alpha: 0.1,
            ),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child:
                (property.mainImageUrl != null &&
                        property.mainImageUrl!.isNotEmpty)
                    ? Image.network(
                      Endpoints.storageUrl(property.mainImageUrl!),
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, _, __) => Icon(
                            Icons.home_work_rounded,
                            color:
                                isAgency ? AppColors.primary : AppColors.orange,
                            size: 30.sp,
                          ),
                    )
                    : Icon(
                      property.type == 'Villa'
                          ? Icons.home_rounded
                          : property.type == 'Appartement'
                          ? Icons.apartment_rounded
                          : Icons.bedroom_parent_rounded,
                      color: isAgency ? AppColors.primary : AppColors.orange,
                      size: 30.sp,
                    ),
          ),
        ),
        title: Text(
          property.title ?? 'Sans titre',
          style:
              TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ).sourceSansProBold,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4.h),
            Text(
              property.location ?? 'Lieu inconnu',
              style:
                  TextStyle(
                    fontSize: 13.sp,
                    color: Colors.grey[600],
                  ).sourceSansProRegular,
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: (isAgency ? AppColors.primary : AppColors.orange)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    isAgency ? 'AGENCE' : 'PROPRIO',
                    style:
                        TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                          color:
                              isAgency ? AppColors.primary : AppColors.orange,
                        ).sourceSansProBold,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    property.owner?.fullName ?? '---',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w500,
                        ).sourceSansProSemiBold,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              property.formattedPrice,
              style:
                  TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ).sourceSansProBold,
            ),
            Icon(Icons.chevron_right_rounded, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}
