import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/todo_structure/cubit/status.dart';

import '../../screens/ArchivedTaskScreen.dart';
import '../../screens/DoneTaskScreen.dart';
import '../../screens/NewTasksScreen.dart';

class AppCubit extends Cubit<AppStates>{
  AppCubit() : super(AppIntStates());
  static AppCubit get(context) => BlocProvider.of(context);
  int currentScreen = 0;
  bool sheetButton = false;
  IconData fpIcon = Icons.edit;
  late Database db ;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];
  List<Widget> screen = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];

  void changeScreen(int index){
    currentScreen = index;
    emit(ChangeBottNavbar());
  }

  void sheetChange(IconData iconData,bool sheetStates){
    sheetButton = sheetStates;
    fpIcon = iconData;
    emit(ChangeSnackStates());
  }

  void createDatabase(){
    openDatabase(
        'todo.db',version:1,
        onCreate:(db,v) async{
          await db.execute(
              'CREATE TABLE Tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT,status TEXT)').then(
                  (value){
                print("Database Created");
              }
          );
        },
        onOpen: (database){}
    ).then((value) {
      db = value;
      print("Database opened");
      emit(AppCreateDatabaseStates());
      getDatabase();
    });
  }

  insertDatabase({
    String? title,
    String? time,
    String? date,
  }) {
      db.transaction((txn){
       txn.rawInsert(
           "INSERT INTO Tasks(title,date,time,status) VALUES('$title','$date','$time','New')").
      then((value) {
        print("$value insert successfully");
        emit(AppInsertDatabaseStates());
        getDatabase();
      }).catchError((e){
        print("${e.toString()} Cannot done!!!");
      });
       return Future(() => null);
    });
  }
  void updateDatabase(int id, String states){
     db.rawUpdate(
        'UPDATE Tasks SET status = ? WHERE id = ?',
        [states, id]).then((value){
          emit(AppUpdateDatabaseStates());
          getDatabase();
     });
  }
  void deleteDatabase(int id){
     db.rawDelete('DELETE FROM Tasks WHERE id = ?', [id]).
     then((value){
          emit(AppDeleteDatabaseStates());
          getDatabase();
     });
  }
  void getDatabase() {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    db.rawQuery("SELECT * FROM Tasks").then((value) {
      for (var v in value) {
        if(v['status']=='New'){
          newTasks.add(v);
        }
        if(v['status']=='Archived'){
          archivedTasks.add(v);
        }
        if(v['status']=='Done'){
          doneTasks.add(v);
        }
      }
      emit(AppGetDatabaseStates());
    });
  }

}