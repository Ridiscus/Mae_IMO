import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart'
    show
    GlobalCupertinoLocalizations,
    GlobalMaterialLocalizations,
    GlobalWidgetsLocalizations;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:toastification/toastification.dart';

import 'core/config/themes/app_theme.dart';
import 'core/constants/constants.dart';
import 'core/manager/state/auth/auth_bloc.dart';
import 'core/manager/state/simple_bloc_observer.dart';
import 'core/manager/token_manager.dart';
import 'di_container.dart';
import 'routes/app_route.dart' show AppRoute;

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
late GoRouter appRouter;

void main() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  binding.deferFirstFrame();

  TokenManager.init();
  appRouter = AppRoute().router;
  await initDependencies();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory:
        kIsWeb
            ? HydratedStorageDirectory.web
            : HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );
  Bloc.observer = SimpleBlocObserver();

  binding.allowFirstFrame();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<AuthBloc>()),
        // BlocProvider(
        //   create:
        //       (context) =>
        //           TransporterCubit<RegisterRequest>()
        //             ..init(value: RegisterRequest()),
        // ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(402, 874),
        builder: (context, child) {
          return ToastificationWrapper(
            config: ToastificationConfig(maxToastLimit: 1),
            child: MaterialApp.router(
              routerConfig: appRouter,
              title: Constants.appName,
              debugShowCheckedModeBanner: false,
              theme: AppTheme.light,
              locale: const Locale('fr', 'FR'),
              supportedLocales: const [Locale('fr', 'FR'), Locale('en', 'US')],
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
            ),
          );
        },
      ),
    );
  }
}
