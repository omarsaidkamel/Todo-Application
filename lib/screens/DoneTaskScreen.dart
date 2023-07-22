import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../todo_structure/cubit/cubit.dart';
import '../todo_structure/cubit/status.dart';
import '../todo_structure/default_tools.dart';

class DoneTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context, states){},
      builder: (context,states){
        return ListView.separated(
          itemBuilder: (context,index)=> listItems(context,AppCubit.get(context).doneTasks[index]),
          separatorBuilder: (context,index) => const Padding(padding: EdgeInsets.all(1)),
          itemCount: AppCubit.get(context).doneTasks.length,
        );
      },
    );
  }
}
