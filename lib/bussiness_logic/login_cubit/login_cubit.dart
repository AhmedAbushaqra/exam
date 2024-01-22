import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:exams/constant/global_var.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http_parser/http_parser.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(AppInitial());


  Future<void> login(String username, String password) async {
    emit(LoginLoading());
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: username,
        password: password,
      );
      prefs.setString('role', 'admin');
      prefs.setBool("ISLOGGED", true);
      emit(LoginSuccess());
    }catch(e){
      print(e);
      emit(UserNotExist("User Not Exist"));
    }
  }

}
