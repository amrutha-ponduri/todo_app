import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo/load_items.dart';
import 'package:todo/pages/home_page.dart';
class AddTodoPage extends StatefulWidget {
  final LoadItems? todo;
  const AddTodoPage({super.key,
    this.todo,
  });
  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  var task=TextEditingController();
  var desc=TextEditingController();
  bool isEditCalled=false;
  @override
  void initState() {
    super.initState();
    if(widget.todo!=null)
    {
        isEditCalled=true;
        final title=widget.todo!.title;
        task.text=title;
        final description=widget.todo!.description;
        desc.text=description;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Theme.of(context).colorScheme.inversePrimary,
        title: Text(isEditCalled?'Edit the task':'Add a task'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: task,
              decoration:const InputDecoration(
                hintText: 'Task.....',
                border: OutlineInputBorder(
                  borderSide: BorderSide(width: 3),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue,width: 4,)
                )

              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: desc,
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 8,
              decoration:const InputDecoration(
                  hintText: 'Description....',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 3),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue,width: 4,)
                  )

              ),
            ),
          ),
          ElevatedButton(onPressed: (){
            isEditCalled?updateData():submitData();

          }, style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: Text(isEditCalled?'Update task':'Add Task'),)
        ],
      ),

    );
  }
  updateData() async{
    final title=task.text.toString();
    final description=desc.text.toString();
    final checked=widget.todo!.iscompleted;
    var body={
      "title":title,
      "description":description,
      "is_completed":checked
    };
    final id=widget.todo!.id;
    final url='https://api.nstack.in/v1/todos/$id';
    final uri=Uri.parse(url);
    final response=await http.put(uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body)
    );
    String snackText;
    if(response.statusCode==200)
    {
      task.text='';
      desc.text='';
      snackText='Updated successfully';
      showMessage(message: snackText, color: Colors.greenAccent);
      //Navigator.push(context, MaterialPageRoute(builder: (context) => const MyHomePage(),));
      navigateToPage();
    }
    else{
      snackText='Couldn\'t update';
      showMessage(message: snackText, color: Colors.redAccent);
    }

  }
  submitData() async{
    final title=task.text.toString();
    final description=desc.text.toString();
    var body={
      "title": title,
      "description": description,
      "is_completed": false
    };
    const url='https://api.nstack.in/v1/todos';
    final uri=Uri.parse(url);
    final response=await http.post(uri,
        headers: {'Content-Type': 'application/json'},//used to specify the type of content
      body: jsonEncode(body)
    );
    String snackText;
    if(response.statusCode==201)
    {
        task.text='';
        desc.text='';
        snackText='Task added successfully';
        showMessage(message: snackText,color: Colors.greenAccent);
        navigateToPage();
    }
    else{
        snackText='Couldn\'t added task';
        showMessage(message: snackText,color: Colors.redAccent);
    }

  }
  showMessage({required String message,required color}){
    final snackBar=SnackBar(content: Text(message),duration: const Duration(seconds: 3),backgroundColor: color,);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void navigateToPage() {
    Navigator.pop(context);
  }

}
