import 'package:flutter/material.dart';

import 'cubit/cubit.dart';

Widget defaultTextField({
  TextEditingController? textEditingController,
  String? Function(String?)? validation,
  String? label,
  Icon? icon,
  required bool readonly,
  void Function()? ontap,
})
{
  return TextFormField(
    controller: textEditingController,
    validator: validation,
    readOnly: readonly,
    onTap: ontap,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: icon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(22),
      ),
    ),
  );
}

Widget separator(double h,Color color,int f){
  return Expanded(
    flex: f,
    child: Container(
      height: h,
      color: color,
    ),
  );
}

Widget listItems(
    BuildContext context,
    Map model,
    ){
  return  Dismissible(
    key: Key(model['id'].toString()),
    child: Container(
      color: Colors.white,
      width: double.infinity,
      height: 120,
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Row(
        children: [
          Container(
            child: CircleAvatar(
              child: Text(model['time'],style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
              backgroundColor: Colors.redAccent,
              radius: 50,
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    width: MediaQuery.of(context).size.width*0.5,
                    child: Text(model['title'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25))
                ),
                Container(
                  width: MediaQuery.of(context).size.width*0.5,
                  child: Text(model['date'],maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 15)
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(onPressed: (){
                AppCubit.get(context).updateDatabase(model['id'],'Done');
              }, icon: Icon(Icons.done,color: Colors.green)),
              IconButton(onPressed: (){
                AppCubit.get(context).updateDatabase(model['id'],'Archived');
              }, icon: Icon(Icons.archive,color: Colors.yellow,)),
            ],
          ),
        ],
      ),
    ),
    onDismissed: (d){
      AppCubit.get(context).deleteDatabase(model['id']);
    },
  );
}