// To parse this JSON data, do
//
//     final getBranchesModel = getBranchesModelFromJson(jsonString);

import 'dart:convert';

//GetExamsModel getBranchesModelFromJson(String str) => GetExamsModel.fromJson(json.decode(str));

//String getBranchesModelToJson(GetExamsModel data) => json.encode(data.toJson());

class ExamsModel {
  ExamsModel({
    this.id,
    required this.title,
    required this.questions,
  });

  String? id;
  String title;
  List<Question> questions;

  factory ExamsModel.fromJson(Map<String, dynamic> json) => ExamsModel(
    id: json["id"],
    title: json["title"],
    questions: List<Question>.from(json["questions"].map((x) => Question.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "questions": List<dynamic>.from(questions.map((x) => x.toJson())),
  };
}

class Question {
  Question({
    required this.question,
    required this.answers,
    required this.correctAnswer,
    required this.score,
  });

  String question;
  List<String> answers;
  int correctAnswer;
  int score;

  factory Question.fromJson(Map<String, dynamic> json) => Question(
    question: json["question"],
    answers: json["answers"],
    correctAnswer: json["correctAnswer"],
    score: json["score"],
  );

  Map<String, dynamic> toJson() => {
    "question": question,
    "answers": answers,
    "correctAnswer": correctAnswer,
    "score": score,
  };
}
