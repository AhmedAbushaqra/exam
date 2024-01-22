import 'package:exams/bussiness_logic/exam_cubit/exam_cubit.dart';
import 'package:exams/constant/global_var.dart';
import 'package:exams/data/models/exams_model.dart';
import 'package:exams/presentation/color_manager.dart';
import 'package:exams/presentation/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TheExam extends StatefulWidget {
  final String? title;
  final String? id;
  final List<ExamsModel>? exams;
  const TheExam({super.key,required this.exams,required this.title, required this.id});

  @override
  State<TheExam> createState() => _TheExamState();
}

class _TheExamState extends State<TheExam> {

  List answersNumbers = ['A','B','C','D','E'];
  String answer='';
  int index=0;
  int studentScore =0;
  int studentTotalScore =0;
  late List<ExamsModel> exams;

  @override
  void initState() {
    // TODO: implement initState
    exams = widget.exams!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primaryGreen,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 40),
            child: Text('${widget.title}',style: TextStyle(color: Color(0xffbf717f),fontWeight: FontWeight.bold,fontSize: 35),),
          ),

               Card(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.white70, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.all(20.0),
                  child: Container(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('${index+1}-'+exams[exams.indexWhere((element) => element.id==widget.id)].questions[index].question,style: TextStyle(color: Color(0xffbf717f),fontWeight: FontWeight.bold,fontSize: 18),),
                        Container(
                          height: MediaQuery.of(context).size.height*0.1+exams[exams.indexWhere((element) => element.id==widget.id)].questions[index].answers.length*40,
                          child: ListView.builder(
                            itemCount: exams[exams.indexWhere((element) => element.id==widget.id)].questions[index].answers.length,
                            itemBuilder: (BuildContext context, int index2) {
                              return RadioListTile(
                                    title: Text('${answersNumbers[index2]}) '+exams[exams.indexWhere((element) => element.id==widget.id)].questions[index].answers[index2]),
                                    value: exams[exams.indexWhere((element) => element.id==widget.id)].questions[index].answers[index2],
                                    groupValue: answer,
                                    onChanged: (value){
                                      setState(() {
                                        answer = value.toString();
                                        if(exams[exams.indexWhere((element) => element.id==widget.id)].questions[index].correctAnswer-1==index2){
                                          studentScore = exams[exams.indexWhere((element) => element.id==widget.id)].questions[index].score;
                                        }else{
                                          studentScore =0;
                                        }
                                      });
                                    },
                                  );
                            },
                          ),
                        ),
                         SizedBox(height: 5,),
                        Text('Question Score is ${exams[exams.indexWhere((element) => element.id==widget.id)].questions[index].score}',style: TextStyle(color: Color(0xffbf717f),fontSize: 15),),
                      ],
                    ),
                  ),
                ),

          const SizedBox(height: 15,),

          AppButton(
            color: Color(0xffbf717f),
            margin: 15,
            height: 45,
            width: 80,
            onPressed: ()async{
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context)=>Center(child: CircularProgressIndicator(color: ColorManager.primaryGreen),));
              if(answer==''){

              }else{
                if(index+1==exams[exams.indexWhere((element) => element.id==widget.id)].questions.length){
                  studentTotalScore = studentTotalScore + studentScore;
                  BlocProvider.of<ExamCubit>(context).submitExam(prefs.getString('role')??'Default name', widget.title!, studentTotalScore);
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  showDialog(
                      context: context,
                      builder: (context)=>Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Container(
                            height: MediaQuery.of(context).size.height*0.17,
                            width: MediaQuery.of(context).size.width*0.1,
                            padding: EdgeInsets.all(20),
                              child: Card(
                                child: Column(
                                  children: [
                                    Text('Final Score',style: TextStyle(color: Color(0xffbf717f),fontSize: 20),),
                                    SizedBox(height: 10,),
                                    Text('${studentTotalScore}',style: TextStyle(color: Color(0xffbf717f),fontSize: 20,fontWeight: FontWeight.bold),),
                                  ],
                                ),
                              ),
                        ),
                      )
                  );
                }else{
                  studentTotalScore = studentTotalScore + studentScore;
                  setState(() {
                    index =index+1;
                  });
                  Navigator.of(context).pop();
                }
              }
            },
            child: index+1<exams[exams.indexWhere((element) => element.id==widget.id)].questions.length?
                   const Text('Next',style: TextStyle(color: Colors.white)):
                   const Text('Submit',style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
