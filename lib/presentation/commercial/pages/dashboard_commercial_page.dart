import 'dart:async';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maelys_imo/core/constants/app_colors.dart';
import 'package:maelys_imo/core/constants/assets.dart';
import 'package:maelys_imo/core/extensions/index.dart';
import 'package:maelys_imo/core/manager/state/auth/auth_bloc.dart';
import 'package:maelys_imo/shared/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maelys_imo/core/domain/models/index.dart';
import 'agencies_list_page.dart';
import 'owners_list_page.dart';
import 'properties_list_page.dart';
import 'create_agency_page.dart';
import 'create_owner_page.dart';
import 'activities_list_page.dart';
import 'activity_detail_page.dart';
import 'profile_commercial_page.dart';
import 'create_agency_property_page.dart';
import 'create_owner_property_page.dart';
import '../../../core/manager/state/dashboard/dashboard_bloc.dart';

class DashboardCommercialPage extends StatefulWidget {
  static const routeName = 'dashboardCommercial';
  static const routePath = '/dashboard-commercial';
  const DashboardCommercialPage({super.key});
  @override
  State<DashboardCommercialPage> createState() =>
      _DashboardCommercialPageState();
}

class _DashboardCommercialPageState extends State<DashboardCommercialPage> {
  Timer? _timer;
  String _currentTime = "";
  String _currentDate = "";

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('fr_FR', null);
    _updateTime();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) => _updateTime(),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardBloc>().add(FetchCommercialDashboardEvent());
    });
  }

  void _updateTime() {
    final now = DateTime.now();
    final timeFormat = DateFormat('HH:mm:ss', 'fr_FR');
    final dateFormat = DateFormat('EEEE d MMMM y', 'fr_FR');
    final formattedTime = timeFormat.format(now);
    final formattedDate = dateFormat.format(now);
    if (mounted) {
      setState(() {
        _currentTime = formattedTime;
        _currentDate =
            formattedDate[0].toUpperCase() + formattedDate.substring(1);
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthBloc bloc) => bloc.state.userModel);
    final commercial = context.select(
      (DashboardBloc bloc) => bloc.state.commercialDashboardModel?.commercial,
    );
    final displayName = commercial?.fullName ?? user?.fullName ?? "Commercial";
    final codeId = commercial?.codeId ?? user?.codeId ?? "---";

    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: AppColors.primary,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _buildHeader(displayName, codeId),
            ),
            Positioned.fill(
              top: (MediaQuery.of(context).size.height * .24).sp,
              child: _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String name, String id) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.sp),
      width: double.infinity,
      height: (MediaQuery.of(context).size.height * .28).sp,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
      ),
      child: Stack(
        children: [
          IllustrationHeader(
            color: Colors.white,
            primaryAlpha: 0.1,
            secondaryAlpha: 0.05,
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.badge_outlined,
                            color: Colors.white,
                            size: 20.sp,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            id,
                            style:
                                TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ).sourceSansProBold,
                          ),
                        ],
                      ),
                    ),
                    CircularIcon(
                      iconAsset: Assets.user,
                      onPressed: () {
                        context.pushNamed(ProfileCommercialPage.routeName);
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Text(
                  'Bonjour, $name',
                  style:
                      TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ).sourceSansProBold,
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      color: Colors.white.withValues(alpha: 0.7),
                      size: 11.sp,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '$_currentDate • ',
                      style:
                          TextStyle(
                            fontSize: 14.sp,
                            color: Colors.white.withValues(alpha: 0.8),
                          ).sourceSansProRegular,
                    ),
                    Text(
                      _currentTime,
                      style:
                          TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ).sourceSansProBold,
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Text(
                  'Gérez vos biens et suivez vos performances en temps réel',
                  style:
                      TextStyle(
                        fontSize: 14.sp,
                        color: Colors.white.withValues(alpha: 0.8),
                      ).sourceSansProRegular,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        final dashboard = state.commercialDashboardModel;
        final statistics = dashboard?.statistics;
        final activities = dashboard?.recentActivities ?? [];

        return Container(
          width: double.infinity,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: AppColors.scaffold,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.r),
              topRight: Radius.circular(30.r),
            ),
          ),
          child: RefreshIndicator.adaptive(
            onRefresh: () async {
              context.read<DashboardBloc>().add(
                FetchCommercialDashboardEvent(),
              );
            },
            child: SafeArea(
              top: false,
              child: ListView(
                padding: EdgeInsets.all(16.sp),
                children: [
                  if (state.isLoading == true && dashboard == null)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: CircularProgressIndicator.adaptive(),
                      ),
                    )
                  else ...[
                    _buildStatisticsSection(statistics),
                    SizedBox(height: 24.h),
                    _buildQuickActionsSection(),
                    SizedBox(height: 16.h),
                    _buildRecentActivitySection(activities),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatisticsSection(CommercialStatisticsModel? stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(
          'Tableau de bord',
          style:
              TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ).sourceSansProBold,
        ),
        SizedBox(height: 16.h),
        // Première ligne : Agences et Propriétaires
        Row(
          children: [
            Expanded(
              child: _buildGradientStatCard(
                title: 'Agences',
                value: '${stats?.totalAgences ?? 0}',
                icon: Icons.business_center_rounded,
                color: AppColors.primary,
                onTap: () => context.pushNamed(AgenciesListPage.routeName),
                isCompact: true,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildGradientStatCard(
                title: 'Propriétaires',
                value: '${stats?.totalProprietaires ?? 0}',
                icon: Icons.group_rounded,
                color: AppColors.orange,
                onTap: () => context.pushNamed(OwnersListPage.routeName),
                isCompact: true,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        // Deuxième ligne : Total Biens (Pleine largeur)
        _buildGradientStatCard(
          title: 'Total Biens Immobiliers',
          value: '${stats?.totalBiens ?? 0}',
          icon: Icons.home_work_rounded,
          color: AppColors.success,
          onTap: () => context.pushNamed(PropertiesListPage.routeName),
        ),
      ],
    );
  }

  Widget _buildGradientStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    bool isCompact = false,
  }) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20.r),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        borderRadius: BorderRadius.circular(24.r),
        splashColor: Colors.white.withValues(alpha: 0.2),
        highlightColor: Colors.white.withValues(alpha: 0.1),
        child: Ink(
          width: double.infinity,
          height: isCompact ? 140.h : 150.h,
          padding: EdgeInsets.all(isCompact ? 16.sp : 20.sp),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color, color.withValues(alpha: 0.85)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Stack(
            children: [
              // Décorateur en arrière-plan (toujours présent)
              Positioned(
                right: isCompact ? -12.w : -8.w,
                bottom: isCompact ? -12.h : -8.h,
                child: Icon(
                  icon,
                  size: isCompact ? 70.sp : 90.sp,
                  color: Colors.white.withValues(alpha: 0.12),
                ),
              ),
              // Contenu principal
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      // Icône de taille moyenne dans un cercle
                      Container(
                        padding: EdgeInsets.all(isCompact ? 10.sp : 12.sp),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: Icon(
                          icon,
                          size: isCompact ? 24.sp : 30.sp,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      // Valeur (en grand à droite de l'icône)
                      Flexible(
                        child: Text(
                          value,
                          style:
                              TextStyle(
                                fontSize: isCompact ? 32.sp : 42.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ).sourceSansProBold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  // Titre (en bas)
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        TextStyle(
                          fontSize: isCompact ? 14.sp : 16.sp,
                          color: Colors.white.withValues(alpha: 0.95),
                          fontWeight: FontWeight.w600,
                        ).sourceSansProSemiBold,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Suppression de l'ancienne méthode _buildCompactStatCard qui n'est plus utilisée

  // Suppression de l'ancienne méthode _buildStatCard qui n'est plus utilisée

  Widget _buildQuickActionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Actions rapides',
          style:
              TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ).sourceSansProBold,
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                'Créer Agence',
                Icons.add_business_outlined,
                () => context.pushNamed(CreateAgencyPage.routeName),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildActionButton(
                'Créer Proprio',
                Icons.person_add_outlined,
                () => context.pushNamed(CreateOwnerPage.routeName),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildActionButton(
                'Ajouter Bien',
                Icons.add_home_work_outlined,
                () => _showAddPropertyBottomSheet(context),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showAddPropertyBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder:
          (context) => Container(
            padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 30.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(36.r)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 30,
                  offset: const Offset(0, -10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Indicateur et ligne de fermeture
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 40.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),

                // Titre principal
                Text(
                  'Ajouter un bien'.toUpperCase(),
                  style:
                      TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        letterSpacing: 0.5,
                      ).sourceSansProBold,
                ),
                SizedBox(height: 4.h),
                Text(
                  'Choisissez le type de propriétaire',
                  style:
                      TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[500],
                      ).sourceSansProRegular,
                ),
                SizedBox(height: 32.h),

                // Grille de sélection
                Row(
                  children: [
                    Expanded(
                      child: _buildChoiceCard(
                        context,
                        title: 'Agence',
                        subtitle: 'Rattacher à une agence partenaire',
                        icon: Icons.business_rounded,
                        color: AppColors.primary,
                        onTap: () {
                          context.pop();
                          context.pushNamed(CreateAgencyPropertyPage.routeName);
                        },
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: _buildChoiceCard(
                        context,
                        title: 'Particulier',
                        subtitle: 'Bien pour un propriétaire direct',
                        icon: Icons.person_rounded,
                        color: AppColors.orange,
                        onTap: () {
                          context.pop();
                          context.pushNamed(CreateOwnerPropertyPage.routeName);
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).padding.bottom + 12.h),
              ],
            ),
          ),
    );
  }

  Widget _buildChoiceCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.mediumImpact();
          onTap();
        },
        borderRadius: BorderRadius.circular(24.r),
        child: Container(
          padding: EdgeInsets.all(20.sp),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              color: color.withValues(alpha: 0.15),
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(16.sp),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 32.sp),
              ),
              SizedBox(height: 16.h),
              Text(
                title,
                style:
                    TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ).sourceSansProBold,
              ),
              SizedBox(height: 8.h),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style:
                    TextStyle(
                      fontSize: 11.sp,
                      color: Colors.grey[600],
                      height: 1.3,
                    ).sourceSansProRegular,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        borderRadius: BorderRadius.circular(16.r),
        splashColor: AppColors.primary.withValues(alpha: 0.1),
        highlightColor: AppColors.primary.withValues(alpha: 0.05),
        child: Ink(
          height: 100.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.15),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: -5,
                bottom: -5,
                child: Icon(
                  icon,
                  size: 44.sp,
                  color: AppColors.primary.withValues(alpha: 0.04),
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.sp),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: AppColors.primary, size: 24.sp),
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      label,
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ).sourceSansProBold,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentActivitySection(
    List<RecentActivityResponseModel> activities,
  ) {
    if (activities.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Activités récentes',
            style:
                TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ).sourceSansProBold,
          ),
          SizedBox(height: 16.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.sp),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Center(
              child: Text(
                'Aucune activité récente',
                style:
                    TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                    ).sourceSansProRegular,
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Activités récentes',
              style:
                  TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ).sourceSansProBold,
            ),
            TextButton(
              onPressed: () {
                final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
                final todayActivities =
                    activities
                        .where((a) => a.rawDate.startsWith(today))
                        .map((a) => a.toActivityModel())
                        .toList();
                context.pushNamed(
                  ActivitiesListPage.routeName,
                  extra: todayActivities,
                );
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Voir tout',
                style:
                    TextStyle(
                      color: AppColors.primary,
                      fontSize: 13.sp,
                    ).sourceSansProRegular,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ListView.separated(
            padding: EdgeInsets.symmetric(vertical: 4.h),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: activities.length > 5 ? 5 : activities.length,
            separatorBuilder:
                (context, index) => Divider(
                  height: 1,
                  indent: 70.w,
                  endIndent: 20.w,
                  color: Colors.grey.withValues(alpha: 0.08),
                ),
            itemBuilder: (context, index) {
              final activity = activities[index];
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    context.pushNamed(
                      ActivityDetailPage.routeName,
                      extra: activity.toActivityModel(),
                    );
                  },
                  borderRadius:
                      index == 0
                          ? BorderRadius.vertical(top: Radius.circular(20.r))
                          : index == activities.length - 1
                          ? BorderRadius.vertical(bottom: Radius.circular(20.r))
                          : null,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10.sp),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Icon(
                            activity.icon,
                            color: AppColors.primary,
                            size: 22.sp,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                activity.name,
                                style:
                                    TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ).sourceSansProBold,
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                '${activity.description} • ${activity.date}',
                                style:
                                    TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.grey[600],
                                    ).sourceSansProRegular,
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.chevron_right_rounded,
                          size: 20.sp,
                          color: Colors.grey[400],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
