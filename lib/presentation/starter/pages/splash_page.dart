import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:maelys_imo/core/extensions/index.dart';
import 'package:maelys_imo/core/manager/state/estate/estate_bloc.dart';
import 'package:maelys_imo/presentation/portal/pages/portal_page.dart';
import 'package:maelys_imo/shared/widgets/index.dart';

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
    context.read<EstateBloc>().add(FetchEstateTypesEvent());
    context.read<EstateBloc>().add(FetchEstateEvent());

    await Future.delayed(const Duration(seconds: 2)).whenComplete(() {
      _next();
    });
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _next() async {
    context.goNamed(PortalPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
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
