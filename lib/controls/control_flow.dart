import 'dart:async';
import 'package:exams/bussiness_logic/login_cubit/login_cubit.dart';
import 'package:exams/presentation/screens/home_page.dart';
import 'package:exams/presentation/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../constant/global_var.dart';

class ControlFlow extends StatefulWidget {
  const ControlFlow({Key? key}) : super(key: key);

  @override
  _ControlFlowState createState() => _ControlFlowState();
}

class _ControlFlowState extends State<ControlFlow> {
  @override
  void initState() {
    super.initState();
    Timer.run(() {
      isLogged
          ?  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
          builder: (_) => HomePage()), (route) => false)
          : Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
          builder: (_) => LoginScreen()), (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
