import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:maelys_imo/core/extensions/context_extension.dart';
import 'package:maelys_imo/shared/widgets/custom_scaffold.dart';

import '../../../core/constants/assets.dart';

class SplashPage extends StatefulWidget {
  static const String routeName = 'splash';
  static const String routePath = '/';

  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  void _init() async {
    await Future.delayed(const Duration(seconds: 3)).whenComplete(() {
      _next();
    });
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _next() async {
    // context.read<ToolsBloc>().add(FetchAdEvent());
    // final userModel = context.read<AuthBloc>().state.userModel;
    // final hasUserToken = await TokenManager().hasUserToken();
    //
    // if (kDebugMode) {
    //   print("userModel $userModel && token $hasUserToken");
    // }
    //
    // if (userModel != null && hasUserToken) {
    //   context.goNamed(MainHomePage.routeName);
    // } else {
    //   context.goNamed(MainAuthPage.routeName);
    // }

    // Navigate to onboarding page
    // context.goNamed(OnboardingPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light,
      child: CustomScaffold(
        isSafeArea: false,
        padding: EdgeInsets.zero,
        child: SizedBox(
          width: context.getSize.width,
          height: context.getSize.height,
          child: Center(child: Image.asset(Assets.splash, fit: BoxFit.cover)),
        ),
      ),
    );
  }
}
