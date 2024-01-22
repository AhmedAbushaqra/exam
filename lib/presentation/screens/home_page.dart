import 'package:exams/presentation/color_manager.dart';
import 'package:exams/presentation/screens/Results.dart';
import 'package:exams/presentation/screens/exams.dart';
import 'package:exams/presentation/widgets/app_button.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _selectedTab = 0;

  List _pages = [
    Center(
      child: Exams(),
    ),
    Center(
      child: ExamResults(),
    ),
  ];

  _changeTab(int index) {
    setState(() {
      _selectedTab = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primaryGreen,
        body: _pages[_selectedTab],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab,
        onTap: (index) => _changeTab(index),
        selectedItemColor: Color(0xffbf717f),
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.school_outlined), label: "Exams"),
          BottomNavigationBarItem(icon: Icon(Icons.score_outlined), label: "Results"),
        ],
      ),
      );
  }
}
