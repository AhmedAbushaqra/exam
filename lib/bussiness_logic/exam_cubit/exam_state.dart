part of 'exam_cubit.dart';

@immutable
abstract class ExamState {}

class AppInitial extends ExamState {}
class ExamLoading extends ExamState {}
class ExamPosted extends ExamState {}
class GetExam extends ExamState {}
class ExamPostedError extends ExamState {}