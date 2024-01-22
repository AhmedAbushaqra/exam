import 'package:exams/bussiness_logic/exam_cubit/exam_cubit.dart';
import 'package:exams/data/models/exams_model.dart';
import 'package:exams/presentation/color_manager.dart';
import 'package:exams/presentation/widgets/app_button.dart';
import 'package:exams/presentation/widgets/text_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExamQuestions extends StatefulWidget {
  final String? title;
  final String? id;
  final List<ExamsModel>? exams;
  const ExamQuestions({super.key,required this.exams,required this.title, required this.id});

  @override
  State<ExamQuestions> createState() => _ExamQuestionsState();
}

class _ExamQuestionsState extends State<ExamQuestions> {
  final TextEditingController questionTitle = TextEditingController();
  final TextEditingController answer1 = TextEditingController();
  final TextEditingController answer2 = TextEditingController();
  final TextEditingController answer3 = TextEditingController();
  final TextEditingController answer4 = TextEditingController();
  final TextEditingController answer5 = TextEditingController();
  final TextEditingController correctAnswer = TextEditingController();
  final TextEditingController grade = TextEditingController();
  List answersNumbers = ['A','B','C','D','E'];
  late List<ExamsModel> exams;

  @override
  void initState() {
    // TODO: implement initState
    exams = widget.exams!;
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
        return Scaffold(
          backgroundColor: ColorManager.primaryGreen,
          body: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 40),
                child: Text('${widget.title}',style: TextStyle(color: Color(0xffbf717f),fontWeight: FontWeight.bold,fontSize: 35),),
              ),

              Expanded(
                child: ListView.builder(
                  itemCount: exams[exams.indexWhere((element) => element.id==widget.id)].questions.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
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
                              height: MediaQuery.of(context).size.height*0.08+exams[exams.indexWhere((element) => element.id==widget.id)].questions[index].answers.length*5,
                              child: ListView.builder(
                                itemCount: exams[exams.indexWhere((element) => element.id==widget.id)].questions[index].answers.length,
                                itemBuilder: (BuildContext context, int index2) {
                                  return Padding(
                                      padding: EdgeInsets.all(2),
                                      child: Text('      ${answersNumbers[index2]}) '+exams[exams.indexWhere((element) => element.id==widget.id)].questions[index].answers[index2],style: TextStyle(color: Color(0xffbf717f),fontSize: 15),)
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: 10,),
                            Text('The correct answer is (${answersNumbers[exams[exams.indexWhere((element) => element.id==widget.id)].questions[index].correctAnswer-1]})',style: TextStyle(color: Color(0xffbf717f),fontSize: 15),),
                            SizedBox(height: 5,),
                            Text('Question Score is ${exams[exams.indexWhere((element) => element.id==widget.id)].questions[index].score}',style: TextStyle(color: Color(0xffbf717f),fontSize: 15),),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) =>  Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.only(top: 15,right: 3,left: 3),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('New Question'
                            ,style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: Color((0xffbf717f))),),

                          const SizedBox(height: 8,),

                          Container(
                            height: MediaQuery.of(context).size.width*0.13,
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(15)
                            ),
                            child: FormInputField(
                              color: ColorManager.primaryGreen,
                              controller: questionTitle,
                              hintText: '',
                              validator: (v) {
                                if (v == '') {
                                  return '';
                                }
                                return null;
                              },
                              prefixText: 'Q:',
                            ),
                          ),

                          Text('Answers'
                            ,style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: Color((0xffbf717f))),),

                          Container(
                            width: MediaQuery.of(context).size.width*0.9,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: ColorManager.primaryGreen,
                                  width: 1.0,
                                  style: BorderStyle.solid
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              children: [
                                const SizedBox(height: 5,),
                                Container(
                                  height: MediaQuery.of(context).size.width*0.13,
                                  margin: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(15)
                                  ),
                                  child: FormInputField(
                                    controller: answer1,
                                    color: ColorManager.primaryGreen,
                                    hintText: '',
                                    validator: (v) {
                                      if (v == '') {
                                        return 'Empty Username';
                                      }
                                      return null;
                                    }, prefixText: 'A1:',
                                  ),
                                ),

                                Container(
                                  height: MediaQuery.of(context).size.width*0.13,
                                  margin: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(15)
                                  ),
                                  child: FormInputField(
                                    controller: answer2,
                                    color: ColorManager.primaryGreen,
                                    hintText: '',
                                    validator: (v) {
                                      if (v == '') {
                                        return 'Empty Username';
                                      }
                                      return null;
                                    }, prefixText: 'A2:',
                                  ),
                                ),

