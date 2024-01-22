import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:exams/constant/end_points.dart';
import 'package:exams/constant/global_var.dart';
import 'package:exams/data/models/exams_model.dart';
import 'package:exams/helpers/dio_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http_parser/http_parser.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart'as http;

import 'package:shared_preferences/shared_preferences.dart';
part 'exam_state.dart';

class ExamCubit extends Cubit<ExamState> {
  ExamCubit() : super(AppInitial());

  List<ExamsModel> examsList = [];

  Future<void> addExam(ExamsModel exam) {
    emit(ExamLoading());
    return DioHelper.postData(url: exams, data: {
      'title': exam.title,
      'questions': exam.questions,
    }).then((response) {
      final newExam = ExamsModel(
          id: response.data['name'],
          title: exam.title,
          questions: exam.questions
      );
      examsList.add(newExam);
      emit(ExamPosted());
    }).catchError((error) {
      print(error);
      emit(ExamPostedError());
      throw error;
    });
  }

  Future<void> getExams() {
    emit(ExamLoading());
    return http.get(Uri.parse(baseUrl + exams)).then((response) {
      final ExtractedData = json.decode(response.body) as Map<String, dynamic>;
      examsList = [];
      ExtractedData.forEach((examId, examData) {
        List<Question> qestions = [];
        if (examData['First Exam'] != null) {
          examData['First Exam'].forEach((questionId, questionData) {
            qestions.add(Question(
                question: questionData['question'].first['question'],
                answers: questionData['question'].first['answers'].cast<
                    String>(),
                correctAnswer: questionData['question'].first['correctAnswer'],
                score: (questionData['question'].first['score']))
            );
          });
        }
        examsList.add(ExamsModel(
          id: examId,
          title: examData['title'],
          questions: qestions,
        ));
      });
      emit(GetExam());
    }).catchError((error) {
      print(error);
      emit(ExamPostedError());
      throw error;
    });
  }


  Future<void> addQuestion(ExamsModel exam) {
    emit(ExamLoading());
    final examIndex = examsList.indexWhere((ex) => ex.id == exam.id);
    return DioHelper.postData(
        url: 'exams/${exam.id}/${exam.title}.json', data: {
      'question': exam.questions,
    }).then((response) {
      final newExam = ExamsModel(
          id: response.data['name'],
          title: exam.title,
          questions: exam.questions
      );
      examsList[examIndex].questions.add(exam.questions.first);
      emit(ExamPosted());
    }).catchError((error) {
      print(error);
      emit(ExamPostedError());
      throw error;
    });
  }

  Future<void> submitExam(String studentName, String exam, int score) {
    emit(ExamLoading());
    return DioHelper.postData(url: 'Submitedexams.json', data: {
      'studentName': studentName,
      'exam': exam,
      'score': score
    }).then((response) {
      emit(ExamPosted());
    }).catchError((error) {
      print(error);
      emit(ExamPostedError());
      throw error;
    });
  }

  List resultsList = [];

  Future<void> getExamResults() {
    emit(ExamLoading());
    return http.get(Uri.parse(baseUrl + 'Submitedexams.json')).then((response) {
      final ExtractedData = json.decode(response.body) as Map<String, dynamic>;
      resultsList = [];
      ExtractedData.forEach((examId, resData) {
        resultsList.add({
          'studentName': resData['studentName'],
          'exam': resData['exam'],
          'score': resData['score'],
        });
      });
      emit(GetExam());
    }).catchError((error) {
      emit(ExamPostedError());
      throw error;
    });
  }
}
