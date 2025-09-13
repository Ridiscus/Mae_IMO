import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:maelys_imo/core/constants/app_colors.dart';
import 'package:maelys_imo/core/constants/assets.dart';
import 'package:maelys_imo/core/domain/models/index.dart';
import 'package:maelys_imo/core/domain/requests/index.dart';
import 'package:maelys_imo/core/extensions/index.dart';
import 'package:maelys_imo/core/manager/state/estate/estate_bloc.dart';
import 'package:maelys_imo/presentation/auth/pages/login_page.dart';
import 'package:maelys_imo/presentation/portal/pages/portal_detail_page.dart';
import 'package:maelys_imo/shared/widgets/index.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PortalPage extends StatefulWidget {
  static const String routeName = 'portal';
  static const String routePath = '/portal';

  const PortalPage({super.key});

  @override
  State<PortalPage> createState() => _PortalPageState();
}

class _PortalPageState extends State<PortalPage> {
  List<EstateTypeModel> _categories = [];
  List<EstateModel> _properties = [];
  EstateTypeModel? _selected;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final state = context.select((EstateBloc state) => state.state);
    _categories = state.estatesType ?? [];
    _properties = state.estates ?? [];
    _isLoading = state.isLoading ?? false;

    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: AppColors.orange,
        statusBarIconBrightness: Brightness.light,
      ),
      child: PageWithHeaderLayout(
        headerBackgroundColor: AppColors.orange,
        bodyPadding: EdgeInsets.only(top: 16.sp),
        headerContent: _buildHeaderContent(),
        bodyContent: _buildPageContent(),
        onRefresh: () async {
          final completer = Completer<void>();

          // Écouter les changements d'état pour savoir quand le chargement est terminé
          late StreamSubscription subscription;
          subscription = context.read<EstateBloc>().stream.listen((state) {
            if (!(state.isLoading ?? false)) {
              subscription.cancel();
              completer.complete();
            }
          });

          // Déclencher le chargement des données
          context.read<EstateBloc>().add(FetchEstateTypesEvent());
          context.read<EstateBloc>().add(FetchEstateEvent());

          // Attendre que le chargement soit terminé
          return completer.future;
        },
      ),
    );
  }

  Widget _buildPageContent() {
    return Column(
      children: [
        CategoryList(
          categories: _categories,
          selected: _selected,
          onCategorySelected: (EstateTypeModel model) {
            if (model == _selected) {
              _selected = null;
            } else {
              _selected = model;
            }
            setState(() {});
            context.read<EstateBloc>().add(
              FetchEstateEvent(dto: FilterEstateRequest(type: _selected?.type)),
            );
          },
        ),
        CustomSpacer(),

        if (_properties.isEmpty && !_isLoading)
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: EmptyStateWidget(
              icon: Icons.search_off_rounded,
              title: 'Aucun résultat trouvé',
              subtitle:
                  'Aucune propriété ne correspond à vos critères de recherche.',
              mainAxisAlignment: MainAxisAlignment.start,
            ),
          )
        else
          ...List.generate(
            _properties.length,
            (index) => Padding(
              padding: EdgeInsets.only(
                left: 16.sp,
                right: 16.sp,
                bottom: index < _properties.length - 1 ? 16.h : 0,
              ),
              child: Skeletonizer(
                enabled: _isLoading,
                child: PropertyCard(
                  property: _properties[index],
                  onPressed:
                      () => _navigateToPropertyDetails(_properties[index]),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildHeaderContent() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircularIcon(
              iconAsset: Assets.user,
              onPressed: () {
                context.pushNamed(LoginPage.routeName);
              },
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                'Maelys-imo',
                textAlign: TextAlign.center,
                style:
                    TextStyle(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ).sourceSansProBold,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.sp),
        _buildSearchBar(),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 8.sp),
            child: Icon(Icons.search, size: 24.sp, color: Colors.grey),
          ),
          SizedBox(width: 8.sp),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Rechercher, Appartement, Villa',
                fillColor: Colors.white,
                hintStyle:
                    TextStyle(
                      fontSize: 14.r,
                      color: Colors.grey,
                    ).sourceSansProRegular,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12.r),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 8.sp),
            child: CircleAvatar(
              backgroundColor: AppColors.orange,
              child: SvgPicture.asset(
                Assets.filter,
                width: 15.sp,
                height: 15.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToPropertyDetails(EstateModel property) {
    context.pushNamed(
      PortalDetailPage.routeName,
      pathParameters: {'id': property.id!.toString(), 'type': 'prospect'},
    );
  }
}