                                Container(
                                  height: MediaQuery.of(context).size.width*0.13,
                                  margin: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(15)
                                  ),
                                  child: FormInputField(
                                    controller: answer3,
                                    color: ColorManager.primaryGreen,
                                    hintText: '',
                                    validator: (v) {
                                      if (v == '') {
                                        return 'Empty Username';
                                      }
                                      return null;
                                    }, prefixText: 'A3:',
                                  ),
                                ),

                                Container(
                                  height: MediaQuery.of(context).size.width*0.13,
                                  margin: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(15)
                                  ),
                                  child: FormInputField(
                                    controller: answer4,
                                    color: ColorManager.primaryGreen,
                                    hintText: '',
                                    validator: (v) {
                                      if (v == '') {
                                        return 'Empty Username';
                                      }
                                      return null;
                                    }, prefixText: 'A4:',
                                  ),
                                ),


                                Container(
                                  height: MediaQuery.of(context).size.width*0.13,
                                  margin: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(15)
                                  ),
                                  child: FormInputField(
                                    controller: answer5,
                                    color: ColorManager.primaryGreen,
                                    hintText: '',
                                    validator: (v) {
                                      if (v == '') {
                                        return 'Empty Username';
                                      }
                                      return null;
                                    }, prefixText: 'A5:',
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 5,),

                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text('Correct Choice'
                                ,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Color((0xffbf717f))),),

                              Text('Question grade'
                                ,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Color((0xffbf717f))),),
                            ],
                          ),


                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                height: MediaQuery.of(context).size.width*0.13,
                                width: MediaQuery.of(context).size.width*0.3,
                                margin: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(15)
                                ),
                                child: FormInputField(
                                  controller: correctAnswer,
                                  keyboardType: TextInputType.number,
                                  color: ColorManager.primaryGreen,
                                  hintText: '',
                                  validator: (v) {
                                    if (v == '') {
                                      return 'Empty Username';
                                    }
                                    return null;
                                  }, prefixText: '#:',
                                ),
                              ),


                              Container(
                                height: MediaQuery.of(context).size.width*0.13,
                                width: MediaQuery.of(context).size.width*0.3,
                                margin: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(15)
                                ),
                                child: FormInputField(
                                  controller: grade,
                                  keyboardType: TextInputType.number,
                                  color: ColorManager.primaryGreen,
                                  hintText: '',
                                  validator: (v) {
                                    if (v == '') {
                                      return 'Empty Username';
                                    }
                                    return null;
                                  }, prefixText: '#:',
                                ),
                              ),
                            ],
                          ),


                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              AppButton(
                                color: Colors.white,
                                margin: 15,
                                onPressed: (){
                                  print(widget.id);
                                  Navigator.of(context).pop();
                                },
                                child: Text('Close',style: TextStyle(color: ColorManager.primaryGreen)),
                              ),
                              AppButton(
                                color: ColorManager.primaryGreen,
                                margin: 15,
                                onPressed: (){
                                  List<String> answers=[];
                                  if(answer1.text.isNotEmpty)answers.add(answer1.value.text);
                                  if(answer2.text.isNotEmpty)answers.add(answer2.value.text);
                                  if(answer3.text.isNotEmpty)answers.add(answer3.value.text);
                                  if(answer4.text.isNotEmpty)answers.add(answer4.value.text);
                                  if(answer5.text.isNotEmpty)answers.add(answer5.value.text);
                                  BlocProvider.of<ExamCubit>(context).addQuestion(ExamsModel(
                                      id: widget.id,
                                      title: widget.title!, questions: [Question(question: questionTitle.value.text,
                                      answers: answers, correctAnswer: int.parse(correctAnswer.value.text),
                                      score: int.parse(grade.value.text))]));
                                  setState(() {});
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Submit',style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                        ],
                      ),
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
