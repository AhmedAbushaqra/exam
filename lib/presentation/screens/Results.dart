import 'package:exams/bussiness_logic/exam_cubit/exam_cubit.dart';
import 'package:exams/presentation/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExamResults extends StatefulWidget {
  const ExamResults({super.key});

  @override
  State<ExamResults> createState() => _ExamResultsState();
}

class _ExamResultsState extends State<ExamResults> {

  late List examsRes;
  @override
  void initState() {
    // TODO: implement initState
    BlocProvider.of<ExamCubit>(context).getExamResults();
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
          examsRes= BlocProvider.of<ExamCubit>(context).resultsList;
        }
        if (state is ExamPosted) {
          Navigator.pop(context);
          examsRes= BlocProvider.of<ExamCubit>(context).resultsList;
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
      examsRes= BlocProvider.of<ExamCubit>(context).resultsList ?? [];
      return  ListView.builder(
        itemCount: examsRes.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.white70, width: 1),
              borderRadius: BorderRadius.circular(10),
            ),
            margin: EdgeInsets.all(20.0),
            child: ListTile(
              title: Text(examsRes[index]['studentName'],style: TextStyle(color: Color(0xffbf717f),fontWeight: FontWeight.bold,fontSize: 18),),
              subtitle: Text('Exam: ${examsRes[index]['exam']}'),
              trailing: Text('Total Score: ${examsRes[index]['score']}',style: TextStyle(color: Color(0xffbf717f),fontWeight: FontWeight.bold,fontSize: 18),),
            ),
          );
        },
      );
    }
    );
  }
}
