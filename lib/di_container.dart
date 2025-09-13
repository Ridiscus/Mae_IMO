import 'package:get_it/get_it.dart' show GetIt;
import 'package:maelys_imo/core/services/estate_service.dart';
import 'package:maelys_imo/presentation/auth/pages/login_page.dart';

import 'core/api_manager/api_client.dart' show ApiClient, LogoutRedirectConfig;
import 'core/api_manager/endpoints.dart' show Endpoints;
import 'core/manager/state/auth/auth_bloc.dart';
import 'core/manager/state/estate/estate_bloc.dart';
import 'core/manager/token_manager.dart';
import 'core/services/auth_service.dart';
import 'main.dart' show navigatorKey;

/// Instance singleton de GetIt pour l'injection de dépendances
final getIt = GetIt.instance;

/// Initialise toutes les dépendances de l'application
Future<void> initDependencies() async {
  await _initCore();
  await _initServices();
  await _initBlocs();
}

/// Initialise les dépendances core de l'application
Future<void> _initCore() async {
  getIt.registerLazySingleton<Endpoints>(() => Endpoints());
  getIt.registerLazySingleton<TokenManager>(() => TokenManager());

  getIt.registerLazySingleton<ApiClient>(
    () => ApiClient(
      baseUrl: Endpoints.baseUrl,
      tokenManager: getIt<TokenManager>(),
      logoutRedirectConfig: LogoutRedirectConfig(
        routeName: LoginPage.routeName,
        navigatorKey: navigatorKey,
      ),
    ),
  );
}

/// Initialise les blocs de l'application
Future<void> _initBlocs() async {
  getIt.registerLazySingleton<AuthBloc>(
    () => AuthBloc(service: getIt<AuthService>()),
  );

  getIt.registerLazySingleton<EstateBloc>(
    () => EstateBloc(service: getIt<EstateService>()),
  );
}

/// Initialise les services de l'application
Future<void> _initServices() async {
  getIt.registerLazySingleton<AuthService>(
    () => AuthServiceImpl(
      apiClient: getIt<ApiClient>(),
      endpoints: getIt<Endpoints>(),
    ),
  );

  getIt.registerLazySingleton<EstateService>(
    () => EstateServiceImpl(
      apiClient: getIt<ApiClient>(),
      endpoints: getIt<Endpoints>(),
    ),
  );
}
