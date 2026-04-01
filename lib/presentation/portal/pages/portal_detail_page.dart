import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:maelys_imo/core/constants/app_colors.dart';
import 'package:maelys_imo/core/constants/assets.dart';
import 'package:maelys_imo/core/domain/models/index.dart';
import 'package:maelys_imo/core/extensions/index.dart';
import 'package:maelys_imo/core/manager/state/auth/auth_bloc.dart';
import 'package:maelys_imo/presentation/portal/pages/visit_request_page.dart';
import 'package:maelys_imo/shared/widgets/index.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/manager/state/estate/estate_bloc.dart';
import '../../../core/utils/index.dart';

class PortalDetailPage extends StatefulWidget {
  static const String routeName = 'portal-detail/:id/:type';
  static const String routePath = '/portal-detail/:id/:type';

  final String? id;
  final String? type;

  const PortalDetailPage({super.key, this.id, this.type});

  @override
  State<PortalDetailPage> createState() => _PortalDetailPageState();
}

class _PortalDetailPageState extends State<PortalDetailPage> {
  int _currentImageIndex = 0;
  bool _isLoading = true;
  EstateModel? _property;

  @override
  void initState() {
    context.read<EstateBloc>().add(
      FetchDetailEstateEvent(id: int.parse(widget.id!)),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final estate = context.select((EstateBloc state) => state.state);
    return BlocConsumer<EstateBloc, EstateState>(
      listener: (context, state) {
        if (state.estate == null && state.isLoading == false) {
          context.pop();
        }
        setState(() {
          _isLoading = state.isLoading ?? true;
        });
      },
      buildWhen: (previous, current) => current.estate != null,
      builder: (context, state) {
        _property = state.estate;
        return AnnotatedRegion(
          value: SystemUiOverlayStyle(statusBarColor: Colors.transparent),
          child: Scaffold(
            backgroundColor: AppColors.scaffold,
            body: Skeletonizer(
              enabled: _isLoading,
              child: SizedBox(
                width: context.getSize.width,
                height: context.getSize.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildImageHeader(),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(16.sp),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildTitleAndPrice(),
                              CustomSpacer(),
                              AmenityChip(
                                amenities: _property?.amenities ?? [],
                              ),
                              CustomSpacer(),
                              _buildDescription(),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (widget.type?.toLowerCase() == 'prospect') ...[
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.sp),
                        child: _buildVisitButton(
                          text: 'Visiter',
                          onPressed: () {
                            context.pushNamed(VisitRequestPage.routeName);
                          },
                        ),
                      ),
                      const SpacerPlatform(),
                    ],
                    if (widget.type?.toLowerCase() == 'tenant') ...[
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.sp),
                        child: _buildVisitButton(
                          text: 'Télécharger mon contrat',
                          onPressed: () {
                            final contrat =
                                context
                                    .read<AuthBloc>()
                                    .state
                                    .userModel
                                    ?.asTenant()
                                    ?.contrat;
                            CoreHelper.launchLink(CoreHelper.fullLink(contrat));
                          },
                          assetPath: Assets.cloudDownload,
                        ),
                      ),
                      const SpacerPlatform(),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageHeader() {
    return SizedBox(
      width: double.infinity,
      height: context.getSize.height * 0.4,
      child: Stack(
        children: [
          // Image
          Stack(
            children: [
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(20.r)),
                  child: PageView.builder(
                    itemCount: _property?.imageCount,
                    onPageChanged: (index) {
                      setState(() {
                        _currentImageIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return UIHelper.cachedNetworkImage(
                        CoreHelper.fullLink(_property?.images![index]),
                        height: double.infinity,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
              ),
              // Pagination indicators
              Positioned(
                bottom: 10.h,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _property?.imageCount ?? 1,
                    (index) =>
                        PaginationDot(isActive: index == _currentImageIndex),
                  ),
                ),
              ),
            ],
          ),

          // Back button
          Positioned(left: 16.r, child: SafeArea(child: CircularBackButton())),
        ],
      ),
    );
  }

  Widget _buildTitleAndPrice() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            "${_property?.title}",
            style:
                TextStyle(
                  fontSize: 22.r,
                  fontWeight: FontWeight.bold,
                ).sourceSansProBold,
          ),
        ),
        Text(
          '${"${_property?.prix}".formatCurrency()} / Mois',
          style:
              TextStyle(
                fontSize: 16.r,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ).sourceSansProBold,
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style:
              TextStyle(
                fontSize: 18.r,
                fontWeight: FontWeight.bold,
              ).sourceSansProBold,
        ),
        SizedBox(height: 8.r),
        Text(
          _property?.description ?? '',
          style:
              TextStyle(
                fontSize: 14.r,
                color: Colors.grey[800],
                height: 1.5,
              ).sourceSansProRegular,
        ),
      ],
    );
  }

  Widget _buildVisitButton({
    required String text,
    required VoidCallback onPressed,
    IconData? iconData,
    String? assetPath,
  }) {
    return CustomButton(
      text: text,
      showArrow: true,
      onPressed: onPressed,
      buttonVariant: ButtonVariant.primary,
      iconData: iconData,
      assetPath: assetPath,
    );
  }
}
