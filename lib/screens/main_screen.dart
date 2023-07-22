import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/todo_structure/cubit/cubit.dart';
import 'package:todo/todo_structure/cubit/status.dart';

import '../todo_structure/snackbar_widgat.dart';

class MainScreen extends StatelessWidget {

  var titleController = TextEditingController();
  var dateController = TextEditingController();
  var timeController = TextEditingController();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (context, states) {
          if(states is AppInsertDatabaseStates){
            Navigator.of(context).pop();
            const snackBar = SnackBar(
              content:  Text('Task added'),
              /*action: SnackBarAction(
                          label: 'Undo',
                          onPressed: () {
                            // Some code to undo the change.
                          },
                        ),*/
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        builder: (context, states) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(title: const Text("TODO APP")),
            bottomNavigationBar: BottomNavigationBar(
                onTap: (V) {
                 cubit.changeScreen(V);
                },
                currentIndex: cubit.currentScreen,
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.menu), label: "New Tasks"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.check_circle_outline),
                      label: "Done Tasks"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.archive_outlined),
                      label: "Archived Tasks"),
                ]),
            body: cubit.screen[cubit.currentScreen],
            floatingActionButton: FloatingActionButton(
                onPressed: () {
                  if (!cubit.sheetButton) {
                    cubit.sheetChange(Icons.add, true);
                    scaffoldKey.currentState!
                        .showBottomSheet((context) => SnackShap(
                            formKey,
                            context,
                            titleController,
                            dateController,
                            timeController))
                        .closed
                        .then((value) {
                      cubit.sheetChange(Icons.edit, false);
                    });
                  } else {
                    if (formKey.currentState!.validate()) {
                      cubit.sheetChange(Icons.edit,false);
                      cubit.insertDatabase(
                              time: timeController.text,
                              title: titleController.text,
                              date: dateController.text);
                      timeController.clear();titleController.clear();dateController.clear();
                    }
                  }
                },
                child: Icon(cubit.fpIcon),
            ),
          );
        },
      ),
    );
  }
}
