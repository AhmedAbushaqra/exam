import 'package:exams/bussiness_logic/exam_cubit/exam_cubit.dart';
import 'package:exams/constant/global_var.dart';
import 'package:exams/data/models/exams_model.dart';
import 'package:exams/presentation/color_manager.dart';
import 'package:exams/presentation/screens/exam_questions.dart';
import 'package:exams/presentation/screens/home_page.dart';
import 'package:exams/presentation/screens/login_screen.dart';
import 'package:exams/presentation/screens/the_exam.dart';
import 'package:exams/presentation/widgets/app_button.dart';
import 'package:exams/presentation/widgets/text_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Exams extends StatefulWidget {
  const Exams({super.key});

  @override
  State<Exams> createState() => _ExamsState();
}

class _ExamsState extends State<Exams> {

  final TextEditingController examTitle = TextEditingController();
  late List<ExamsModel> exams;

  @override
  void initState() {
    // TODO: implement initState
    BlocProvider.of<ExamCubit>(context).getExams();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ExamCubit, ExamState>(
      listener: (context, state) {
        if (state is ExamLoading) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context)=>Center(child: CircularProgressIndicator(color: ColorManager.primaryGreen),));
        }
        if(state is GetExam){
          exams= BlocProvider.of<ExamCubit>(context).examsList;
        }
        if (state is ExamPosted) {
          Navigator.pop(context);
          exams= BlocProvider.of<ExamCubit>(context).examsList;
          setState(() {});
        }
        if (state is ExamPostedError) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Something went error"),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 5),
            ),
          );
        }
      },
      builder: (context,state){
        exams= BlocProvider.of<ExamCubit>(context).examsList ?? [];
        return Scaffold(
          backgroundColor: ColorManager.primaryGreen,
          appBar: prefs.getString('role')!='admin'?null:AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              AppButton(
                  color: Colors.transparent,
                  margin: 15,
                  onPressed: ()async{
                    prefs.setBool("ISLOGGED",false);
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                        builder: (_) => LoginScreen()), (route) => false);
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('logout',style: TextStyle(color: Colors.white)),
                      SizedBox(width: 10,),
                      Icon(Icons.logout)
                    ],
                  )
              ),
            ],
          ),
          body: exams.isEmpty?Center(
                child: Text('No Submitted Exams',style: TextStyle(color: Colors.white)),
              ):ListView.builder(
                itemCount: exams.length,
                itemBuilder: (BuildContext context, int index) {
                  int totalScore=0;
                  for(var i = 0; i < exams[index].questions.length; i++){
                    totalScore += exams[index].questions[i].score as int;
                  }
                  return exams[index].questions.length<1&&prefs.getString('role')!='admin'?Container():Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.white70, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: EdgeInsets.all(20.0),
                    child: ListTile(
                      title: Text(exams[index].title,style: TextStyle(color: Color(0xffbf717f),fontWeight: FontWeight.bold,fontSize: 18),),
                      subtitle: Text('Total Score : $totalScore'),
                      trailing: Icon(Icons.arrow_forward_ios,color: Color(0xffbf717f)),
                      onTap: (){
                        if(prefs.getString('role')!='admin'){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => TheExam(
                            exams: exams,id: exams[index].id,title: exams[index].title,)));
                        }else{
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ExamQuestions(
                            exams: exams,id: exams[index].id,title: exams[index].title,)));
                        }
                     },
                    ),
                  );
                },
              ),




          floatingActionButton: prefs.getString('role')!='admin'?Container():FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) =>  Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    padding: EdgeInsets.only(top: 15,right: 3,left: 3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('New Exam Title'
                          ,style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: Color((0xffbf717f))),),

                        const SizedBox(height: 15,),

                        Container(
                          height: MediaQuery.of(context).size.width*0.13,
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(15)
                          ),
                          child: FormInputField(
                            color: ColorManager.primaryGreen,
                            controller: examTitle,
                            keyboardType: TextInputType.name,
                            hintText: '',
                            validator: (v) {
                              if (v == '') {
                                return '';
                              }
                              return null;
                            },
                            prefixText: '',
                          ),
                        ),


                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            AppButton(
                              color: Colors.white,
                              margin: 15,
                              onPressed: (){
                                Navigator.of(context).pop();
                              },
                              child: Text('Close',style: TextStyle(color: ColorManager.primaryGreen)),
                            ),
                            AppButton(
                              color: ColorManager.primaryGreen,
                              margin: 15,
                              onPressed: (){
                                if(examTitle.text.isNotEmpty){
                                  BlocProvider.of<ExamCubit>(context).addExam(ExamsModel(
                                      title: examTitle.text.toString(), questions: []));
                                  setState(() {});
                                  Navigator.of(context).pop();
                                }
                              },
                              child: const Text('Submit',style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            child: Icon(Icons.add,),
            backgroundColor: Color(0xffbf717f),
          ),
        );
      },
    );
  }

}
