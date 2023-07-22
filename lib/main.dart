import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todo/bloc.dart';
import 'package:todo/screens/main_screen.dart';


void main() {
  Bloc.observer = MyBlocObserver();
  runApp(
    MaterialApp(
      home: MainScreen(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
