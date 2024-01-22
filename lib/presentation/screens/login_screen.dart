import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exams/bussiness_logic/login_cubit/login_cubit.dart';
import 'package:exams/constant/global_var.dart';
import 'package:exams/presentation/color_manager.dart';
import 'package:exams/presentation/screens/exams.dart';
import 'package:exams/presentation/screens/home_page.dart';
import 'package:exams/presentation/widgets/app_button.dart';
import 'package:exams/presentation/widgets/text_input_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController stName = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool isAdmin=true;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          backgroundColor: ColorManager.primaryGreen,
          body: _LoginPageBody(),
        )
      ]
    );
  }


  Widget _LoginPageBody(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppButton(
                color: isAdmin?const Color(0xffbf717f):null,
                margin: 15,
                width: MediaQuery.of(context).size.width*0.4,
                height: MediaQuery.of(context).size.height*0.06,
                onPressed: (){
                  setState(() {
                    isAdmin=true;
                  });
                },
                child: const Text('Admin',style: TextStyle(color: Colors.white70)),
              ),


              AppButton(
                color: isAdmin?null:const Color(0xffbf717f),
                margin: 15,
                width: MediaQuery.of(context).size.width*0.4,
                height: MediaQuery.of(context).size.height*0.06,
                onPressed: (){
                  setState(() {
                    isAdmin=false;
                  });
                },
                child: const Text('Student',style: TextStyle(color: Colors.white70)),
              ),

            ],
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height*0.05,),

        isAdmin?_AdminLogin():
        _StudentLogin(),

        if(!isAdmin)SizedBox(height: MediaQuery.of(context).size.width*0.2,)
      ],
    );
  }


  Widget _AdminLogin(){
    return Container(
      width: MediaQuery.of(context).size.width*0.9,
      decoration: BoxDecoration(
        border: Border.all(
            color: Colors.white54,
            width: 1.0,
            style: BorderStyle.solid
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _buildloginSubmittedBloc(),
          const SizedBox(height: 5,),
          Container(
            height: MediaQuery.of(context).size.width*0.15,
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15)
            ),
            child: FormInputField(
              controller: username,
              keyboardType: TextInputType.emailAddress,
              hintText: '',
              validator: (v) {
                if (v == '') {
                  return 'Empty Username';
                }
                return null;
              }, prefixText: 'Username:',
            ),
          ),

          Container(
            height: MediaQuery.of(context).size.width*0.15,
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15)
            ),
            child: FormInputField(
              controller: password,
              obscure: true,
              hintText: '',
              validator: (v) {
                if (v == '') {
                  return 'Empty Username';
                }
                return null;
              }, prefixText: 'Password:',
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              AppButton(
                  color: const Color(0xffbf717f),
                  margin: 15,
                  onPressed: ()async{
                    BlocProvider.of<LoginCubit>(context).login(username.text.trim(), password.text.trim());
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(width: 50,),
                      Text('Next',style: TextStyle(color: Colors.white70)),
                      SizedBox(width: 10,),
                      Icon(Icons.arrow_forward_ios)
                    ],
                  )
              ),
            ],
          ),

        ],
      ),
    );
  }



  Widget _StudentLogin(){
    return Container(
      width: MediaQuery.of(context).size.width*0.9,
      decoration: BoxDecoration(
        border: Border.all(
            color: Colors.white54,
            width: 1.0,
            style: BorderStyle.solid
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const SizedBox(height: 5,),

          Container(
            height: MediaQuery.of(context).size.width*0.15,
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15)
            ),
            child: FormInputField(
              controller: stName,
              keyboardType: TextInputType.name,
              hintText: '',
              validator: (v) {
                if (v == '') {
                  return 'Empty Student Name';
                }
                return null;
              }, prefixText: 'Student Name:',
            ),
          ),


          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [

              AppButton(
                  color: const Color(0xffbf717f),
                  margin: 15,
                  onPressed: ()async{

                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context)=>Center(child: CircularProgressIndicator(color: ColorManager.primaryGreen),));

                    prefs.setString('role', stName.text);
                    Navigator.pop(context);
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Exams()),(route) => false,);
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(width: 50,),
                      Text('Next',style: TextStyle(color: Colors.white70)),
                      SizedBox(width: 10,),
                      Icon(Icons.arrow_forward_ios)
                    ],
                  )
              ),
            ],
          ),

        ],
      ),
    );
  }




  Widget _buildloginSubmittedBloc() {
    return BlocListener<LoginCubit, LoginState>(
      listenWhen: (previous, current) {
        return previous != current;
      },
      listener: (context, state) {
        if (state is LoginLoading) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context)=>Center(child: CircularProgressIndicator(color: ColorManager.primaryGreen),));
        }
        if (state is LoginSuccess) {
          Navigator.pop(context);
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (context) => LoginCubit(),
                child: HomePage(),
              )), (route) => false);
        }
        if (state is UserNotExist) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Something went error or User Not Exist"),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 5),
            ),
          );
        }
      },
      child: Container(),
    );
  }
}
