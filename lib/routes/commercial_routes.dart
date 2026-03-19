import 'package:go_router/go_router.dart';
import '../presentation/commercial/pages/dashboard_commercial_page.dart';
import '../presentation/commercial/pages/agencies_list_page.dart';
import '../presentation/commercial/pages/owners_list_page.dart';
import '../presentation/commercial/pages/properties_list_page.dart';
import '../presentation/commercial/pages/create_agency_page.dart';
import '../presentation/commercial/pages/create_owner_page.dart';
import '../presentation/commercial/pages/create_property_page.dart';
import '../presentation/commercial/pages/create_agency_property_page.dart';
import '../presentation/commercial/pages/create_owner_property_page.dart';
import '../presentation/commercial/pages/property_detail_page.dart';
import '../presentation/commercial/pages/agency_detail_page.dart';
import '../presentation/commercial/pages/owner_detail_page.dart';
import '../presentation/commercial/pages/activities_list_page.dart';
import '../presentation/commercial/pages/activity_detail_page.dart';
import '../presentation/commercial/pages/profile_commercial_page.dart';
import '../presentation/commercial/pages/update_email_commercial_page.dart';
import '../presentation/commercial/pages/update_password_commercial_page.dart';
import '../core/domain/models/index.dart';

class CommercialRoutes {
  static final List<RouteBase> routes = [
    GoRoute(
      name: DashboardCommercialPage.routeName,
      path: DashboardCommercialPage.routePath,
      builder: (context, state) => const DashboardCommercialPage(),
    ),
    GoRoute(
      name: AgenciesListPage.routeName,
      path: AgenciesListPage.routePath,
      builder: (context, state) => const AgenciesListPage(),
    ),
    GoRoute(
      name: AgencyDetailPage.routeName,
      path: AgencyDetailPage.routePath,
      builder: (context, state) {
        final agency = state.extra as AgencyModel;
        return AgencyDetailPage(agency: agency);
      },
    ),
    GoRoute(
      name: OwnersListPage.routeName,
      path: OwnersListPage.routePath,
      builder: (context, state) => const OwnersListPage(),
    ),
    GoRoute(
      name: OwnerDetailPage.routeName,
      path: OwnerDetailPage.routePath,
      builder: (context, state) {
        final owner = state.extra as OwnerModel;
        return OwnerDetailPage(owner: owner);
      },
    ),
    GoRoute(
      name: PropertiesListPage.routeName,
      path: PropertiesListPage.routePath,
      builder: (context, state) => const PropertiesListPage(),
    ),
    GoRoute(
      name: PropertyDetailPage.routeName,
      path: PropertyDetailPage.routePath,
      builder: (context, state) {
        final property = state.extra as PropertyModel;
        return PropertyDetailPage(property: property);
      },
    ),
    GoRoute(
      name: CreateAgencyPage.routeName,
      path: CreateAgencyPage.routePath,
      builder: (context, state) => const CreateAgencyPage(),
    ),
    GoRoute(
      name: CreateOwnerPage.routeName,
      path: CreateOwnerPage.routePath,
      builder: (context, state) => const CreateOwnerPage(),
    ),
    GoRoute(
      name: CreatePropertyPage.routeName,
      path: CreatePropertyPage.routePath,
      builder: (context, state) => const CreatePropertyPage(),
    ),
    GoRoute(
      name: CreateAgencyPropertyPage.routeName,
      path: CreateAgencyPropertyPage.routePath,
      builder: (context, state) => const CreateAgencyPropertyPage(),
    ),
    GoRoute(
      name: CreateOwnerPropertyPage.routeName,
      path: CreateOwnerPropertyPage.routePath,
      builder: (context, state) => const CreateOwnerPropertyPage(),
    ),
    // Route pour la liste complète des activités
    GoRoute(
      name: ActivitiesListPage.routeName,
      path: ActivitiesListPage.routePath,
      builder: (context, state) => ActivitiesListPage(),
    ),
    GoRoute(
      name: ActivityDetailPage.routeName,
      path: ActivityDetailPage.routePath,
      builder: (context, state) {
        final activity = state.extra as ActivityModel;
        return ActivityDetailPage(activity: activity);
      },
    ),
    GoRoute(
      name: ProfileCommercialPage.routeName,
      path: ProfileCommercialPage.routePath,
      builder: (context, state) => const ProfileCommercialPage(),
    ),
    GoRoute(
      name: UpdateEmailCommercialPage.routeName,
      path: UpdateEmailCommercialPage.routePath,
      builder: (context, state) => const UpdateEmailCommercialPage(),
    ),
    GoRoute(
      name: UpdatePasswordCommercialPage.routeName,
      path: UpdatePasswordCommercialPage.routePath,
      builder: (context, state) => const UpdatePasswordCommercialPage(),
    ),
  ];
}
