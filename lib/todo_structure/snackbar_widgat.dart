import 'package:flutter/material.dart';
import 'package:todo/todo_structure/default_tools.dart';

Widget SnackShap(
  GlobalKey<FormState> formKey,
  BuildContext context,
  TextEditingController titleController,
  TextEditingController dateController,
  TextEditingController timeController,
){
  return Container(
    color: Colors.black12,
    width: double.infinity,
    height: MediaQuery.of(context).size.height * 0.3,
    child: Padding(
      padding: EdgeInsets.all(20),
      child: Form(
        key: formKey,
        child: ListView(
          // mainAxisSize: MainAxisSize.min,
          children: [
            defaultTextField(
              readonly: false,
              textEditingController: titleController,
              icon: const Icon(Icons.title),
              label: 'Task Title',
              validation: (value) {
                if (value!.isEmpty) return 'Title is empty';
              },
              ontap: () {
                print('Title Tapped');
              },
            ),
            Padding(padding: EdgeInsets.only(top: 10)),
            defaultTextField(
              readonly: true,
              textEditingController: timeController,
              icon: const Icon(Icons.watch_later_outlined),
              label: 'Task Time',
              validation: (value) {
                if (value!.isEmpty) return 'Time is empty';
              },
              ontap: () {
                showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now())
                    .then((value) {
                  if (value != null) {
                    timeController.text = value.format(context);
                  }
                });
              },
            ),
            Padding(padding: EdgeInsets.only(top: 10)),
            defaultTextField(
              readonly: true,
              textEditingController: dateController,
              icon: const Icon(Icons.date_range),
              label: 'Task Date',
              validation: (value) {
                if (value!.isEmpty) return 'Date is empty';
              },
              ontap: () {
                showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1990),
                    lastDate: DateTime(2024),
                )
                    .then((value) {
                  if (value != null) {
                    dateController.text =
                    "${value.day}-${value.month}-${value.year}";
                  }
                });
              },
            ),
          ],
        ),
      ),
    ),
  );
}