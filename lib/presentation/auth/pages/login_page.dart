import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maelys_imo/core/manager/state/auth/auth_bloc.dart';

import '../../../core/manager/token_manager.dart';

class LoginPage extends StatefulWidget {
  static const routeName = 'login';
  static const routePath = '/login';

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: Text('data')));
  }

  Future<void> _init() async {
    final userModel = context.read<AuthBloc>().state.userModel;
    final hasUserToken = await TokenManager().hasUserToken();

    if (kDebugMode) {
      print("userModel $userModel && token $hasUserToken");
    }

    if (userModel != null && hasUserToken) {
    } else {
      if (kDebugMode) {
        _usernameController.text = "christ2";
        _passwordController.text = "1234";

        setState(() {});
      }
    }
  }
}
