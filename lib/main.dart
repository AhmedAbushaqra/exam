import 'dart:io';
import 'package:exams/bussiness_logic/exam_cubit/exam_cubit.dart';
import 'package:exams/bussiness_logic/login_cubit/login_cubit.dart';
import 'package:exams/constant/global_var.dart';
import 'package:exams/controls/control_flow.dart';
import 'package:exams/helpers/dio_helper.dart';
import 'package:exams/presentation/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid?
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: 'AIzaSyDpNbh4tT8lpIfKV13ll6-RxkdJEUC2IVE',
        appId: '1:388640235398:android:a83fc73b3ac94ec736d607',
        messagingSenderId: '388640235398',
        projectId: 'exams-41b70'
    )
  ):
  await Firebase.initializeApp();
  DioHelper.init();
  prefs = await SharedPreferences.getInstance();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => LoginCubit(),
          ),
          BlocProvider(
            create: (context) => ExamCubit(),
          ),
        ],
        child:MaterialApp(
          home: ControlFlow(),
        )
    );
  }
}
